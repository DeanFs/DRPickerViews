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
};

IB_DESIGNABLE
@interface DRDatePickerView : UIView

@property (nonatomic, assign) IBInspectable NSInteger dateModeXib;
@property (nonatomic, assign) DRDatePickerMode dateMode; // default DRDatePickerModeYMD

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
