//
//  DRHourMinutePicker.h
//  Records
//
//  Created by 冯生伟 on 2018/11/8.
//  Copyright © 2018 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRBaseDatePicker.h"
#import "DRHourMinuteAtomicPickerView.h"

@interface DRHourMinutePickerPlanWeekConfig : NSObject

@property (nonatomic, copy, readonly) NSArray<NSNumber *> *weekDays;
@property (nonatomic, copy, readonly) NSString *pickedTime;
// 持续时长，单位：秒
@property (nonatomic, assign, readonly) int64_t duration;
// 持续时长中文描述
@property (nonatomic, copy, readonly) NSString *durationDesc;
// 结束时间的小时分钟 HHmm
@property (nonatomic, copy, readonly) NSString *endHourMinute;
// 时长不小于最小时长
@property (nonatomic, assign, readonly) BOOL enoughDuration;
// 持续时长跨天标志
@property (nonatomic, assign, readonly) BOOL beyondOneDay;

@end

@interface DRHourMinutePickerDurationModel : NSObject

@property (nonatomic, strong, readonly) NSDate *date;
@property (nonatomic, copy, readonly) NSString *pickedTime; // HHmm
// 持续时长，单位：秒
@property (nonatomic, assign, readonly) int64_t duration;
// 持续时长中文描述
@property (nonatomic, copy, readonly) NSString *durationDesc;
// 结束时间的小时分钟 HHmm
@property (nonatomic, copy, readonly) NSString *endHourMinute;
// 时长不小于最小时长
@property (nonatomic, assign, readonly) BOOL enoughDuration;
// 持续时长跨天标志
@property (nonatomic, assign, readonly) BOOL beyondOneDay;

@end

typedef NS_ENUM(NSInteger, DRHourMinutePickerType) {
    DRHourMinutePickerTypeNormal, // 普通的用于更改小十分钟
    DRHourMinutePickerTypePlanWeekConfig, // 每周频次配置
};

@interface DRHourMinutePicker : DRBaseDatePicker

+ (void)showPickerViewWithType:(DRHourMinutePickerType)type
                   currentDate:(NSDate *)currentDate
                 pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                    setupBlock:(DRDatePickerSetupBlock)setupBlock;

@end
