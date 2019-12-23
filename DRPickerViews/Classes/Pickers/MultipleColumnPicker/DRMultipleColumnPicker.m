//
//  DRMultipleColumnPicker.m
//  Records
//
//  Created by qing on 2019/11/20.
//  Copyright © 2019 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRMultipleColumnPicker.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import <DRCategories/UIView+DRExtension.h>
#import <DRCategories/NSArray+DRExtension.h>
#import <DRUIWidgetKit/DRUIWidgetUtil.h>
#import <DRUIWidgetKit/DRSectionTitleView.h>
#import <DRUIWidgetKit/DRNormalDataPickerView.h>

@interface DRMultipleColumnPicker (){
    
}
@property (weak, nonatomic) IBOutlet DRNormalDataPickerView *pickerView;
@property (weak, nonatomic) IBOutlet DRSectionTitleView *tipView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewTop;

@property (assign, nonatomic) NSUInteger currentIndex;
@end

@implementation DRMultipleColumnPicker


- (CGFloat)pickerViewHeight {
    DRPickerMultipleColumnOption *opt = (DRPickerMultipleColumnOption *)self.pickerOption;
    if (opt.tipText.length > 0) {
        return 303;
    }
    self.tipViewTop.constant = 0;
    self.tipViewHeight.constant = 0;
    return [super pickerViewHeight];
}

- (void)prepareToShow {
    DRPickerMultipleColumnOption *opt = (DRPickerMultipleColumnOption *)self.pickerOption;
    if (opt.optionArray.count == 0) {
        return;
    }
    self.pickerView.dataSource = opt.optionArray;
    self.pickerView.currentSelectedStrings = opt.currentSelectedStrings;
    self.pickerView.getSeparateTextBeforeSectionBlock = ^NSString *(NSInteger section) {
        return @"";
    };
    self.pickerView.getFontForSectionWithBlock = ^UIFont *(NSInteger section) {
        return [UIFont dr_PingFangSC_RegularWithSize:20];
    };
    self.pickerView.onSelectedChangeBlock = ^(NSInteger section, NSInteger index, NSString *selectedString) {
        NSMutableArray *stringArray = [NSMutableArray arrayWithArray:opt.currentSelectedStrings];
        NSArray *sectionArray = [opt.optionArray safeGetObjectWithIndex:section];
        [stringArray replaceObjectAtIndex:section withObject:[sectionArray safeGetObjectWithIndex:index]];
        opt.currentSelectedStrings = stringArray;
    };
    self.pickerView.getWidthForSectionWithBlock = ^CGFloat(NSInteger section) {
        return 40;
    };
    self.pickerView.getTextAlignmentForSectionBlock = ^NSTextAlignment(NSInteger section) {
        return NSTextAlignmentCenter;
    };

    if (opt.tipText.length > 0) {
        self.tipView.title = opt.tipText;
    }
}

- (Class)pickerOptionClass {
    return [DRPickerMultipleColumnOption class];
}

- (id)pickedObject {
    DRPickerMultipleColumnOption *opt = (DRPickerMultipleColumnOption *)self.pickerOption;
    DRPickerMultipleColumnPickedObj *obj = [DRPickerMultipleColumnPickedObj new];
    obj.selectedStrings = opt.currentSelectedStrings;
    NSMutableArray *indexArray = [NSMutableArray array];
    for (int i = 0; i < opt.currentSelectedStrings.count; i++) {
        NSArray *columnArray = [opt.optionArray safeGetObjectWithIndex:i];
        NSInteger index = [columnArray indexOfObject:[opt.currentSelectedStrings safeGetObjectWithIndex:i]];
        [indexArray addObject:[NSNumber numberWithInt:index]];
    }
    obj.selectedIndexs = indexArray;
    return obj;
}

@end
