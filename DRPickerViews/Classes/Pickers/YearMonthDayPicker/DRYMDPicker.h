//
//  DRYMDPicker.h
//  Records
//
//  Created by 冯生伟 on 2018/10/30.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRBaseDatePicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRYMDPicker : DRBaseDatePicker

+ (void)showStartDatePickerWithCurrentDate:(NSDate *)currentDate
                                   minDate:(NSDate *)minDate
                             pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                                setupBlock:(DRDatePickerSetupBlock)setupBlock;

+ (void)showEndDatePickerWithCurrentDate:(NSDate *)currentDate
                               startDate:(NSDate *)startDate
                           pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                              setupBlock:(DRDatePickerSetupBlock)setupBlock;

+ (void)showDatePickerWithCurrentDate:(NSDate *)currentDate
                              minDate:(NSDate *)minDate
                              maxDate:(NSDate *)maxDate
                        pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                           setupBlock:(DRDatePickerSetupBlock)setupBlock;

@end

NS_ASSUME_NONNULL_END
