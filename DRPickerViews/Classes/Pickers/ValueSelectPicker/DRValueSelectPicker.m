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
#import "DRValuePickerView.h"
#import "DRSectionTitleView.h"

@interface DRValueSelectPicker ()

@property (weak, nonatomic) IBOutlet DRValuePickerView *pickerView;
@property (weak, nonatomic) IBOutlet DRSectionTitleView *tipView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewTop;

@end

@implementation DRValueSelectPicker

- (CGFloat)pickerViewHeight {
    DRPickerValueSelectOption *opt = (DRPickerValueSelectOption *)self.pickerOption;
    if (opt.tipText.length > 0) {
        return 303;
    }
    self.tipViewTop.constant = 0;
    self.tipViewHeight.constant = 0;
    return [super pickerViewHeight];
}

- (void)prepareToShow {
    DRPickerValueSelectOption *opt = (DRPickerValueSelectOption *)self.pickerOption;
    self.pickerView.minValue = opt.minValue;
    self.pickerView.maxValue = opt.maxValue;
    self.pickerView.currentValue = opt.currentValue;
    self.pickerView.valueUnit = opt.valueUnit;
    self.pickerView.prefixUnit = opt.prefixUnit;
    self.pickerView.isLoop = opt.isLoop;
    if (opt.valueScale <= 0) {
        self.pickerView.valueScale = 1;
    }else{
        self.pickerView.valueScale = opt.valueScale;
        if (opt.valueScale <= 1.0) {
            self.pickerView.isForceDigit = NO;
            self.pickerView.digitCount = 2;
        }
    }

    if (opt.tipText.length > 0) {
        self.tipView.title = opt.tipText;
    }
}

- (id)pickedObject {
    return @(self.pickerView.currentValue);
}

- (Class)pickerOptionClass {
    return [DRPickerValueSelectOption class];
}

@end
