//
//  DRUIWidgetUtil.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/7/31.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRUIWidgetUtil : NSObject

#pragma mark - 字体颜色配置
/// 设置通用颜色，跟随主题
/// @param highlightColor 高亮色
/// @param oneLevelColor 普通文字颜色（一级）
/// @param twoLevelColor 描述文字颜色 （二级）
/// @param lineBaseColor 分割线基础色，在这个颜色基础上，0.5pt细分隔线不透明度0.1，粗分割线不透明度0.06
+ (void)setupHighlightColor:(UIColor *)highlightColor
              oneLevelColor:(UIColor *)oneLevelColor
              twoLevelColor:(UIColor *)twoLevelColor
              lineBaseColor:(UIColor *)lineBaseColor;

+ (UIColor *)highlightColor;
+ (UIColor *)cancelColor;
+ (UIColor *)normalColor;
+ (UIColor *)descColor;
+ (UIColor *)disableColor;
+ (UIColor *)borderColor;
+ (UIColor *)thickLineColor;
+ (UIColor *)coverBgColor;
+ (UIColor *)pickerDisableColor;

#pragma mark - 包含小时分钟的时间选择器，分钟步长设置
/// 设置时间步长
/// @param timeScale 步长，默认5
+ (void)setTimeScale:(NSInteger)timeScale;
+ (NSInteger)defaultTimeScale;

#pragma mark - 城市选择器，城市列表资源配置
/// 设置城市列表json文件，放到mainBundle中
/// @param fileName json文件名
+ (void)setupCityListJsonFileName:(NSString *)fileName;

// 城市列表json文件
+ (NSString *)cityJsonFileName;

#pragma mark - 一周滚轮选择器显示配置
+ (BOOL)weekPickerOnlyCurrentMonth;
+ (void)setWeekPickerOnlyCurrentMonth:(BOOL)only;

#pragma mark - 工具方法
/**
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

/// 加载pod包内的png图片
+ (UIImage *)pngImageWithName:(NSString *)imageName
                     inBundle:(NSBundle *)bundle;

/// 设置获取顶层视图控制器回调
/// @param getTopVcBlock 获取顶层视图控制器回调
+ (void)setGetTopViewControllerBlock:(UIViewController *(^)(void))getTopVcBlock;

/// 获取顶层视图控制器
+ (UIViewController *)topViewController;

@end
