//
//  DRLunarDatePickerView.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/4.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface DRLunarDatePickerView : UIView

@property (nonatomic, assign) IBInspectable BOOL ignoreYear; // default NO
@property (nonatomic, strong, readonly) NSDate *selectedDate;
@property (nonatomic, copy) void (^onSelectChangeBlock) (NSDate *date, NSInteger year, NSInteger month, NSInteger day, BOOL leapMonth);

/**
 初始化
 在执行该方法前先设置ignoreYear

 @param currentDate 公历日期，内部会转为农历反显
 @param minDate 公历日期
 @param maxDate 公历日期
 @param month 忽略年份时的月
 @param day 忽略年份时的日
 @param leapMonth 是否闰月
 @param selectChangeBlock 输出的date为公历日期
 */
- (void)setupWithCurrentDate:(NSDate *)currentDate
                     minDate:(NSDate *)minDate
                     maxDate:(NSDate *)maxDate
                       month:(NSInteger)month
                         day:(NSInteger)day
                   leapMonth:(BOOL)leapMonth
           selectChangeBlock:(void(^)(NSDate *date, NSInteger year, NSInteger month, NSInteger day, BOOL leapMonth))selectChangeBlock;

/**
 刷新显示

 @param date 公历日期
 @param month 忽略年份时的月
 @param leapMonth 是否闰月
 @param day 忽略年份时的日
 */
- (void)refreshWithDate:(NSDate *)date
                  month:(NSInteger)month
                    day:(NSInteger)day
              leapMonth:(BOOL)leapMonth;

@end
