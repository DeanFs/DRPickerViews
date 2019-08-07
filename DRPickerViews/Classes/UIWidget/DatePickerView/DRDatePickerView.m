//
//  DRDatePickerView.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/2.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRDatePickerView.h"
#import <Masonry/Masonry.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIView+DRExtension.h>
#import <DRCategories/UIFont+DRExtension.h>
#import <DRCategories/NSDate+DRExtension.h>
#import <DRCategories/NSDateComponents+DRExtension.h>
#import "DRUIWidgetUtil.h"

#define kDatePickerRowCount 10000   // 总行数，即可显示的总天数
#define kDatePickerCentreRow 5000   // 中间行数，每次滚动结束时定位的位置

@interface DRDatePickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) UIPickerView *pickerView;

@property (nonatomic, assign) NSInteger monthDayCount; // 当月天数
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger minDate;
@property (nonatomic, assign) NSInteger maxDate;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, copy) void (^onSelectChangeBlock) (NSDate *date, NSInteger month, NSInteger day);

@end

@implementation DRDatePickerView

- (void)setDateModeXib:(NSInteger)dateModeXib {
    self.dateMode = dateModeXib;
}

- (void)setDateMode:(DRDatePickerMode)dateMode {
    if (dateMode == _dateMode) {
        return;
    }
    _dateMode = dateMode;
    [self.pickerView setNeedsLayout];
    [self.pickerView reloadAllComponents];
    [self setupPickerView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self pickerView:self.pickerView didSelectRow:[self.pickerView selectedRowInComponent:0] inComponent:0];
    });
}

- (void)setupWithCurrentDate:(NSDate *)currentDate
                     minDate:(NSDate *)minDate
                     maxDate:(NSDate *)maxDate
                       month:(NSInteger)month
                         day:(NSInteger)day
           selectChangeBlock:(void(^)(NSDate *date, NSInteger month, NSInteger day))selectChangeBlock {
    [DRUIWidgetUtil dateLegalCheckForCurrentDate:&currentDate minDate:&minDate maxDate:&maxDate];
    self.minDate = [minDate dateStringFromFormatterString:@"yyyyMMdd"].integerValue;
    self.maxDate = [maxDate dateStringFromFormatterString:@"yyyyMMdd"].integerValue;
    self.onSelectChangeBlock = selectChangeBlock;
    _selectedDate = currentDate;
    [self refreshWithDate:currentDate month:month day:day];
}

