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
#import <DRCategories/NSUserDefaults+DRExtension.h>
#import <objc/message.h>

typedef UIViewController *(^DRUIWidgetGetTopViewControllerBlock) (void);

static UIColor *_highlightColor;
static UIColor *_oneLevelColor;
static UIColor *_twoLevelColor;
static UIColor *_lineBaseColor;
static UIColor *_gradientLightColor;
static UIColor *_gradientDarkColor;
static BOOL _weekPickerOnlyCurrentMonth = NO;
static NSString *_cityJsonFileName;
static DRUIWidgetGetTopViewControllerBlock _getTopVcBlock;

@implementation DRUIWidgetUtil

#pragma mark - 字体颜色配置
/// 设置通用颜色，跟随主题
/// @param highlightColor 高亮色
/// @param oneLevelColor 普通文字颜色（一级）
/// @param twoLevelColor 描述文字颜色 （二级）
/// @param lineBaseColor 分割线基础色，在这个颜色基础上，0.5pt细分隔线不透明度0.1，粗分割线不透明度0.06
+ (void)setupHighlightColor:(UIColor *)highlightColor
              oneLevelColor:(UIColor *)oneLevelColor
              twoLevelColor:(UIColor *)twoLevelColor
              lineBaseColor:(UIColor *)lineBaseColor {
    _highlightColor = highlightColor;
    _oneLevelColor = oneLevelColor;
    _twoLevelColor = twoLevelColor;
    _lineBaseColor = lineBaseColor;
}

+ (UIColor *)oneLevelColor {
    if (_oneLevelColor == nil) {
        _oneLevelColor = [UIColor hx_colorWithHexRGBAString:@"#232323"];
    }
    return _oneLevelColor;
}

+ (UIColor *)twoLevelColor {
    if (_twoLevelColor == nil) {
        _twoLevelColor = [UIColor hx_colorWithHexRGBAString:@"#3C3C43"];
    }
    return _twoLevelColor;
}

+ (UIColor *)lineBaseColor {
    if (_lineBaseColor == nil) {
        _lineBaseColor = [UIColor blackColor];
    }
    return _lineBaseColor;
}

+ (UIColor *)highlightColor {
    if (_highlightColor == nil) {
        _highlightColor = [UIColor hx_colorWithHexRGBAString:@"#2899FB"];
    }
    return _highlightColor;
}

+ (UIColor *)cancelColor {
    return [[self twoLevelColor] colorWithAlphaComponent:0.85];
}

+ (UIColor *)normalColor {
    return [self oneLevelColor];
}

+ (UIColor *)descColor {
    return [[self twoLevelColor] colorWithAlphaComponent:0.5];
}

+ (UIColor *)disableColor {
    return [[self twoLevelColor] colorWithAlphaComponent:0.3];
}

+ (UIColor *)borderColor {
    return [[self lineBaseColor] colorWithAlphaComponent:0.1];
}

+ (UIColor *)thickLineColor {
    return [[self lineBaseColor] colorWithAlphaComponent:0.06];
}

+ (UIColor *)coverBgColor {
    return [[self lineBaseColor] colorWithAlphaComponent:0.24];
}

+ (UIColor *)pickerDisableColor {
    return [[self oneLevelColor] colorWithAlphaComponent:0.2];
}

#pragma mark - 包含小时分钟的时间选择器，分钟步长设置
/// 设置时间步长
/// @param timeScale 步长，默认5
+ (void)setTimeScale:(NSInteger)timeScale {
    [NSUserDefaults setInteger:timeScale forKey:@"global_default_time_scale"];
}

+ (NSInteger)defaultTimeScale {
    NSInteger timeScale = [NSUserDefaults integerForKey:@"global_default_time_scale"];
    if (timeScale == 0) {
        timeScale = 5;
        [self setTimeScale:5];
    }
    return timeScale;
}

#pragma mark - 城市选择器，城市列表资源配置
/// 设置城市列表json文件，放到mainBundle中
/// @param fileName json文件名
+ (void)setupCityListJsonFileName:(NSString *)fileName {
    _cityJsonFileName = fileName;
}

// 城市列表json文件
+ (NSString *)cityJsonFileName {
    if (!_cityJsonFileName) {
        _cityJsonFileName = @"city_list";
    }
    return _cityJsonFileName;
}

#pragma mark - 一周滚轮选择器显示配置
+ (BOOL)weekPickerOnlyCurrentMonth {
    return _weekPickerOnlyCurrentMonth;
}

+ (void)setWeekPickerOnlyCurrentMonth:(BOOL)only {
    _weekPickerOnlyCurrentMonth = only;
}

#pragma mark - 工具方法
/**
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

/// 加载pod包内的png图片
+ (UIImage *)pngImageWithName:(NSString *)imageName
                     inBundle:(NSBundle *)bundle {
    NSInteger scale = (NSInteger)[UIScreen mainScreen].scale;
    NSString *realImageName = [imageName stringByAppendingFormat:@"@%ldx", (long)scale];
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:realImageName ofType:@"png"]];
}

/// 设置获取顶层视图控制器回调
/// @param getTopVcBlock 获取顶层视图控制器回调
+ (void)setGetTopViewControllerBlock:(UIViewController *(^)(void))getTopVcBlock {
    _getTopVcBlock = getTopVcBlock;
}

/// 获取顶层视图控制器
+ (UIViewController *)topViewController {
    if (_getTopVcBlock != nil) {
        return _getTopVcBlock();
    }
    return nil;
}

#pragma mark - scrollView.delegate method hook
+ (BOOL)addSelector:(SEL)selector forObj:(id)obj fromObj:(id)fromObj imp:(IMP)imp {
    Method exchangeM = class_getInstanceMethod([fromObj class], selector);
    return class_addMethod([obj class],
                           selector,
                           imp,
                           method_getTypeEncoding(exchangeM));
}

void add_scrollViewDidScroll(id self, SEL _cmd, UIScrollView *scrollView) {}
void add_scrollViewWillBeginDragging(id self, SEL _cmd, UIScrollView *scrollView) {}
void add_scrollViewDidEndDecelerating(id self, SEL _cmd, UIScrollView *scrollView) {}
void add_scrollViewDidEndScrollingAnimation(id self, SEL _cmd, UIScrollView *scrollView) {}
void add_scrollViewWillEndDragging(id self, SEL _cmd, UIScrollView *scrollView, CGPoint velocity, CGPoint *targetContentOffset) {}

@end
