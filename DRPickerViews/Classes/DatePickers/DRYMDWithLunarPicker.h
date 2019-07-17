//
//  DRYMDWithLunarPicker.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/18.
//

#import "DRBaseDatePicker.h"
#import "DRYMDWithLunarPickerOutputObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRYMDWithLunarPicker : DRBaseDatePicker

/**
 生日时间设置选择器

 @param currentDate 反显当前日期，不忽略年份时的出生年月
 @param minDate 最小可选日期
 @param maxDate 最大可选日期
 @param month 忽略年份时的月
 @param day 忽略年份时的日
 @param ignoreYear 忽略年份
 @param isLunar 使用的是农历
 @param setupBlock 便于以后扩展参数的传入和初始化逻辑增加
 @param pickDoneBlock 选择完成回调
 */
+ (void)showWithCurrentDate:(NSDate *)currentDate
                    minDate:(NSDate *)minDate
                    maxDate:(NSDate *)maxDate
                      month:(NSInteger)month
                        day:(NSInteger)day
                 ignoreYear:(BOOL)ignoreYear
                    isLunar:(BOOL)isLunar
              pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                 setupBlock:(DRDatePickerSetupBlock)setupBlock;


/**
 限定公历时间范围选择时间，可选择农历，不可忽略年份
 由于农历数据限制，目前只支持1918-01-01 ~ 2099-12-31
 
 @param currentDate 当前公历日期
 @param minDate 最小可选日期
 @param maxDate 最大可选日期
 @param isLunar 是否反显农历
 @param setupBlock 便于以后扩展参数的传入和初始化逻辑增加
 @param pickDoneBlock 选择完成：selectedDate(公历日期) isLunar是否是农历
 */
+ (void)showWithCurrentDate:(NSDate *)currentDate
                    minDate:(NSDate *)minDate
                    maxDate:(NSDate *)maxDate
                    isLunar:(BOOL)isLunar
              pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                 setupBlock:(DRDatePickerSetupBlock)setupBlock;

@end

NS_ASSUME_NONNULL_END
