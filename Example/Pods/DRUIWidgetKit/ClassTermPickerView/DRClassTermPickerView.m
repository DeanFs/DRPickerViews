//
//  DRClassTermPickerView.m
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/11.
//

#import "DRClassTermPickerView.h"
#import <Masonry/Masonry.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import <DRCategories/NSDate+DRExtension.h>
#import "DRNormalDataPickerView.h"

@interface DRClassTermPickerView ()

@property (weak, nonatomic) DRNormalDataPickerView *pickerView;
@property (nonatomic, assign) BOOL didDrawRect;

@end

@implementation DRClassTermPickerView

- (void)setupPickerView {
    NSMutableArray *years = [NSMutableArray array];
    NSInteger maxYear = [NSDate date].year;
    for (NSInteger i=self.minYear; i<=maxYear; i++) {
        [years addObject:[NSString stringWithFormat:@"%ld-%ld", i, i+1]];
    }

    NSArray *levels = @[@"大一", @"大二", @"大三", @"大四", @"大五", @"研一", @"研二", @"研三", @"博一", @"博二", @"博三", @"博四", @"博五"];
    NSInteger maxGrade = self.maxGrade;
    if (maxGrade > levels.count) {
        maxGrade = levels.count;
    }
    NSMutableArray *grades = [NSMutableArray array];
    for (NSInteger i=0; i<maxGrade; i++) {
        [grades addObject:levels[i]];
    }

    NSMutableArray *terms = [NSMutableArray array];
    for (NSInteger i=0; i<self.maxTerm; i++) {
        [terms addObject:[NSString stringWithFormat:@"第%ld学期", i+1]];
    }

    NSString *currentYear = [NSString stringWithFormat:@"%ld-%ld", self.startYear, self.startYear + 1];
    NSString *currentGrade = levels[self.grade-1];
    NSString *currentTerm = [NSString stringWithFormat:@"第%ld学期", self.term];

    self.pickerView.dataSource = @[years, grades, terms];
    self.pickerView.currentSelectedStrings = @[currentYear, currentGrade, currentTerm];
    self.pickerView.getFontForSectionWithBlock = ^UIFont *(NSInteger section) {
        if (section == 0) {
            return [UIFont dr_PingFangSC_RegularWithSize:22];
        }
        return [UIFont dr_PingFangSC_MediumWithSize:17];
    };
    self.pickerView.getWidthForSectionWithBlock = ^CGFloat(NSInteger section) {
        CGFloat wholeWidth = kDRScreenWidth - 48;
        if (section == 0) {
            return wholeWidth * 0.4;
        }
        if (section == 1) {
            return wholeWidth * 0.24;
        }
        return wholeWidth * 0.3;
    };
    self.pickerView.getIsLoopForSectionBlock = ^BOOL(NSInteger section) {
        if (section == 2) {
            return NO;
        }
        return YES;
    };
    kDRWeakSelf
    self.pickerView.onSelectedChangeBlock = ^(NSInteger section, NSInteger index, NSString *selectedString) {
        if (section == 0) {
            weakSelf.startYear = weakSelf.minYear + index;
        } else if (section == 1) {
            weakSelf.grade = index + 1;
        } else {
            weakSelf.term = index + 1;
        }
    };
}

#pragma mark - setup xib
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    if (!self.pickerView) {
        DRNormalDataPickerView *picker = [[DRNormalDataPickerView alloc] init];
        [self addSubview:picker];
        [picker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_offset(0);
        }];
        self.pickerView = picker;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if (CGRectEqualToRect(rect, CGRectZero)) {
        return;
    }
    if (!self.didDrawRect) {
        self.didDrawRect = YES;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupPickerView];
        });
    }
}

@end
