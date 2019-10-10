//
//  DRWeekPickerView.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/5.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRWeekPickerView.h"
#import <Masonry/Masonry.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIView+DRExtension.h>
#import <DRCategories/NSDate+DRExtension.h>
#import "DRUIWidgetUtil.h"
#import "DRWeekPickerCell.h"

#define kRowCount 20001  // 能跨两百多年
#define kCenterRow 10000
#define kFirstLoadCount 100

@interface DRWeekPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *yearMonthLabel;
@property (weak, nonatomic) IBOutlet UIStackView *weekTitleContanerView;
@property (weak, nonatomic) UIPickerView *pickerView;

@property (nonatomic, assign) NSInteger minOffset;
@property (nonatomic, assign) NSInteger maxOffset;
@property (nonatomic, assign) NSInteger minSelectableRow;
@property (nonatomic, assign) NSInteger maxSeletableRow;
@property (nonatomic, strong) NSCalendar *solarCalendar;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, DRWeekPickerDateModel *> *weekDataSource;
@property (nonatomic, copy) void (^onSelecteChangeBlock)(NSDate *date);

@end

@implementation DRWeekPickerView

- (void)setupWithCurrentDate:(NSDate *)currentDate
                     minDate:(NSDate *)minDate
                     maxDate:(NSDate *)maxDate
           selectChangeBlock:(void(^)(NSDate *date))selectChangeBlock {
    [DRUIWidgetUtil dateLegalCheckForCurrentDate:&currentDate minDate:&minDate maxDate:&maxDate];
    self.minOffset = [currentDate numberOfDaysDifferenceWithDate:minDate];
    self.maxOffset = [currentDate numberOfDaysDifferenceWithDate:maxDate];
    [self setupDataSource:currentDate];
    [self.pickerView selectRow:kCenterRow inComponent:0 animated:NO];
    self.yearMonthLabel.text = [currentDate dateStringFromFormatterString:@"yyyy/MM"];
    self.onSelecteChangeBlock = selectChangeBlock;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pickerView setNeedsLayout];
        [self.pickerView reloadAllComponents];
    });
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    [DRUIWidgetUtil hideSeparateLineForPickerView:pickerView];
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return kRowCount;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 34;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    DRWeekPickerCell *cell = (DRWeekPickerCell *)view;
    if (!cell) {
        cell = kDR_LOAD_XIB_NAMED(NSStringFromClass([DRWeekPickerCell class]));
        cell.frame = CGRectMake(0, 0, pickerView.width, 34);
    }
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:component];
    [cell setupWeekCellWithModel:[self weekModelForRow:row] selected:row == selectedRow];
    return cell;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    DRWeekPickerDateModel *model = self.weekDataSource[@(row)];
    if (row < self.minSelectableRow) {
        [pickerView selectRow:self.minSelectableRow inComponent:0 animated:YES];
        model = self.weekDataSource[@(self.minSelectableRow)];
    } else if (row > self.maxSeletableRow) {
        [pickerView selectRow:self.maxSeletableRow inComponent:0 animated:YES];
        model = self.weekDataSource[@(self.maxSeletableRow)];
    }
    self.yearMonthLabel.text = [model.month dateStringFromFormatterString:@"yyyy/MM"];
    _selectedDate = model.firstDateInWeek;
    kDR_SAFE_BLOCK(self.onSelecteChangeBlock, model.firstDateInWeek);
    [pickerView reloadAllComponents];
}

#pragma mark - private
- (void)setupDataSource:(NSDate *)currentDate {
    NSDate *firstDateInWeek = currentDate.firstDayInThisWeek;
    NSInteger day = [self dayForDate:firstDateInWeek];
    NSInteger dayOffset = [currentDate numberOfDaysDifferenceWithDate:firstDateInWeek];
    DRWeekPickerDateModel *model = [DRWeekPickerDateModel new];
    if (day < 23) {
        for (NSInteger i=0; i<7; i++) {
            [model.daysList addObject:[NSString stringWithFormat:@"%02ld", day+i]];
        }
        model.lastDateInWeek = [self dateByAddingDays:6 months:0 fromDate:firstDateInWeek];
    } else {
        NSDate *date;
        [model.daysList addObject:[NSString stringWithFormat:@"%02ld", day]];
        for (NSInteger i=1; i<7; i++) {
            date = [self dateByAddingDays:i months:0 fromDate:firstDateInWeek];
            [model.daysList addObject:[NSString stringWithFormat:@"%02ld", [self dayForDate:date]]];
        }
        model.lastDateInWeek = date;
    }
    model.firstDateInWeek = firstDateInWeek;
    model.month = currentDate;
    model.weekIndexInMonth = (int)[self.solarCalendar component:NSCalendarUnitWeekOfMonth fromDate:currentDate];
    if (model.weekIndexInMonth > 3 && model.daysList.lastObject.integerValue < 7) {
        model.lastWeekInMonth = YES;
    }
    model.dayOffset = dayOffset;
    if (dayOffset <= self.minOffset) {
        model.firstSelectableWeek = YES;
        model.enableIndexFrom = (int)(self.minOffset - dayOffset);
        self.minSelectableRow = kCenterRow;
    }
    if (dayOffset+6 >= self.maxOffset) {
        model.lastSelectableWeek = YES;
        model.enableIndexTo = (int)(6 - (dayOffset-self.maxOffset));
        self.maxSeletableRow = kCenterRow;
    }
    [self.weekDataSource setObject:model forKey:@(kCenterRow)];
    
    for (NSInteger i=1; i< kFirstLoadCount; i++) {
        [self weekModelForRow:kCenterRow-i];
        [self weekModelForRow:kCenterRow+i];
    }
    [self loadMore];
    _selectedDate = model.firstDateInWeek;
}

