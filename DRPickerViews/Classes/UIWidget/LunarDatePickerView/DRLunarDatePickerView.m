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

@interface DRLunarDateModel : NSObject

@property (nonatomic, assign) NSInteger lunarYear;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDateComponents *cmp;
@property (nonatomic, assign) NSInteger dayCount;
@property (nonatomic, assign) NSInteger index;

@end

@implementation DRLunarDateModel

@end

@interface DRLunarDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) UIPickerView *pickerView;

@property (nonatomic, strong) DRLunarDateModel *minDate;
@property (nonatomic, strong) DRLunarDateModel *maxDate;
@property (nonatomic, strong) NSCalendar *lunarCalendar;
@property (nonatomic, strong) NSCalendar *solarCalendar;
@property (nonatomic, strong) NSArray<NSString *> *lunarDays;
@property (nonatomic, strong) NSArray<NSString *> *lunarMonths;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSArray<DRLunarDateModel *> *> *yearMonthListMap;
@property (nonatomic, strong) NSArray<DRLunarDateModel *> *currentMonthList;
@property (nonatomic, strong) DRLunarDateModel *currentMonth;
@property (nonatomic, assign) NSInteger lunarYear;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) BOOL didDrawRect;
@property (nonatomic, assign) BOOL dateModeChanging;

@end

@implementation DRLunarDatePickerView

- (void)setIgnoreYear:(BOOL)ignoreYear {
    if (ignoreYear == _ignoreYear) {
        return;
    }
    
    if (_ignoreYear) { // 之前是忽略年份的
        self.currentMonthList = [self monthListFromLunarYear:self.lunarYear];
    } else { // 之前是显示年份的
        self.currentMonthList = [self ignoreYearMonthList];
    }
    self.currentMonth = [self findEquelLunarModel:self.currentMonth fromList:self.currentMonthList];
    
    _ignoreYear = ignoreYear;
    
    if (self.pickerView.delegate) {
        [self setupPickerView];
        [self.pickerView setNeedsLayout];
        [self.pickerView reloadAllComponents];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dateModeChanging = YES;
            [self pickerView:self.pickerView didSelectRow:self.day-1 + self.currentMonth.dayCount * kLunarPickerCentreRow inComponent:4];
        });
    }
}

- (void)setupWithCurrentDate:(NSDate *)currentDate
                     minDate:(NSDate *)minDate
                     maxDate:(NSDate *)maxDate
                       month:(NSInteger)month
                         day:(NSInteger)day
                   leapMonth:(BOOL)leapMonth
           selectChangeBlock:(void(^)(NSDate *date, NSInteger year, NSInteger month, NSInteger day, BOOL leapMonth))selectChangeBlock {
    [DRUIWidgetUtil dateLegalCheckForCurrentDate:&currentDate minDate:&minDate maxDate:&maxDate];
    self.minDate = [self lunarDateCmpModelDate:minDate];
    self.maxDate = [self lunarDateCmpModelDate:maxDate];
    self.onSelectChangeBlock = selectChangeBlock;
    [self refreshWithDate:currentDate month:month day:day leapMonth:leapMonth];
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
        _selectedDate = date;
    }
    if (self.ignoreYear) {
        self.currentMonthList = [self ignoreYearMonthList];
        self.currentMonth = self.currentMonthList[(month-1) * 2 + leapMonth];
        self.day = day;
    } else {
        self.currentMonthList = [self monthListFromLunarYear:self.lunarYear];
        self.currentMonth = self.currentMonthList[cmp.month-1 + cmp.leapMonth];
        self.day = cmp.day;
    }
    if (self.pickerView.delegate) {
        [self setupPickerView];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.ignoreYear) {
        return 3;
    }
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.ignoreYear) {
        if (component == 0) {
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
            return self.currentMonth.dayCount * kLunarPickerRowCount;
        }
    }
    return 1;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.ignoreYear) {
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
    if (!self.ignoreYear && component == 0) {
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
    if (self.ignoreYear) {
        if (component == 0) {
            text = self.currentMonthList[row%24].name;
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
            text = self.lunarDays[row%self.currentMonth.dayCount];
        }
    }
    label.text = text;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.ignoreYear) {
        [self setupIgnoreYearSelectRow:row inComponent:component];
    } else {
        [self setupWithYearSelectRow:row inComponent:component];
    }
    [self.pickerView reloadAllComponents];
    if (!self.dateModeChanging) {
        [self whenSelectChange];
    }
    self.dateModeChanging = NO;
}