- (void)refreshWithDate:(NSDate *)date
                  month:(NSInteger)month
                    day:(NSInteger)day {
    if (date) {
        NSDateComponents *cmp = [self.calendar components:[NSDate dateComponentsUnitsWithType:DRCalenderUnitsTypeDay]
                                                 fromDate:date];
        self.year = cmp.year;
        self.month = cmp.month;
        self.day = cmp.day;
        _selectedDate = date;
    }
    if (self.dateMode == DRDatePickerModeMD) {
        self.month = month;
        self.day = day;
    }
    [self setupPickerView];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.dateMode == DRDatePickerModeYMD) {
        return 5;
    }
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (self.dateMode) {
        case DRDatePickerModeYMD: {
            if (component == 0) { // 年
                return kDatePickerRowCount;
            }
            if (component == 2) { // 月
                return 12 * kDatePickerRowCount;
            }
            if (component == 4) {
                return self.monthDayCount * kDatePickerRowCount; // 日
            }
            return 1; // 分隔线/
        } break;
            
        case DRDatePickerModeYM: {
            if (component == 0) { // 年
                return kDatePickerRowCount;
            }
            if (component == 2) { // 月
                return kDatePickerRowCount * 12;
            }
            return 1; // 分隔线/
        } break;
            
        case DRDatePickerModeMD: {
            if (component == 0) { // 月
                return 12 * kDatePickerRowCount;
            }
            if (component == 2) { // 日
                return self.monthDayCount * kDatePickerRowCount;
            }
            return 1; // 分隔线/
        } break;
            
        default:
            break;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (self.dateMode) {
        case DRDatePickerModeYMD: {
            CGFloat colunmWith = (self.width - 95) / 3;
            if (component == 0) { // 年
                return colunmWith + 30;
            }
            if (component %2 == 0) { // 月，日
                return colunmWith;
            }
            return 8; // 分隔线/
        } break;
            
        case DRDatePickerModeYM: {
            if (component == 0) { // 年
                return 120;
            }
            if (component == 2) { // 月
                return 100;
            }
            return 8; // 分隔线/
        } break;
            
        case DRDatePickerModeMD: {
            if (component == 1) {
                return 8; // 分隔线/
            }
            return 70;
        } break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 34;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.textColor = [DRUIWidgetUtil pickerUnSelectColor];
        label.font = [UIFont dr_PingFangSC_RegularWithSize:26];
        label.textAlignment = NSTextAlignmentCenter;
        if (component % 2 > 0) {
            label.textColor = [DRUIWidgetUtil normalColor];
            label.font = [UIFont dr_PingFangSC_RegularWithSize:15];
        }
    }
    [self setupTextColorForLabel:label inComponent:component forRow:row];
    
    NSString *text = @"/";
    switch (self.dateMode) {
        case DRDatePickerModeYMD: {
            if (component == 0) {
                text = [self yearFromRow:row];
            } else if (component == 2) {
                text = [self monthFromRow:row];
            } else if (component == 4) {
                text = [self dayFromRow:row];
            }
        } break;
            
        case DRDatePickerModeYM: {
            if (component == 0) {
                text = [self yearFromRow:row];
            } else if (component == 2) {
                text = [self monthFromRow:row];
            }
        } break;
            
        case DRDatePickerModeMD: {
            if (component == 0) {
                text = [self monthFromRow:row];
            } else if (component == 2) {
                text = [self dayFromRow:row];
            }
        } break;
            
        default:
            break;
    }
    label.text = text;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (self.dateMode) {
        case DRDatePickerModeYMD: {
            [self setupYMDSelectRow:row inComponent:component];
        } break;
            
        case DRDatePickerModeYM: {
            [self setupYMSelectRow:row inComponent:component];
        } break;
            
        case DRDatePickerModeMD: {
            [self setupMDSelectRow:row inComponent:component];
        } break;
            
        default:
            break;
    }
    [pickerView reloadAllComponents];
    [self whenSelectChange];
}

#pragma mark - private
- (void)setupPickerView {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.dateMode == DRDatePickerModeMD) {
            self.monthDayCount = [self daysCountInCurrentMonth];
            [self.pickerView selectRow:self.month-1 + 12 * kDatePickerCentreRow inComponent:0 animated:NO];
            [self.pickerView selectRow:self.day-1 + self.monthDayCount * kDatePickerCentreRow inComponent:2 animated:NO];
        } else {
            if (self.dateMode == DRDatePickerModeYMD) {
                self.monthDayCount = [self daysCountInCurrentMonth];
                [self.pickerView selectRow:self.year inComponent:0 animated:NO];
                [self.pickerView selectRow:self.month-1 + 12 * kDatePickerCentreRow inComponent:2 animated:NO];
                [self.pickerView selectRow:self.day-1 + self.monthDayCount * kDatePickerCentreRow inComponent:4 animated:NO];
            } else {
                [self.pickerView selectRow:self.year inComponent:0 animated:NO];
                [self.pickerView selectRow:kDatePickerCentreRow*12 + self.month-1 inComponent:2 animated:NO];
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.pickerView setNeedsDisplay];
            [self.pickerView reloadAllComponents];
        });
        [self reloadAllComponents];
    });
}

- (void)reloadComponent:(NSInteger)component {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pickerView reloadComponent:component];
    });
}

- (void)reloadAllComponents {
    [self reloadComponent:0];
    [self reloadComponent:2];
    if (self.dateMode == DRDatePickerModeYMD) {
        [self reloadComponent:4];
    }
}

