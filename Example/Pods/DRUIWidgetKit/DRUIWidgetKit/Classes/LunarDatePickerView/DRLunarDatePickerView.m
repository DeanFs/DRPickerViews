//
//  DRLunarDatePickerView.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/4.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRLunarDatePickerView.h"
#import <Masonry/Masonry.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIView+DRExtension.h>
#import <DRCategories/UIFont+DRExtension.h>
#import <DRCategories/NSDate+DRExtension.h>
#import <DRCategories/NSDateComponents+DRExtension.h>
#import "DRUIWidgetUtil.h"
#import "DRLunarYearView.h"

#define kLunarPickerRowCount 10000   // 总行数，即可显示的总天数
#define kLunarPickerCentreRow 5000   // 中间行数，每次滚动结束时定位的位置
#define kZeroYear 2697
#define kLunarCycle 60

@implementation DRLunarDatePickerMonthModel

@end

@interface DRLunarDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *solarDateContentView;
@property (weak, nonatomic) IBOutlet UIImageView *solarIcon;
@property (weak, nonatomic) IBOutlet UILabel *solarDateLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *solarDateContentViewHeight;

@property (nonatomic, strong) DRLunarDatePickerMonthModel *minDate;
@property (nonatomic, strong) DRLunarDatePickerMonthModel *maxDate;
@property (nonatomic, strong) NSCalendar *lunarCalendar;
@property (nonatomic, strong) NSCalendar *solarCalendar;
@property (nonatomic, strong) NSArray<NSString *> *lunarDays;
@property (nonatomic, strong) NSArray<NSString *> *lunarMonths;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSArray<DRLunarDatePickerMonthModel *> *> *yearMonthListMap;
@property (nonatomic, strong) NSArray<DRLunarDatePickerMonthModel *> *currentMonthList;
@property (nonatomic, assign) NSInteger lunarYear;
@property (nonatomic, assign) BOOL didDrawRect;
@property (nonatomic, assign) BOOL dateModeChanging;

@end

@implementation DRLunarDatePickerView

- (void)setDateModeXib:(NSInteger)dateModeXib {
    self.dateMode = dateModeXib;
}

- (void)setDateMode:(DRLunarDatePickerMode)dateMode {
    if (dateMode == _dateMode) {
        return;
    }
    _dateMode = dateMode;

    if (dateMode == DRLunarDatePickerModeYMD) {
        self.currentMonthList = [self monthListFromLunarYear:self.lunarYear];
    } else if (dateMode == DRLunarDatePickerModeMD) {
        self.currentMonthList = [self ignoreYearMonthListWithLeapMonth:NO];
    } else {
        self.currentMonthList = [self ignoreYearMonthListWithLeapMonth:YES];
    }
    _selectedMonth = [self findEquelLunarModel:self.selectedMonth fromList:self.currentMonthList];

    if (self.pickerView.delegate) {
        [self setupPickerView];
        [self.pickerView setNeedsLayout];
        [self.pickerView reloadAllComponents];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dateModeChanging = YES;
            NSInteger component = 4;
            if (self.dateMode != DRLunarDatePickerModeYMD) {
                component = 2;
            }
            NSInteger row = self.selectedDay-1 + self.selectedMonth.dayCount * kLunarPickerCentreRow;
            [self pickerView:self.pickerView didSelectRow:row inComponent:component];
        });
    }
    [self setupSolarTip];
}

- (void)setupSolarTip {
    if (self.dateMode == DRLunarDatePickerModeYMD && self.showSolarTip) {
        self.solarDateContentView.hidden = NO;
        self.solarDateContentViewHeight.constant = 42;
    } else {
        self.solarDateContentView.hidden = YES;
        self.solarDateContentViewHeight.constant = 0;
    }
}

