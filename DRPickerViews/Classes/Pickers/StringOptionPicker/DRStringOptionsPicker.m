//
//  DRStringOptionsPicker.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/7.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRStringOptionsPicker.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import <DRCategories/UIView+DRExtension.h>
#import "DRUIWidgetUtil.h"

@interface DRStringOptionsPicker ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation DRStringOptionsPicker

+ (void)showPickerViewWithCurrentDate:(NSDate *)currentDate minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock setupBlock:(DRDatePickerSetupBlock)setupBlock {
    DRStringOptionsPicker *pickerView = [DRStringOptionsPicker pickerView];
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
    NSInteger row = self.pickOption.currentStringIndex;
    if (self.pickOption.currentStringOption.length) {
        for (NSInteger i=0; i<self.pickOption.stringOptions.count; i++) {
            NSString *option = self.pickOption.stringOptions[i];
            if ([option isEqualToString:self.pickOption.currentStringOption]) {
                row = i;
                break;
            }
        }
    }
    [self.pickerView selectRow:row inComponent:0 animated:NO];
    [self.pickerView reloadComponent:0];
}

- (id)pickedObject {
    DRStringOptionValueModel *model = [DRStringOptionValueModel new];
    model.selectedIndex = [self.pickerView selectedRowInComponent:0];
    model.selectedOption = self.pickOption.stringOptions[model.selectedIndex];
    return model;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickOption.stringOptions.count;
}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont dr_PingFangSC_MediumWithSize:20];
    label.textColor = [DRUIWidgetUtil pickerUnSelectColor];
    if (row == [pickerView selectedRowInComponent:component]) {
        label.textColor = [DRUIWidgetUtil normalColor];
    }
    label.text = self.pickOption.stringOptions[row];
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
