//
//  DRLunarDatePickerView.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/4.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRLunarDatePickerMonthModel : NSObject

@property (nonatomic, assign) NSInteger lunarYear;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDateComponents *cmp;
@property (nonatomic, assign) NSInteger dayCount;
@property (nonatomic, assign) NSInteger index;

@end

IB_DESIGNABLE
@interface DRLunarDatePickerView : UIView

@property (nonatomic, assign) IBInspectable BOOL ignoreYear; // default NO

/**
 date：公历日期
 month：当前选中的月，不含闰，如：闰七月 == 7
 day：当前选中的日
 */
@property (nonatomic, copy) void (^onSelectChangeBlock) (NSDate *date, NSInteger month, NSInteger day);

@property (nonatomic, strong, readonly) NSDate *selectedDate;
@property (nonatomic, strong, readonly) DRLunarDatePickerMonthModel *selectedMonth;
@property (nonatomic, assign, readonly) NSInteger selectedDay;

/**
 初始化
 在执行该方法前先设置ignoreYear

 @param currentDate 公历日期，内部会转为农历反显
 @param minDate 公历日期
 @param maxDate 公历日期
 @param month 忽略年份时的月
 @param day 忽略年份时的日
 @param leapMonth 是否闰月
 */
- (void)setupWithCurrentDate:(NSDate *)currentDate
                     minDate:(NSDate *)minDate
                     maxDate:(NSDate *)maxDate
                       month:(NSInteger)month
                         day:(NSInteger)day
                   leapMonth:(BOOL)leapMonth;

/**
 刷新显示

 @param date 公历日期
 @param month 忽略年份时的月
 @param day 忽略年份时的日
 */
- (void)refreshWithDate:(NSDate *)date
                  month:(NSInteger)month
                    day:(NSInteger)day;

@end
