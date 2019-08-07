//
//  DRDatePickerFactory.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/15.
//

#import <Foundation/Foundation.h>
#import "DRBaseDatePicker.h"

/**
 时间选择器选择完成的回调
 
 @param picker 选择器对象，满足DRDatePickerProtocol协议
 @param pickedObject 选中的数据结构
 */
typedef void (^DRPickerDoneBlock)(DRBaseDatePicker *picker, id pickedObject);

typedef NS_ENUM(NSInteger, DRPickerType) {
    // yyyy年MM月dd日, 年月日选择器，仅用于选择公历日期
    // 回调中返回的pickedObject为NSDate类
    DRPickerTypeYMD,
    
    // yyyy年M月d日，可切换显示农历
    // 回调中返回的pickedObject为DRYMDWithLunarPickerOutputObject类
    DRPickerTypeYMDWithLunar,
    
    // 生日设置时间选择器，可切换显示农历,
    // 通过option参数中的canIgnoreYear设置是否可以忽略年份
    // 回调中返回的pickedObject为DRYMDWithLunarPickerOutputObject类
    DRPickerTypeYMDBirthday,
    
    // 计划开始日期设置
    // maxDate无效，currentDate需要在今天及以后，且不超过下一年最后一天
    // 回调中返回的pickedObject为NSDate类
    DRPickerTypePlanStart,
    
    // 计划结束日期设置
    // minDate为计划开始日期，maxDate无效
    // 回调中返回的pickedObject为NSDate类
    DRPickerTypePlanEnd,
    
    // 年月选择器
    // 回调中返回的pickedObject为NSDate类
    DRPickerTypeYearMoth,
    
    // 年月选择器带筛选，月视图中使用
    // 筛选条件反显为option.monthViewFilterIndexs
    // 回调中返回的pickedObject为DRMonthViewFilterYearMonthModel类
    DRPickerTypeYearMothFileterMonthView,
    
    // 周选择器，周视图中使用
    // 回调中返回的pickedObject为NSDate类，选中周的周一日期
    // currentDate,minDate,maxDate参数有效
    DRPickerTypeOneWeek,
    
    // 小时、分钟
    // option.hourMinuteOnly = YES 则回调中返回的pickedObject为HHmm格式字符串
    // 否则返回currentDate日期拼上选中的小时分钟的NSDate，默认为此
    // minDate, maxDate无效
    // currentDate为空且option.hourMinuteOnly = YES时，等同于DRPickerTypeHMOnly
    DRPickerTypeHM,
    
    // 仅用于选择小时分钟
    // 通过option.currentTime传入当前反显时间
    // 回调中返回的pickedObject为HHmm格式字符串
    // currentDate, minDate, maxDate无效
    DRPickerTypeHMOnly,
    
    // 计划中，每周类型添加频次
    // 通过option.currentTime传入当前反显时间
    // 通过option.currentWeekConfig传入反显的每周频次配置
    // 回调中返回的pickedObject为DRHourMinutePickerPlanWeekConfig类型model对象
    // currentDate, minDate, maxDate无效
    DRPickerTypeHMPlanWeek,
    
    // 耗时0~9天，0~23小时，0~59分钟
    // 刻度为分钟
    // 通过option.currentDuration传入反显值
    // 回调中返回DRTimeConsumingModel
    DRPickerTypeTimeConsuming,
    
    // 提前提醒0~6小时，小时为0时，分5~55，否则分为0或30
    // 刻度为分钟
    // 通过option.currentDuration传入反显值
    // 回调中返回DRTimeConsumingModel
    DRPickerTypeRemindAhead,
    
    // 数值带单位选择器，如xx天  xx岁
    // 通过option.minValue传入最小值
    // 通过option.maxValue传入最大值
    // 通过option.valueUnit传入单位，如天，岁
    // 通过option.currentValue传入当前值反显
    // 回调中返回NSNumber，选择的数值
    DRPickerTypeValueSelect,
    
    // 简单字符串选项
    // 通过option.stringOptions数组传入所有选项
    // 通过option.currentStringOption或者currentStringIndex反显
    // 回调中pickedObject为DRStringOptionValueModel
    DRPickerTypeStringOption,
};

@interface DRPickerFactory : NSObject

/**
 非日期时间类的选择器调用
 
 @param type 选择器类型
 @param option 选择器参数
 @param pickDoneBlock 点击完成按钮确认选的回调
 */
+ (void)showPickerViewWithType:(DRPickerType)type
                        option:(DRPickerOption *)option
                 pickDoneBlock:(DRPickerDoneBlock)pickDoneBlock;

/**
 简易的显示指定类型的时间选择器
 
 @param type 选择器类型
 @param currentDate 需要反显选中的时间
 @param minDate 可选择的最小公历日期
 @param maxDate 可选择的最大公历日期
 @param pickDoneBlock 点击完成按钮确认选的回调
 */
+ (void)showDatePickerWithType:(DRPickerType)type
                   currentDate:(NSDate *)currentDate
                       minDate:(NSDate *)minDate
                       maxDate:(NSDate *)maxDate
                 pickDoneBlock:(DRPickerDoneBlock)pickDoneBlock;

/**
 显示指定类型的时间选择器

 @param type 选择器类型
 @param currentDate 需要反显选中的时间
 @param minDate 可选择的最小公历日期
 @param maxDate 可选择的最大公历日期
 @param option 额外参数，特殊选择器需要额外参数
 @param pickDoneBlock 点击完成按钮确认选的回调
 */
+ (void)showDatePickerWithType:(DRPickerType)type
                   currentDate:(NSDate *)currentDate
                       minDate:(NSDate *)minDate
                       maxDate:(NSDate *)maxDate
                   otherOption:(DRPickerOption *)option
                 pickDoneBlock:(DRPickerDoneBlock)pickDoneBlock;

@end
