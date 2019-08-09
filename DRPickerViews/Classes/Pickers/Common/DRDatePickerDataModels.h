//
//  DRDatePickerDataModels.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/6.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRPickerContainerView.h"

#pragma mark - 选择器类型定义
typedef NS_ENUM(NSInteger, DRPickerType) {
    // 入参：DRPickerDateOption
    // 出参(完成回调中的pickedObject，下同)：NSDate
    DRPickerTypeYMD,
    
    // 公历农历互切时间选择器
    // 入参：DRPickerWithLunarOption
    // 出参：DRPickerWithLunarPickedObj
    DRPickerTypeWithLunar,
    
    // 生日设置时间选择器，可切换显示农历，可忽略年份
    // 入参：DRPickerBirthdayOption
    // 出参：DRPickerBirthdayPickedObj
    DRPickerTypeBirthday,
    
    // 计划结束日期设置
    // 入参：DRPickerPlanEndOption
    // 出参：NSDate
    DRPickerTypePlanEnd,
    
    // 年月选择器
    // 入参：DRPickerDateOption
    // 出参(完成回调中的pickedObject，下同)：NSDate
    DRPickerTypeYearMoth,
    
    // 年月选择器带筛选，月视图中使用
    // 入参：DRPickerYearMonthFilterOption
    // 出参：DRPickerYearMonthFilterPickedObj
    DRPickerTypeYearMothFileter,
    
    // 周选择器，周视图中使用
    // 入参：DRPickerDateOption
    // 出参：NSDate
    DRPickerTypeOneWeek,
    
    // 传入date，修改其小时分钟
    // 入参：DRPickerHMForDateOption
    // 出参：NSDate
    DRPickerTypeHMForDate,
    
    // 入参：DRPickerHMOnlyOption
    // 出参：时间段时：DRPickerHMOnlyPickedObj  时间点时：NSString(HHmm)
    DRPickerTypeHMOnly,
    
    // 计划中，每周类型添加频次
    // 入参：DRPickerHMPlanWeekOption
    // 出参：DRPickerPlanWeekPickedObj
    DRPickerTypeHMPlanWeek,
    
    // 耗时0~9天，0~23小时，0~59分钟, 刻度为5分钟
    // 入参：DRPickerTimeConsumingOption
    // 出参：DRPickerTimeConsumingPickedObj
    DRPickerTypeTimeConsuming,
    
    // 提前提醒0~6小时，小时为0时，分5~55，否则分为0或30, 刻度为5分钟
    // 入参：DRPickerOptionBase
    // 出参：NSNumber
    DRPickerTypeRemindAhead,
    
    // 数值带单位选择器，如xx天  xx岁
    // 入参：DRPickerValueSelectOption
    // 出参：NSNumber
    DRPickerTypeValueSelect,
    
    // 简单字符串选项
    // 入参：DRPickerStringSelectOption
    // 出参：DRPickerStringSelectPickedObj
    DRPickerTypeStringSelect,
};


#pragma mark - 选择器参数定义
#pragma mark 基类
@interface DRPickerOptionBase : NSObject
/**
 顶部标题
 */
@property (nonatomic, copy) NSString *title;

/**
 指定在某个UI显示，默认显示到 keyWindow
 */
@property (nonatomic, weak) UIView *showInView;

/**
 选择器弹出的方向，默认：DRPickerShowPositionBottom
 */
@property (nonatomic, assign) DRPickerShowPosition showFromPosition;

/**
 是否在点击完成h时自动隐藏选择器，默认 YES
 如果设置为NO，在满足条件时在pickDoneBlock中调用[picker dismiss]进行隐藏
 */
@property (nonatomic, assign) BOOL autoDismissWhenPicked;

/**
 取消选择的回调
 */
@property (nonatomic, copy) dispatch_block_t cancelBlock;

/**
 选择器隐藏时的回调
 */
@property (nonatomic, copy) dispatch_block_t dismissBlock;

+ (instancetype)optionWithTitle:(NSString *)title;

@end


#pragma mark - 选择器参数子类
@interface DRPickerDateOption : DRPickerOptionBase
/**
 当前日期，反显，默认：今天
 */
@property (nonatomic, strong) NSDate *currentDate;

/**
 最小可选日期，默认：NSDate扩展中的最小日期
 */
@property (nonatomic, strong) NSDate *minDate;