- (void)setupWithCurrentDate:(NSDate *)currentDate
                     minDate:(NSDate *)minDate
                     maxDate:(NSDate *)maxDate
                       month:(NSInteger)month
                         day:(NSInteger)day
                   leapMonth:(BOOL)leapMonth {
    [DRUIWidgetUtil dateLegalCheckForCurrentDate:&currentDate minDate:&minDate maxDate:&maxDate];
    self.minDate = [self lunarDateCmpModelDate:minDate];
    self.maxDate = [self lunarDateCmpModelDate:maxDate];
    [self refreshWithDate:currentDate month:month day:day leapMonth:leapMonth];
}

- (void)refreshWithDate:(NSDate *)date
                  month:(NSInteger)month
                    day:(NSInteger)day {
    [self refreshWithDate:date month:month day:day leapMonth:NO];
}

- (void)refreshWithDate:(NSDate *)date
                  month:(NSInteger)month
                    day:(NSInteger)day
              leapMonth:(BOOL)leapMonth {
    NSDateComponents *cmp;
    if (date) {
        cmp = [self.lunarCalendar components:[NSDate dateComponentsUnitsWithType:DRCalenderUnitsTypeDay]|NSCalendarUnitEra
                                    fromDate:date];
        self.lunarYear = cmp.era * kLunarCycle + cmp.year - kZeroYear;
        self.solarDateLabel.text = [date dateStringFromFormatterString:@"yyyy年MM月dd日"];
        _selectedDate = date;
    }
    if (self.dateMode == DRLunarDatePickerModeYMD) {
        self.currentMonthList = [self monthListFromLunarYear:self.lunarYear];
        _selectedMonth = self.currentMonthList[cmp.month-1 + cmp.leapMonth];
        _selectedDay = cmp.day;
    } else if (self.dateMode == DRLunarDatePickerModeMD) {
        self.currentMonthList = [self ignoreYearMonthListWithLeapMonth:NO];
        _selectedMonth = self.currentMonthList[month-1];
        _selectedDay = day;
    } else {
        self.currentMonthList = [self ignoreYearMonthListWithLeapMonth:YES];
        _selectedMonth = self.currentMonthList[(month-1) * 2 + leapMonth];
        _selectedDay = day;
    }
    if (self.pickerView.delegate) {
        [self setupPickerView];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    [DRUIWidgetUtil hideSeparateLineForPickerView:pickerView];
    if (self.dateMode != DRLunarDatePickerModeYMD) {
        return 3;
    }
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.dateMode != DRLunarDatePickerModeYMD) {
        if (component == 0) {
            if (self.dateMode == DRLunarDatePickerModeMD) {
                return 12 * kLunarPickerRowCount;
            }
            return 24 * kLunarPickerRowCount;
        }
        if (component == 2) {
            return 30 * kLunarPickerRowCount;
        }
    } else {
        if (component == 0) {
            return kLunarPickerRowCount;
        }
        if (component == 2) {
            return self.currentMonthList.count * kLunarPickerRowCount;
        }
        if (component == 4) {
            return self.selectedMonth.dayCount * kLunarPickerRowCount;
        }
    }
    return 1;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.dateMode != DRLunarDatePickerModeYMD) {
        if (component == 1) {
            return 8;
        }
        return 90;
    } else {
        CGFloat colunmWith = (self.width - 115) / 3;
        if (component == 0) { // 年
            return colunmWith + 50;
        }
        if (component %2 == 0) { // 月，日
            return colunmWith;
        }
        return 8; // 分隔线/
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 34;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label;
    DRLunarYearView *yearView;
    if (self.dateMode == DRLunarDatePickerModeYMD && component == 0) {
        yearView = (DRLunarYearView *)view;
        if (!yearView) {
            yearView = kDR_LOAD_XIB_NAMED(NSStringFromClass([DRLunarYearView class]));
            yearView.textColor = [DRUIWidgetUtil pickerUnSelectColor];
        }
    } else {
        label = (UILabel *)view;
        if (!label) {
            label = [[UILabel alloc] init];
            label.textColor = [DRUIWidgetUtil pickerUnSelectColor];
            label.font = [UIFont dr_PingFangSC_MediumWithSize:17];
            label.textAlignment = NSTextAlignmentCenter;
            if (component % 2 > 0) {
                label.textColor = [DRUIWidgetUtil normalColor];
                label.font = [UIFont dr_PingFangSC_RegularWithSize:15];
            }
        }
    }
    [self setupTextColorForLabel:label yearView:yearView inComponent:component forRow:row];

    NSString *text = @"/";
    if (self.dateMode != DRLunarDatePickerModeYMD) {
        if (component == 0) {
            if (self.dateMode == DRLunarDatePickerModeMD) {
                text = self.currentMonthList[row%12].name;
            } else {
                text = self.currentMonthList[row%24].name;
            }
        } else if (component == 2) {
            text = self.lunarDays[row%30];
        }
    } else {
        if (component == 0) {
            [self setupLunarYearView:yearView withLunarYear:row];
            return yearView;
        }
        if (component == 2) {
            text = self.currentMonthList[row%self.currentMonthList.count].name;
        }
        if (component == 4) {
            text = self.lunarDays[row%self.selectedMonth.dayCount];
        }
    }
    label.text = text;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.dateMode != DRLunarDatePickerModeYMD) {
        [self setupIgnoreYearSelectRow:row inComponent:component];
    } else {
        [self setupWithYearSelectRow:row inComponent:component];
    }
    [self.pickerView reloadAllComponents];

    if (self.dateMode != DRLunarDatePickerModeYMD) {
        _selectedDate = nil;
    } else {
        NSDateComponents *cmp = [NSDateComponents lunarComponentsWithEra:self.selectedMonth.cmp.era
                                                                    year:self.selectedMonth.cmp.year
                                                                   month:self.selectedMonth.cmp.month
                                                                     day:self.selectedDay
                                                               leapMonth:self.selectedMonth.cmp.leapMonth];
        _selectedDate = [self.lunarCalendar dateFromComponents:cmp];
        self.solarDateLabel.text = [self.selectedDate dateStringFromFormatterString:@"yyyy年MM月dd日"];
    }
    if (!self.dateModeChanging) {
        kDR_SAFE_BLOCK(self.onSelectChangeBlock, self.selectedDate, self.selectedMonth.cmp.month, self.selectedDay);
    }
    self.dateModeChanging = NO;
}

