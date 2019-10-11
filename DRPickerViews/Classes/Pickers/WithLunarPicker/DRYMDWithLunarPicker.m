//
//  DRYMDWithLunarPicker.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/18.
//

#import "DRYMDWithLunarPicker.h"
#import <DRUIWidgetKit/DRSegmentBar.h>
#import <DRUIWidgetKit/DRDatePickerView.h>
#import <DRUIWidgetKit/DRLunarDatePickerView.h>
#import <DRCategories/NSDate+DRExtension.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIView+DRExtension.h>

@interface DRYMDWithLunarPicker ()

@property (weak, nonatomic) IBOutlet DRSegmentBar *segmentBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) DRDatePickerView *solarPickerView;
@property (nonatomic, strong) DRLunarDatePickerView *lunarPickerView;
@property (nonatomic, assign) BOOL isLunar;
@property (nonatomic, assign) BOOL ignoreYear;

@end

@implementation DRYMDWithLunarPicker

- (CGFloat)pickerViewHeight {
    return 303;
}

- (Class)pickerOptionClass {
    if (self.isForBirthday) {
        return [DRPickerBirthdayOption class];
    }
    return [DRPickerWithLunarOption class];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    kDRWeakSelf
    [self.segmentBar setupWithAssociatedScrollView:self.scrollView titles:@[@"公历", @"农历"]];
    self.segmentBar.onSelectChangeBlock = ^(NSInteger index) {
        weakSelf.isLunar = (index == 1);
    };
}

- (void)prepareToShow {
    kDRWeakSelf
    if (self.isForBirthday) {
        [self setupTopLeftButton];
        self.topBar.leftButtonActionBlock = ^(DRPickerTopBar *topBar, UIButton *tappedButton) {
            weakSelf.ignoreYear = !weakSelf.ignoreYear;
            [weakSelf setupTopLeftButton];
        };
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.scrollView.subviews.count == 0) {
        kDRWeakSelf
        // 获取当前反显日期
        DRPickerWithLunarOption * lunarOption = (DRPickerWithLunarOption *)self.pickerOption;
        NSDate *minDate = lunarOption.minDate;
        NSDate *maxDate = lunarOption.maxDate;
        NSDate *currentDate = lunarOption.currentDate;
        NSInteger year = lunarOption.year;
        NSInteger month = lunarOption.month;
        NSInteger day = lunarOption.day;
        BOOL leapMonth = lunarOption.leapMonth;
        self.isLunar = lunarOption.isLunar;
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
        self.segmentBar.selectedIndex = self.isLunar;
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

#pragma mark - private
- (void)setupTopLeftButton {
    if (self.ignoreYear) {
        self.topBar.leftButtonTitle = @"显示年份";
        self.solarPickerView.dateMode = DRDatePickerModeMD;
    } else {
        self.topBar.leftButtonTitle = @"忽略年份";
        self.solarPickerView.dateMode = DRDatePickerModeYMD;
    }
    self.lunarPickerView.ignoreYear = self.ignoreYear;
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
