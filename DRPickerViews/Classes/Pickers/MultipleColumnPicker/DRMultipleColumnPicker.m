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

@interface DRMultipleColumnPicker ()

@property (weak, nonatomic) IBOutlet DRNormalDataPickerView *pickerView;
@property (weak, nonatomic) IBOutlet DRSectionTitleView *tipView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewTop;

@property (assign, nonatomic) NSUInteger currentIndex;
@property (strong, nonatomic) NSArray<UIFont *> *columnsFont;
@property (strong, nonatomic) NSArray<NSString *> *separateTexts;
@property (strong, nonatomic) NSArray<NSNumber *> *columnsWidth;

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
    kDRWeakSelf
    self.columnsFont = opt.columnsFont;
    self.separateTexts = opt.separateTexts;
    [self countColumnWidthWithDataSource:opt.optionArray];
    self.pickerView.dataSource = opt.optionArray;
    self.pickerView.currentSelectedStrings = opt.currentSelectedStrings;
    self.pickerView.getSeparateTextBeforeSectionBlock = ^NSString *(NSInteger section) {
        NSString *sText = [weakSelf.separateTexts safeGetObjectWithIndex:section-1];
        if (sText.length > 0) {
            return sText;
        }
        return @"";
    };
    self.pickerView.getFontForSectionWithBlock = ^UIFont *(NSInteger section, NSInteger row) {
        UIFont *font = [weakSelf.columnsFont safeGetObjectWithIndex:section];
        if (font != nil) {
            return font;
        }
        return [UIFont dr_PingFangSC_RegularWithSize:20];
    };
    self.pickerView.onSelectedChangeBlock = ^(NSInteger section, NSInteger index, NSString *selectedString) {
        NSMutableArray *stringArray = [NSMutableArray arrayWithArray:opt.currentSelectedStrings];
        NSArray *sectionArray = [opt.optionArray safeGetObjectWithIndex:section];
        [stringArray replaceObjectAtIndex:section withObject:[sectionArray safeGetObjectWithIndex:index]];
        opt.currentSelectedStrings = stringArray;
    };
    self.pickerView.getWidthForSectionWithBlock = ^CGFloat(NSInteger section) {
        NSNumber *width = [weakSelf.columnsWidth safeGetObjectWithIndex:section];
        if (width != nil && width.floatValue > 40) {
            return width.floatValue;
        }
        return 50;
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
        [indexArray addObject:@(index)];
    }
    obj.selectedIndexs = indexArray;
    return obj;
}

- (void)countColumnWidthWithDataSource:(NSArray<NSArray<NSString *> *> *)dataSource {
    NSMutableArray<NSNumber *> *arr = [NSMutableArray array];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine;
    for (NSInteger i=0; i<dataSource.count; i++) {
        NSArray<NSString *> *column = dataSource[i];
        CGFloat maxWidth = 0;
        UIFont *font = [self.columnsFont safeGetObjectWithIndex:i];
        if (font == nil) {
            font = [UIFont dr_PingFangSC_RegularWithSize:20];
        }
        for (NSString *text in column) {
            CGFloat width = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, font.lineHeight)
                                               options:options
                                            attributes:@{NSFontAttributeName: font}
                                               context:nil].size.width + 10;
            if (width > maxWidth) {
                maxWidth = width;
            }
        }
        if (maxWidth < 50) {
            maxWidth = 50;
        }
        [arr addObject:@(maxWidth)];
    }
    self.columnsWidth = arr;
}

@end
