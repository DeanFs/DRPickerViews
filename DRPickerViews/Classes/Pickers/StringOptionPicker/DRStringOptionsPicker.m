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

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [DRUIWidgetUtil hideSeparateLineForPickerView:self.pickerView];
    });
}

- (void)prepareToShow {
    [self.pickerView reloadAllComponents];
    DRPickerStringSelectOption *opt = (DRPickerStringSelectOption *)self.pickerOption;
    NSInteger row = opt.currentStringIndex;
    if (opt.currentStringOption.length) {
        for (NSInteger i=0; i<opt.stringOptions.count; i++) {
            NSString *option = opt.stringOptions[i];
            if ([option isEqualToString:opt.currentStringOption]) {
                row = i;
                break;
            }
        }
    }
    [self.pickerView selectRow:row inComponent:0 animated:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pickerView reloadAllComponents];
    });
}

- (id)pickedObject {
    DRPickerStringSelectOption *opt = (DRPickerStringSelectOption *)self.pickerOption;
    DRPickerStringSelectPickedObj *obj = [DRPickerStringSelectPickedObj new];
    obj.selectedIndex = [self.pickerView selectedRowInComponent:0];
    obj.selectedOption = opt.stringOptions[obj.selectedIndex];
    return obj;
}

- (Class)pickerOptionClass {
    return [DRPickerStringSelectOption class];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    DRPickerStringSelectOption *opt = (DRPickerStringSelectOption *)self.pickerOption;
    return opt.stringOptions.count;
}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    DRPickerStringSelectOption *opt = (DRPickerStringSelectOption *)self.pickerOption;
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont dr_PingFangSC_MediumWithSize:20];
    label.textColor = [DRUIWidgetUtil pickerUnSelectColor];
    if (row == [pickerView selectedRowInComponent:component]) {
        label.textColor = [DRUIWidgetUtil normalColor];
    }
    label.text = opt.stringOptions[row];
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