#pragma mark - private
- (void)setupPickerView {
    [self.pickerView reloadAllComponents];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.dateMode != DRLunarDatePickerModeYMD) {
            if (self.dateMode == DRLunarDatePickerModeMD) {
                [self.pickerView selectRow:self.selectedMonth.index + kLunarPickerCentreRow * 12 inComponent:0 animated:NO];
            } else {
                [self.pickerView selectRow:self.selectedMonth.index + kLunarPickerCentreRow * 24 inComponent:0 animated:NO];
            }
            [self.pickerView selectRow:self.selectedDay-1 + kLunarPickerCentreRow * 30 inComponent:2 animated:NO];
        } else {
            [self.pickerView selectRow:self.selectedMonth.lunarYear inComponent:0 animated:NO];
            [self.pickerView selectRow:self.selectedMonth.index + kLunarPickerCentreRow * self.currentMonthList.count inComponent:2 animated:NO];
            [self.pickerView selectRow:self.selectedDay-1 + kLunarPickerCentreRow * self.selectedMonth.dayCount inComponent:4 animated:NO];
        }
        [self.pickerView reloadAllComponents];
    });
}

- (void)setupLunarYearView:(DRLunarYearView *)yearView withLunarYear:(NSInteger)lunarYear {
    NSInteger year = (lunarYear + kZeroYear) % kLunarCycle;
    if (year == 0) {
        year = 60;
    }
    NSArray *heavenlyStems = @[@"甲", @"乙", @"丙", @"丁", @"戊", @"己", @"庚", @"辛", @"壬", @"癸"];
    NSArray *earthlyBranches = @[@"子", @"丑", @"寅", @"卯", @"辰", @"巳", @"午", @"未", @"申", @"酉", @"戌", @"亥"];
    NSInteger heavenlyStemIndex = (year - 1) % heavenlyStems.count;
    NSInteger earthlyBrancheIndex = (year - 1) % earthlyBranches.count;
    NSString *string = [NSString stringWithFormat:@"%@%@", heavenlyStems[heavenlyStemIndex], earthlyBranches[earthlyBrancheIndex]];
    [yearView setupName:string year:lunarYear];
}

