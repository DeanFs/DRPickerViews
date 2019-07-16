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
#import "DRHourMinuteAtomicPickerView.h"

@implementation DRHourMinutePickerPlanWeekConfig

- (void)setupWeekDays:(NSArray<NSNumber *> *)weekDays
           pickedTime:(NSString *)pickedTime {
    _weekDays = weekDays;
    _pickedTime = pickedTime;
}

- (void)setupWeekDays:(NSArray<NSNumber *> *)weekDays
           pickedTime:(NSString *)pickedTime
             duration:(NSInteger)duration
         durationDesc:(NSString *)durationDesc
        endHourMinute:(NSString *)endHourMinute
       enoughDuration:(BOOL)enoughDuration
         beyondOneDay:(BOOL)beyondOneDay {
    _weekDays = weekDays;
    _pickedTime = pickedTime;
    _duration = duration;
    _durationDesc = durationDesc;
    _endHourMinute = endHourMinute;
    _enoughDuration = enoughDuration;
    _beyondOneDay = beyondOneDay;
}

@end

@implementation DRHourMinutePickerDurationModel

- (void)setupWithDate:(NSDate *)date
           pickedTime:(NSString *)pickedTime
             duration:(NSInteger)duration
         durationDesc:(NSString *)durationDesc
        endHourMinute:(NSString *)endHourMinute
        enoughDuation:(BOOL)enoughDuration
         beyondOneDay:(BOOL)beyondOneDay {
    _date = date;
    _pickedTime = pickedTime;
    _duration = duration;
    _durationDesc = durationDesc;
    _endHourMinute = endHourMinute;
    _enoughDuration = enoughDuration;
    _beyondOneDay = beyondOneDay;
}

@end

@interface DRHourMinutePicker ()

@property (weak, nonatomic) IBOutlet DRHourMinuteAtomicPickerView *pickerView;

@property (weak, nonatomic) IBOutlet JXButton *cleanButton;
@property (weak, nonatomic) IBOutlet UIStackView *buttonsContainerView;
@property (weak, nonatomic) IBOutlet UILabel *weekDayTipLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weekContainerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weekButtonContainerLeft;

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
        self.pickerView.type = DRHourMinuteAtomicPickerViewTypeDuration;
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

    // setup clean button
    if (self.pickOption.canClean) {
        self.cleanButton.hidden = NO;
        self.titleLabel.hidden = YES;
    }

    // setup plan week config
    if (self.type == DRHourMinutePickerTypePlanWeekConfig) {
        if (kDRScreenWidth < 375) {
            self.weekButtonContainerLeft.constant = 15;
        }
        for (NSNumber *day in self.pickOption.weekDays) {
            JXButton *button = (JXButton *)[self.buttonsContainerView viewWithTag:day.integerValue];
            if ([button isKindOfClass:[JXButton class]]) {
                button.selected = YES;
                button.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"4E8BFF"];
                button.borderWidth = 0;
            }
        }
        if (self.pickOption.onlyWeekDay) {
            self.containerViewHeight.constant = self.weekContainerViewHeight.constant + 45;
            self.pickerView.hidden = YES;
            self.weekDayTipLabel.hidden = YES;
        }
    } else {
        self.containerViewHeight.constant -= self.weekContainerViewHeight.constant;
        self.weekContainerViewHeight.constant = 0;
    }
}

- (NSArray<NSNumber *> *)getWeekConfig {
    NSMutableArray *weekDays = [NSMutableArray array];
    for (JXButton *button in self.buttonsContainerView.subviews) {
        if (button.isSelected) {
            [weekDays addObject:@( button.tag)];
        }
    }
    return weekDays;
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

- (IBAction)cleanTimeAction:(id)sender {
    id deletedObj;
    if (self.currentDate) {
        deletedObj = self.currentDate;
    } else {
        deletedObj = self.pickOption.currentTime;
    }
    kDR_SAFE_BLOCK(self.pickOption.cleanBlock, deletedObj);
    [self dismiss];
}

- (IBAction)weekDayButtonAction:(JXButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        sender.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"4E8BFF"];
        sender.borderWidth = 0;
    } else {
        sender.backgroundColor = [UIColor clearColor];
        sender.borderWidth = 1;
    }
}

@end
