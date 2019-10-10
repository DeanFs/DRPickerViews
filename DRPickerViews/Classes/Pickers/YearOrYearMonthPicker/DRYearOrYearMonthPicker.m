//
//  DRYearOrYearMonthPicker.m
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/10.
//

#import "DRYearOrYearMonthPicker.h"
#import <DRUIWidget/DRSegmentBar.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRUIWidget/DRDatePickerView.h>

@interface DRYearOrYearMonthPicker ()

@property (weak, nonatomic) IBOutlet DRSegmentBar *segmentBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong)  *<#name#>;

@property (nonatomic, assign) BOOL isOnlyYear;

@end

@implementation DRYearOrYearMonthPicker

- (CGFloat)picerViewHeight {
    return 303;
}

- (Class)pickerOptionClass {
    return [DRPickerYearOrYearMonthOption class];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    kDRWeakSelf
    [self.segmentBar setupWithAssociatedScrollView:self.scrollView titles:@[@"月份", @"年份"]];
    self.segmentBar.onSelectChangeBlock = ^(NSInteger index) {
        weakSelf.isOnlyYear = (index == 1);
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

        if (self.isForBirthday) {
            self.ignoreYear = ((DRPickerBirthdayOption *)self.pickerOption).ignoreYear;
            [self setupTopLeftButton];
            if (self.ignoreYear) {
                currentDate = nil;
            }
        }
        if (!self.ignoreYear && !currentDate) {
            currentDate = [NSDate correctionYear:year month:month day:day hour:0 minute:0 second:0];
            if (self.isLunar) {
                // 农历转公历
                currentDate = [NSDate dateFromLunarDate:currentDate leapMonth:leapMonth];
            }
        }

        // 设置选择器容器scrollView
        CGFloat width = self.scrollView.width;
        CGFloat height = self.scrollView.height;
        self.scrollView.contentSize = CGSizeMake(width*2, height);

        // 初始化并添加公历选择器
        self.solarPickerView.frame = CGRectMake(0, 0, width, height);
        self.solarPickerView.onSelectChangeBlock = ^(NSDate *date, NSInteger month, NSInteger day) {
            [weakSelf.lunarPickerView refreshWithDate:date month:month day:day];
        };
        [self.solarPickerView setupWithCurrentDate:currentDate
                                           minDate:minDate
                                           maxDate:maxDate
                                             month:month
                                               day:day];

        // 初始化并添加农历选择器
        self.lunarPickerView.frame = CGRectMake(width, 0, width, height);
        self.lunarPickerView.onSelectChangeBlock = ^(NSDate *date, NSInteger month, NSInteger day) {
            [weakSelf.solarPickerView refreshWithDate:date month:month day:day];
        };
        [self.lunarPickerView setupWithCurrentDate:currentDate
                                           minDate:minDate
                                           maxDate:maxDate
                                             month:month
                                               day:day
                                         leapMonth:leapMonth];

        if (self.isLunar) {
            [self.scrollView addSubview:self.lunarPickerView];
        } else {
            [self.scrollView addSubview:self.solarPickerView];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDRAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.isLunar) {
                [self.scrollView addSubview:self.solarPickerView];
            } else {
                [self.scrollView addSubview:self.lunarPickerView];
            }
        });
        self.segmentBar.selectedIndex = self.isOnlyYear;
    }
}

- (id)pickedObject {
    DRPickerWithLunarPickedObj *obj;
    if (self.isForBirthday) {
        obj = [DRPickerBirthdayPickedObj new];
        ((DRPickerBirthdayPickedObj *)obj).ignoreYear = self.ignoreYear;
        [self setupObj:obj];
        if (self.ignoreYear) {
            obj.year = -1;
            obj.date = nil;
        }
    } else {
        obj = [DRPickerWithLunarPickedObj new];
        [self setupObj:obj];
    }
    return obj;
}

- (void)setupObj:(DRPickerWithLunarPickedObj *)obj {
    obj.isLunar = self.isLunar;
    if (self.isLunar) {
        obj.date = self.lunarPickerView.selectedDate;
        obj.year = self.lunarPickerView.selectedMonth.lunarYear;
        obj.month = self.lunarPickerView.selectedMonth.cmp.month;
        obj.day = self.lunarPickerView.selectedDay;
        obj.leapMonth = self.lunarPickerView.selectedMonth.cmp.leapMonth;
    } else {
        obj.date = self.solarPickerView.selectedDate;
        obj.year = self.solarPickerView.selectedYear;
        obj.month = self.solarPickerView.selectedMonth;
        obj.day = self.solarPickerView.selectedDay;
    }
}

#pragma mark - lazy load
- (DRDatePickerView *)solarPickerView {
    if (!_solarPickerView) {
        _solarPickerView = [[DRDatePickerView alloc] init];
    }
    return _solarPickerView;
}

- (DRLunarDatePickerView *)lunarPickerView {
    if (!_lunarPickerView) {
        _lunarPickerView = [[DRLunarDatePickerView alloc] init];
    }
    return _lunarPickerView;
}


@end
