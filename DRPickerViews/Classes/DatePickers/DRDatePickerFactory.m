//
//  DRDatePickerFactory.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/15.
//

#import "DRDatePickerFactory.h"
#import "NSDate+DRExtension.h"
#import "DRBasicKitDefine.h"

@implementation DRDatePickerFactory

/**
 显示指定类型的时间选择器
 
 @param type 选择器类型
 @param currentDate 需要反显选中的时间
 @param minDate 可选择的最小公历日期
 @param maxDate 可选择的最大公历日期
 @param pickDoneBlock 点击完成按钮确认选的回调
 */
+ (void)showDatePickerWithType:(DRDatePickerType)type
                   currentDate:(NSDate *)currentDate
                       minDate:(NSDate *)minDate
                       maxDate:(NSDate *)maxDate
                 pickDoneBlock:(DRDatePickerDoneBlock)pickDoneBlock {
    [DRDatePickerFactory showDatePickerWithType:type
                                    currentDate:currentDate
                                        minDate:minDate
                                        maxDate:maxDate
                                    otherOption:nil
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
+ (void)showDatePickerWithType:(DRDatePickerType)type
                   currentDate:(NSDate *)currentDate
                       minDate:(NSDate *)minDate
                       maxDate:(NSDate *)maxDate
                   otherOption:(DRDatePickerOption *)option
                 pickDoneBlock:(DRDatePickerDoneBlock)pickDoneBlock {
    DRDatePickerInnerDoneBlock innerPickDoneBlock = [self pickDoneBlockWithOption:option
                                                                    pickDoneBlock:pickDoneBlock];
    DRDatePickerSetupBlock setupBlock = [self setupBlockWithOption:option];
    switch (type) {
        case DRDatePickerTypeYMD: {
            if (!option.title.length) {
                option.title = @"选择日期";
            }
            [DRYMDPicker showDatePickerWithCurrentDate:currentDate
                                               minDate:minDate
                                               maxDate:maxDate
                                         pickDoneBlock:innerPickDoneBlock
                                            setupBlock:setupBlock];
        } break;
            
        case DRDatePickerTypeYMDWithToday: {
            [DRYMDWithTodayPicker showDatePickerViewWithCurrentDate:currentDate
                                                            minDate:minDate
                                                            maxDate:maxDate
                                                      pickDoneBlock:innerPickDoneBlock
                                                         setupBlock:setupBlock];
        } break;
            
        case DRDatePickerTypeYMDWithLunar: {
            [DRYMDWithLunarPicker showWithCurrentDate:currentDate
                                              minDate:minDate
                                              maxDate:maxDate
                                              isLunar:option.isLunar
                                        pickDoneBlock:innerPickDoneBlock
                                           setupBlock:setupBlock];
        } break;
            
        case DRDatePickerTypeYMDBirthday: {
            [DRYMDWithLunarPicker showWithCurrentDate:currentDate
                                              minDate:minDate
                                              maxDate:maxDate
                                                month:option.month
                                                  day:option.day
                                           ignoreYear:option.ignoreYear
                                              isLunar:option.isLunar
                                        pickDoneBlock:innerPickDoneBlock
                                           setupBlock:setupBlock];
        } break;
            
        case DRDatePickerTypePlanStart: {
            [DRYMDPicker showStartDatePickerWithCurrentDate:currentDate
                                                    minDate:minDate
                                            pickDoneBlock:innerPickDoneBlock
                                                 setupBlock:setupBlock];
        } break;
            
        case DRDatePickerTypePlanEnd: {
            [DRYMDPicker showEndDatePickerWithCurrentDate:currentDate
                                                startDate:minDate
                                          pickDoneBlock:innerPickDoneBlock
                                               setupBlock:setupBlock];
        } break;
            
        case DRDatePickerTypeYearMoth: {
            [DRYearMonthPicker showPickerViewWithCurrentDate:currentDate
                                                     minDate:minDate
                                                     maxDate:maxDate
                                               pickDoneBlock:innerPickDoneBlock
                                                  setupBlock:setupBlock];
        } break;
            
        case DRDatePickerTypeMDWT: {
            [DRMDWTPicker showPickerViewWithCurrentDate:currentDate
                                                minDate:minDate
                                                maxDate:maxDate
                                          pickDoneBlock:innerPickDoneBlock
                                             setupBlock:setupBlock];
        } break;
            
        case DRDatePickerTypeMDWTimeOnly: {
            [DRMDWTPicker showPickerViewWithCurrentDate:currentDate
                                                minDate:minDate
                                                maxDate:maxDate
                                          pickDoneBlock:innerPickDoneBlock
                                             setupBlock:^(DRBaseDatePicker * _Nonnull picker) {
                                                 setupBlock(picker);
                                                 DRMDWTPicker *mdtPicker = (DRMDWTPicker *)picker;
                                                 mdtPicker.pickTimeOnly = YES;
                                             }];
        } break;
            
        case DRDatePickerTypeHM: {
            if (!currentDate) {
                currentDate = [NSDate date];
            }
            [DRHourMinutePicker showPickerViewWithType:DRHourMinutePickerTypeNormal
                                           currentDate:currentDate
                                         pickDoneBlock:innerPickDoneBlock
                                            setupBlock:setupBlock];
        } break;
            
        case DRDatePickerTypeHMOnly: {
            [DRHourMinutePicker showPickerViewWithType:DRHourMinutePickerTypeNormal
                                           currentDate:nil
                                         pickDoneBlock:innerPickDoneBlock
                                            setupBlock:setupBlock];
            
        } break;
            
        case DRDatePickerTypeHMPlanWeek: {
            [DRHourMinutePicker showPickerViewWithType:DRHourMinutePickerTypePlanWeekConfig
                                           currentDate:nil
                                         pickDoneBlock:innerPickDoneBlock
                                            setupBlock:setupBlock];
        } break;
            
        case DRDatePickerTypeTimeConsuming: {
            [DRTimeConsumingPicker showPickerViewWithCurrentDate:nil
                                                         minDate:nil
                                                         maxDate:nil
                                                   pickDoneBlock:innerPickDoneBlock
                                                      setupBlock:setupBlock];
        } break;
            
        default:
            break;
    }
}

+ (DRDatePickerInnerDoneBlock)pickDoneBlockWithOption:(DRDatePickerOption *)option
                                        pickDoneBlock:(DRDatePickerDoneBlock)pickDoneBlock {
    return ^BOOL(DRBaseDatePicker * _Nonnull picker, id  _Nonnull pickedObject) {
        kDR_SAFE_BLOCK(pickDoneBlock, picker, pickedObject);
        if (option && !option.autoDismissWhenPicked) {
            return NO;
        }
        return YES;
    };
}

+ (DRDatePickerSetupBlock)setupBlockWithOption:(DRDatePickerOption *)option {
    return ^void(DRBaseDatePicker *picker) {
        picker.pickOption = option;
        if (option.title.length) {
            picker.titleLabel.text = option.title;
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