#pragma mark - private
- (void)setupPickerView {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.ignoreYear) {
            [self.pickerView selectRow:self.currentMonth.index + kLunarPickerCentreRow * 24 inComponent:0 animated:NO];
            [self.pickerView selectRow:self.day-1 + kLunarPickerCentreRow * 30 inComponent:2 animated:NO];
        } else {
            [self.pickerView selectRow:self.currentMonth.lunarYear inComponent:0 animated:NO];
            [self.pickerView selectRow:self.currentMonth.index + kLunarPickerCentreRow * self.currentMonthList.count inComponent:2 animated:NO];
            [self.pickerView selectRow:self.day-1 + kLunarPickerCentreRow * self.currentMonth.dayCount inComponent:4 animated:NO];
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

- (DRLunarDateModel *)lunarDateCmpModelDate:(NSDate *)date {
    NSDateComponents *cmp = [self.lunarCalendar components:[NSDate dateComponentsUnitsWithType:DRCalenderUnitsTypeDay]|NSCalendarUnitEra fromDate:date];
    DRLunarDateModel *model = [DRLunarDateModel new];
    model.cmp = cmp;
    model.lunarYear = cmp.era * kLunarCycle + cmp.year - kZeroYear;
    NSArray *monthList = [self monthListFromLunarYear:model.lunarYear];
    model.index = [self findEquelLunarModel:model fromList:monthList].index;
    return model;
}

- (void)setupTextColorForLabel:(UILabel *)label yearView:(DRLunarYearView *)yearView inComponent:(NSInteger)component forRow:(NSInteger)row {
    if (component % 2 > 0) {
        return;
    }
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:component];
    if (row == selectedRow) {
        label.textColor = [DRUIWidgetUtil normalColor];
        yearView.textColor = [DRUIWidgetUtil normalColor];
    }

    if (!self.ignoreYear && [self isDisableForRow:row inComponent:component]) {
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
    NSInteger year = self.currentMonth.lunarYear;
    NSInteger monthIndex = self.currentMonth.index;
    NSInteger day = self.day;
    if (component == 0) {
        year = row;
    } else if (component == 2) {
        DRLunarDateModel *model = self.currentMonthList[row % self.currentMonthList.count];
        monthIndex = model.index;
    } else if (component == 4) {
        day = row % self.currentMonth.dayCount + 1;
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
    // 获取最新值，及滚动复位
    NSInteger year = self.currentMonth.lunarYear;
    NSInteger monthIndex = self.currentMonth.index;
    if (component == 0) {
        year = row;
    }
    if (component == 2) {
        monthIndex = row%self.currentMonthList.count;
        [self.pickerView selectRow:monthIndex + kLunarPickerCentreRow*self.currentMonthList.count inComponent:2 animated:NO];
    }
    if (component == 4) {
        self.day = row % self.currentMonth.dayCount + 1;
        [self.pickerView selectRow:self.day-1 + self.currentMonth.dayCount * kLunarPickerCentreRow inComponent:4 animated:NO];
    }

    // 超限检查
    BOOL needScroll = NO;
    if ([self compareDateForRow:row inComponent:component] < 0) {
        year = self.minDate.lunarYear;
        monthIndex = self.minDate.index;
        self.day = self.minDate.cmp.day;
        needScroll = YES;
    } else if ([self compareDateForRow:row inComponent:component] > 0) {
        year = self.maxDate.lunarYear;
        monthIndex = self.maxDate.index;
        self.day = self.maxDate.cmp.day;
        needScroll = YES;
    }
    if (year != self.currentMonth.lunarYear) {
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
    DRLunarDateModel *model = self.currentMonthList[monthIndex];
    if (!model) { // 月份变少了，month是最后一个月时会取不到
        model = self.currentMonthList.lastObject;
        needScroll = YES;
    }
    NSInteger daysInMonth = model.dayCount;
    if (daysInMonth != self.currentMonth.dayCount) {
        [self.pickerView selectRow:self.day-1 + daysInMonth * kLunarPickerCentreRow inComponent:4 animated:NO]; // 按新的每月天数设置日的行号
    }
    if (self.day > daysInMonth) {
        self.day = daysInMonth;
        needScroll = YES;
    }
    self.currentMonth = model;
    [self.pickerView reloadComponent:4];

    // 超限回滚
    if (needScroll) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pickerView selectRow:year inComponent:0 animated:YES];
            [self.pickerView selectRow:self.currentMonth.index + self.currentMonthList.count*kLunarPickerCentreRow inComponent:2 animated:YES];
            [self.pickerView selectRow:self.day-1 + self.currentMonth.dayCount*kLunarPickerCentreRow inComponent:4 animated:YES];
        });
    }
}

