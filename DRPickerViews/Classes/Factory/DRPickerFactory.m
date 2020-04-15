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
#import "DROptionCardPicker.h"
#import "DRYearOrYearMonthPicker.h"
#import "DRCityPicker.h"
#import "DRClassTableWeekPicker.h"
#import "DRClassDurationPicker.h"
#import "DRClassRemindTimePicker.h"
#import "DRClassTermPicker.h"
#import "DRLinkagePicker.h"
#import "DRMultipleColumnPicker.h"
#import "DRDateToNowPicker.h"

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
    switch (type) {
        case DRPickerTypeYMD: {
            [DRYMDPicker showPickerViewWithOption:pickerOption
                                       setupBlock:nil
                                    pickDoneBlock:pickDoneBlock];
        } break;
            
        case DRPickerTypeWithLunar: {
            [DRYMDWithLunarPicker showPickerViewWithOption:pickerOption
                                                setupBlock:nil
                                             pickDoneBlock:pickDoneBlock];
        } break;
            
        case DRPickerTypePlanEnd: {
            [DRYMDPicker showPickerViewWithOption:pickerOption
                                       setupBlock:^(DRYMDPicker *picker) {
                                           picker.type = DRYMDPickerTypePlanEnd;
                                       }
                                    pickDoneBlock:pickDoneBlock];
        } break;
            
        case DRPickerTypeYearMonth: {
            [DRYearMonthPicker showPickerViewWithOption:pickerOption
                                             setupBlock:nil
                                          pickDoneBlock:pickDoneBlock];
        } break;

        case DRPickerTypeYearOrYearMoth: {
            [DRYearOrYearMonthPicker showPickerViewWithOption:pickerOption
                                                   setupBlock:nil
                                                pickDoneBlock:pickDoneBlock];
        } break;
            
        case DRPickerTypeYearMonthFileter: {
            [DRYearMonthPicker showPickerViewWithOption:pickerOption
                                             setupBlock:^(DRYearMonthPicker *picker) {
                                                 picker.withMonthViewFilter = YES;
                                             }
                                          pickDoneBlock:pickDoneBlock];
        } break;
            
        case DRPickerTypeOneWeek: {
            [DROneWeekPicker showPickerViewWithOption:pickerOption
                                           setupBlock:nil
                                        pickDoneBlock:pickDoneBlock];
        } break;
            
        case DRPickerTypeHMForDate: {
            [DRHourMinutePicker showPickerViewWithOption:pickerOption
                                              setupBlock:^(DRHourMinutePicker *picker) {
                                                  picker.type = DRHourMinutePickerTypeResetDate;
                                              }
                                           pickDoneBlock:pickDoneBlock];
        } break;
            
        case DRPickerTypeHMOnly: {
            [DRHourMinutePicker showPickerViewWithOption:pickerOption
                                              setupBlock:^(DRHourMinutePicker *picker) {
                                                  picker.type = DRHourMinutePickerTypeNormal;
                                              }
                                           pickDoneBlock:pickDoneBlock];
            
        } break;
            
        case DRPickerTypeHMPlanWeek: {
            [DRHourMinutePicker showPickerViewWithOption:pickerOption
                                              setupBlock:^(DRHourMinutePicker *picker) {
                                                  picker.type = DRHourMinutePickerTypePlanWeekConfig;
                                              }
                                           pickDoneBlock:pickDoneBlock];
        } break;
            
        case DRPickerTypeTimeConsuming: {
            [DRTimeConsumingPicker showPickerViewWithOption:pickerOption
                                                 setupBlock:nil
                                              pickDoneBlock:pickDoneBlock];
        } break;
            
        case DRPickerTypeRemindAhead: {
            [DRAheadTimePicker showPickerViewWithOption:pickerOption
                                             setupBlock:nil
                                          pickDoneBlock:pickDoneBlock];
        } break;
            
        case DRPickerTypeValueSelect: {
            [DRValueSelectPicker showPickerViewWithOption:pickerOption
                                               setupBlock:nil
                                            pickDoneBlock:pickDoneBlock];
        } break;
            
        case DRPickerTypeStringSelect: {
            [DRStringOptionsPicker showPickerViewWithOption:pickerOption
                                                 setupBlock:nil
                                              pickDoneBlock:pickDoneBlock];
        } break;
            
        case DRPickerTypeOptionCard: {
            [DROptionCardPicker showPickerViewWithOption:pickerOption
                                              setupBlock:nil
                                           pickDoneBlock:pickDoneBlock];
        } break;

        case DRPickerTypeCity: {
            [DRCityPicker showPickerViewWithOption:pickerOption
                                        setupBlock:nil
                                     pickDoneBlock:pickDoneBlock];
        } break;

        case DRPickerTypeClassTable: {
            [DRClassTableWeekPicker showPickerViewWithOption:pickerOption
                                                  setupBlock:nil
                                               pickDoneBlock:pickDoneBlock];
        } break;

        case DRPickerTypeClassTerm: {
            [DRClassTermPicker showPickerViewWithOption:pickerOption
                                              setupBlock:nil
                                           pickDoneBlock:pickDoneBlock];
        } break;

        case DRPickerTypeClassDuration: {
            [DRClassDurationPicker showPickerViewWithOption:pickerOption
                                                 setupBlock:nil
                                              pickDoneBlock:pickDoneBlock];
        } break;

        case DRPickerTypeClassRemindTime: {
            [DRClassRemindTimePicker showPickerViewWithOption:pickerOption
                                                   setupBlock:nil
                                                pickDoneBlock:pickDoneBlock];
        } break;
            
        case DRPickerTypeLinkage: {
            [DRLinkagePicker showPickerViewWithOption:pickerOption
                                           setupBlock:nil
                                        pickDoneBlock:pickDoneBlock];
        } break;
            
        case DRPickerTypeMultipleColumn: {
            [DRMultipleColumnPicker showPickerViewWithOption:pickerOption
                                                  setupBlock:nil
                                               pickDoneBlock:pickDoneBlock];
        } break;
            
        case DRPickerTypeDateToNow: {
            [DRDateToNowPicker showPickerViewWithOption:pickerOption
                                             setupBlock:nil
                                          pickDoneBlock:pickDoneBlock];
        } break;
            
        default:
            break;
    }
}

@end