- (void)loadMore {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger i=kFirstLoadCount; i<kCenterRow; i++) {
            [self weekModelForRow:kCenterRow-i];
            [self weekModelForRow:kCenterRow+i];
        }
    });
}

- (DRWeekPickerDateModel *)weekModelForRow:(NSInteger)row {
    NSNumber *key = @(row);
    DRWeekPickerDateModel *model = self.weekDataSource[key];
    if (!model) {
        if (row < kCenterRow) {
            model = [self previousWeekModelFromRow:row];
            self.weekDataSource[key] = model;
        } else {
            model = [self nextWeekModelFromRow:row];
            self.weekDataSource[key] = model;
        }
    }
    return model;
}

- (DRWeekPickerDateModel *)previousWeekModelFromRow:(NSInteger)row {
    DRWeekPickerDateModel *lastModel = self.weekDataSource[@(row+1)];
    if (!lastModel) {
        return nil;
    }
    NSDate *firstDateInWeek = [self dateByAddingDays:-7 months:0 fromDate:lastModel.firstDateInWeek];
    NSInteger day = lastModel.daysList.firstObject.integerValue-7;
    NSInteger dayOffset = lastModel.dayOffset - 7;
    DRWeekPickerDateModel *model = [DRWeekPickerDateModel new];
    if (day > 0) {
        for (NSInteger i=0; i<7; i++) {
            [model.daysList addObject:[NSString stringWithFormat:@"%02ld", day+i]];
        }
        model.lastDateInWeek = [self dateByAddingDays:6 months:0 fromDate:firstDateInWeek];
    } else {
        NSDate *date;
        [model.daysList addObject:[NSString stringWithFormat:@"%02ld", [self dayForDate:firstDateInWeek]]];
        for (NSInteger i=1; i<7; i++) {
            date = [self dateByAddingDays:i months:0 fromDate:firstDateInWeek];
            [model.daysList addObject:[NSString stringWithFormat:@"%02ld", [self dayForDate:date]]];
        }
        model.lastDateInWeek = date;
    }
    model.firstDateInWeek = firstDateInWeek;
    model.month = lastModel.month;
    if (lastModel.weekIndexInMonth == 1) { // 下一个周是下个月的第一周
        model.month = [self dateByAddingDays:0 months:-1 fromDate:model.month];
    }
    model.dayOffset = dayOffset;
    if (lastModel.disableSelect || lastModel.firstSelectableWeek) {
        model.disableSelect = YES;
    } else {
        if (dayOffset <= self.minOffset) {
            model.firstSelectableWeek = YES;
            model.enableIndexTo = (int)(self.minOffset - dayOffset);
            self.minSelectableRow = row;
        }
    }
    model.weekIndexInMonth = (int)[self.solarCalendar component:NSCalendarUnitWeekOfMonth fromDate:model.lastDateInWeek];
    if (model.weekIndexInMonth == 1) {
        if (model.daysList.firstObject.integerValue > 7) { // 是本月第一个周，且包含上个月日期
            DRWeekPickerDateModel *nexWeekModel = [model copy];
            nexWeekModel.weekIndexInMonth = (int)[self.solarCalendar component:NSCalendarUnitWeekOfMonth fromDate:firstDateInWeek];
            nexWeekModel.month = firstDateInWeek;
            nexWeekModel.lastWeekInMonth = YES;
            if (model.firstSelectableWeek) {
                nexWeekModel.disableSelect = YES;
            }
            self.weekDataSource[@(row-1)] = nexWeekModel;
        }
    }
    return model;
}