/**
 最大可选日期，默认：NSDate扩展中的最大日期
 */
@property (nonatomic, strong) NSDate *maxDate;

+ (instancetype)optionWithTitle:(NSString *)title
                    currentDate:(NSDate *)currentDate
                        minDate:(NSDate *)minDate
                        maxDate:(NSDate *)maxDate;

@end


@interface DRPickerWithLunarOption : DRPickerOptionBase
/**
 最小可选日期(公历)，默认：NSDate扩展中的最小日期
 */
@property (nonatomic, strong) NSDate *minDate;

/**
 最大可选日期(公历)，默认：NSDate扩展中的最大日期
 */
@property (nonatomic, strong) NSDate *maxDate;

/**
 年
 */
@property (nonatomic, assign) NSInteger year;

/**
 忽略年份时的月份
 */
@property (nonatomic, assign) NSInteger month;

/**
 忽略年份时的日
 */
@property (nonatomic, assign) NSInteger day;

/**
 是农历
 */
@property (nonatomic, assign) BOOL isLunar;

/**
 是闰月
 */
@property (nonatomic, assign) BOOL leapMonth;

+ (instancetype)optionWithTitle:(NSString *)title
                        minDate:(NSDate *)minDate
                        maxDate:(NSDate *)maxDate;

@end


@interface DRPickerBirthdayOption : DRPickerWithLunarOption
/**
 忽略年份
 */
@property (nonatomic, assign) BOOL ignoreYear;

@end


@interface DRPickerPlanEndOption : DRPickerOptionBase
/**
 计划开始日期
 */
@property (nonatomic, strong) NSDate *startDate;

/**
 当前反显日期
 */
@property (nonatomic, strong) NSDate *currentDate;

/**
 最大可选日期
 */
@property (nonatomic, strong) NSDate *maxDate;

+ (instancetype)optionWithTitle:(NSString *)title
                    currentDate:(NSDate *)currentDate
                      startDate:(NSDate *)startDate
                        maxDate:(NSDate *)maxDate;

@end


@interface DRPickerYearMonthFilterOption : DRPickerDateOption
/**
 当前选中的筛选条件，反显
 */
@property (nonatomic, strong) NSArray<NSNumber *> *monthViewFilterIndexs;

/**
 筛选条件少于一项时的toas文案
 */
@property (nonatomic, copy) NSString *belowToast;

@end


@interface DRPickerHMBaseOption : DRPickerOptionBase

/**
 时间步长，默认5分钟
 */
@property (nonatomic, assign) NSInteger timeScale;

@end


@interface DRPickerHMForDateOption : DRPickerHMBaseOption
/**
 当前日期，需要被修改小时分钟的日期
 */
@property (nonatomic, strong) NSDate *currentDate;


+ (instancetype)optionWithTitle:(NSString *)title
                    currentDate:(NSDate *)currentDate;

@end


@interface DRPickerHMOnlyOption : DRPickerHMBaseOption
/**
 选则时间段
 */
@property (nonatomic, assign) BOOL forDuration;

/**
 当前小时分钟，HHmm
 */
@property (nonatomic, copy) NSString *currentTime;

/**
 时间间隔，用于时间段选择，forDuration == YES
 单位：秒
 */
@property (nonatomic, assign) int64_t currentDuration;

/**
 最小时间间隔，用于时间段，单位分钟
 默认最小30分钟
 */
@property (nonatomic, assign) NSInteger minDuration;

/**
 是否可以清除时间
 */
@property (nonatomic, assign) BOOL canClean;

/**
 清除时间回调
 */
@property (nonatomic, copy) void (^onCleanTimeBlock)(id deletedObj);

@end


@interface DRPickerHMPlanWeekOption : DRPickerHMOnlyOption

/**
 当前选中的weekday
 */
@property (nonatomic, strong) NSArray<NSNumber *> *weekDays;

/**
 重复每周全天类型，仅选择周
 */
@property (nonatomic, assign) BOOL onlyWeekDay;

@end


@interface DRPickerTimeConsumingOption : DRPickerOptionBase
/**
 当前消耗时长，反显
 */
@property (nonatomic, assign) int64_t timeConsuming;

/**
 时间步长，默认5分钟
 */
@property (nonatomic, assign) NSInteger timeScale;

+ (instancetype)optionWithTitle:(NSString *)title
                  timeConsuming:(int64_t)timeConsuming;

@end


