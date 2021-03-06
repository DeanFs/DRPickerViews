//
//  DRDatePickerView.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/2.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DRDatePickerMode) {
    DRDatePickerModeYMD, // 年月日
    DRDatePickerModeYM,  // 年月
    DRDatePickerModeMD,  // 月日，忽略年份
    DRDatePickerModeYearOnly // 仅显示年
};

IB_DESIGNABLE
@interface DRDatePickerView : UIView

@property (nonatomic, assign) DRDatePickerMode dateMode;
@property (nonatomic, assign) IBInspectable NSInteger dateModeXib;
/// 年月日文字字体
@property (strong, nonatomic) UIFont *textFont;
/// 分隔线字体
@property (strong, nonatomic) UIFont *separatorFont;
/// 年月日文字颜色
@property (strong, nonatomic) UIColor *textColor;
/// 底部显示农历日期，DRDatePickerModeYMD模式有效，默认 NO
@property (nonatomic, assign) BOOL showLunarTip;

@property (nonatomic, copy) void (^onSelectChangeBlock) (NSDate *date, NSInteger month, NSInteger day);
@property (nonatomic, strong, readonly) NSDate *selectedDate;
@property (nonatomic, assign, readonly) NSInteger selectedYear;
@property (nonatomic, assign, readonly) NSInteger selectedMonth;
@property (nonatomic, assign, readonly) NSInteger selectedDay;

// 在执行该方法前先设置dateMode
- (void)setupWithCurrentDate:(NSDate *)currentDate
                     minDate:(NSDate *)minDate
                     maxDate:(NSDate *)maxDate
                       month:(NSInteger)month
                         day:(NSInteger)day;

- (void)refreshWithDate:(NSDate *)date
                  month:(NSInteger)month
                    day:(NSInteger)day;

@end
