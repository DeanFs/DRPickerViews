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

+ (void)showPickerViewWithCurrentDate:(NSDate *)currentDate
                              minDate:(NSDate *)minDate
                              maxDate:(NSDate *)maxDate
                        pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                           setupBlock:(DRDatePickerSetupBlock)setupBlock {
    DRYearMonthPicker *picker = [DRYearMonthPicker pickerView];
    kDR_SAFE_BLOCK(setupBlock, picker);
    picker.pickDoneBlock = pickDoneBlock;
    picker.currentDate = currentDate;
    [picker setupPickerView:currentDate minDate:minDate maxDate:maxDate];
    [picker show];
}

- (void)setupPickerView:(NSDate *)currentDate minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate {
    [self.pickerView setupWithCurrentDate:currentDate minDate:minDate maxDate:maxDate month:1 day:1 selectChangeBlock:nil];
}

- (CGFloat)picerViewHeight {
    if (self.withMonthViewFilter) {
        return 380;
    }
    return 260;
}

- (void)prepareToShow {
    if (self.withMonthViewFilter) {
        kDRWeakSelf
        self.filterOptionCardView.allOptions = @[@"事项", @"重复", @"实用功能"];
        self.filterOptionCardView.selectedIndexs = self.pickOption.monthViewFilterIndexs;
        self.selectedFilterOptionIndexs = self.pickOption.monthViewFilterIndexs;
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
        DRMonthViewFilterYearMonthModel *model = [DRMonthViewFilterYearMonthModel new];
        model.date = self.pickerView.selectedDate;
        model.filterOptionIndexs = self.selectedFilterOptionIndexs;
        return model;
    }
    return self.pickerView.selectedDate;
}

@end
