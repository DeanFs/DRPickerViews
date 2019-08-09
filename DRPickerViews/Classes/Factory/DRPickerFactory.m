//
//  DRDatePickerFactory.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/15.
//

#import "DRPickerFactory.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import "DRYMDPicker.h"
#import "DRYMDWithLunarPicker.h"
#import "DRYearMonthPicker.h"
#import "DRHourMinutePicker.h"
#import "DRTimeConsumingPicker.h"
#import "DRAheadTimePicker.h"
#import "DROneWeekPicker.h"
#import "DRValueSelectPicker.h"
#import "DRStringOptionsPicker.h"

@implementation DRPickerFactory

/**
 显示选择器
 
 @param type 选择器类型
 @param pickerOption 选择器参数
 @param pickDoneBlock 点击完成按钮确认选的回调
 */
+ (void)showPickerViewWithType:(DRPickerType)type
                  pickerOption:(DRPickerOptionBase *)pickerOption
                 pickDoneBlock:(DRPickerDoneBlock)pickDoneBlock {
    DRPickerInnerDoneBlock innerPickDoneBlock = [self pickDoneBlockWithOption:pickerOption
                                                                pickDoneBlock:pickDoneBlock];
    switch (type) {
        case DRPickerTypeYMD: {
            [DRYMDPicker showPickerViewWithOption:pickerOption
                                       setupBlock:^(DRYMDPicker *picker) {
                                           picker.type = DRYMDPickerTypeNormal;
                                       }
                                    pickDoneBlock:innerPickDoneBlock];
        } break;
            
        case DRPickerTypeWithLunar: {
            [DRYMDWithLunarPicker showPickerViewWithOption:pickerOption
                                                setupBlock:^(DRYMDWithLunarPicker *picker) {
                                                    
                                                }
                                             pickDoneBlock:innerPickDoneBlock];
        } break;
            
        case DRPickerTypeBirthday: {
            [DRYMDWithLunarPicker showPickerViewWithOption:pickerOption
                                                setupBlock:^(DRYMDWithLunarPicker *picker) {
                                                    
                                                }
                                             pickDoneBlock:innerPickDoneBlock];
        } break;
            
        case DRPickerTypePlanEnd: {
            [DRYMDPicker showPickerViewWithOption:pickerOption
                                       setupBlock:^(DRYMDPicker *picker) {
                                           picker.type = DRYMDPickerTypePlanEnd;
                                       }
                                    pickDoneBlock:innerPickDoneBlock];
        } break;
            
        case DRPickerTypeYearMoth: {
            [DRYearMonthPicker showPickerViewWithOption:pickerOption
                                             setupBlock:nil
                                          pickDoneBlock:innerPickDoneBlock];
        } break;
            
        case DRPickerTypeYearMothFileter: {
            [DRYearMonthPicker showPickerViewWithOption:pickerOption
                                             setupBlock:^(DRYearMonthPicker *picker) {
                                                 picker.withMonthViewFilter = YES;
                                             }
                                          pickDoneBlock:innerPickDoneBlock];
        } break;
            
        case DRPickerTypeOneWeek: {
            [DROneWeekPicker showPickerViewWithOption:pickerOption
                                           setupBlock:nil
                                        pickDoneBlock:innerPickDoneBlock];
        } break;
            
        case DRPickerTypeHMForDate: {
            [DRHourMinutePicker showPickerViewWithOption:pickerOption
                                              setupBlock:^(DRHourMinutePicker *picker) {
                                                  picker.type = DRHourMinutePickerTypeResetDate;
                                              }
                                           pickDoneBlock:innerPickDoneBlock];
        } break;
            
        case DRPickerTypeHMOnly: {
            [DRHourMinutePicker showPickerViewWithOption:pickerOption
                                              setupBlock:^(DRHourMinutePicker *picker) {
                                                  picker.type = DRHourMinutePickerTypeNormal;
                                              }
                                           pickDoneBlock:innerPickDoneBlock];
            
        } break;
            
        case DRPickerTypeHMPlanWeek: {
            [DRHourMinutePicker showPickerViewWithOption:pickerOption
                                              setupBlock:^(DRHourMinutePicker *picker) {
                                                  picker.type = DRHourMinutePickerTypePlanWeekConfig;
                                              }
                                           pickDoneBlock:innerPickDoneBlock];
        } break;
            
        case DRPickerTypeTimeConsuming: {
            [DRTimeConsumingPicker showPickerViewWithOption:pickerOption
                                                 setupBlock:nil
                                              pickDoneBlock:innerPickDoneBlock];
        } break;
            
        case DRPickerTypeRemindAhead: {
            [DRAheadTimePicker showPickerViewWithOption:pickerOption
                                             setupBlock:nil
                                          pickDoneBlock:innerPickDoneBlock];
        } break;
            
        case DRPickerTypeValueSelect: {
            [DRValueSelectPicker showPickerViewWithOption:pickerOption
                                               setupBlock:nil
                                            pickDoneBlock:innerPickDoneBlock];
        } break;
            
        case DRPickerTypeStringSelect: {
            [DRStringOptionsPicker showPickerViewWithOption:pickerOption
                                                 setupBlock:nil
                                              pickDoneBlock:innerPickDoneBlock];
        } break;
            
        default:
            break;
    }
}

+ (DRPickerInnerDoneBlock)pickDoneBlockWithOption:(DRPickerOptionBase *)pickerOption
                                    pickDoneBlock:(DRPickerDoneBlock)pickDoneBlock {
    return ^BOOL(DRBaseAlertPicker * _Nonnull picker, id  _Nonnull pickedObject) {
        kDR_SAFE_BLOCK(pickDoneBlock, picker, pickedObject);
        if (pickerOption && !pickerOption.autoDismissWhenPicked) {
            return NO;
        }
        return YES;
    };
}

@end
