//
//  DRDatePickerDataModels.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/6.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRDatePickerDataModels.h"

@implementation DRPickerOption

- (instancetype)init {
    self = [super init];
    if (self) {
        self.autoDismissWhenPicked = YES;
        self.timeScale = 5;
        self.minDuration = 30;
    }
    return self;
}

+ (instancetype)optionWithTitle:(NSString *)title {
    DRPickerOption *opt = [[DRPickerOption alloc] init];
    opt.title = title;
    return opt;
}

@end

@implementation DRTimeConsumingModel

+ (instancetype)modelWithDuration:(int64_t)duration timeString:(NSString *)timeString {
    DRTimeConsumingModel *model = [DRTimeConsumingModel new];
    model.timeString = timeString;
    model.duration = duration;
    return model;
}

@end


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

@implementation DRMonthViewFilterYearMonthModel

@end


@implementation DRStringOptionValueModel

@end
