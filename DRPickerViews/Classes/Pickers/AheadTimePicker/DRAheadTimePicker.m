//
//  DRAheadTimePicker.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/6.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRAheadTimePicker.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import "DRNormalDataPickerView.h"
#import <DRCategories/NSArray+DRExtension.h>
#import <DRMacroDefines/DRMacroDefines.h>

@interface DRAheadTimePicker ()

@property (weak, nonatomic) IBOutlet DRNormalDataPickerView *pickerView;
@property (strong, nonatomic) NSDateComponents *maxAheadTimeCmp;
@property (strong, nonatomic) NSDateComponents *currentAheadCmp;
@property (strong, nonatomic) NSArray<NSString *> *dayDataSource;
@property (strong, nonatomic) NSArray<NSString *> *fullMinutDataSrouce;
@property (strong, nonatomic) NSArray<NSString *> *fullHourDataSrouce;

@end


@implementation DRAheadTimePicker

- (void)prepareToShow {
    [self setupDatasWithOption:(DRPickerRemindAheadOption *)self.pickerOption];
    
    kDRWeakSelf
    self.pickerView.getFontForSectionWithBlock = ^UIFont *(NSInteger section, NSInteger row) {
        if (section % 2 == 0) {
            if (kDRScreenWidth < 375 && weakSelf.maxAheadTimeCmp.day > 0) {
                return [UIFont dr_PingFangSC_RegularWithSize:13];
            }
            return [UIFont dr_PingFangSC_RegularWithSize:15];
        }
        if (kDRScreenWidth < 375 && weakSelf.maxAheadTimeCmp.day > 0) {
            return [UIFont dr_PingFangSC_RegularWithSize:20];
        }
        return [UIFont dr_PingFangSC_RegularWithSize:26];
    };
    self.pickerView.getWidthForSectionWithBlock = ^CGFloat(NSInteger section) {
        if (section % 2 == 0) {
            if (kDRScreenWidth < 375 && weakSelf.maxAheadTimeCmp.day > 0) {
                return 28;
            }
            return 32;
        }
        if (weakSelf.maxAheadTimeCmp.day == 0 && weakSelf.maxAheadTimeCmp.hour == 0) {
            return 60;
        }
        if (kDRScreenWidth < 375 && weakSelf.maxAheadTimeCmp.day > 0) {
            return 28;
        }
        return 35;
    };
    self.pickerView.getSeparateTextBeforeSectionBlock = ^NSString *(NSInteger section) {
        return @"";
    };
    self.pickerView.getTextAlignmentForSectionBlock = ^NSTextAlignment(NSInteger section) {
        return NSTextAlignmentCenter;
    };
    self.pickerView.onSelectedChangeBlock = ^(NSInteger section, NSInteger index, NSString *selectedString) {
        [weakSelf timeChangeWithSection:section value:selectedString.integerValue];
    };
}

- (id)pickedObject {
    DRPickerRemindAheadPickedObj *obj = [DRPickerRemindAheadPickedObj new];
    if (self.maxAheadTimeCmp.day > 0) {
        obj.day = [(NSString *)[self.pickerView.currentSelectedStrings safeGetObjectWithIndex:1] integerValue];
        obj.hour = [(NSString *)[self.pickerView.currentSelectedStrings safeGetObjectWithIndex:3] integerValue];
        obj.minute = [(NSString *)[self.pickerView.currentSelectedStrings safeGetObjectWithIndex:5] integerValue];
    } else if (self.maxAheadTimeCmp.hour > 0) {
        obj.hour = [(NSString *)[self.pickerView.currentSelectedStrings safeGetObjectWithIndex:1] integerValue];
        obj.minute = [(NSString *)[self.pickerView.currentSelectedStrings safeGetObjectWithIndex:3] integerValue];
    } else {
        obj.minute = [(NSString *)[self.pickerView.currentSelectedStrings safeGetObjectWithIndex:1] integerValue];
    }
    obj.desc = @"";
    obj.minuteValue = 0;
    if (obj.day > 0) {
        obj.desc = [obj.desc stringByAppendingFormat:@"%ld天", obj.day];
        obj.minuteValue += obj.day * 1440;
    }
    if (obj.hour > 0) {
        obj.desc = [obj.desc stringByAppendingFormat:@"%ld小时", obj.hour];
        obj.minuteValue += obj.hour * 60;
    }
    if (obj.minute > 0) {
        obj.desc = [obj.desc stringByAppendingFormat:@"%ld分钟", obj.minute];
        obj.minuteValue += obj.minute;
    }
    return obj;
}

- (Class)pickerOptionClass {
    return [DRPickerRemindAheadOption class];
}

