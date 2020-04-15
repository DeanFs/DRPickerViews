//
//  DRHourMinutePicker.m
//  Records
//
//  Created by 冯生伟 on 2018/11/8.
//  Copyright © 2018 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRHourMinutePicker.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/NSDate+DRExtension.h>
#import <DRCategories/NSString+DRExtension.h>
#import <DRCategories/UIView+DRExtension.h>
#import <JXExtension/JXExtension.h>
#import <HexColors/HexColors.h>
#import "DRHourMinutePickerView.h"
#import "DROptionCardView.h"
#import "DRUIWidgetUtil.h"
#import "DRSectionTitleView.h"

@interface DRHourMinutePicker ()<DRHourMinutePickerViewDelegate>

@property (weak, nonatomic) IBOutlet DRHourMinutePickerView *pickerView;
@property (weak, nonatomic) IBOutlet DRSectionTitleView *weekdaySectionView;
@property (weak, nonatomic) IBOutlet DRSectionTitleView *timeTitleSectionView;
@property (weak, nonatomic) IBOutlet DROptionCardView *weekDaySelectView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weekContainerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weekButtonContainerLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weekdaySectionTitleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeSectionViewHeight;

@property (nonatomic, strong) NSArray<NSNumber *> *selectedWeekdays;

@end

@implementation DRHourMinutePicker

- (Class)pickerOptionClass {
    if (self.type == DRHourMinutePickerTypeResetDate) {
        return [DRPickerHMForDateOption class];
    }
    if (self.type == DRHourMinutePickerTypeNormal) {
        return [DRPickerHMOnlyOption class];
    }
    return [DRPickerHMPlanWeekOption class];
}

- (CGFloat)pickerViewHeight {
    if (self.type == DRHourMinutePickerTypePlanWeekConfig) {
        if (((DRPickerHMPlanWeekOption *)self.pickerOption).onlyWeekDay) {
            return 136;
        }
        return 380;
    }
    return 260;
}

- (void)prepareToShow {
    self.tipLabel.hidden = YES;
    self.pickerView.timeScale = ((DRPickerHMBaseOption *)self.pickerOption).timeScale;
    
    if (self.type == DRHourMinutePickerTypeResetDate) {
        NSDate *currentDate = ((DRPickerHMForDateOption *)self.pickerOption).currentDate;
        [self.pickerView setCurrentHour:currentDate.hour
                                 minute:currentDate.minute];
        self.weekContainerViewHeight.constant = 0;
        return;
    }
    
    DRPickerHMOnlyOption *hmOption = (DRPickerHMOnlyOption *)self.pickerOption;
    NSInteger hour = 0;
    NSInteger minute = 0;
    if (hmOption.currentTime.length == 4) {
        NSString *hourString = [hmOption.currentTime substringToIndex:2];
        NSString *minuteString = [hmOption.currentTime substringFromIndex:2];
        hour += [hourString integerValue];
        minute += [minuteString integerValue];
    } else {
        NSDate *today = [NSDate date];
        hour += today.hour;
        minute += today.minute;
    }
    
    if (hmOption.forDuration) {
        self.pickerView.delegate = self;
        self.tipLabel.hidden = !hmOption.showDurationTip;
        self.pickerViewTop.constant = 20;
        self.pickerView.type = DRHourMinutePickerViewTypeDuration;
        self.pickerView.minDuration = hmOption.minDuration;
        [self.pickerView setCurrentStartHour:hour
                                 startMimute:minute
                                    duration:hmOption.currentDuration];
    } else {
        [self.pickerView setCurrentHour:hour
                                 minute:minute];
    }
    
    kDRWeakSelf
    if (hmOption.canClean && hmOption.onCleanTimeBlock) {
        self.topBar.centerButtonTitle = @"清除时间";
        self.topBar.centerButtonActionBlock = ^(DRPickerTopBar *topBar, UIButton *tappedButton) {
            [weakSelf dismissComplete:^{
                kDR_SAFE_BLOCK(hmOption.onCleanTimeBlock, hmOption.currentTime);
            }];
        };
    }

    // setup plan week config
    if (self.type == DRHourMinutePickerTypePlanWeekConfig) {
        if (kDRScreenWidth < 375) {
            self.weekButtonContainerLeft.constant = 8;
        }
        if (((DRPickerHMPlanWeekOption *)self.pickerOption).onlyWeekDay) {
            self.pickerView.hidden = YES;
            self.timeTitleSectionView.hidden = YES;
            self.weekdaySectionView.hidden = YES;
            self.weekContainerViewHeight.constant = 80;
            self.weekdaySectionTitleHeight.constant = 0;
            self.timeSectionViewHeight.constant = 0;
        }
        self.weekDaySelectView.allOptions = [NSDate weekDayNumberTitleArray];
        self.weekDaySelectView.selectedOptions = [self getSelectedOptionIndexs];
        self.selectedWeekdays = ((DRPickerHMPlanWeekOption *)self.pickerOption).weekDays;
        NSDictionary<NSString *, NSNumber *> *titleTagMap = @{@"一": @(1),
                                                              @"二": @(2),
                                                              @"三": @(3),
                                                              @"四": @(4),
                                                              @"五": @(5),
                                                              @"六": @(6),
                                                              @"日": @(7)};
        self.weekDaySelectView.onSelectionChangeBlock = ^(NSArray<NSString *> *selectedOptions, NSArray<NSNumber *> *selectedWeekdayss) {
            NSMutableArray *indexs = [NSMutableArray array];
            for (NSString *title in selectedOptions) {
                [indexs addObject:titleTagMap[title]];
            }
            weakSelf.selectedWeekdays = indexs;
        };
    } else {
        self.weekContainerViewHeight.constant = 0;
    }
}

