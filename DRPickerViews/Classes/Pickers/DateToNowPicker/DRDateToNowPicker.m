//
//  DRDateToNowPicker.m
//  DRPickerViews_Example
//
//  Created by 冯生伟 on 2020/2/4.
//  Copyright © 2020 Dean_F. All rights reserved.
//

#import "DRDateToNowPicker.h"
#import <DRUIWidgetKit/DRNormalDataPickerView.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import <DRCategories/UIView+DRExtension.h>
#import <DRCategories/NSArray+DRExtension.h>
#import <DRCategories/NSDate+DRExtension.h>

@interface DRDateToNowPicker ()

@property (weak, nonatomic) IBOutlet DRNormalDataPickerView *pickerView;

@property (strong, nonatomic) NSArray<NSString *> *years;
@property (strong, nonatomic) NSArray<NSString *> *months;
@property (strong, nonatomic) NSArray<NSString *> *days;
@property (assign, nonatomic) NSInteger maxYearIndex;
@property (assign, nonatomic) BOOL isToNow;

@end

@implementation DRDateToNowPicker

- (void)prepareToShow {
    kDRWeakSelf
    DRPickerDateOption *opt = (DRPickerDateOption *)self.pickerOption;
    NSInteger minYear = opt.minDate.year;
    NSInteger maxYear = [NSDate date].year;
    NSMutableArray *years = [NSMutableArray array];
    for (NSInteger i=minYear; i<=maxYear; i++) {
        [years addObject:@(i).stringValue];
    }
    [years addObject:@"至今"];
    self.years = years;
    
    int currentYear = (int)opt.currentDate.year;
    int currentMonth = (int)opt.currentDate.month;
    int currentDay = (int)opt.currentDate.day;
    [self setupDaysWithYear:currentYear month:currentMonth];
    
    self.pickerView.dataSource = @[self.years, self.months, self.days];
    self.pickerView.currentSelectedStrings = @[@(currentYear).stringValue,
                                               [NSString stringWithFormat:@"%02d", currentMonth],
                                               [NSString stringWithFormat:@"%02d", currentDay]];
    self.maxYearIndex = maxYear - minYear + 1;
    
    self.pickerView.getFontForSectionWithBlock = ^UIFont *(NSInteger section, NSInteger row) {
        if (section == 0 && row == weakSelf.maxYearIndex) {
            return [UIFont dr_PingFangSC_RegularWithSize:22];
        }
        return [UIFont dr_PingFangSC_RegularWithSize:26];
    };
    self.pickerView.getWidthForSectionWithBlock = ^CGFloat(NSInteger section) {
        CGFloat wholeWidth = kDRScreenWidth - 2*[weakSelf horizontalPadding];
        CGFloat colunmWith = (wholeWidth - 95) / 3;
        if (section == 0) { // 年
            return colunmWith + 30;
        }
        return colunmWith;
    };
    self.pickerView.getSeparateTextBeforeSectionBlock = ^NSString *(NSInteger section) {
        if ([weakSelf.pickerView.currentSelectedStrings.firstObject isEqualToString:@"至今"]) {
            return @"";
        }
        return @"/";
    };
    self.pickerView.getTextAlignmentForSectionBlock = ^NSTextAlignment(NSInteger section) {
        return NSTextAlignmentCenter;
    };
    self.pickerView.onSelectedChangeBlock = ^(NSInteger section, NSInteger index, NSString *selectedString) {
        if (section < 2) {
            if (section == 0) {
                if (index == weakSelf.maxYearIndex) {
                    weakSelf.pickerView.dataSource = @[weakSelf.years, @[], @[]];
                    [weakSelf.pickerView reloadData];
                    weakSelf.isToNow = YES;
                    return;
                } else {
                    weakSelf.isToNow = NO;
                }
            }
            if (!weakSelf.isToNow) {
                [weakSelf setupDaysWithYear:weakSelf.pickerView.currentSelectedStrings[0].intValue
                                      month:weakSelf.pickerView.currentSelectedStrings[1].intValue];
                weakSelf.pickerView.dataSource = @[weakSelf.years, weakSelf.months, weakSelf.days];
                [weakSelf.pickerView reloadData];
            }
        }
    };
}

- (id)pickedObject {
    if ([self.pickerView.currentSelectedStrings.firstObject isEqualToString:@"至今"]) {
        return [NSDate date].midnight;
    }
    return [NSDate correctionYear:self.pickerView.currentSelectedStrings[0].integerValue
                            month:self.pickerView.currentSelectedStrings[1].integerValue
                              day:self.pickerView.currentSelectedStrings[2].integerValue
                             hour:0
                           minute:0
                           second:0];
}

- (Class)pickerOptionClass {
    return [DRPickerDateOption class];
}

- (void)setupDaysWithYear:(int)year month:(int)month {
    int monthCount = 12;
    NSDate *today = [NSDate date];
    if (year == today.year) {
        monthCount = (int)today.month;
        if (month > monthCount) {
            month = monthCount;
        }
    }
    NSMutableArray *months = [NSMutableArray array];
    for (int i=1; i<=monthCount; i++) {
        [months addObject:[NSString stringWithFormat:@"%02d", i]];
    }
    self.months = months;
    
    NSDate *date = [NSDate correctionYear:year month:month day:1 hour:0 minute:0 second:0];
    NSMutableArray *days = [NSMutableArray array];
    NSInteger dayCount;
    if ([date isEqualMonthToDate:[NSDate date]]) {
        dayCount = [NSDate date].day;
    } else {
        dayCount = [date totalDaysInMonth];
    }
    for (int i=1; i<=dayCount; i++) {
        [days addObject:[NSString stringWithFormat:@"%02d", i]];
    }
    self.days = days;
}

@end
