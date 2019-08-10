//
//  DRCalendarTitleView.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/7/31.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface DRCalendarTitleView : UIView

@property (nonatomic, assign) IBInspectable CGFloat fontSize;       // default 13
@property (nonatomic, assign) IBInspectable BOOL showBottomLine;    // default YES

/**
 当前选中的日期
 */
@property (nonatomic, strong) NSDate *currentMonth;

/**
 如果有自定义的年月选择器时，传入该回调，点击标题时呼出自定义年月选择器
 从选择器选择年月确定后，调用didSelectYearMonth(yearMonth)，告知新的年月
 */
@property (nonatomic, copy) void (^willShowYearMonthPickerBlock) (void(^didSelectYearMonth)(NSDate *yearMonth));

/**
 从年月选择器选择年月确定后，执行该回调，告知新的年月
 */
@property (nonatomic, copy) void (^onYearMonthChangeBlock)(NSDate *yearMonth);

- (void)setupWithCurrentMonth:(NSDate *)currentMonth
                     minMonth:(NSDate *)minMonth
                     maxMonth:(NSDate *)maxMonth;

@end
