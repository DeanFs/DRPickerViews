//
//  DRYearMonthPicker.m
//  Records
//
//  Created by 冯生伟 on 2018/12/12.
//  Copyright © 2018 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRYearMonthPicker.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import "DRDatePickerView.h"
#import "DROptionCardView.h"

@interface DRYearMonthPicker ()

@property (weak, nonatomic) IBOutlet DRDatePickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *filterOptionContentView;
@property (weak, nonatomic) IBOutlet DROptionCardView *filterOptionCardView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterOptionHeight;

@property (nonatomic, strong) NSArray<NSNumber *> *selectedFilterOptionIndexs;

@end

@implementation DRYearMonthPicker

- (CGFloat)picerViewHeight {
    if (self.withMonthViewFilter) {
        return 380;
    }
    return 260;
}

- (Class)pickerOptionClass {
    if (self.withMonthViewFilter) {
        return [DRPickerYearMonthFilterOption class];
    }
    return [DRPickerDateOption class];
}

- (void)prepareToShow {
    DRPickerDateOption *dateOption = (DRPickerDateOption *)self.pickerOption;
    [self.pickerView setupWithCurrentDate:dateOption.currentDate
                                  minDate:dateOption.minDate
                                  maxDate:dateOption.maxDate
                                    month:1
                                      day:1];
    
    if (self.withMonthViewFilter) {
        kDRWeakSelf
        self.filterOptionCardView.allOptions = @[@"事项", @"重复", @"实用功能"];
        DRPickerYearMonthFilterOption *filterOption = (DRPickerYearMonthFilterOption *)self.pickerOption;
        self.filterOptionCardView.selectedIndexs = filterOption.monthViewFilterIndexs;
        self.selectedFilterOptionIndexs = filterOption.monthViewFilterIndexs;
        self.filterOptionCardView.onSelectionChangeBlock = ^(NSArray<NSString *> *selectedOptions, NSArray<NSNumber *> *selectedIndexs) {
            weakSelf.selectedFilterOptionIndexs = selectedIndexs;
        };
    } else {
        self.filterOptionHeight.constant = 0;
        self.filterOptionContentView.hidden = YES;
    }
}

#pragma mark - actions
- (id)pickedObject {
    if (self.withMonthViewFilter) {
        DRPickerYearMonthFilterPickedObj *obj = [DRPickerYearMonthFilterPickedObj new];
        obj.date = self.pickerView.selectedDate;
        obj.filterOptionIndexs = self.selectedFilterOptionIndexs;
        return obj;
    }
    return self.pickerView.selectedDate;
}

@end