- (DRLunarDatePickerMonthModel *)lunarDateCmpModelDate:(NSDate *)date {
    NSDateComponents *cmp = [self.lunarCalendar components:[NSDate dateComponentsUnitsWithType:DRCalenderUnitsTypeDay]|NSCalendarUnitEra fromDate:date];
    DRLunarDatePickerMonthModel *model = [DRLunarDatePickerMonthModel new];
    model.cmp = cmp;
    model.lunarYear = cmp.era * kLunarCycle + cmp.year - kZeroYear;
    NSArray *monthList = [self monthListFromLunarYear:model.lunarYear];
    model.index = [self findEquelLunarModel:model fromList:monthList].index;
    return model;
}

- (void)setupTextColorForLabel:(UILabel *)label yearView:(DRLunarYearView *)yearView inComponent:(NSInteger)component forRow:(NSInteger)row {
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:component];
    if (row == selectedRow) {
        label.textColor = [DRUIWidgetUtil normalColor];
        yearView.textColor = [DRUIWidgetUtil normalColor];
    }

    if (self.dateMode == DRLunarDatePickerModeYMD && [self isDisableForRow:row inComponent:component]) {
        label.textColor = [DRUIWidgetUtil pickerDisableColor];
        yearView.textColor = [DRUIWidgetUtil pickerDisableColor];
    }
}

- (BOOL)isDisableForRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([self compareDateForRow:row inComponent:component] != 0) {
        return YES;
    }
    return NO;
}

- (NSInteger)compareDateForRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger year = self.selectedMonth.lunarYear;
    NSInteger monthIndex = self.selectedMonth.index;
    NSInteger day = self.selectedDay;
    if (component == 0) {
        year = row;
    } else if (component == 2) {
        DRLunarDatePickerMonthModel *model = self.currentMonthList[row % self.currentMonthList.count];
        monthIndex = model.index;
    } else if (component == 4) {
        day = row % self.selectedMonth.dayCount + 1;
    }
    if (year < self.minDate.lunarYear ||
        (year == self.minDate.lunarYear && monthIndex < self.minDate.index) ||
        (year == self.minDate.lunarYear && monthIndex == self.minDate.index && day < self.minDate.cmp.day)) {
        return -1;
    }
    if (year > self.maxDate.lunarYear ||
        (year == self.maxDate.lunarYear && monthIndex > self.maxDate.index) ||
        (year == self.maxDate.lunarYear && monthIndex == self.maxDate.index && day > self.maxDate.cmp.day)) {
        return 1;
    }
    return 0;
}

