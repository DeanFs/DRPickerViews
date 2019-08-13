//
//  DRValueSelectPicker.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/7.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRValueSelectPicker.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import <DRCategories/UIView+DRExtension.h>
#import "DRUIWidgetUtil.h"

@interface DRValueSelectPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *prefixUnitLabel;

@end

@implementation DRValueSelectPicker

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [DRUIWidgetUtil hideSeparateLineForPickerView:self.pickerView];
    });
    
    self.unitLabel.textColor = [DRUIWidgetUtil normalColor];
    self.prefixUnitLabel.textColor = [DRUIWidgetUtil normalColor];
}

- (void)prepareToShow {
    [self.pickerView reloadAllComponents];
    DRPickerValueSelectOption *opt = (DRPickerValueSelectOption *)self.pickerOption;
    NSInteger row = opt.currentValue - opt.minValue;
    if (row > 0) {
        [self.pickerView selectRow:row inComponent:0 animated:NO];
    }
    self.unitLabel.text = opt.valueUnit;
    self.prefixUnitLabel.text = opt.prefixUnit;
    self.valueLabel.text = [NSString stringWithFormat:@"%ld", opt.maxValue];
}

- (id)pickedObject {
    DRPickerValueSelectOption *opt = (DRPickerValueSelectOption *)self.pickerOption;
    return @(opt.minValue + [self.pickerView selectedRowInComponent:0]);
}

- (Class)pickerOptionClass {
    return [DRPickerValueSelectOption class];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    DRPickerValueSelectOption *opt = (DRPickerValueSelectOption *)self.pickerOption;
    return opt.maxValue - opt.minValue + 1;
}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    DRPickerValueSelectOption *opt = (DRPickerValueSelectOption *)self.pickerOption;
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:31];
    label.text = [NSString stringWithFormat:@"%ld", opt.minValue + row];
    label.textColor = [DRUIWidgetUtil pickerUnSelectColor];
    if (row == [pickerView selectedRowInComponent:component] || component == 1) {
        label.textColor = [DRUIWidgetUtil normalColor];
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [pickerView reloadComponent:component];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 34;
}

@end
