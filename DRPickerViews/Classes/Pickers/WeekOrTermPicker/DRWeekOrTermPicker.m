//
//  DRWeekOrTermPicker.m
//  DRPickerViews_Example
//
//  Created by 冯生伟 on 2019/10/11.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRWeekOrTermPicker.h"
#import <DRUIWidgetKit/DRSegmentBar.h>
#import <DRUIWidgetKit/DRNormalDataPickerView.h>
#import <DRUIWidgetKit/DRValuePickerView.h>
#import <DRCategories/NSDate+DRExtension.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import <DRCategories/UIView+DRExtension.h>

@interface DRWeekOrTermPicker ()

@property (weak, nonatomic) IBOutlet DRSegmentBar *segmentBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) DRValuePickerView *weekPicker;
@property (nonatomic, strong) DRNormalDataPickerView *termPicker;
@property (nonatomic, assign) NSInteger minYear;
@property (nonatomic, assign) NSInteger startYear;
@property (nonatomic, assign) NSInteger grade;
@property (nonatomic, assign) NSInteger term;

@end

@implementation DRWeekOrTermPicker

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.segmentBar setupWithAssociatedScrollView:self.scrollView titles:@[@"当前周", @"当前学期"]];
    self.weekPicker.valueUnit = @"周";
    self.weekPicker.prefixUnit = @"第";
    self.weekPicker.minValue = 1;
}

- (CGFloat)pickerViewHeight {
    return 303;
}

- (Class)pickerOptionClass {
    return [DRPickerWeekOrTermOption class];
}

- (void)prepareToShow {
    DRPickerWeekOrTermOption *opt = (DRPickerWeekOrTermOption *)self.pickerOption;
    self.weekPicker.maxValue = opt.maxWeek;
    self.weekPicker.currentValue = opt.currentWeek;

    NSMutableArray *years = [NSMutableArray array];
    NSInteger maxYear = [NSDate date].year;
    for (NSInteger i=opt.minYear; i<=maxYear; i++) {
        [years addObject:[NSString stringWithFormat:@"%ld-%ld", i, i+1]];
    }

    NSArray *levels = @[@"大一", @"大二", @"大三", @"大四", @"大五", @"研一", @"研二", @"研三", @"博一", @"博二", @"博三", @"博四", @"博无"];
    NSInteger maxGrade = opt.maxGrade;
    if (maxGrade > levels.count) {
        maxGrade = levels.count;
    }
    NSMutableArray *grades = [NSMutableArray array];
    for (NSInteger i=0; i<maxGrade; i++) {
        [grades addObject:levels[i]];
    }

    NSMutableArray *terms = [NSMutableArray array];
    for (NSInteger i=0; i<opt.maxTerm; i++) {
        [terms addObject:[NSString stringWithFormat:@"第%ld学期", i+1]];
    }

    self.minYear = opt.minYear;
    self.startYear = opt.startYear;
    NSString *currentYear = [NSString stringWithFormat:@"%ld-%ld", opt.startYear, opt.toYear];
    self.grade = opt.grade;
    NSString *currentGrade = levels[opt.grade-1];
    self.term = opt.term;
    NSString *currentTerm = [NSString stringWithFormat:@"第%ld学期", opt.term];

    self.termPicker.dataSource = @[years, grades, terms];
    self.termPicker.currentSelectedStrings = @[currentYear, currentGrade, currentTerm];
    self.termPicker.getFontForSectionWithBlock = ^UIFont *(NSInteger section) {
        if (section == 0) {
            return [UIFont dr_PingFangSC_RegularWithSize:22];
        }
        return [UIFont dr_PingFangSC_MediumWithSize:17];
    };
    self.termPicker.getWidthForSectionWithBlock = ^CGFloat(NSInteger section) {
        CGFloat wholeWidth = kDRScreenWidth - 48;
        if (section == 0) {
            return wholeWidth * 0.4;
        }
        if (section == 1) {
            return wholeWidth * 0.24;
        }
        return wholeWidth * 0.3;
    };
    self.termPicker.getIsLoopForSectionBlock = ^BOOL(NSInteger section) {
        if (section == 2) {
            return NO;
        }
        return YES;
    };
    kDRWeakSelf
    self.termPicker.onSelectedChangeBlock = ^(NSInteger section, NSInteger index, NSString *selectedString) {
        if (section == 0) {
            weakSelf.startYear = weakSelf.minYear + index;
        } else if (section == 1) {
            weakSelf.grade = index + 1;
        } else {
            weakSelf.term = index + 1;
        }
    };
}

- (id)pickedObject {
    DRPickerWeekOrTermPickedObj *obj = [DRPickerWeekOrTermPickedObj new];
    obj.currentWeek = self.weekPicker.currentValue;
    obj.startYear = self.startYear;
    obj.toYear = self.startYear + 1;
    obj.grade = self.grade;
    obj.term = self.term;
    return obj;
}

#pragma mark - setup
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if (!self.weekPicker.superview) {
        CGFloat width = self.scrollView.width;
        CGFloat height = self.scrollView.height;
        self.weekPicker.frame = CGRectMake(0, 0, width, height);
        [self.scrollView addSubview:self.weekPicker];
        self.segmentBar.selectedIndex = 0;
        [self.scrollView setContentSize:CGSizeMake(width * 2, height)];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDRAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.termPicker.frame = CGRectMake(width, 0, width, height);
            [self.scrollView addSubview:self.termPicker];
        });
    }
}

- (DRValuePickerView *)weekPicker {
    if (!_weekPicker) {
        _weekPicker = [[DRValuePickerView alloc] init];
    }
    return _weekPicker;
}

- (DRNormalDataPickerView *)termPicker {
    if (!_termPicker) {
        _termPicker = [[DRNormalDataPickerView alloc] init];
    }
    return _termPicker;
}

@end
