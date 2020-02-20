//
//  DRStringOptionsPicker.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/7.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRStringOptionsPicker.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIView+DRExtension.h>
#import <DRCategories/NSArray+DRExtension.h>
#import <DRUIWidgetKit/DRSectionTitleView.h>
#import <DRUIWidgetKit/DRNormalDataPickerView.h>

@interface DRStringOptionsPicker ()

@property (weak, nonatomic) IBOutlet DRNormalDataPickerView *pickerView;
@property (weak, nonatomic) IBOutlet DRSectionTitleView *tipView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewTop;

@end

@implementation DRStringOptionsPicker

- (CGFloat)pickerViewHeight {
    DRPickerStringSelectOption *opt = (DRPickerStringSelectOption *)self.pickerOption;
    if (opt.tipText.length > 0) {
        return 303;
    }
    self.tipViewTop.constant = 0;
    self.tipViewHeight.constant = 0;
    return [super pickerViewHeight];
}

- (void)prepareToShow {
    kDRWeakSelf
    DRPickerStringSelectOption *opt = (DRPickerStringSelectOption *)self.pickerOption;
    if (opt.stringOptions.count == 0) {
        return;
    }
    NSString *value = opt.currentStringOption;
    if (value.length == 0) {
        value = [opt.stringOptions safeGetObjectWithIndex:opt.currentStringIndex];
    }
    if (value == nil) {
        value = @"";
    }
    NSMutableArray *stringValues = [NSMutableArray arrayWithObject:value];
    NSMutableArray *dataSouce = [NSMutableArray arrayWithObject:opt.stringOptions];
    CGFloat valueWidth = kDRScreenWidth - 2*[self horizontalPadding];
    if (opt.valueUnit.length > 0 || opt.prefixUnit.length > 0) {
        valueWidth = 0;
        for (NSString *value in opt.stringOptions) {
            CGFloat width = 20 * value.length;
            if (width > valueWidth) {
                valueWidth = width;
            }
        }
        if (opt.prefixUnit.length > 0) {
            [dataSouce insertObject:@[opt.prefixUnit] atIndex:0];
            [stringValues insertObject:opt.prefixUnit atIndex:0];
        }
        if (opt.valueUnit.length > 0) {
            [dataSouce addObject:@[opt.valueUnit]];
            [stringValues addObject:opt.valueUnit];
        }
    }
    self.pickerView.dataSource = dataSouce;
    self.pickerView.currentSelectedStrings = stringValues;
    
    self.pickerView.getFontForSectionWithBlock = ^UIFont *(NSInteger section, NSInteger row) {
        if (dataSouce.count > 1) {
            if (section == 0 || section == 2) {
                return opt.unitFont;
            }
        }
        return opt.valueFont;
    };
    self.pickerView.getWidthForSectionWithBlock = ^CGFloat(NSInteger section) {
        CGFloat wholeWidth = kDRScreenWidth - 2*[weakSelf horizontalPadding];
        if (dataSouce.count > 1) {
            if (section == 0 || section == 2) {
                return (wholeWidth - valueWidth - 18) / 2;
            }
        }
        return valueWidth;
    };
    self.pickerView.getSeparateTextBeforeSectionBlock = ^NSString *(NSInteger section) {
        return @"";
    };
    self.pickerView.getTextAlignmentForSectionBlock = ^NSTextAlignment(NSInteger section) {
        if (dataSouce.count > 1) {
            if (section == 0) {
                return NSTextAlignmentRight;
            }
            if (section == 2) {
                return NSTextAlignmentLeft;
            }
        }
        return NSTextAlignmentCenter;
    };
    
    if (opt.tipText.length > 0) {
        self.tipView.title = opt.tipText;
    }
}

- (id)pickedObject {
    DRPickerStringSelectOption *opt = (DRPickerStringSelectOption *)self.pickerOption;
    NSString *option = self.pickerView.currentSelectedStrings.firstObject;
    NSInteger index = [self.pickerView.dataSource[0] indexOfObject:option];
    if (opt.valueUnit.length > 0 || opt.prefixUnit.length > 0) {
        option = self.pickerView.currentSelectedStrings[1];
        index = [self.pickerView.dataSource[1] indexOfObject:option];
    }
    DRPickerStringSelectPickedObj *obj = [DRPickerStringSelectPickedObj new];
    obj.selectedIndex = index;
    obj.selectedOption = option;
    return obj;
}

- (Class)pickerOptionClass {
    return [DRPickerStringSelectOption class];
}

@end
