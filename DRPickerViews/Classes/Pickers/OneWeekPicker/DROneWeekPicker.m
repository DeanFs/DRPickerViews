//
//  DROneWeekPicker.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/7.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DROneWeekPicker.h"
#import "DRWeekPickerView.h"
#import <DRMacroDefines/DRMacroDefines.h>

@interface DROneWeekPicker ()

@property (weak, nonatomic) IBOutlet DRWeekPickerView *weekPickerView;

@end

@implementation DROneWeekPicker

+ (void)showPickerViewWithCurrentDate:(NSDate *)currentDate minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock setupBlock:(DRDatePickerSetupBlock)setupBlock {
    DROneWeekPicker *picker = [DROneWeekPicker pickerView];
    kDR_SAFE_BLOCK(setupBlock, picker);
    picker.pickDoneBlock = pickDoneBlock;
    [picker.weekPickerView setupWithCurrentDate:currentDate minDate:minDate maxDate:maxDate selectChangeBlock:nil];
    [picker show];
}

- (id)pickedObject {
    return self.weekPickerView.selectedDate;
}

- (CGFloat)picerViewHeight {
    return 303;
}

@end
