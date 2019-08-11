//
//  DRYMDWithLunarPicker.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/18.
//

#import "DRYMDWithLunarPicker.h"
#import "DRSegmentBar.h"
#import "DRDatePickerView.h"
#import "DRLunarDatePickerView.h"
#import "NSDate+DRExtension.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIView+DRExtension.h>

@interface DRYMDWithLunarPicker ()

@property (weak, nonatomic) IBOutlet DRSegmentBar *segmentBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) DRDatePickerView *solarPickerView;
@property (nonatomic, strong) DRLunarDatePickerView *lunarPickerView;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) BOOL isLunar;
@property (nonatomic, assign) BOOL leapMonth;
@property (nonatomic, assign) BOOL ignoreYear;

@end

@implementation DRYMDWithLunarPicker

- (CGFloat)picerViewHeight {
    return 303;
}

- (Class)pickerOptionClass {
    DRPickerWithLunarOption * lunarOption = (DRPickerWithLunarOption *)self.pickerOption;
    self.minDate = lunarOption.minDate;
    self.maxDate = lunarOption.maxDate;
    self.year = lunarOption.year;
    self.month = lunarOption.month;
    self.day = lunarOption.day;
    self.isLunar = lunarOption.isLunar;
    self.leapMonth = lunarOption.leapMonth;
    if (self.isForBirthday) {
        self.ignoreYear = ((DRPickerBirthdayOption *)self.pickerOption).ignoreYear;
        return [DRPickerBirthdayOption class];
    }
    return [DRPickerWithLunarOption class];
}

- (void)prepareToShow {
    // 添加日期选择器
    CGFloat width = self.scrollView.width;
    CGFloat height = self.scrollView.height;
    self.scrollView.contentSize = CGSizeMake(width*2, height);
    self.solarPickerView.frame = CGRectMake(0, 0, width, height);
    self.lunarPickerView.frame = CGRectMake(width, 0, width, height);
    [self.scrollView addSubview:self.solarPickerView];
    [self.scrollView addSubview:self.lunarPickerView];
    
    // 分段选择器设置
    kDRWeakSelf
    [self.segmentBar setupWithAssociatedScrollView:self.scrollView titles:@[@"公历", @"农历"]];
    self.segmentBar.selectedIndex = self.isLunar;
    self.segmentBar.onSelectChangeBlock = ^(NSInteger index) {
        weakSelf.isLunar = (index == 1);
    };
    
    // 设置顶部按钮
    if (self.isForBirthday) {
        [self setupTopLeftButton];
        self.topBar.leftButtonActionBlock = ^(DRPickerTopBar *topBar, UIButton *tappedButton) {
            weakSelf.ignoreYear = !weakSelf.ignoreYear;
            [weakSelf setupTopLeftButton];
        };
    }
    
    // 初始化选择器并设置回调
    NSDate *currentDate;
    if (!self.ignoreYear) {
        currentDate = [NSDate correctionYear:self.year month:self.month day:self.day hour:0 minute:0 second:0];
    }
    [self.solarPickerView setupWithCurrentDate:currentDate minDate:self.minDate maxDate:self.maxDate month:self.month day:self.day selectChangeBlock:^(NSDate *date, NSInteger month, NSInteger day) {
        weakSelf.year = date.year;
        weakSelf.month = month;
        weakSelf.day = day;
        [weakSelf.lunarPickerView refreshWithDate:date month:month day:day leapMonth:NO];
    }];
    [self.lunarPickerView setupWithCurrentDate:currentDate minDate:self.minDate maxDate:self.maxDate month:self.month day:self.day leapMonth:self.leapMonth selectChangeBlock:^(NSDate *date, NSInteger year, NSInteger month, NSInteger day, BOOL leapMonth) {
        weakSelf.year = year;
        weakSelf.month = month;
        weakSelf.day = day;
        weakSelf.leapMonth = leapMonth;
        [weakSelf.solarPickerView refreshWithDate:date month:month day:day];
    }];
}

- (id)pickedObject {
    if (self.isForBirthday) {
        DRPickerBirthdayPickedObj *obj = [DRPickerBirthdayPickedObj new];
        obj.ignoreYear = self.ignoreYear;
        obj.year = 0;
        if (!self.ignoreYear) {
            obj.year = self.year;
        }
        obj.month = self.month;
        obj.day = self.day;
        obj.leapMonth = self.leapMonth;
        obj.isLunar = self.isLunar;
        return obj;
    }
    DRPickerWithLunarPickedObj *obj = [DRPickerWithLunarPickedObj new];
    obj.year = self.year;
    obj.month = self.month;
    obj.day = self.day;
    obj.leapMonth = self.leapMonth;
    obj.isLunar = self.isLunar;
    return obj;
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
