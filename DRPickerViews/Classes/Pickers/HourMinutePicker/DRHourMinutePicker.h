//
//  DRHourMinutePicker.h
//  Records
//
//  Created by 冯生伟 on 2018/11/8.
//  Copyright © 2018 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRBaseAlertPicker.h"

typedef NS_ENUM(NSInteger, DRHourMinutePickerType) {
    DRHourMinutePickerTypeNormal, // 普通的用于更改小十分钟
    DRHourMinutePickerTypeResetDate,    // 更改指定日期的小十分钟
    DRHourMinutePickerTypePlanWeekConfig, // 每周频次配置
};

@interface DRHourMinutePicker : DRBaseAlertPicker

@property (nonatomic, assign) DRHourMinutePickerType type;

@end