- (NSInteger)daysCountInCurrentMonth {
    if (self.dateMode == DRDatePickerModeMD) {
        if (self.month < 8) {
            if (self.month % 2 == 0) {
                if (self.month == 2) {
                    return 29;
                }
                return 30;
            }
            return 31;
        }
        if (self.month % 2 == 0) {
            return 31;
        }
        return 30;
    }    
    return [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[self currentDateWithDay:1]].length;
}

- (NSDate *)currentDateWithDay:(NSInteger)day {
    NSDateComponents *cmp = [NSDateComponents componentsWithYear:self.year month:self.month day:day];
    return [self.calendar dateFromComponents:cmp];
}

- (NSString *)yearFromRow:(NSInteger)row {
    return [NSString stringWithFormat:@"%ld", row];
}

- (NSString *)monthFromRow:(NSInteger)row {
    return [NSString stringWithFormat:@"%02ld", row % 12 + 1];
}

- (NSString *)dayFromRow:(NSInteger)row {
    return [NSString stringWithFormat:@"%02ld", row % self.monthDayCount + 1];
}

- (void)setupTextColorForLabel:(UILabel *)label inComponent:(NSInteger)component forRow:(NSInteger)row {
    if (component % 2 > 0) {
        return;
    }
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:component];
    if (row == selectedRow) {
        label.textColor = [DRUIWidgetUtil normalColor];
    }
    
    if (self.dateMode != DRDatePickerModeMD) {
        NSInteger currentDate = [self currentDateIntegerWithRow:row inComponent:component];
        NSInteger minDate = self.minDate;
        NSInteger maxDate = self.maxDate;
        if (self.dateMode == DRDatePickerModeYM) {
            minDate = minDate / 100 * 100;
            maxDate = maxDate / 100 * 100;
        }
        if (currentDate < minDate || currentDate > maxDate) {
            label.textColor = [DRUIWidgetUtil pickerDisableColor];
        }
    }
}

- (NSInteger)currentDateIntegerWithRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger date = 0;
    if (component == 0) {
        date += (row * 10000);
        date += self.month * 100;
    } else if (component == 2) {
        date += self.year * 10000;
        date += ((row % 12 + 1) * 100);
    } else if (component == 4) {
        date += self.year * 10000;
        date += self.month * 100;
        date += (row % self.monthDayCount + 1);
    }
    if (component != 4 && self.dateMode == DRDatePickerModeYMD) {
        date += self.day;
    }
    return date;
}

- (void)setupYMDSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // 获取最新值，及滚动复位
    BOOL monthDayMayChange = NO;
    if (component == 0) {
        self.year = row;
        monthDayMayChange = YES;
    }
    if (component == 2) {
        self.month = row % 12 + 1;
        [self.pickerView selectRow:self.month-1 + kDatePickerCentreRow*12 inComponent:2 animated:NO];
        monthDayMayChange = YES;
    }
    if (component == 4) {
        self.day = row % self.monthDayCount + 1;
        [self.pickerView selectRow:self.day-1 + self.monthDayCount * kDatePickerCentreRow inComponent:4 animated:NO];
    }
    
    // 超限检查
    BOOL beyond = NO;
    NSInteger newDate = [self currentDateIntegerWithRow:row inComponent:component];
    if (newDate < self.minDate) {
        self.year = self.minDate / 10000;
        self.month = self.minDate / 100 % 100;
        self.day = self.minDate % 100;
        beyond = YES;
    } else if (newDate > self.maxDate) {
        self.year = self.maxDate / 10000;
        self.month = self.maxDate / 100 % 100;
        self.day = self.maxDate % 100;
        beyond = YES;
    }
    
    // 检测每月天数改变
    if (monthDayMayChange) {
        NSInteger day = [self.pickerView selectedRowInComponent:4] % self.monthDayCount + 1;
        NSInteger daysInMonth = [self daysCountInCurrentMonth];
        if (daysInMonth != self.monthDayCount) {
            [self.pickerView selectRow:day-1 + daysInMonth * kDatePickerCentreRow inComponent:4 animated:NO]; // 按新的每月天数设置日的行号
        }
        if (day > daysInMonth) {
            self.day = daysInMonth;
            [self.pickerView selectRow:self.day-1 + daysInMonth * kDatePickerCentreRow inComponent:4 animated:YES];
        }
        self.monthDayCount = daysInMonth;
    }
    
    // 超限回滚
    if (beyond) {
        [self.pickerView selectRow:self.year inComponent:0 animated:YES];
        [self.pickerView selectRow:self.month-1 + 12*kDatePickerCentreRow inComponent:2 animated:YES];
        [self.pickerView selectRow:self.day-1 + self.monthDayCount*kDatePickerCentreRow inComponent:4 animated:YES];
    }
}

