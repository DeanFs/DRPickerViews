//
//  DRWeekPickerCell.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/5.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRWeekPickerCell.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/NSDate+DRExtension.h>
#import <DRCategories/NSArray+DRExtension.h>
#import "DRUIWidgetUtil.h"

@implementation DRWeekPickerDateModel

- (instancetype)copyWithZone:(NSZone *)zone {
    DRWeekPickerDateModel *model = [[DRWeekPickerDateModel allocWithZone:zone] init];
    [model.daysList addObjectsFromArray:self.daysList];
    model.firstDateInWeek = self.firstDateInWeek;
    model.lastDateInWeek = self.lastDateInWeek;
    model.disableSelect = self.disableSelect;
    model.dayOffset = self.dayOffset;
    model.firstSelectableWeek = self.firstSelectableWeek;
    model.enableIndexFrom = self.enableIndexFrom;
    model.lastSelectableWeek = self.lastSelectableWeek;
    model.enableIndexTo = self.enableIndexTo;
    return model;
}

- (NSMutableArray<NSString *> *)daysList {
    if (!_daysList) {
        _daysList = [NSMutableArray array];
    }
    return _daysList;
}

@end

@interface DRWeekPickerCell ()

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UIStackView *dayContentView;

@property (nonatomic, strong) NSArray<NSString *> *weekTitles;

@end

@implementation DRWeekPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (kDRScreenWidth < 375) {
        self.weekLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        for (NSInteger i=0; i<7; i++) {
            UILabel *label = [self.dayContentView viewWithTag:1001+i];
            if ([label isKindOfClass:[UILabel class]]) {
                label.font = [UIFont systemFontOfSize:18];
            }
        }
    }
}

- (void)setupWeekCellWithModel:(DRWeekPickerDateModel *)weekModel selected:(BOOL)selected {
    if (!weekModel) {
        return;
    }
    self.weekLabel.text = [NSString stringWithFormat:@"第%@周", [self.weekTitles safeGetObjectWithIndex:weekModel.weekIndexInMonth-1]];
    self.weekLabel.textColor = [DRUIWidgetUtil pickerUnSelectColor];
    if (selected) {
        self.weekLabel.textColor = [DRUIWidgetUtil normalColor];
    }
    if (weekModel.disableSelect) {
        self.weekLabel.textColor = [DRUIWidgetUtil pickerDisableColor];
    }
    for (NSInteger i=0; i<7; i++) {
        UILabel *label = [self.dayContentView viewWithTag:1001+i];
        if (![label isKindOfClass:[UILabel class]]) {
            continue;
        }
        label.text = weekModel.daysList[i];
        label.textColor = [DRUIWidgetUtil pickerUnSelectColor];
        if (selected) {
            label.textColor = [DRUIWidgetUtil normalColor];
        }
        if ([DRUIWidgetUtil weekPickerOnlyCurrentMonth]) {
            if ((weekModel.weekIndexInMonth == 1 && label.text.integerValue > 7) ||
                (weekModel.lastWeekInMonth && label.text.integerValue < 7)) {
                label.text = nil; // 不是当月的
            }
        }
        if (weekModel.disableSelect) { // 不可选
            label.textColor = [DRUIWidgetUtil pickerDisableColor];
        } else {
            if (weekModel.firstSelectableWeek) {
                if (i < weekModel.enableIndexFrom) {
                    label.textColor = [DRUIWidgetUtil pickerDisableColor];
                }
            } else if (weekModel.lastSelectableWeek) {
                if (i > weekModel.enableIndexTo) {
                    label.textColor = [DRUIWidgetUtil pickerDisableColor];
                }
            }
        }
    }
}

- (NSArray<NSString *> *)weekTitles {
    if (!_weekTitles) {
        _weekTitles = @[@"一", @"二", @"三", @"四", @"五", @"六"];
    }
    return _weekTitles;
}

@end
