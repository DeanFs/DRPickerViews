//
//  DRAheadTimePicker.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/6.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRAheadTimePicker.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIView+DRExtension.h>
#import <DRCategories/UIFont+DRExtension.h>
#import "DRUIWidgetUtil.h"

@interface DRAheadTimePicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSArray<NSArray *> *dataSouce;

@end


@implementation DRAheadTimePicker

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [DRUIWidgetUtil hideSeparateLineForPickerView:self.pickerView];
    });
}

- (void)prepareToShow {
    [self.pickerView selectRow:6 inComponent:3 animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pickerView reloadAllComponents];
    });
}

- (id)pickedObject {
    NSInteger hourIndex = [self.pickerView selectedRowInComponent:1];
    NSInteger minIndex = [self.pickerView selectedRowInComponent:3];
    NSInteger total = 0;
    if (hourIndex >= 0 && self.dataSouce[1].count >= hourIndex) {
        NSNumber *hour = self.dataSouce[1][hourIndex];
        total += hour.integerValue * 60;
    }
    
    if (minIndex >= 0 && self.dataSouce[3].count >= minIndex) {
        NSNumber *min = self.dataSouce[3][minIndex];
        total += min.integerValue;
    }
    return @(total);
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.dataSouce.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.dataSouce.count > component) {
        NSArray<NSString *> *datas = self.dataSouce[component];
        return datas.count;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = (UILabel *)view;
    if (self.dataSouce.count > component) {
        NSArray<NSString *> *datas = self.dataSouce[component];
        if (datas.count > row) {
            NSString *text = datas[row];
            label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = text;
            label.font = [UIFont systemFontOfSize:20];
            label.textColor = [DRUIWidgetUtil pickerUnSelectColor];
            if (row == [pickerView selectedRowInComponent:component]) {
                label.textColor = [DRUIWidgetUtil normalColor];
            }
            if (component % 2 == 0) {
                label.font = [UIFont systemFontOfSize:15];
            } else {
                label.font = [UIFont dr_PingFangSC_RegularWithSize:26];
            }
        }
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0 || component == 2 || component == 4) {
        return;
    }
    
    NSInteger component1SelectedRow = [pickerView selectedRowInComponent:1];
    if (component == 3 && row == 0 && component1SelectedRow == 0) {
        self.topBar.rightButtonEnble = NO;
        [pickerView selectRow:1 inComponent:3 animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.topBar.rightButtonEnble = YES;
        });
        return;
    }
    
    if (component == 1 && row >= 1) {
        
        NSMutableArray *newDataSouce = self.dataSouce.mutableCopy;
        newDataSouce[3] = @[@"0", @"30"];
        self.dataSouce = newDataSouce;
        [pickerView reloadComponent:3];
    }
    else if (component == 1 && row == 0) {
        NSMutableArray *newDataSouce = self.dataSouce.mutableCopy;
        NSMutableArray *mins = @[].mutableCopy;
        for (int i = 0; i < 12; i++) {
            mins[i] = @(i * 5).stringValue;
        }
        newDataSouce[3] = mins;
        self.dataSouce = newDataSouce;
        [pickerView reloadComponent:3];
    }
    [pickerView reloadAllComponents];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component % 2 == 0) {
        return 32;
    }
    return 75;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 34;
}

#pragma mark - lazy load
- (NSArray<NSArray *> *)dataSouce {
    if (!_dataSouce) {
        NSMutableArray *dataSouce = @[].mutableCopy;
        [dataSouce addObject:@[@"提前"]];
        
        NSMutableArray *hours = @[].mutableCopy;
        for (int i = 0; i < 7; i++) {
            hours[i] = @(i).stringValue;
        }
        [dataSouce addObject:hours];
        [dataSouce addObject:@[@"小时"]];
        
        NSMutableArray *mins = @[].mutableCopy;
        for (int i = 0; i < 12; i++) {
            mins[i] = @(i * 5).stringValue;
        }
        [dataSouce addObject:mins];
        [dataSouce addObject:@[@"分钟"]];
        _dataSouce = dataSouce;
    }
    return _dataSouce;
}

@end