@interface DRPickerValueSelectOption : DRPickerOptionBase

@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, copy) NSString *valueUnit;
@property (nonatomic, assign) NSInteger currentValue;

+ (instancetype)optionWithTitle:(NSString *)title
                   currentValue:(NSInteger)currentValue
                       minValue:(NSInteger)minValue
                       maxValue:(NSInteger)maxValue
                      valueUnit:(NSString *)valueUnit;

@end


@interface DRPickerStringSelectOption : DRPickerOptionBase

@property (nonatomic, strong) NSArray<NSString *> *stringOptions;
@property (nonatomic, copy) NSString *currentStringOption;
@property (nonatomic, assign) NSInteger currentStringIndex;

+ (instancetype)optionWithTitle:(NSString *)title
                  stringOptions:(NSArray<NSString *> *)stringOptions;

@end


#pragma mark - 选择器选择完成回调返回数据结构定义
@interface DRPickerWithLunarPickedObj : NSObject
/**
 年
 */
@property (nonatomic, assign) NSInteger year;

/**
 忽略年份时的月份
 */
@property (nonatomic, assign) NSInteger month;

/**
 忽略年份时的日
 */
@property (nonatomic, assign) NSInteger day;

/**
 是农历
 */
@property (nonatomic, assign) BOOL isLunar;

/**
 是闰月
 */
@property (nonatomic, assign) BOOL leapMonth;

@end


@interface DRPickerBirthdayPickedObj : DRPickerWithLunarPickedObj
/**
 忽略年份
 */
@property (nonatomic, assign) BOOL ignoreYear;

@end


@interface DRPickerYearMonthFilterPickedObj : NSObject
/**
 选择的日期
 */
@property (nonatomic, strong) NSDate *date;

/**
 选择的筛选条件
 */
@property (nonatomic, strong) NSArray<NSNumber *> *filterOptionIndexs;

@end


@interface DRPickerHMOnlyPickedObj : NSObject
/**
 当前选中的小时分钟，或者时间段的起点小时分钟，HHmm格式
 */
@property (nonatomic, copy) NSString *pickedTime; // HHmm

/**
 持续时长，单位：秒
 */
@property (nonatomic, assign) int64_t duration;

/**
 持续时长中文描述
 */
@property (nonatomic, copy) NSString *durationDesc;

/**
 结束时间的小时分钟 HHmm
 */
@property (nonatomic, copy) NSString *endHourMinute;

/**
 时长不小于最小时长
 */
@property (nonatomic, assign) BOOL enoughDuration;

/**
 持续时长跨天标志
 */
@property (nonatomic, assign) BOOL beyondOneDay;

- (void)setupWithPickedTime:(NSString *)pickedTime
                   duration:(NSInteger)duration
               durationDesc:(NSString *)durationDesc
              endHourMinute:(NSString *)endHourMinute
              enoughDuation:(BOOL)enoughDuration
               beyondOneDay:(BOOL)beyondOneDay;

@end


@interface DRPickerPlanWeekPickedObj : DRPickerHMOnlyPickedObj
/**
 当前选中的周
 */
@property (nonatomic, copy) NSArray<NSNumber *> *weekDays;

- (void)setupWeekDays:(NSArray<NSNumber *> *)weekDays
           pickedTime:(NSString *)pickedTime;

- (void)setupWeekDays:(NSArray<NSNumber *> *)weekDays
           pickedTime:(NSString *)pickedTime
             duration:(NSInteger)duration
         durationDesc:(NSString *)durationDesc
        endHourMinute:(NSString *)endHourMinute
       enoughDuration:(BOOL)enoughDuration
         beyondOneDay:(BOOL)beyondOneDay;

@end


@interface DRPickerTimeConsumingPickedObj : NSObject
/**
 耗时时长
 */
@property (nonatomic, assign) int64_t timeConsuming;

/**
 xx天xx小时xx分钟
 */
@property (nonatomic, copy) NSString *timeDesc;

+ (instancetype)objWithTimeConsuming:(int64_t)timeConsuming
                            timeDesc:(NSString *)timeDesc;

@end


@interface DRPickerStringSelectPickedObj : NSObject

@property (nonatomic, copy) NSString *selectedOption;
@property (nonatomic, assign) NSInteger selectedIndex;

+ (instancetype)objWithSelectedOption:(NSString *)option
                        selectedIndex:(NSInteger)index;

@end
