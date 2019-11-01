//
//  DRYearOrYearMonthPicker.m
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/10.
//

#import "DRYearOrYearMonthPicker.h"
#import <DRUIWidgetKit/DRSegmentBar.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRUIWidgetKit/DRDatePickerView.h>
#import <DRCategories/UIView+DRExtension.h>

@interface DRYearOrYearMonthPicker ()

@property (weak, nonatomic) IBOutlet DRSegmentBar *segmentBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) DRDatePickerView *yearMonthPicker;
@property (nonatomic, strong) DRDatePickerView *yearPicker;

@property (nonatomic, assign) BOOL isOnlyYear;

@end

@implementation DRYearOrYearMonthPicker

- (CGFloat)pickerViewHeight {
    return 303;
}

- (Class)pickerOptionClass {
    return [DRPickerYearOrYearMonthOption class];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    kDRWeakSelf
    [self.segmentBar setupWithAssociatedScrollView:self.scrollView titles:@[@"年份", @"月份"]];
    self.segmentBar.onSelectChangeBlock = ^(NSInteger index) {
        weakSelf.isOnlyYear = (index == 0);
    };
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if (self.scrollView.subviews.count == 0) {
        kDRWeakSelf
        // 获取当前反显日期
        DRPickerYearOrYearMonthOption * option = (DRPickerYearOrYearMonthOption *)self.pickerOption;
        NSDate *minDate = option.minDate;
        NSDate *maxDate = option.maxDate;
        NSDate *currentDate = option.currentDate;
        self.isOnlyYear = option.isOnlyYear;

        // 设置选择器容器scrollView
        CGFloat width = self.scrollView.width;
        CGFloat height = self.scrollView.height;
        self.scrollView.contentSize = CGSizeMake(width*2, height);

        // 初始化并添加农历选择器
        self.yearPicker.frame = CGRectMake(0, 0, width, height);
        self.yearPicker.onSelectChangeBlock = ^(NSDate *date, NSInteger month, NSInteger day) {
            [weakSelf.yearMonthPicker refreshWithDate:date month:month day:day];
        };
        [self.yearPicker setupWithCurrentDate:currentDate
                                      minDate:minDate
                                      maxDate:maxDate
                                        month:1
                                          day:1];

        // 初始化并添加公历选择器
        self.yearMonthPicker.frame = CGRectMake(width, 0, width, height);
        self.yearMonthPicker.onSelectChangeBlock = ^(NSDate *date, NSInteger month, NSInteger day) {
            [weakSelf.yearPicker refreshWithDate:date month:month day:day];
        };
        [self.yearMonthPicker setupWithCurrentDate:currentDate
                                           minDate:minDate
                                           maxDate:maxDate
                                             month:1
                                               day:1];

        if (self.isOnlyYear) {
            [self.scrollView addSubview:self.yearPicker];
        } else {
            [self.scrollView addSubview:self.yearMonthPicker];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDRAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.isOnlyYear) {
                [self.scrollView addSubview:self.yearMonthPicker];
            } else {
                [self.scrollView addSubview:self.yearPicker];
            }
        });
        self.segmentBar.selectedIndex = !self.isOnlyYear;
    }
}

- (id)pickedObject {
    DRPickerYearOrYearMonthPickedObj *obj = [DRPickerYearOrYearMonthPickedObj new];
    obj.isOnlyYear = self.isOnlyYear;
    obj.yearMonth = self.yearMonthPicker.selectedDate;
    return obj;
}

#pragma mark - lazy load
- (DRDatePickerView *)yearMonthPicker {
    if (!_yearMonthPicker) {
        _yearMonthPicker = [[DRDatePickerView alloc] init];
        _yearMonthPicker.dateMode = DRDatePickerModeYM;
    }
    return _yearMonthPicker;
}

- (DRDatePickerView *)yearPicker {
    if (!_yearPicker) {
        _yearPicker = [[DRDatePickerView alloc] init];
        _yearPicker.dateMode = DRDatePickerModeYearOnly;
    }
    return _yearPicker;
}


@end
