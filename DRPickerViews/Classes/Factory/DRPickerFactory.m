//
//  DRDatePickerFactory.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/15.
//

#import "DRPickerFactory.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import "DRYMDPicker.h"             // year month day
#import "DRYMDWithLunarPicker.h"    // year month day lunar
#import "DRYearMonthPicker.h"       // year month
#import "DRHourMinutePicker.h"      // hour minute
#import "DRTimeConsumingPicker.h"   // day hour minute
#import "DRAheadTimePicker.h"
#import "DROneWeekPicker.h"
#import "DRValueSelectPicker.h"
#import "DRStringOptionsPicker.h"

@implementation DRPickerFactory

/**
 显示指定类型的时间选择器
 
 @param type 选择器类型
 @param currentDate 需要反显选中的时间
 @param minDate 可选择的最小公历日期
 @param maxDate 可选择的最大公历日期
 @param pickDoneBlock 点击完成按钮确认选的回调
 */
+ (void)showDatePickerWithType:(DRPickerType)type
                   currentDate:(NSDate *)currentDate
                       minDate:(NSDate *)minDate
                       maxDate:(NSDate *)maxDate
                 pickDoneBlock:(DRPickerDoneBlock)pickDoneBlock {
    [DRPickerFactory showDatePickerWithType:type
                                    currentDate:currentDate
                                        minDate:minDate
                                        maxDate:maxDate
                                    otherOption:nil
                                  pickDoneBlock:pickDoneBlock];
}

/**
 非日期时间类的选择器调用
 
 @param type 选择器类型
 @param option 选择器参数
 @param pickDoneBlock 点击完成按钮确认选的回调
 */
+ (void)showPickerViewWithType:(DRPickerType)type
                        option:(DRPickerOption *)option
                 pickDoneBlock:(DRPickerDoneBlock)pickDoneBlock {
    [self showDatePickerWithType:type
                     currentDate:nil
                         minDate:nil
                         maxDate:nil
                     otherOption:option
                   pickDoneBlock:pickDoneBlock];
}

/**
 显示指定类型的时间选择器
 
 @param type 选择器类型
 @param currentDate 需要反显选中的时间
 @param minDate 可选择的最小公历日期
 @param maxDate 可选择的最大公历日期
 @param option 额外参数，特殊选择器需要额外参数
 @param pickDoneBlock 点击完成按钮确认选的回调
 */