#pragma mark - private
- (void)setupDatasWithOption:(DRPickerRemindAheadOption *)option {
    NSInteger timeScale = option.timeScale;
    NSInteger maxAheadTime = option.maxAheadTime / timeScale * timeScale;
    NSInteger minuteCount = MIN(60, maxAheadTime) / timeScale;
    NSMutableArray *fullMinuteDataSrouce = [NSMutableArray array];
    for (NSInteger i=1; i<=minuteCount; i++) {
        NSInteger minute = i*timeScale;
        if (minute >= 60) {
            break;
        }
        [fullMinuteDataSrouce addObject:@(minute).stringValue];
    }
    self.fullMinutDataSrouce = fullMinuteDataSrouce;
    self.fullHourDataSrouce = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"12"];
    
    self.maxAheadTimeCmp = [NSDateComponents new];
    self.maxAheadTimeCmp.day = maxAheadTime / 1440;
    maxAheadTime %= 1440;
    self.maxAheadTimeCmp.hour = maxAheadTime / 60;
    self.maxAheadTimeCmp.minute = maxAheadTime % 60;
    
    self.currentAheadCmp = [NSDateComponents new];
    if (option.currentAhead >= 0) {
        NSInteger currentAhead = option.currentAhead / timeScale * timeScale;
        self.currentAheadCmp.day = currentAhead / 1440;
        currentAhead %= 1440;
        self.currentAheadCmp.hour = currentAhead / 60;
        self.currentAheadCmp.minute = MIN(currentAhead % 60, option.maxAheadTime / timeScale * timeScale);
    } else {
        self.currentAheadCmp.day = 0;
        self.currentAheadCmp.hour = 0;
        self.currentAheadCmp.minute = MIN(30, option.maxAheadTime / timeScale * timeScale);
    }
    
    if (self.maxAheadTimeCmp.day > 0) {
        self.maxAheadTimeCmp.hour = 0;
        self.maxAheadTimeCmp.minute = 0;
        NSMutableArray *days = [NSMutableArray array];
        self.dayDataSource = days;
        for (NSInteger i=0; i<= self.maxAheadTimeCmp.day; i++) {
            [days addObject:@(i).stringValue];
        }
        self.pickerView.currentSelectedStrings = @[@"提前", @(self.currentAheadCmp.day).stringValue, @"天", @(self.currentAheadCmp.hour).stringValue, @"小时", @(self.currentAheadCmp.minute).stringValue, @"分钟"];
    } else if (self.maxAheadTimeCmp.hour > 0) {
        NSMutableArray *fullHourDataSource = [NSMutableArray array];
        for (NSInteger i=0; i<=self.maxAheadTimeCmp.hour; i++) {
            [fullHourDataSource addObject:@(i).stringValue];
        }
        self.fullHourDataSrouce = fullHourDataSource;
        self.pickerView.currentSelectedStrings = @[@"提前", @(self.currentAheadCmp.hour).stringValue, @"小时", @(self.currentAheadCmp.minute).stringValue, @"分钟"];
    } else {
        self.fullHourDataSrouce = nil;
        self.pickerView.currentSelectedStrings = @[@"提前", @(self.currentAheadCmp.minute).stringValue, @"分钟"];
    }
    [self setupPickerViewDataSource];
}

- (void)timeChangeWithSection:(NSInteger)section value:(NSInteger)value {
    if (self.maxAheadTimeCmp.day > 0) {
        if (section == 1) {
            self.currentAheadCmp.day = value;
            self.currentAheadCmp.hour = 0;
            self.currentAheadCmp.minute = 0;
        } else if (section == 3) {
            self.currentAheadCmp.hour = value;
        } else if (section == 5) {
            return;
        }
    } else if (self.maxAheadTimeCmp.hour > 0) {
        if (section == 1) {
            self.currentAheadCmp.hour = value;
        } else if (section == 3) {
            return;
        }
    } else {
        return;
    }
    [self setupPickerViewDataSource];
    [self.pickerView reloadData];
}

- (void)setupPickerViewDataSource {
    if (self.maxAheadTimeCmp.day > 0) {
        if (self.currentAheadCmp.day > 0) {
            self.pickerView.dataSource = @[@[@"提前"], self.dayDataSource, @[@"天"], @[@"0"], @[@"小时"], @[@"0"], @[@"分钟"]];
        } else {
            if (self.currentAheadCmp.hour > 0) {
                self.pickerView.dataSource = @[@[@"提前"], self.dayDataSource, @[@"天"], self.fullHourDataSrouce, @[@"小时"], @[@"0", @"30"], @[@"分钟"]];
            } else {
                self.pickerView.dataSource = @[@[@"提前"], self.dayDataSource, @[@"天"], self.fullHourDataSrouce, @[@"小时"], self.fullMinutDataSrouce, @[@"分钟"]];
            }
        }
    } else if (self.maxAheadTimeCmp.hour > 0) {
        if (self.currentAheadCmp.hour > 0) {
            if (self.currentAheadCmp.hour == self.maxAheadTimeCmp.hour && self.maxAheadTimeCmp.minute < 30) {
                self.pickerView.dataSource = @[@[@"提前"], self.fullHourDataSrouce, @[@"小时"], @[@"0"], @[@"分钟"]];
            } else {
                self.pickerView.dataSource = @[@[@"提前"], self.fullHourDataSrouce, @[@"小时"], @[@"0", @"30"], @[@"分钟"]];
            }
        } else {
            self.pickerView.dataSource = @[@[@"提前"], self.fullHourDataSrouce, @[@"小时"], self.fullMinutDataSrouce, @[@"分钟"]];
        }
    } else {
        self.pickerView.dataSource = @[@[@"提前"], self.fullMinutDataSrouce, @[@"分钟"]];
    }
}

@end
