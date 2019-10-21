//
//  DRUIWidgetUtil.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/7/31.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRUIWidgetUtil.h"
#import <HexColors/HexColors.h>
#import <DRCategories/NSDate+DRExtension.h>

static UIColor *_highlightColor;
static UIColor *_normalColor;
static UIColor *_descColor;
static UIColor *_gradientLightColor;
static UIColor *_gradientDarkColor;
static BOOL _weekPickerOnlyCurrentMonth = NO;
static NSString *_cityJsonFileName;

@implementation DRUIWidgetUtil

/// 设置通用颜色，跟随主题
/// @param highlightColor 高亮色
/// @param normalColor 普通文字颜色（一级）
/// @param descColor 描述文字颜色 （二级）
+ (void)setupHighlightColor:(UIColor *)highlightColor
                normalColor:(UIColor *)normalColor
                  descColor:(UIColor *)descColor {
    _highlightColor = highlightColor;
    _normalColor = normalColor;
    _descColor = descColor;
}

/// 设置渐变色，跟随主题
/// @param lightColor 渐变相对浅色值
/// @param darkColor 渐变相对深色值
+ (void)setupGradientLightColor:(UIColor *)lightColor
                      darkColor:(UIColor *)darkColor {
    _gradientLightColor = lightColor;
    _gradientDarkColor = darkColor;
}

/// 设置城市列表json文件，放到mainBundle中
/// @param fileName json文件名
+ (void)setupCityListJsonFileName:(NSString *)fileName {
    _cityJsonFileName = fileName;
}

+ (UIColor *)highlightColor {
    if (!_highlightColor) {
        _highlightColor = [UIColor hx_colorWithHexRGBAString:@"4BA2F3"];
    }
    return _highlightColor;
}

+ (UIColor *)normalColor {
    if (!_normalColor) {
        _normalColor = [UIColor hx_colorWithHexRGBAString:@"465B88"];
    }
    return _normalColor;
}

+ (UIColor *)descColor {
    if (!_descColor) {
        _descColor = [UIColor hx_colorWithHexRGBAString:@"B8BFCD"];
    }
    return _descColor;
}

+ (UIColor *)pickerUnSelectColor {
    return [_normalColor colorWithAlphaComponent:0.4];
}

+ (UIColor *)pickerDisableColor {
    return [_normalColor colorWithAlphaComponent:0.18];
}

+ (UIColor *)disableColor {
    return [_normalColor colorWithAlphaComponent:0.3];
}

+ (UIColor *)borderColor {
    return [_normalColor colorWithAlphaComponent:0.1];
}

+ (UIColor *)gradientLightColor {
    if (!_gradientLightColor) {
        _gradientLightColor = [UIColor hx_colorWithHexRGBAString:@"8CCDFF"];
    }
    return _gradientLightColor;
}

+ (UIColor *)gradientDarkColor {
    if (!_gradientDarkColor) {
        _gradientDarkColor = [UIColor hx_colorWithHexRGBAString:@"4BA2F3"];
    }
    return _gradientDarkColor;
}

+ (BOOL)weekPickerOnlyCurrentMonth {
    return _weekPickerOnlyCurrentMonth;
}

+ (void)setWeekPickerOnlyCurrentMonth:(BOOL)only {
    _weekPickerOnlyCurrentMonth = only;
}

+ (NSString *)cityJsonFileName {
    if (!_cityJsonFileName) {
        _cityJsonFileName = @"city_list";
    }
    return _cityJsonFileName;
}

/**
 工具方法
 检查currentDate, minDate, maxDate设置的合理性，并进行修正
 子类中选择性调用该方法
 */
+ (void)dateLegalCheckForCurrentDate:(NSDate **)currentDate
                             minDate:(NSDate **)minDate
                             maxDate:(NSDate **)maxDate {
    // 当前时间默认今天
    if (!*currentDate) {
        *currentDate = [NSDate date].midnight;
    } else {
        *currentDate = (*currentDate).midnight;
    }
    if (!*minDate) {
        *minDate = [NSDate minDate];
    } else {
        *minDate = (*minDate).midnight;
    }
    
    // 当前时间不能比最小日期小
    if ([*currentDate compare:*minDate] == NSOrderedAscending) {
        if (*maxDate && [*minDate compare:*maxDate] == NSOrderedDescending) {
            *minDate = [NSDate minDate];
            *maxDate = [NSDate maxDate];
            return;
        } else {
            *currentDate = *minDate;
        }
    }
    
    // 最大日期默认y100年后最后一天最后一秒
    if (!*maxDate || [*minDate compare:*maxDate] == NSOrderedDescending) {
        *maxDate = [NSDate maxDate];
        return;
    } else {
        *maxDate = (*maxDate).midnight;
    }
    
    if ([*currentDate compare:*maxDate] == NSOrderedDescending) {
        *currentDate = *maxDate;
    }
}

/**
 隐藏pickerView的分割线
 */
+ (void)hideSeparateLineForPickerView:(UIPickerView *)pickerView {
    for (UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height > 0 && singleLine.frame.size.height < 1) {
            singleLine.hidden = YES;
        }
    }
}

+ (UIImage *)pngImageWithName:(NSString *)imageName
                     inBundle:(NSBundle *)bundle {
    NSInteger scale = (NSInteger)[UIScreen mainScreen].scale;
    NSString *realImageName = [imageName stringByAppendingFormat:@"@%ldx", scale];
    NSString *path = [bundle pathForResource:realImageName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:realImageName ofType:@"png"]];
}

@end
