//
//  DRUIWidgetUtil.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/7/31.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRUIWidgetUtil : NSObject

/// 设置通用颜色，跟随主题
/// @param highlightColor 高亮色
/// @param normalColor 普通文字颜色（一级）
/// @param descColor 描述文字颜色 （二级）
+ (void)setupHighlightColor:(UIColor *)highlightColor
                normalColor:(UIColor *)normalColor
                  descColor:(UIColor *)descColor;

/// 设置渐变色，跟随主题
/// @param lightColor 渐变相对浅色值
/// @param darkColor 渐变相对深色值
+ (void)setupGradientLightColor:(UIColor *)lightColor
                      darkColor:(UIColor *)darkColor;

+ (UIColor *)highlightColor;
+ (UIColor *)normalColor;
+ (UIColor *)descColor;
+ (UIColor *)disableColor;
+ (UIColor *)borderColor;
+ (UIColor *)pickerUnSelectColor;
+ (UIColor *)pickerDisableColor;
+ (UIColor *)gradientLightColor;
+ (UIColor *)gradientDarkColor;

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