- (void)setupIgnoreYearSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // 获取最新值，及滚动复位
    if (component == 0) {
        NSInteger month = row % 24;
        self.currentMonth = self.currentMonthList[month];
        [self.pickerView selectRow:month + kLunarPickerCentreRow*self.currentMonthList.count inComponent:0 animated:NO];
        [self.pickerView reloadComponent:2];
    }
    if (component == 2) {
        self.day = row % 30 + 1;
        [self.pickerView selectRow:self.day-1 + 30 * kLunarPickerCentreRow inComponent:2 animated:NO];
    }
}

- (void)whenSelectChange {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.ignoreYear) {
            self->_selectedDate = nil;
            kDR_SAFE_BLOCK(self.onSelectChangeBlock, nil, 0, self.currentMonth.cmp.month, self.day, self.currentMonth.cmp.leapMonth);
        } else {
            NSDateComponents *cmp = [NSDateComponents lunarComponentsWithEra:self.currentMonth.cmp.era
                                                                        year:self.currentMonth.cmp.year
                                                                       month:self.currentMonth.cmp.month
                                                                         day:self.day
                                                                   leapMonth:self.currentMonth.cmp.leapMonth];
            self->_selectedDate = [self.lunarCalendar dateFromComponents:cmp];
            kDR_SAFE_BLOCK(self.onSelectChangeBlock, self->_selectedDate, self.currentMonth.cmp.year, -1, -1, cmp.leapMonth);
        }
    });
}

- (NSArray<DRLunarDateModel *> *)monthListFromLunarYear:(NSInteger)lunarYear {
    NSArray *monthList = self.yearMonthListMap[@(lunarYear)];
    if (!monthList) {
        NSMutableArray<DRLunarDateModel *> *list = [NSMutableArray array];
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
                DRLunarDateModel *model = [DRLunarDateModel new];
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

- (NSArray<DRLunarDateModel *> *)ignoreYearMonthList {
    NSMutableArray<DRLunarDateModel *> *list = [NSMutableArray array];
    for (NSInteger i=0; i<24; i++) {
        NSDateComponents *cmp = [NSDateComponents lunarComponentsWithEra:0 year:0 month:1+i/2 day:1 leapMonth:i%2];
        DRLunarDateModel *model = [DRLunarDateModel new];
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

- (DRLunarDateModel *)findEquelLunarModel:(DRLunarDateModel *)lunarModel fromList:(NSArray<DRLunarDateModel *> *)monthList {
    DRLunarDateModel *currentModel = nil;
    for (DRLunarDateModel *model in monthList) {
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
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.backgroundColor = [UIColor clearColor];
    [self addSubview:picker];
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_offset(0);
    }];
    self.pickerView = picker;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [DRUIWidgetUtil hideSeparateLineForPickerView:self.pickerView];
    });
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupPickerView];
            });
        });
    }
}

#pragma mark - layzy load
- (NSCalendar *)lunarCalendar {
    if (!_lunarCalendar) {
        NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
        _lunarCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
        [_lunarCalendar setTimeZone:timeZone];
        [_lunarCalendar setFirstWeekday:DRCalendarFirstDay];
    }
    return _lunarCalendar;
}

- (NSCalendar *)solarCalendar {
    if (!_solarCalendar) {
        NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
        _solarCalendar = [NSCalendar currentCalendar];
        [_solarCalendar setTimeZone:timeZone];
        [_solarCalendar setFirstWeekday:DRCalendarFirstDay];
    }
    return _solarCalendar;
}

- (NSMutableDictionary<NSNumber *, NSArray<DRLunarDateModel *> *> *)yearMonthListMap {
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