- (void)setupWithYearSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component % 2) {
        return;
    }
    // 获取最新值，及滚动复位
    NSInteger year = self.selectedMonth.lunarYear;
    NSInteger monthIndex = self.selectedMonth.index;
    if (component == 0) {
        year = row;
    }
    if (component == 2) {
        monthIndex = row%self.currentMonthList.count;
        [self.pickerView selectRow:monthIndex + kLunarPickerCentreRow*self.currentMonthList.count inComponent:2 animated:NO];
    }
    if (component == 4) {
        _selectedDay = row % self.selectedMonth.dayCount + 1;
        [self.pickerView selectRow:self.selectedDay-1 + self.selectedMonth.dayCount * kLunarPickerCentreRow inComponent:4 animated:NO];
    }

    // 超限检查
    BOOL needScroll = NO;
    if ([self compareDateForRow:row inComponent:component] < 0) {
        year = self.minDate.lunarYear;
        monthIndex = self.minDate.index;
        _selectedDay = self.minDate.cmp.day;
        needScroll = YES;
    } else if ([self compareDateForRow:row inComponent:component] > 0) {
        year = self.maxDate.lunarYear;
        monthIndex = self.maxDate.index;
        _selectedDay = self.maxDate.cmp.day;
        needScroll = YES;
    }
    if (year != self.selectedMonth.lunarYear) {
        self.lunarYear = year;
        NSArray *monthList = [self monthListFromLunarYear:self.lunarYear];
        if (monthList.count != self.currentMonthList.count) {
            [self.pickerView selectRow:monthIndex + monthList.count * kLunarPickerCentreRow inComponent:2 animated:NO];
            needScroll = YES;
        }
        self.currentMonthList = monthList;
        [self.pickerView reloadComponent:2];
    }

    // 检测每月天数改变
    DRLunarDatePickerMonthModel *model = self.currentMonthList[monthIndex];
    if (!model) { // 月份变少了，month是最后一个月时会取不到
        model = self.currentMonthList.lastObject;
        needScroll = YES;
    }
    NSInteger daysInMonth = model.dayCount;
    if (daysInMonth != self.selectedMonth.dayCount) {
        [self.pickerView selectRow:self.selectedDay-1 + daysInMonth * kLunarPickerCentreRow inComponent:4 animated:NO]; // 按新的每月天数设置日的行号
    }
    if (self.selectedDay > daysInMonth) {
        _selectedDay = daysInMonth;
        needScroll = YES;
    }
    _selectedMonth = model;
    [self.pickerView reloadComponent:4];

    // 超限回滚
    if (needScroll) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pickerView selectRow:year inComponent:0 animated:YES];
            [self.pickerView selectRow:self.selectedMonth.index + self.currentMonthList.count*kLunarPickerCentreRow inComponent:2 animated:YES];
            [self.pickerView selectRow:self.selectedDay-1 + self.selectedMonth.dayCount*kLunarPickerCentreRow inComponent:4 animated:YES];
        });
    }
}

- (void)setupIgnoreYearSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component % 2) {
        return;
    }
    // 获取最新值，及滚动复位
    if (component == 0) {
        NSInteger month = row % 24;
        if (self.dateMode == DRLunarDatePickerModeMD) {
            month = row % 12;
        }
        _selectedMonth = self.currentMonthList[month];
        [self.pickerView selectRow:month + kLunarPickerCentreRow*self.currentMonthList.count inComponent:0 animated:NO];
        [self.pickerView reloadComponent:2];
    }
    if (component == 2) {
        _selectedDay = row % 30 + 1;
        [self.pickerView selectRow:self.selectedDay-1 + 30 * kLunarPickerCentreRow inComponent:2 animated:NO];
    }
}

- (NSArray<DRLunarDatePickerMonthModel *> *)monthListFromLunarYear:(NSInteger)lunarYear {
    NSArray *monthList = self.yearMonthListMap[@(lunarYear)];
    if (!monthList) {
        NSMutableArray<DRLunarDatePickerMonthModel *> *list = [NSMutableArray array];
        monthList = list;
        [self.yearMonthListMap setObject:list forKey:@(lunarYear)];

        NSInteger wholeYear = lunarYear + kZeroYear;
        NSInteger era = wholeYear / kLunarCycle;
        NSInteger year = wholeYear % kLunarCycle;
        if (year == 0) {
            year = 60;
            era--;
        }

        NSInteger index = 0;
        for (NSInteger i=0; i<24; i++) {
            NSDateComponents *cmp = [NSDateComponents lunarComponentsWithEra:era year:year month:1+i/2 day:1 leapMonth:i%2];
            if ([cmp isValidDateInCalendar:self.lunarCalendar]) {
                DRLunarDatePickerMonthModel *model = [DRLunarDatePickerMonthModel new];
                model.lunarYear = lunarYear;
                model.cmp = cmp;
                model.dayCount =  [self.lunarCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[self.lunarCalendar dateFromComponents:cmp]].length;
                if (cmp.leapMonth) {
                    model.name = [NSString stringWithFormat:@"闰%@", self.lunarMonths[cmp.month-1]];
                } else {
                    model.name = self.lunarMonths[cmp.month-1];
                }
                model.index = index;
                [list addObject:model];
                index ++;
            }
        }
    }
    return monthList;
}