+ (void)showDatePickerWithType:(DRPickerType)type
                   currentDate:(NSDate *)currentDate
                       minDate:(NSDate *)minDate
                       maxDate:(NSDate *)maxDate
                   otherOption:(DRPickerOption *)option
                 pickDoneBlock:(DRPickerDoneBlock)pickDoneBlock {
    DRDatePickerInnerDoneBlock innerPickDoneBlock = [self pickDoneBlockWithOption:option
                                                                    pickDoneBlock:pickDoneBlock];
    DRDatePickerSetupBlock setupBlock = [self setupBlockWithOption:option];
    switch (type) {
        case DRPickerTypeYMD: {
            if (!option.title.length) {
                option.title = @"选择日期";
            }
            [DRYMDPicker showDatePickerWithCurrentDate:currentDate
                                               minDate:minDate
                                               maxDate:maxDate
                                         pickDoneBlock:innerPickDoneBlock
                                            setupBlock:setupBlock];
        } break;
            
        case DRPickerTypeYMDWithLunar: {
            [DRYMDWithLunarPicker showWithCurrentDate:currentDate
                                              minDate:minDate
                                              maxDate:maxDate
                                              isLunar:option.isLunar
                                            leapMonth:option.leapMonth
                                        pickDoneBlock:innerPickDoneBlock
                                           setupBlock:setupBlock];
        } break;
            
        case DRPickerTypeYMDBirthday: {
            [DRYMDWithLunarPicker showWithCurrentDate:currentDate
                                              minDate:minDate
                                              maxDate:maxDate
                                                month:option.month
                                                  day:option.day
                                           ignoreYear:option.ignoreYear
                                              isLunar:option.isLunar
                                            leapMonth:option.leapMonth
                                        pickDoneBlock:innerPickDoneBlock
                                           setupBlock:setupBlock];
        } break;
            
        case DRPickerTypePlanStart: {
            [DRYMDPicker showStartDatePickerWithCurrentDate:currentDate
                                                    minDate:minDate
                                            pickDoneBlock:innerPickDoneBlock
                                                 setupBlock:setupBlock];
        } break;
            
        case DRPickerTypePlanEnd: {
            [DRYMDPicker showEndDatePickerWithCurrentDate:currentDate
                                                startDate:minDate
                                          pickDoneBlock:innerPickDoneBlock
                                               setupBlock:setupBlock];
        } break;
            
        case DRPickerTypeYearMoth: {
            [DRYearMonthPicker showPickerViewWithCurrentDate:currentDate
                                                     minDate:minDate
                                                     maxDate:maxDate
                                               pickDoneBlock:innerPickDoneBlock
                                                  setupBlock:setupBlock];
        } break;
            
        case DRPickerTypeYearMothFileterMonthView: {
            [DRYearMonthPicker showPickerViewWithCurrentDate:currentDate
                                                     minDate:minDate
                                                     maxDate:maxDate
                                               pickDoneBlock:innerPickDoneBlock
                                                  setupBlock:^(DRBaseDatePicker *picker) {
                                                      DRYearMonthPicker *ymPickerView = (DRYearMonthPicker *)picker;
                                                      ymPickerView.withMonthViewFilter = YES;
                                                      setupBlock(picker);
                                                  }];
        } break;
            
        case DRPickerTypeOneWeek: {
            [DROneWeekPicker showPickerViewWithCurrentDate:currentDate
                                                     minDate:minDate
                                                     maxDate:maxDate
                                               pickDoneBlock:innerPickDoneBlock
                                                  setupBlock:setupBlock];
        } break;
            
        case DRPickerTypeHM: {
            if (!currentDate) {
                currentDate = [NSDate date];
            }
            [DRHourMinutePicker showPickerViewWithType:DRHourMinutePickerTypeNormal
                                           currentDate:currentDate
                                         pickDoneBlock:innerPickDoneBlock
                                            setupBlock:setupBlock];
        } break;
            
        case DRPickerTypeHMOnly: {
            [DRHourMinutePicker showPickerViewWithType:DRHourMinutePickerTypeNormal
                                           currentDate:nil
                                         pickDoneBlock:innerPickDoneBlock
                                            setupBlock:setupBlock];
            
        } break;
            
        case DRPickerTypeHMPlanWeek: {
            [DRHourMinutePicker showPickerViewWithType:DRHourMinutePickerTypePlanWeekConfig
                                           currentDate:nil
                                         pickDoneBlock:innerPickDoneBlock
                                            setupBlock:setupBlock];
        } break;
            
        case DRPickerTypeTimeConsuming: {
            [DRTimeConsumingPicker showPickerViewWithCurrentDate:nil
                                                         minDate:nil
                                                         maxDate:nil
                                                   pickDoneBlock:innerPickDoneBlock
                                                      setupBlock:setupBlock];
        } break;
            
        case DRPickerTypeRemindAhead: {            
            [DRAheadTimePicker showPickerViewWithCurrentDate:nil
                                                     minDate:nil
                                                     maxDate:nil
                                               pickDoneBlock:innerPickDoneBlock
                                                  setupBlock:setupBlock];
        } break;
            
        case DRPickerTypeValueSelect: {
            [DRValueSelectPicker showPickerViewWithCurrentDate:currentDate
                                                       minDate:minDate
                                                       maxDate:maxDate
                                                 pickDoneBlock:innerPickDoneBlock
                                                    setupBlock:setupBlock];
        } break;
            
        case DRPickerTypeStringOption: {
            [DRStringOptionsPicker showPickerViewWithCurrentDate:currentDate
                                                         minDate:minDate
                                                         maxDate:maxDate
                                                   pickDoneBlock:innerPickDoneBlock
                                                      setupBlock:setupBlock];
        } break;
            
        default:
            break;
    }
}

+ (DRDatePickerInnerDoneBlock)pickDoneBlockWithOption:(DRPickerOption *)option
                                        pickDoneBlock:(DRPickerDoneBlock)pickDoneBlock {
    return ^BOOL(DRBaseDatePicker * _Nonnull picker, id  _Nonnull pickedObject) {
        kDR_SAFE_BLOCK(pickDoneBlock, picker, pickedObject);
        if (option && !option.autoDismissWhenPicked) {
            return NO;
        }
        return YES;
    };
}

+ (DRDatePickerSetupBlock)setupBlockWithOption:(DRPickerOption *)option {
    return ^void(DRBaseDatePicker *picker) {
        picker.pickOption = option;
        if (option.title.length) {
            picker.topBar.centerButtonTitle = option.title;
        }
        if (option.showInView) {
            picker.frame = option.showInView.bounds;
            [option.showInView addSubview:picker];
        } else {
            picker.frame = kDRWindow.bounds;
            [kDRWindow addSubview:picker];
        }
    };
}

@end
