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
#import <DRUIWidgetKit/DRUIWidgetUtil.h>
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
    NSMutableArray *dataSouce = [NSMutableArray array];
    [dataSouce addObject:opt.stringOptions];
    CGFloat valueWidth = kDRScreenWidth - 2*[self horizontalPadding];
    if (opt.valueUnit.length || opt.prefixUnit) {
        valueWidth = 0;
        for (NSString *value in opt.stringOptions) {
            CGFloat width = 20 * value.length;
            if (width > valueWidth) {
                valueWidth = width;
            }
        }
        [dataSouce insertObject:@[opt.prefixUnit] atIndex:0];
        [dataSouce addObject:@[opt.valueUnit]];
    }
    self.pickerView.dataSource = dataSouce;
    if (opt.currentStringOption.length > 0) {
        self.pickerView.currentSelectedStrings = @[opt.currentStringOption];
    } else {
        self.pickerView.currentSelectedStrings = @[[opt.stringOptions safeGetObjectWithIndex:opt.currentStringIndex]];
    }
    self.pickerView.getFontForSectionWithBlock = ^UIFont *(NSInteger section) {
        if (dataSouce.count > 1) {
            if (section == 0 || section == 2) {
                return [UIFont dr_PingFangSC_RegularWithSize:18];
            }
        }
        return [UIFont dr_PingFangSC_RegularWithSize:20];
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
