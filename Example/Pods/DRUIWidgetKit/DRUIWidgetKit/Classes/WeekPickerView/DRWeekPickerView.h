//
//  DRWeekPickerView.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/5.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRWeekPickerCell.h"

IB_DESIGNABLE
@interface DRWeekPickerView : UIView

@property (nonatomic, strong, readonly) DRWeekPickerDateModel *currentWeek;

- (void)setupWithCurrentDate:(NSDate *)currentDate
                     minDate:(NSDate *)minDate
                     maxDate:(NSDate *)maxDate
           selectChangeBlock:(void(^)(DRWeekPickerDateModel *currentWeek))selectChangeBlock;

@end
