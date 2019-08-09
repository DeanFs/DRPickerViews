//
//  DRYMDPicker.h
//  Records
//
//  Created by 冯生伟 on 2018/10/30.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRBaseAlertPicker.h"

typedef NS_ENUM(NSInteger, DRYMDPickerType) {
    DRYMDPickerTypeNormal, // 普通的日期选择器
    DRYMDPickerTypePlanEnd, // 计划结束日期的设置
};

NS_ASSUME_NONNULL_BEGIN

@interface DRYMDPicker : DRBaseAlertPicker

@property (nonatomic, assign) DRYMDPickerType type;

@end

NS_ASSUME_NONNULL_END
