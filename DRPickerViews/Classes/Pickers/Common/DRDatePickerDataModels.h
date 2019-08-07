//
//  DRDatePickerDataModels.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/6.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 清除时间回调
 
 @param deletedObj 被清除的时间
 */
typedef void (^DRDatePickerCleanBlock)(id deletedObj);

@interface DRPickerOption : NSObject

/**
 指定在某个UI显示，默认显示到 keyWindow
 */
@property (nonatomic, weak) UIView *showInView;

/**
 顶部标题
 */
@property (nonatomic, copy) NSString *title;

/**
 取消选择的回调
 */
@property (nonatomic, copy) dispatch_block_t cancelBlock;

/**
 选择器隐藏时的回调
 */
@property (nonatomic, copy) dispatch_block_t dismissBlock;

/**
 是否可以清除时间，即是否显示清除时间按钮，默认 NO
 支持type: DRPickerTypeMDWT, DRPickerTypeMDWTimeOnly, DRPickerTypeHM
 DRPickerTypeHMOnly, DRPickerTypeHMPlanWeek
 */
@property (nonatomic, assign) BOOL canClean;

/**
 清除时间的回调
 支持type: DRPickerTypeMDWT
 */
@property (nonatomic, copy) DRDatePickerCleanBlock cleanBlock;

/**
 是否在点击完成h时自动隐藏选择器，默认 YES
 如果设置为NO，在满足条件时在pickDoneBlock中调用[picker dismiss]进行隐藏
 */
@property (nonatomic, assign) BOOL autoDismissWhenPicked;


#pragma mark - DRYMDWithLunarPicker需要的参数
/**
 是农历
 */
@property (nonatomic, assign) BOOL isLunar;

/**
 是闰月
 */
@property (nonatomic, assign) BOOL leapMonth;

/**
 忽略年份
 */
@property (nonatomic, assign) BOOL ignoreYear;

/**
 忽略年份时的月份
 */
@property (nonatomic, assign) NSInteger month;

/**
 忽略年份时的日
 */
@property (nonatomic, assign) NSInteger day;

#pragma mark - DRHourMinutePicker
/**
 仅小时分钟，返回 HHmm 格式字符串，默认NO
 适用于 DRPickerTypeHM
 */
@property (nonatomic, assign) BOOL hourMinuteOnly;

/**
 当前小时分钟，试用于 DRPickerTypeHMOnly, DRPickerTypeHMPlanWeek
 */
@property (nonatomic, copy) NSString *currentTime;

/**
 当前每周配置，适用于DRPickerTypeHMPlanWeek
 */
@property (nonatomic, strong) NSArray<NSNumber *> *weekDays;

/**
 重复每周全天类型，仅选择周
 */
@property (nonatomic, assign) BOOL onlyWeekDay;

/**
 时间步长，默认5
 */
@property (nonatomic, assign) NSInteger timeScale;

/**
 选则时间段
 */
@property (nonatomic, assign) BOOL forDuration;

/**
 最小时间间隔，用于时间段，单位分钟
 默认最小30分钟
 */
@property (nonatomic, assign) NSInteger minDuration;

/**
 时间间隔，用于时间段选择DRPickerTypeHMDuration
 单位：秒
 */
@property (nonatomic, assign) int64_t currentDuration;

#pragma mark - 月视图中年月选择器的筛选条件反显 DRPickerTypeYearMothFileterMonthView
@property (nonatomic, strong) NSArray<NSNumber *> *monthViewFilterIndexs;

#pragma mark - DRPickerTypeValueSelect
@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, copy) NSString *valueUnit;
@property (nonatomic, assign) NSInteger currentValue;

#pragma mark - DRPickerTypeStringOption
@property (nonatomic, strong) NSArray<NSString *> *stringOptions;
@property (nonatomic, copy) NSString *currentStringOption;
@property (nonatomic, assign) NSInteger currentStringIndex;

+ (instancetype)optionWithTitle:(NSString *)title;

@end


#pragma mark - 选择完成耗时时长, 
@interface DRTimeConsumingModel : NSObject

// 时长秒数，单位：秒
@property (nonatomic, assign) int64_t duration;
// xx天xx小时xx分钟
@property (nonatomic, copy) NSString *timeString;

+ (instancetype)modelWithDuration:(int64_t)duration
                       timeString:(NSString *)timeString;

@end


#pragma mark - 小十分钟选择器
@interface DRHourMinutePickerPlanWeekConfig : NSObject

@property (nonatomic, copy, readonly) NSArray<NSNumber *> *weekDays;
@property (nonatomic, copy, readonly) NSString *pickedTime;
// 持续时长，单位：秒
@property (nonatomic, assign, readonly) int64_t duration;
// 持续时长中文描述
@property (nonatomic, copy, readonly) NSString *durationDesc;
// 结束时间的小时分钟 HHmm
@property (nonatomic, copy, readonly) NSString *endHourMinute;
// 时长不小于最小时长
@property (nonatomic, assign, readonly) BOOL enoughDuration;
// 持续时长跨天标志
@property (nonatomic, assign, readonly) BOOL beyondOneDay;

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

@interface DRHourMinutePickerDurationModel : NSObject

@property (nonatomic, strong, readonly) NSDate *date;
@property (nonatomic, copy, readonly) NSString *pickedTime; // HHmm
// 持续时长，单位：秒
@property (nonatomic, assign, readonly) int64_t duration;
// 持续时长中文描述
@property (nonatomic, copy, readonly) NSString *durationDesc;
// 结束时间的小时分钟 HHmm
@property (nonatomic, copy, readonly) NSString *endHourMinute;
// 时长不小于最小时长
@property (nonatomic, assign, readonly) BOOL enoughDuration;
// 持续时长跨天标志
@property (nonatomic, assign, readonly) BOOL beyondOneDay;

- (void)setupWithDate:(NSDate *)date
           pickedTime:(NSString *)pickedTime
             duration:(NSInteger)duration
         durationDesc:(NSString *)durationDesc
        endHourMinute:(NSString *)endHourMinute
        enoughDuation:(BOOL)enoughDuration
         beyondOneDay:(BOOL)beyondOneDay;

@end


#pragma mark - 周视图筛选年月选择器返回结果
@interface DRMonthViewFilterYearMonthModel : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray<NSNumber *> *filterOptionIndexs;

@end


#pragma mark - DRPickerTypeStringOption
@interface DRStringOptionValueModel : NSObject

@property (nonatomic, copy) NSString *selectedOption;
@property (nonatomic, assign) NSInteger selectedIndex;

@end
