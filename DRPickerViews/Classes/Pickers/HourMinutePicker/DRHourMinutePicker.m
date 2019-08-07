//
//  DRHourMinutePicker.m
//  Records
//
//  Created by 冯生伟 on 2018/11/8.
//  Copyright © 2018 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRHourMinutePicker.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import "NSDate+DRExtension.h"
#import <JXExtension/JXExtension.h>
#import <HexColors/HexColors.h>
#import "DRHourMinutePickerView.h"
#import "DROptionCardView.h"

@interface DRHourMinutePicker ()

@property (weak, nonatomic) IBOutlet DRHourMinutePickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *timeTitleSectionView;
@property (weak, nonatomic) IBOutlet DROptionCardView *weekDaySelectView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weekContainerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weekButtonContainerLeft;
@property (nonatomic, strong) NSArray *selectedIndex;

@property (nonatomic, assign) DRHourMinutePickerType type;

@end

@implementation DRHourMinutePicker

+ (void)showPickerViewWithType:(DRHourMinutePickerType)type
                   currentDate:(NSDate *)currentDate
                 pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                    setupBlock:(DRDatePickerSetupBlock)setupBlock {
    DRHourMinutePicker *picker = [DRHourMinutePicker pickerView];
    kDR_SAFE_BLOCK(setupBlock, picker);
    picker.type = type;
    picker.currentDate = currentDate;
    picker.pickDoneBlock = pickDoneBlock;
    [picker show];
}

- (CGFloat)picerViewHeight {
    if (self.type == DRHourMinutePickerTypePlanWeekConfig) {
        if (self.pickOption.onlyWeekDay) {
            return 162;
        }
        return 380;
    }
    return 260;
}

- (void)prepareToShow {
    self.pickerView.timeScale = self.pickOption.timeScale;
    
    // 反显设置
    NSInteger hour = 0;
    NSInteger minute = 0;
    if (self.currentDate) {
        hour += self.currentDate.hour;
        minute += self.currentDate.minute;
    } else if (self.pickOption.currentTime.length == 4) {
        NSString *hourString = [self.pickOption.currentTime substringToIndex:2];
        NSString *minuteString = [self.pickOption.currentTime substringFromIndex:2];
        hour += [hourString integerValue];
        minute += [minuteString integerValue];
    } else {
        NSDate *today = [NSDate date];
        hour += today.hour;
        minute += today.minute;
    }
    
    if (self.pickOption.forDuration) {
        self.pickerView.type = DRHourMinutePickerViewTypeDuration;
        self.pickerView.minDuration = self.pickOption.minDuration;
        self.pickerView.timeScale = self.pickOption.timeScale;
        if (self.pickOption.currentDuration < self.pickOption.minDuration*60) {
            self.pickOption.currentDuration = self.pickOption.minDuration*60;
        }
        [self.pickerView setCurrentStartHour:hour
                                 startMimute:minute
                                    duration:self.pickOption.currentDuration];
    } else {
        [self.pickerView setCurrentHour:hour
                                 minute:minute];
    }
    
    // setupCleanButton
    kDRWeakSelf
    if (self.pickOption.canClean) {
        self.topBar.centerButtonTitle = @"清除时间";
        self.topBar.centerButtonActionBlock = ^(DRPickerTopBar *topBar, UIButton *tappedButton) {
            id deletedObj;
            if (weakSelf.currentDate) {
                deletedObj = weakSelf.currentDate;
            } else {
                deletedObj = weakSelf.pickOption.currentTime;
            }
            kDR_SAFE_BLOCK(weakSelf.pickOption.cleanBlock, deletedObj);
            [weakSelf dismiss];
        };
    }

    // setup plan week config
    if (self.type == DRHourMinutePickerTypePlanWeekConfig) {
        if (kDRScreenWidth < 375) {
            self.weekButtonContainerLeft.constant = 8;
        }
        if (self.pickOption.onlyWeekDay) {
            self.pickerView.hidden = YES;
            self.timeTitleSectionView.hidden = YES;
            self.weekContainerViewHeight.constant = 106;
        }
        self.weekDaySelectView.allOptions = @[@"一", @"二", @"三", @"四", @"五", @"六", @"七"];
        self.weekDaySelectView.selectedIndexs = [self getSelectedOptionIndexs];
        self.selectedIndex = [self getSelectedOptionIndexs];
        self.weekDaySelectView.onSelectionChangeBlock = ^(NSArray<NSString *> *selectedOptions, NSArray<NSNumber *> *selectedIndexs) {
            weakSelf.selectedIndex = selectedIndexs;
        };
    } else {
        self.weekContainerViewHeight.constant = 0;
    }
}

- (NSArray<NSNumber *> *)getSelectedOptionIndexs {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSNumber *weekDay in self.pickOption.weekDays) {
        [arr addObject:@(weekDay.integerValue-1)];
    }
    return arr;
}

- (NSArray<NSNumber *> *)getWeekConfig {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSNumber *index in self.selectedIndex) {
        [arr addObject:@(index.integerValue+1)];
    }
    return arr;
}

#pragma mark - actions
- (id)pickedObject {
    DRHourMinutePickerValueModel *value = [self.pickerView currentSelectedValue];
    if (self.type == DRHourMinutePickerTypePlanWeekConfig) {
        NSArray<NSNumber *> *weekDays = [self getWeekConfig];
        if (weekDays.count) {
            DRHourMinutePickerPlanWeekConfig *config = [DRHourMinutePickerPlanWeekConfig new];
            NSString *pickedTime = [NSString stringWithFormat:@"%02ld%02ld", value.hour, value.minute];
            if (self.pickOption.forDuration) {
                [config setupWeekDays:weekDays
                           pickedTime:pickedTime
                             duration:value.duration
                         durationDesc:value.durationDesc
                        endHourMinute:value.endHourMinute
                       enoughDuration:value.enoughDuration
                         beyondOneDay:value.beyondOneDay];
            } else {
                [config setupWeekDays:weekDays
                           pickedTime:pickedTime];
            }
            return config;
        } else {
            return nil;
        }
    }
    
    if (self.pickOption.forDuration) {
        NSDateComponents *cmp = [self dateComponentsFromDate:self.currentDate];
        cmp.hour = value.hour;
        cmp.minute = value.minute;
        
        DRHourMinutePickerDurationModel *model = [DRHourMinutePickerDurationModel new];
        [model setupWithDate:[self.calendar dateFromComponents:cmp]
                  pickedTime:[NSString stringWithFormat:@"%02ld%02ld", value.hour, value.minute]
                    duration:value.duration
                durationDesc:value.durationDesc
               endHourMinute:value.endHourMinute
               enoughDuation:value.enoughDuration
                beyondOneDay:value.beyondOneDay];
        return model;
    }
    
    if (self.currentDate && !self.pickOption.hourMinuteOnly) {
        NSDateComponents *cmp = [self dateComponentsFromDate:self.currentDate];
        cmp.hour = value.hour;
        cmp.minute = value.minute;
        return [self.calendar dateFromComponents:cmp];
    }
    
    return [NSString stringWithFormat:@"%02ld%02ld", value.hour, value.minute];
}

@end
