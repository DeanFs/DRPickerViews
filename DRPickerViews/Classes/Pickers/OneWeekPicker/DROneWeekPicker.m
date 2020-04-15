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

- (void)prepareToShow {
    DRPickerDateOption *opt = (DRPickerDateOption *)self.pickerOption;
    [self.weekPickerView setupWithCurrentDate:opt.currentDate
                                      minDate:opt.minDate
                                      maxDate:opt.maxDate
                            selectChangeBlock:nil];
}

- (id)pickedObject {
    DRPickerOneWeekPickedObj *obj = [DRPickerOneWeekPickedObj new];
    obj.firstDateInWeek = self.weekPickerView.currentWeek.firstDateInWeek;
    obj.lastDateInWeek = self.weekPickerView.currentWeek.lastDateInWeek;
    obj.weekIndexInMonth = self.weekPickerView.currentWeek.weekIndexInMonth;
    obj.month = self.weekPickerView.currentWeek.month;
    obj.lastWeekInMonth = self.weekPickerView.currentWeek.lastWeekInMonth;
    obj.weekTitle = self.weekPickerView.currentWeek.weekTitle;
    return obj;
}

- (CGFloat)pickerViewHeight {
    return 303;
}

@end