- (NSArray<NSString *> *)getSelectedOptionIndexs {
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *titles = @[@"一", @"二", @"三", @"四", @"五", @"六", @"日"];
    for (NSNumber *weekDay in ((DRPickerHMPlanWeekOption *)self.pickerOption).weekDays) {
        [arr addObject:titles[weekDay.integerValue-1]];
    }
    return arr;
}

#pragma mark - actions
- (id)pickedObject {
    DRHourMinutePickerValueModel *value = [self.pickerView currentSelectedValue];
    if (self.type == DRHourMinutePickerTypeResetDate) {
        NSDate *date = ((DRPickerHMForDateOption *)self.pickerOption).currentDate;
        return [date resetHour:value.hour minute:value.minute];
    }
    
    if (self.type == DRHourMinutePickerTypePlanWeekConfig) {
        if (self.selectedWeekdays.count) {
            DRPickerPlanWeekPickedObj *config = [DRPickerPlanWeekPickedObj new];
            NSString *pickedTime = [NSString stringWithFormat:@"%02ld%02ld", value.hour, value.minute];
            if (((DRPickerHMPlanWeekOption *)self.pickerOption).forDuration) {
                [config setupWeekDays:self.selectedWeekdays
                           pickedTime:pickedTime
                             duration:value.duration
                         durationDesc:value.durationDesc
                        endHourMinute:value.endHourMinute
                       enoughDuration:value.enoughDuration
                         beyondOneDay:value.beyondOneDay];
            } else {
                [config setupWeekDays:self.selectedWeekdays
                           pickedTime:pickedTime];
            }
            return config;
        } else {
            return nil;
        }
    }
    
    if (((DRPickerHMOnlyOption *)self.pickerOption).forDuration) {
        DRPickerHMOnlyPickedObj *obj = [DRPickerHMOnlyPickedObj new];
        [obj setupWithPickedTime:[NSString stringWithFormat:@"%02ld%02ld", value.hour, value.minute]
                    duration:value.duration
                durationDesc:value.durationDesc
               endHourMinute:value.endHourMinute
               enoughDuation:value.enoughDuration
                beyondOneDay:value.beyondOneDay];
        return obj;
    }
    return [NSString stringWithFormat:@"%02ld%02ld", value.hour, value.minute];
}

- (void)hourMinutePickerView:(DRHourMinutePickerView *)hourMinutePickerView
             didSeletedValue:(DRHourMinutePickerValueModel *)selectedValue {
    self.topBar.rightButtonEnble = NO;
    self.tipLabel.textColor = [UIColor hx_colorWithHexRGBAString:@"E95157"];
    DRPickerHMOnlyOption *hmOption = (DRPickerHMOnlyOption *)self.pickerOption;
    if (selectedValue.beyondOneDay) {
        if (hmOption.ignoreError) {
            self.tipLabel.hidden = YES;
        } else {
            self.tipLabel.text = @"时间段设置不能跨天";
        }
        self.topBar.rightButtonEnble = ((DRPickerHMOnlyOption *)self.pickerOption).allowBeyondDay;
    } else if (!selectedValue.enoughDuration) {
        if (hmOption.ignoreError) {
            self.tipLabel.hidden = YES;
        } else {
            self.tipLabel.text = [NSString stringWithFormat:@"时间段设置不能少于%ld分钟", self.pickerView.minDuration];
        }
    } else {
        self.tipLabel.hidden = NO;
        self.tipLabel.text = [NSString stringWithFormat:@"持续%@", [NSString descForTimeDuration:selectedValue.duration]];
        self.tipLabel.textColor = [DRUIWidgetUtil descColor];
        self.topBar.rightButtonEnble = YES;
    }
}

- (void)setupCardContainerVc:(QCCardContainerController *)cardContainerVc {
    [super setupCardContainerVc:cardContainerVc];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat columnSpace = (self.weekDaySelectView.width - self.weekDaySelectView.height * 7) / 6;
        self.weekDaySelectView.columnSpace = columnSpace;
    });
}

@end
