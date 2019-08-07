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

@end

@implementation DRValueSelectPicker

+ (void)showPickerViewWithCurrentDate:(NSDate *)currentDate minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock setupBlock:(DRDatePickerSetupBlock)setupBlock {
    DRValueSelectPicker *pickerView = [DRValueSelectPicker pickerView];
    kDR_SAFE_BLOCK(setupBlock, pickerView);
    pickerView.pickDoneBlock = pickDoneBlock;
    [pickerView show];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [DRUIWidgetUtil hideSeparateLineForPickerView:self.pickerView];
    });
}

- (void)prepareToShow {
    NSInteger row = self.pickOption.currentValue - self.pickOption.minValue;
    if (row > 0) {
        [self.pickerView selectRow:row inComponent:0 animated:NO];
        [self.pickerView reloadComponent:0];
    }
}

- (id)pickedObject {
    return @(self.pickOption.minValue + [self.pickerView selectedRowInComponent:0]);
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.pickOption.maxValue - self.pickOption.minValue + 1;
    }
    return 1;
}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    if (component == 0) {
        label.font = [UIFont systemFontOfSize:31];
        label.text = [NSString stringWithFormat:@"%ld", self.pickOption.minValue + row];
    } else {
        label.font = [UIFont dr_PingFangSC_RegularWithSize:18];
        label.text = self.pickOption.valueUnit;
    }
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
