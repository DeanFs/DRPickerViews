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
#import <DRCategories/NSArray+DRExtension.h>
#import <DRUIWidget/DRUIWidgetUtil.h>
#import <DRUIWidget/DRSectionTitleView.h>
#import <DRUIWidget/DRNormalDataPickerView.h>

@interface DRStringOptionsPicker ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet DRNormalDataPickerView *pickerView;
@property (weak, nonatomic) IBOutlet DRSectionTitleView *tipView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewTop;

@end

@implementation DRStringOptionsPicker

- (CGFloat)picerViewHeight {
    DRPickerStringSelectOption *opt = (DRPickerStringSelectOption *)self.pickerOption;
    if (opt.tipText.length > 0) {
        return 303;
    }
    self.tipViewTop.constant = 0;
    self.tipViewHeight.constant = 0;
    return [super picerViewHeight];
}

- (void)prepareToShow {
    DRPickerStringSelectOption *opt = (DRPickerStringSelectOption *)self.pickerOption;
    self.pickerView.dataSource = @[opt.stringOptions];
    if (opt.currentStringOption) {
        self.pickerView.currentSelectedStrings = @[opt.currentStringOption];
    } else {
        self.pickerView.currentSelectedStrings = @[[opt.stringOptions safeGetObjectWithIndex:opt.currentStringIndex]];
    }
    self.pickerView.getFontForSectionWithBlock = ^UIFont *(NSInteger section) {
        return [UIFont dr_PingFangSC_MediumWithSize:20];
    };

    if (opt.tipText.length > 0) {
        self.tipView.title = opt.tipText;
    }
}

- (id)pickedObject {
    DRPickerStringSelectPickedObj *obj = [DRPickerStringSelectPickedObj new];
    NSString *option = self.pickerView.currentSelectedStrings.firstObject;
    NSInteger index = [self.pickerView.dataSource[0] indexOfObject:option];
    obj.selectedIndex = index;
    obj.selectedOption = option;
    return obj;
}

- (Class)pickerOptionClass {
    return [DRPickerStringSelectOption class];
}

@end
