//
//  DRDatePickerDataModels.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/6.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRDatePickerDataModels.h"
#import <DRMacroDefines/DRMacroDefines.h>

#define kDefaultTimeScale 5
#define kDefaultMinDuration 30

#pragma mark - 选择器参数定义
#pragma mark 基类
@implementation DRPickerOptionBase

+ (instancetype)optionWithTitle:(NSString *)title {
    DRPickerOptionBase *opt = [[[self class] alloc] init];
    opt.title = title;
    return opt;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _autoDismissWhenPicked = YES;
        _showInView = kDRWindow;
        _showFromPosition = DRPickerShowPositionBottom;
    }
    return self;
}

@end


#pragma mark - 选择器参数子类
@implementation DRPickerDateOption

+ (instancetype)optionWithTitle:(NSString *)title
                    currentDate:(NSDate *)currentDate
                        minDate:(NSDate *)minDate
                        maxDate:(NSDate *)maxDate {
    DRPickerDateOption *opt = [super optionWithTitle:title];
    opt.currentDate = currentDate;
    opt.minDate = minDate;
    opt.maxDate = maxDate;
    return opt;
}

@end


@implementation DRPickerWithLunarOption

+ (instancetype)optionWithTitle:(NSString *)title
                        minDate:(NSDate *)minDate
                        maxDate:(NSDate *)maxDate {
    DRPickerWithLunarOption *opt = [super optionWithTitle:title];
    opt.minDate = minDate;
    opt.maxDate = maxDate;
    return opt;
}

@end


@implementation DRPickerBirthdayOption

@end


@implementation DRPickerPlanEndOption

+ (instancetype)optionWithTitle:(NSString *)title
                    currentDate:(NSDate *)currentDate
                      startDate:(NSDate *)startDate
                        maxDate:(NSDate *)maxDate {
    DRPickerPlanEndOption *opt = [DRPickerPlanEndOption optionWithTitle:title];
    opt.currentDate = currentDate;
    opt.startDate = startDate;
    opt.maxDate = maxDate;
    return opt;
}

@end


@implementation DRPickerYearMonthFilterOption

@end


@implementation DRPickerHMBaseOption

- (instancetype)init {
    self = [super init];
    if (self) {
        _timeScale = kDefaultTimeScale;
    }
    return self;
}

@end


@implementation DRPickerHMForDateOption

+ (instancetype)optionWithTitle:(NSString *)title currentDate:(NSDate *)currentDate {
    DRPickerHMForDateOption *opt = [DRPickerHMForDateOption optionWithTitle:title];
    opt.currentDate = currentDate;
    return opt;
}

@end


@implementation DRPickerHMOnlyOption

- (instancetype)init {
    self = [super init];
    if (self) {
        _minDuration = kDefaultMinDuration;
    }
    return self;
}

@end


@implementation DRPickerHMPlanWeekOption

@end


@implementation DRPickerTimeConsumingOption

- (instancetype)init {
    self = [super init];
    if (self) {
        _timeScale = kDefaultTimeScale;
    }
    return self;
}

+ (instancetype)optionWithTitle:(NSString *)title timeConsuming:(int64_t)timeConsuming {
    DRPickerTimeConsumingOption *opt = [DRPickerTimeConsumingOption optionWithTitle:title];
    opt.timeConsuming = timeConsuming;
    return opt;
}

@end


@implementation DRPickerValueSelectOption

+ (instancetype)optionWithTitle:(NSString *)title currentValue:(NSInteger)currentValue minValue:(NSInteger)minValue maxValue:(NSInteger)maxValue valueUnit:(NSString *)valueUnit {
    DRPickerValueSelectOption *opt = [DRPickerValueSelectOption optionWithTitle:title];
    opt.currentValue = currentValue;
    opt.minValue = minValue;
    opt.maxValue = maxValue;
    opt.valueUnit = valueUnit;
    return opt;
}

@end

@implementation DRPickerStringSelectOption

+ (instancetype)optionWithTitle:(NSString *)title stringOptions:(NSArray<NSString *> *)stringOptions {
    DRPickerStringSelectOption *opt = [DRPickerStringSelectOption optionWithTitle:title];
    opt.stringOptions = stringOptions;
    return opt;
}

@end


@implementation DRPickerOptionCardOption

- (instancetype)init {
    self = [super init];
    if (self) {
        _columnCount = 3;
        _lineCount = 3;
        _mutableSelection = NO;
        _maxSelectCount = 3;
        _minSelectCount = 1;
        _columnSpace = 13;
        _lineHeight = 32;
        _fontSize = 13;
        _itemCornerRadius = 6;
        _showPageControl = NO;
        _pageControlHeight = 30;
    }
    return self;
}

@end


#pragma mark - 选择器选择完成回调返回数据结构定义
@implementation DRPickerWithLunarPickedObj

@end


@implementation DRPickerBirthdayPickedObj

@end


@implementation DRPickerYearMonthFilterPickedObj

@end


@implementation DRPickerHMOnlyPickedObj

- (void)setupWithPickedTime:(NSString *)pickedTime
                   duration:(NSInteger)duration
               durationDesc:(NSString *)durationDesc
              endHourMinute:(NSString *)endHourMinute
              enoughDuation:(BOOL)enoughDuration
               beyondOneDay:(BOOL)beyondOneDay {
    _pickedTime = pickedTime;
    _duration = duration;
    _durationDesc = durationDesc;
    _endHourMinute = endHourMinute;
    _enoughDuration = enoughDuration;
    _beyondOneDay = beyondOneDay;
}

@end


@implementation DRPickerPlanWeekPickedObj

- (void)setupWeekDays:(NSArray<NSNumber *> *)weekDays
           pickedTime:(NSString *)pickedTime {
    self.weekDays = weekDays;
    self.pickedTime = pickedTime;
}

- (void)setupWeekDays:(NSArray<NSNumber *> *)weekDays
           pickedTime:(NSString *)pickedTime
             duration:(NSInteger)duration
         durationDesc:(NSString *)durationDesc
        endHourMinute:(NSString *)endHourMinute
       enoughDuration:(BOOL)enoughDuration
         beyondOneDay:(BOOL)beyondOneDay {
    self.weekDays = weekDays;
    self.pickedTime = pickedTime;
    self.duration = duration;
    self.durationDesc = durationDesc;
    self.endHourMinute = endHourMinute;
    self.enoughDuration = enoughDuration;
    self.beyondOneDay = beyondOneDay;
}

@end


@implementation DRPickerTimeConsumingPickedObj

+ (instancetype)objWithTimeConsuming:(int64_t)timeConsuming timeDesc:(NSString *)timeDesc {
    DRPickerTimeConsumingPickedObj *obj = [DRPickerTimeConsumingPickedObj new];
    obj.timeConsuming = timeConsuming;
    obj.timeDesc = timeDesc;
    return obj;
}

@end


@implementation DRPickerStringSelectPickedObj

+ (instancetype)objWithSelectedOption:(NSString *)option selectedIndex:(NSInteger)index {
    DRPickerStringSelectPickedObj *obj = [DRPickerStringSelectPickedObj new];
    obj.selectedOption = option;
    obj.selectedIndex = index;
    return obj;
}

@end


@implementation DRPickerOptionCardPickedObj

@end
