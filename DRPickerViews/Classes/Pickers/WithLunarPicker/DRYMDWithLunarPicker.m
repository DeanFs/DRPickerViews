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

@property (nonatomic, assign) DRYMDWithLunarPickerType type;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) BOOL isLunar;
@property (nonatomic, assign) BOOL leapMonth;
@property (nonatomic, assign) BOOL ignoreYear;
@property (nonatomic, strong) DRDatePickerView *solarPickerView;
@property (nonatomic, strong) DRLunarDatePickerView *lunarPickerView;

@end

@implementation DRYMDWithLunarPicker

- (CGFloat)pickerViewHeight {
    return 303;
}

- (Class)pickerOptionClass {
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
    DRPickerWithLunarOption *lunarOpt = (DRPickerWithLunarOption *)self.pickerOption;
    self.type = lunarOpt.type;
    self.currentDate =   lunarOpt.currentDate;
    self.minDate = lunarOpt.minDate;
    self.maxDate = lunarOpt.maxDate;
    self.year = lunarOpt.year;
    self.month = lunarOpt.month;
    self.day = lunarOpt.day;
    self.isLunar = lunarOpt.isLunar;
    self.leapMonth = lunarOpt.leapMonth;
    self.ignoreYear = lunarOpt.ignoreYear;

    if (self.currentDate == nil) {
        if (!self.ignoreYear) {
            self.currentDate = [NSDate correctionYear:self.year month:self.month day:self.day hour:0 minute:0 second:0];
            if (self.isLunar) {
                self.currentDate = [NSDate dateFromLunarDate:self.currentDate leapMonth:self.leapMonth];
            }
        }
    }

    if (self.type == DRYMDWithLunarPickerTypeNormal) {
        self.solarPickerView.dateMode = DRDatePickerModeYMD;
        self.lunarPickerView.dateMode = DRLunarDatePickerModeYMD;
    } else if (self.type == DRYMDWithLunarPickerTypeCanIngnoreYear) {
        [self setupTopLeftButton];
        self.topBar.leftButtonActionBlock = ^(DRPickerTopBar *topBar, UIButton *tappedButton) {
            weakSelf.ignoreYear = !weakSelf.ignoreYear;
            [weakSelf setupTopLeftButton];
        };
    } else if (self.type == DRYMDWithLunarPickerTypeMonthDayOnly) {
        self.solarPickerView.dateMode = DRDatePickerModeMD;
        self.lunarPickerView.dateMode = DRLunarDatePickerModeMD;
    }

    if (lunarOpt.showDoubleCalendarTip) {
        self.solarPickerView.showLunarTip = YES;
        self.lunarPickerView.showSolarTip = YES;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.scrollView.subviews.count == 0) {
        // 设置选择器容器scrollView
        CGFloat width = self.scrollView.width;
        CGFloat height = self.scrollView.height;
        self.scrollView.contentSize = CGSizeMake(width*2, height);
        
        // 初始化并添加公历选择器
        self.solarPickerView.frame = CGRectMake(0, 0, width, height);
        [self.solarPickerView setupWithCurrentDate:self.currentDate
                                           minDate:self.minDate
                                           maxDate:self.maxDate
                                             month:self.month
                                               day:self.day];
        
        // 初始化并添加农历选择器
        self.lunarPickerView.frame = CGRectMake(width, 0, width, height);
        [self.lunarPickerView setupWithCurrentDate:self.currentDate
                                           minDate:self.minDate
                                           maxDate:self.maxDate
                                             month:self.month
                                               day:self.day
                                         leapMonth:self.leapMonth];
        
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
    DRPickerWithLunarPickedObj *obj = [DRPickerWithLunarPickedObj new];
    [self setupObj:obj];
    if (self.type == DRYMDWithLunarPickerTypeCanIngnoreYear) {
        obj.ignoreYear =  self.ignoreYear;
        if (self.ignoreYear) {
            obj.year = -1;
            obj.date = nil;
        }
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
        self.lunarPickerView.dateMode = DRLunarDatePickerModeMDLeapMonth;
    } else {
        self.topBar.leftButtonTitle = @"忽略年份";
        self.solarPickerView.dateMode = DRDatePickerModeYMD;
        self.lunarPickerView.dateMode = DRLunarDatePickerModeYMD;
    }
}

#pragma mark - lazy load
- (DRDatePickerView *)solarPickerView {
    if (!_solarPickerView) {
        kDRWeakSelf
        _solarPickerView = [[DRDatePickerView alloc] init];
        _solarPickerView.onSelectChangeBlock = ^(NSDate *date, NSInteger month, NSInteger day) {
            [weakSelf.lunarPickerView refreshWithDate:date month:month day:day];
        };
    }
    return _solarPickerView;
}

- (DRLunarDatePickerView *)lunarPickerView {
    if (!_lunarPickerView) {
        kDRWeakSelf
        _lunarPickerView = [[DRLunarDatePickerView alloc] init];
        _lunarPickerView.onSelectChangeBlock = ^(NSDate *date, NSInteger month, NSInteger day) {
            [weakSelf.solarPickerView refreshWithDate:date month:month day:day];
        };
    }
    return _lunarPickerView;
}

@end
