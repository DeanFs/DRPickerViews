//
//  DRLinkagePicker.m
//  Records
//
//  Created by qing on 2019/11/20.
//  Copyright © 2019 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRLinkagePicker.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import <DRCategories/UIView+DRExtension.h>
#import <DRCategories/NSArray+DRExtension.h>
#import <DRUIWidgetKit/DRUIWidgetUtil.h>
#import <DRUIWidgetKit/DRSectionTitleView.h>
#import <DRUIWidgetKit/DRNormalDataPickerView.h>

@interface DRLinkagePicker ()

@property (weak, nonatomic) IBOutlet DRNormalDataPickerView *pickerView;
@property (weak, nonatomic) IBOutlet DRSectionTitleView *tipView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewTop;

/// 左边一列影响右边一列，即unitArray在左边，optionArray在右边
@property (assign, nonatomic) BOOL leftToRith;
/// 主动列字体
@property (strong, nonatomic) UIFont *unitFont;
/// 被动影响数据源列字体
@property (strong, nonatomic) UIFont *valueFont;
/// 分隔符
@property (copy, nonatomic) NSString *separateText;
@property (strong, nonatomic) NSArray<NSNumber *> *columnsWidth;
@property (strong, nonatomic) NSArray<NSArray<NSString *> *> *valuesArray;
@property (strong, nonatomic) NSArray<NSString *> *unitArray;

@end


@implementation DRLinkagePicker

- (CGFloat)pickerViewHeight {
    DRPickerLinkageOption *opt = (DRPickerLinkageOption *)self.pickerOption;
    if (opt.tipText.length > 0) {
        return 303;
    }
    self.tipViewTop.constant = 0;
    self.tipViewHeight.constant = 0;
    return [super pickerViewHeight];
}

- (void)prepareToShow {
    DRPickerLinkageOption *opt = (DRPickerLinkageOption *)self.pickerOption;
    if (opt.valuesArray.count == 0) {
        return;
    }
    //数据构建
    kDRWeakSelf
    self.leftToRith = opt.leftToRith;
    self.unitFont = opt.unitFont;
    self.valueFont = opt.valueFont;
    self.separateText = opt.separateText;
    self.valuesArray = opt.valuesArray;
    self.unitArray = opt.unitArray;
    if (opt.currentSelectUnit.length == 0) {
        opt.currentSelectUnit = opt.unitArray.firstObject;
    }
    NSInteger index = [opt.unitArray indexOfObject:opt.currentSelectUnit];
    NSArray *currentQuantityArray = [opt.valuesArray safeGetObjectWithIndex:index];
    if (currentQuantityArray == nil) {
        opt.currentSelectUnit = opt.unitArray.firstObject;
        currentQuantityArray = opt.valuesArray.firstObject;
        opt.currentSelectValue = currentQuantityArray.firstObject;
    }
    NSArray *dataSource = @[currentQuantityArray, opt.unitArray];
    if (self.leftToRith) {
        dataSource = @[opt.unitArray, currentQuantityArray];
    }
    if (opt.currentSelectValue.length == 0) {
        opt.currentSelectValue = currentQuantityArray.firstObject;
    }
    NSArray *selectedStrings = @[opt.currentSelectValue, opt.currentSelectUnit];
    if (self.leftToRith) {
        selectedStrings = @[opt.currentSelectUnit, opt.currentSelectValue];
    }
    [self countColumnWidthWithDataSource:dataSource];
    self.pickerView.dataSource = dataSource;
    self.pickerView.currentSelectedStrings = selectedStrings;
    
    self.pickerView.getSeparateTextBeforeSectionBlock = ^NSString *(NSInteger section) {
        return weakSelf.separateText;
    };
    self.pickerView.getFontForSectionWithBlock = ^UIFont *(NSInteger section, NSInteger row) {
        if (section == 0) {
            if (weakSelf.leftToRith) {
                return weakSelf.unitFont;
            }
            return weakSelf.valueFont;
        } else {
            if (weakSelf.leftToRith) {
                return weakSelf.valueFont;
            }
            return weakSelf.unitFont;
        }
    };
    self.pickerView.onSelectedChangeBlock = ^(NSInteger section, NSInteger index, NSString *selectedString) {
        if (weakSelf.leftToRith) {
            if (section == 0) {
                NSArray *dataSource = @[weakSelf.unitArray, [weakSelf.valuesArray safeGetObjectWithIndex:index]];
                [weakSelf countColumnWidthWithDataSource:dataSource];
                weakSelf.pickerView.dataSource = dataSource;
                [weakSelf.pickerView reloadData];
            }
        } else {
            if (section == 1) {
                NSArray *dataSource = @[[weakSelf.valuesArray safeGetObjectWithIndex:index], weakSelf.unitArray];
                [weakSelf countColumnWidthWithDataSource:dataSource];
                weakSelf.pickerView.dataSource = dataSource;
                [weakSelf.pickerView reloadData];
            }
        }
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

- (id)pickedObject {
    DRPickerLinkagePickedObj *obj = [DRPickerLinkagePickedObj new];
    if (self.leftToRith) {
        [self.pickerView getSelectedValueForSection:1 withBlock:^(NSInteger index, NSString *selectedString) {
            obj.selectValueIndex = index;
            obj.currentSelectValue = selectedString;
        }];
        [self.pickerView getSelectedValueForSection:0 withBlock:^(NSInteger index, NSString *selectedString) {
            obj.currentSelectUnit = selectedString;
            obj.selectUnitIndex = index;
        }];
    } else {
        [self.pickerView getSelectedValueForSection:0 withBlock:^(NSInteger index, NSString *selectedString) {
            obj.selectValueIndex = index;
            obj.currentSelectValue = selectedString;
        }];
        [self.pickerView getSelectedValueForSection:1 withBlock:^(NSInteger index, NSString *selectedString) {
            obj.currentSelectUnit = selectedString;
            obj.selectUnitIndex = index;
        }];
    }
    return obj;
}

- (Class)pickerOptionClass {
    return [DRPickerLinkageOption class];
}

- (void)countColumnWidthWithDataSource:(NSArray<NSArray<NSString *> *> *)dataSource {
    NSMutableArray<NSNumber *> *arr = [NSMutableArray array];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine;
    for (NSInteger i=0; i<dataSource.count; i++) {
        NSArray<NSString *> *column = dataSource[i];
        CGFloat maxWidth = 0;
        UIFont *font;
        if (self.leftToRith) {
            if (i == 0) {
                font = self.unitFont;
            } else {
                font = self.valueFont;
            }
        } else {
            if (i == 0) {
                font = self.valueFont;
            } else {
                font = self.unitFont;
            }
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
