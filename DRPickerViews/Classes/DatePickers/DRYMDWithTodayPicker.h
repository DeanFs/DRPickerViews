//
//  DRYMDWithTodayPicker.h
//  Records
//
//  Created by 冯生伟 on 2019/1/28.
//  Copyright © 2019 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRBaseDatePicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRYMDWithTodayPicker : DRBaseDatePicker

+ (void)showDatePickerViewWithCurrentDate:(NSDate *)currentDate
                                  minDate:(NSDate *)minDate
                                  maxDate:(NSDate *)maxDate
                            pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                               setupBlock:(DRDatePickerSetupBlock)setupBlock;

@end

NS_ASSUME_NONNULL_END
