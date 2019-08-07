//
//  DRUIWidgetUtil.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/7/31.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRUIWidgetUtil : NSObject

+ (void)setupHighlightColor:(UIColor *)highlightColor
                normalColor:(UIColor *)normalColor
                  descColor:(UIColor *)descColor;

+ (UIColor *)highlightColor;
+ (UIColor *)normalColor;
+ (UIColor *)descColor;
+ (UIColor *)disableColor;
+ (UIColor *)borderColor;
+ (UIColor *)pickerUnSelectColor;
+ (UIColor *)pickerDisableColor;

+ (BOOL)weekPickerOnlyCurrentMonth;
+ (void)setWeekPickerOnlyCurrentMonth:(BOOL)only;

/**
 工具方法
 检查currentDate, minDate, maxDate设置的合理性，并进行修正
 子类中选择性调用该方法
 */
+ (void)dateLegalCheckForCurrentDate:(NSDate **)currentDate
                             minDate:(NSDate **)minDate
                             maxDate:(NSDate **)maxDate;

/**
 隐藏pickerView的分割线
 */
+ (void)hideSeparateLineForPickerView:(UIPickerView *)pickerView;

@end