- (NSArray<DRLunarDatePickerMonthModel *> *)ignoreYearMonthListWithLeapMonth:(BOOL)withLeapMonth {
    NSMutableArray<DRLunarDatePickerMonthModel *> *list = [NSMutableArray array];
    NSInteger count = 12 * (1+withLeapMonth);
    for (NSInteger i=0; i<count; i++) {
        NSDateComponents *cmp = [NSDateComponents lunarComponentsWithEra:0
                                                                    year:0
                                                                   month:1+i/(1+withLeapMonth)
                                                                     day:1
                                                               leapMonth:withLeapMonth*(i%2)];
        DRLunarDatePickerMonthModel *model = [DRLunarDatePickerMonthModel new];
        model.cmp = cmp;
        model.dayCount = 30;
        if (cmp.leapMonth) {
            model.name = [NSString stringWithFormat:@"闰%@", self.lunarMonths[cmp.month-1]];
        } else {
            model.name = self.lunarMonths[cmp.month-1];
        }
        model.index = i;
        [list addObject:model];
    }
    return list;
}

- (DRLunarDatePickerMonthModel *)findEquelLunarModel:(DRLunarDatePickerMonthModel *)lunarModel fromList:(NSArray<DRLunarDatePickerMonthModel *> *)monthList {
    DRLunarDatePickerMonthModel *currentModel = nil;
    for (DRLunarDatePickerMonthModel *model in monthList) {
        if (model.cmp.month == lunarModel.cmp.month) {
            currentModel = model;
            if (!lunarModel.cmp.leapMonth) {
                break;
            }
        }
        if (model.cmp.month > lunarModel.cmp.month) {
            break;
        }
    }
    return currentModel;
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
    if (!self.containerView) {
        self.containerView = kDR_LOAD_XIB_NAMED(NSStringFromClass([self class]));
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_offset(0);
        }];
        self.solarDateContentView.hidden = YES;
        self.solarDateContentViewHeight.constant = 0;

        self.solarDateLabel.textColor = [DRUIWidgetUtil highlightColor];
        self.solarIcon.image = [DRUIWidgetUtil pngImageWithName:@"icon_birth_solar"
                                                       inBundle:KDR_CURRENT_BUNDLE];
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
            self.pickerView.delegate = self;
            self.pickerView.dataSource = self;
            [self.pickerView reloadAllComponents];
            [self setupSolarTip];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupPickerView];
            });
        });
    }
}

#pragma mark - layzy load
- (NSCalendar *)lunarCalendar {
    if (!_lunarCalendar) {
        _lunarCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
        [_lunarCalendar setTimeZone:[NSTimeZone defaultTimeZone]];
        [_lunarCalendar setFirstWeekday:DRCalendarFirstDay];
    }
    return _lunarCalendar;
}

- (NSCalendar *)solarCalendar {
    if (!_solarCalendar) {
        _solarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [_solarCalendar setTimeZone:[NSTimeZone defaultTimeZone]];
        [_solarCalendar setFirstWeekday:DRCalendarFirstDay];
    }
    return _solarCalendar;
}

- (NSMutableDictionary<NSNumber *, NSArray<DRLunarDatePickerMonthModel *> *> *)yearMonthListMap {
    if (!_yearMonthListMap) {
        _yearMonthListMap = [NSMutableDictionary dictionary];
    }
    return _yearMonthListMap;
}

- (NSArray<NSString *> *)lunarDays {
    if (!_lunarDays) {
        _lunarDays = @[@"初一", @"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十"];
    }
    return _lunarDays;
}

- (NSArray<NSString *> *)lunarMonths {
    if (!_lunarMonths) {
        _lunarMonths = @[@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"冬月",@"腊月"];
    }
    return _lunarMonths;
}

@end
