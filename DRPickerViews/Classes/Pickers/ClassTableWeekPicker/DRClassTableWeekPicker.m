//
//  DRClassTableWeekPicker.m
//  DRPickerViews_Example
//
//  Created by 冯生伟 on 2019/10/11.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRClassTableWeekPicker.h"
#import <DRUIWidgetKit/DROptionCardView.h>
#import <DRUIWidgetKit/DRCheckboxGroupView.h>
#import <DRCategories/UIView+DRExtension.h>
#import <DRMacroDefines/DRMacroDefines.h>

@interface DRClassTableWeekPicker ()

@property (weak, nonatomic) IBOutlet DROptionCardView *optionCardView;
@property (weak, nonatomic) IBOutlet DRCheckboxGroupView *quickSelectView;

@property (nonatomic, assign) BOOL didDrawRect;

@end

@implementation DRClassTableWeekPicker

- (CGFloat)pickerViewHeight {
    return 323;
}

- (void)prepareToShow {
    DRPickerClassTableOption *opt = (DRPickerClassTableOption *)self.pickerOption;

    NSMutableArray *options = [NSMutableArray array];
    for (NSInteger i=0; i<opt.wholeWeekCount; i++) {
        [options addObject:[NSString stringWithFormat:@"%ld", i+1]];
    }
    NSMutableArray *selectedIndexs = [NSMutableArray array];
    BOOL allEvenNumbers = opt.classWeeks.count == opt.wholeWeekCount / 2; // 全偶数
    BOOL allOddNumber = opt.classWeeks.count == (opt.wholeWeekCount / 2 + (opt.wholeWeekCount % 2 > 0)); // 全奇数
    BOOL allSelected = opt.classWeeks.count == opt.wholeWeekCount; // 全选
    for (NSNumber *week in opt.classWeeks) {
        NSInteger value = week.integerValue;
        [selectedIndexs addObject:@(value-1)];
        if (value % 2 == 0) {
            allOddNumber = NO;
        } else {
            allEvenNumbers = NO;
        }
    }

    kDRWeakSelf
    self.optionCardView.allOptions = options;
    self.optionCardView.selectedIndexs = selectedIndexs;
    self.optionCardView.onSelectionChangeBlock = ^(NSArray<NSString *> *selectedOptions, NSArray<NSNumber *> *selectedIndexs) {
        weakSelf.quickSelectView.selectedIndexs = @[];
    };

    self.quickSelectView.optionTitles = @[@"单周", @"双周", @"每周"];
    if (allOddNumber) {
        self.quickSelectView.selectedIndexs = @[@(0)];
    } else if (allEvenNumbers) {
        self.quickSelectView.selectedIndexs = @[@(1)];
    } else if (allSelected) {
        self.quickSelectView.selectedIndexs = @[@(2)];
    }
    self.quickSelectView.onSelectedChangeBlock = ^(NSArray<NSNumber *> * _Nonnull selectedIndexs, NSArray<NSString *> * _Nonnull selectedOptions) {
        if (selectedIndexs.count == 0) {
            weakSelf.optionCardView.selectedIndexs = @[];
            return;
        }

        DRPickerClassTableOption *opt = (DRPickerClassTableOption *)weakSelf.pickerOption;
        NSInteger index = selectedIndexs.firstObject.integerValue;
        NSMutableArray *values = [NSMutableArray array];

        for (NSInteger i=0; i<opt.wholeWeekCount; i++) {
            if (index == 2) {
                [values addObject:@(i)];
            } else {
                if (i % 2 == 0) {
                    if (index == 0) {
                        [values addObject:@(i)];
                    }
                } else {
                    if (index == 1) {
                        [values addObject:@(i)];
                    }
                }
            }
        }
        weakSelf.optionCardView.selectedIndexs = values;
    };
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if (CGRectEqualToRect(rect, CGRectZero)) {
        return;
    }
    if (!self.didDrawRect) {
        self.didDrawRect = YES;
        CGFloat wholeWidth = self.width - 34;
        CGFloat space = (wholeWidth - 32 * 7) / 6;
        space = ceil(space / 0.5) * 0.5;
        self.optionCardView.columnSpace = space;
    }
}

- (id)pickedObject {
    NSMutableArray *values = [NSMutableArray array];
    for (NSNumber *number in self.optionCardView.selectedIndexs) {
        [values addObject:@(number.integerValue + 1)];
    }

    DRPickerClassTablePickedObj *obj = [DRPickerClassTablePickedObj new];
    obj.classWeeks = values;
    return obj;
}

- (Class)pickerOptionClass {
    return [DRPickerClassTableOption class];
}

@end