- (void)setupYMSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // 获取最新值，及滚动复位
    if (component == 0) {
        self.year = row;
    }
    if (component == 2) {
        self.month = row % 12 + 1;
        [self.pickerView selectRow:self.month-1 + kDatePickerCentreRow*12 inComponent:2 animated:NO];
    }
    
    // 超限检查
    BOOL beyond = NO;
    NSInteger newDate = [self currentDateIntegerWithRow:row inComponent:component];
    NSInteger minDate = self.minDate / 100 * 100;
    NSInteger maxDate = self.maxDate / 100 * 100;
    if (newDate < minDate) {
        self.year = self.minDate / 10000;
        self.month = self.minDate / 100 % 100;
        beyond = YES;
    } else if (newDate > maxDate) {
        self.year = self.maxDate / 10000;
        self.month = self.maxDate / 100 % 100;
        beyond = YES;
    }
    
    // 超限回滚
    if (beyond) {
        [self.pickerView selectRow:self.year inComponent:0 animated:YES];
        [self.pickerView selectRow:self.month-1 + 12*kDatePickerCentreRow inComponent:2 animated:YES];
    }
}

- (void)setupMDSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // 获取最新值，及滚动复位
    BOOL monthDayMayChange = NO;
    if (component == 0) {
        self.month = row % 12 + 1;
        [self.pickerView selectRow:self.month-1 + kDatePickerCentreRow*12 inComponent:0 animated:NO];
        monthDayMayChange = YES;
    }
    if (component == 2) {
        self.day = row % self.monthDayCount + 1;
        [self.pickerView selectRow:self.day-1 + self.monthDayCount * kDatePickerCentreRow inComponent:2 animated:NO];
    }
    
    // 检测每月天数改变
    if (monthDayMayChange) {
        NSInteger day = [self.pickerView selectedRowInComponent:2] % self.monthDayCount + 1;
        NSInteger daysInMonth = [self daysCountInCurrentMonth];
        if (daysInMonth != self.monthDayCount) {
            [self.pickerView selectRow:day-1 + daysInMonth * kDatePickerCentreRow inComponent:2 animated:NO]; // 按新的每月天数设置日的行号
        }
        if (day > daysInMonth) {
            self.day = daysInMonth;
            [self.pickerView selectRow:self.day-1 + daysInMonth * kDatePickerCentreRow inComponent:2 animated:YES];
        }
        self.monthDayCount = daysInMonth;
    }
}

- (void)whenSelectChange {
    dispatch_async(dispatch_get_main_queue(), ^{
        _selectedDate = self.dateMode==DRDatePickerModeMD?nil:[self currentDateWithDay:self.day];
        kDR_SAFE_BLOCK(self.onSelectChangeBlock, _selectedDate, self.month, self.day);
    });
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
    _dateMode = DRDatePickerModeYMD;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        picker.delegate = self;
        picker.dataSource = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadAllComponents];
        });
        [DRUIWidgetUtil hideSeparateLineForPickerView:self.pickerView];
    });
}

- (void)dealloc {
    kDR_LOG(@"%@ dealloc", NSStringFromClass([self class]));
}

#pragma mark - lazy load
- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _calendar;
}

@end
