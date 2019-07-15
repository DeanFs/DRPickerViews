//
//  DRDatePickerFactory.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/15.
//

#import <Foundation/Foundation.h>
// pickers
#import "DRYMDPicker.h"             // year month day
#import "DRYMDWithTodayPicker.h"    // year-month-day in a label
#import "DRYMDWithLunarPicker.h"    // year month day lunar
#import "DRYearMonthPicker.h"       // year month
#import "DRMDWTPicker.h"            // year month week hour minute
#import "DRHourMinutePicker.h"      // hour minute
#import "DRTimeConsumingPicker.h"   // day hour minute

/**
 时间选择器选择完成的回调
 
 @param picker 选择器对象，满足DRDatePickerProtocol协议
 @param pickedObject 选中的数据结构
 */
typedef void (^DRDatePickerDoneBlock)(DRBaseDatePicker *picker, id pickedObject);

typedef NS_ENUM(NSInteger, DRDatePickerType) {
    // yyyy年MM月dd日, 年月日选择器，仅用于选择公历日期
    // 回调中返回的pickedObject为NSDate类
    DRDatePickerTypeYMD,
    
    // yyyy年M月d日, 年月日选择器，仅支持公历
    // 只有一个滚动区，每次滚动一天
    // 显示今天，当前年不显示年份
    // 回调中返回的pickedObject为NSDate类
    DRDatePickerTypeYMDWithToday,
    
    // yyyy年M月d日，可切换显示农历
    // 由于农历数据限制，目前时间范围只支持1918-01-01 ~ 2099-12-31
    // 回调中返回的pickedObject为DRYMDWithLunarPickerOutputObject类
    DRDatePickerTypeYMDWithLunar,
    
    // 生日设置时间选择器，可切换显示农历,
    // 通过option参数中的canIgnoreYear设置是否可以忽略年份
    // 由于农历数据限制，目前时间范围只支持1918-01-01 ~ 2099-12-31
    // 回调中返回的pickedObject为DRYMDWithLunarPickerOutputObject类
    DRDatePickerTypeYMDBirthday,
    
    // 计划开始日期设置
    // maxDate无效，currentDate需要在今天及以后，且不超过下一年最后一天
    // 回调中返回的pickedObject为NSDate类
    DRDatePickerTypePlanStart,
    
    // 计划结束日期设置
    // minDate为计划开始日期，maxDate无效
    // 回调中返回的pickedObject为NSDate类
    DRDatePickerTypePlanEnd,
    
    // 年月选择器
    // 回调中返回的pickedObject为NSDate类
    DRDatePickerTypeYearMoth,
    
    // 月、日、周、小时、分钟
    // 回调中返回的pickedObject为NSDate类
    // 可通过option.canClean开启传入清除时间回调
    DRDatePickerTypeMDWT,
    
    // 月、日、周、小时、分钟
    // 仅更改小时分钟，日周显示currentDate
    // 回调中返回的pickedObject为NSDate类
    // minDate, maxDate无效
    DRDatePickerTypeMDWTimeOnly,
    
    // 小时、分钟
    // option.hourMinuteOnly = YES 则回调中返回的pickedObject为HHmm格式字符串
    // 否则返回currentDate日期拼上选中的小时分钟的NSDate，默认为此
    // minDate, maxDate无效
    // currentDate为空且option.hourMinuteOnly = YES时，等同于DRDatePickerTypeHMOnly
    DRDatePickerTypeHM,
    
    // 仅用于选择小时分钟
    // 通过option.currentTime传入当前反显时间
    // 回调中返回的pickedObject为HHmm格式字符串
    // currentDate, minDate, maxDate无效
    DRDatePickerTypeHMOnly,
    
    // 计划中，每周类型添加频次
    // 通过option.currentTime传入当前反显时间
    // 通过option.currentWeekConfig传入反显的每周频次配置
    // 回调中返回的pickedObject为DRHourMinutePickerPlanWeekConfig类型model对象
    // currentDate, minDate, maxDate无效
    DRDatePickerTypeHMPlanWeek,
    
    // 耗时0~9天，0~23小时，0~59分钟
    // 刻度为分钟
    // 通过option.currentDuration传入反显值
    // 回调中返回DRTimeConsumingModel
    DRDatePickerTypeTimeConsuming
};

@interface DRDatePickerFactory : NSObject

/**
 简易的显示指定类型的时间选择器
 
 @param type 选择器类型
 @param currentDate 需要反显选中的时间
 @param minDate 可选择的最小公历日期
 @param maxDate 可选择的最大公历日期
 @param pickDoneBlock 点击完成按钮确认选的回调
 */
+ (void)showDatePickerWithType:(DRDatePickerType)type
                   currentDate:(NSDate *)currentDate
                       minDate:(NSDate *)minDate
                       maxDate:(NSDate *)maxDate
                 pickDoneBlock:(DRDatePickerDoneBlock)pickDoneBlock;

/**
 显示指定类型的时间选择器

 @param type 选择器类型
 @param currentDate 需要反显选中的时间
 @param minDate 可选择的最小公历日期
 @param maxDate 可选择的最大公历日期
 @param option 额外参数，特殊选择器需要额外参数
 @param pickDoneBlock 点击完成按钮确认选的回调
 */
+ (void)showDatePickerWithType:(DRDatePickerType)type
                   currentDate:(NSDate *)currentDate
                       minDate:(NSDate *)minDate
                       maxDate:(NSDate *)maxDate
                   otherOption:(DRDatePickerOption *)option
                 pickDoneBlock:(DRDatePickerDoneBlock)pickDoneBlock;

@end
