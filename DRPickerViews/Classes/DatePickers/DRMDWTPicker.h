//
//  DRMDWTPicker.h
//  Records
//
//  Created by Zube on 2018/3/24.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRBaseDatePicker.h"

@interface DRMDWTPickerOutputObject : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) int64_t timestamp; // yyyyMMddHHmmss

@end

@interface DRMDWTPicker : DRBaseDatePicker

/// 仅选择小时分钟，日期显示currentDate
@property (nonatomic, assign) BOOL pickTimeOnly;

@end