- (DRWeekPickerDateModel *)nextWeekModelFromRow:(NSInteger)row {
    DRWeekPickerDateModel *lastModel = self.weekDataSource[@(row-1)];
    if (!lastModel) {
        return nil;
    }
    NSDate *firstDateInWeek = [self dateByAddingDays:1 months:0 fromDate:lastModel.lastDateInWeek];
    NSInteger day = lastModel.daysList.lastObject.integerValue+1;
    NSInteger dayOffset = lastModel.dayOffset + 7;
    DRWeekPickerDateModel *model = [DRWeekPickerDateModel new];
    if (day < 23) {
        for (NSInteger i=0; i<7; i++) {
            [model.daysList addObject:[NSString stringWithFormat:@"%02ld", day+i]];
        }
        model.lastDateInWeek = [self dateByAddingDays:6 months:0 fromDate:firstDateInWeek];
    } else {
        NSDate *date;
        [model.daysList addObject:[NSString stringWithFormat:@"%02ld", [self dayForDate:firstDateInWeek]]];
        for (NSInteger i=1; i<7; i++) {
            date = [self dateByAddingDays:i months:0 fromDate:firstDateInWeek];
            [model.daysList addObject:[NSString stringWithFormat:@"%02ld", [self dayForDate:date]]];
        }
        model.lastDateInWeek = date;
    }
    model.firstDateInWeek = firstDateInWeek;
    model.month = lastModel.month;
    if (model.daysList.firstObject.integerValue == 1) { // 上一周的最后一天，是上个月的最后一天
        model.month = [self dateByAddingDays:0 months:1 fromDate:model.month];
    }
    model.dayOffset = dayOffset;
    if (lastModel.disableSelect || lastModel.lastSelectableWeek) {
        model.disableSelect = YES;
    } else {
        if (dayOffset+6 >= self.maxOffset) {
            model.lastSelectableWeek = YES;
            model.enableIndexTo = (int)(6 - (dayOffset-self.maxOffset));
            self.maxSeletableRow = row;
        }
    }
    model.weekIndexInMonth = (int)[self.solarCalendar component:NSCalendarUnitWeekOfMonth fromDate:firstDateInWeek];
    if (model.weekIndexInMonth > 4) {
        if (model.daysList.lastObject.integerValue < 7) { // 是本月最后一个周，且包含下个月日期
            model.lastWeekInMonth = YES;
            DRWeekPickerDateModel *nexWeekModel = [model copy];
            nexWeekModel.weekIndexInMonth = 1;
            nexWeekModel.month = [self dateByAddingDays:0 months:1 fromDate:model.month];
            if (model.lastSelectableWeek) {
                nexWeekModel.disableSelect = YES;
            }
            self.weekDataSource[@(row+1)] = nexWeekModel;
        }
    }
    return model;
}

- (NSDate *)dateByAddingDays:(NSInteger)days months:(NSInteger)months fromDate:(NSDate *)date {
    NSDateComponents *cmp = [[NSDateComponents alloc] init];
    cmp.day = days;
    cmp.month = months;
    return [self.solarCalendar dateByAddingComponents:cmp toDate:date options:0];
}

- (NSInteger)dayForDate:(NSDate *)date {
    return [self.solarCalendar component:NSCalendarUnitDay fromDate:date];
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
    self.containerView = kDR_LOAD_XIB_NAMED(NSStringFromClass([self class]));
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_offset(0);
    }];
        
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.backgroundColor = [UIColor whiteColor];
    picker.delegate = self;
    picker.dataSource = self;
    [self addSubview:picker];
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(54);
        make.bottom.mas_offset(-10);
        make.left.mas_offset(22);
        make.right.mas_offset(-22);
    }];
    self.pickerView = picker;
    
    self.yearMonthLabel.textColor = [DRUIWidgetUtil descColor];
    for (UILabel *label in self.weekTitleContanerView.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            label.textColor = [DRUIWidgetUtil descColor];
        }
    }
    
    self.minSelectableRow = 0;
    self.maxSeletableRow = kRowCount-1;
}

#pragma mark - lazy load
- (NSCalendar *)solarCalendar {
    if (!_solarCalendar) {
        NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
        _solarCalendar = [NSCalendar currentCalendar];
        [_solarCalendar setTimeZone:timeZone];
        [_solarCalendar setFirstWeekday:2];
    }
    return _solarCalendar;
}

- (NSMutableDictionary<NSNumber *, DRWeekPickerDateModel *> *)weekDataSource {
    if (!_weekDataSource) {
        _weekDataSource = [NSMutableDictionary dictionary];
    }
    return _weekDataSource;
}

@end
