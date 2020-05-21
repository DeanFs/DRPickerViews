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

@interface DRAheadTimePicker ()

@property (weak, nonatomic) IBOutlet DRNormalDataPickerView *pickerView;

@property (strong, nonatomic) NSArray *hours;
@property (nonatomic, strong) NSArray *minutes;
@property (strong, nonatomic) NSDictionary *hourMinuteMap;
@property (assign, nonatomic) NSInteger hour;

@end


@implementation DRAheadTimePicker

- (void)awakeFromNib {
    [super awakeFromNib];
    self.hour = 0;
}

- (void)prepareToShow {
    NSMutableArray *currentSelected = [NSMutableArray arrayWithArray:@[@"提前", @"0", @"小时", @"30", @"分钟"]];
    DRPickerRemindAheadOption *option = (DRPickerRemindAheadOption *)self.pickerOption;
    if (option.currentAhead > 0) {
        self.hour = option.currentAhead / 60;
        NSInteger minute = option.currentAhead % 60;
        [currentSelected replaceObjectAtIndex:1 withObject:@(self.hour).stringValue];
        [currentSelected replaceObjectAtIndex:3 withObject:@(minute).stringValue];
    }
    self.pickerView.currentSelectedStrings = currentSelected;
    self.pickerView.dataSource = @[@[@"提前"], self.hours, @[@"小时"], self.minutes, @[@"分钟"]];
    
    kDRWeakSelf
    self.pickerView.getFontForSectionWithBlock = ^UIFont *(NSInteger section, NSInteger row) {
        if (section % 2 == 0) {
            return [UIFont systemFontOfSize:15];
        }
        return [UIFont systemFontOfSize:26];
    };
    self.pickerView.getWidthForSectionWithBlock = ^CGFloat(NSInteger section) {
        if (section % 2 == 0) {
            return 32;
        }
        return 40;
    };
    self.pickerView.getSeparateTextBeforeSectionBlock = ^NSString *(NSInteger section) {
        return @"";
    };
    self.pickerView.getTextAlignmentForSectionBlock = ^NSTextAlignment(NSInteger section) {
        return NSTextAlignmentCenter;
    };
    self.pickerView.onSelectedChangeBlock = ^(NSInteger section, NSInteger index, NSString *selectedString) {
        if (section == 1) {
            weakSelf.hour = [selectedString integerValue];
            weakSelf.pickerView.dataSource = @[@[@"提前"], self.hours, @[@"小时"], self.minutes, @[@"分钟"]];
            [weakSelf.pickerView reloadData];
        }
    };
}

- (id)pickedObject {
    NSInteger minute = [(NSString *)[self.pickerView.currentSelectedStrings safeGetObjectWithIndex:3] integerValue];
    return @(self.hour * 60 + minute);
}

- (Class)pickerOptionClass {
    return [DRPickerRemindAheadOption class];
}

- (void)setMinutesList:(NSArray<NSString *> *)minutes forHour:(NSInteger)hour inDictionary:(NSMutableDictionary *)dic {
    if (hour < 7 || hour == 12 || hour == 24 || hour == 48) {
        dic[@(hour).stringValue] = minutes;
    }
}

#pragma mark - lazy load
- (NSDictionary *)hourMinuteMap {
    if (!_hourMinuteMap) {
        DRPickerRemindAheadOption *option = (DRPickerRemindAheadOption *)self.pickerOption;
        NSInteger timeScale = option.timeScale;
        NSMutableArray *mins = [NSMutableArray array];
        NSInteger min = ceil(1.0 * option.minAheadTime / timeScale);
        NSInteger minCount = MIN(60, option.maxAheadTime) / timeScale;
        for (NSInteger i=min; i<minCount; i++) {
            [mins addObject:@(i * timeScale).stringValue];
        }
        NSMutableDictionary *hourMap = [NSMutableDictionary dictionary];
        hourMap[@"0"] = mins;
        NSInteger restMinute = option.maxAheadTime % 60;
        NSInteger maxHour = option.maxAheadTime / 60 + (restMinute > 0);
        for (NSInteger i=1; i<=maxHour; i++) {
            if (i == maxHour && restMinute > 0) {
                if (i < 24 && restMinute >= 30) {
                    [self setMinutesList:@[@"0", @"30"] forHour:i inDictionary:hourMap];
                } else {
                    [self setMinutesList:@[@"0"] forHour:i inDictionary:hourMap];
                }
            } else {
                if (i < 24) {
                    [self setMinutesList:@[@"0", @"30"] forHour:i inDictionary:hourMap];
                } else {
                    [self setMinutesList:@[@"0"] forHour:i inDictionary:hourMap];
                }
            }
        }
        _hourMinuteMap = hourMap;
    }
    return _hourMinuteMap;
}

- (NSArray *)hours {
    if (!_hours) {
        NSMutableArray *hours = [[self.hourMinuteMap allKeys] mutableCopy];
        [hours sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            if (obj1.integerValue > obj2.integerValue) {
                return NSOrderedDescending;
            } else if (obj1.integerValue == obj2.integerValue) {
                return NSOrderedSame;
            }
            return NSOrderedAscending;
        }];
        _hours = hours;
    }
    return _hours;
}

- (NSArray *)minutes {
    return self.hourMinuteMap[@(self.hour).stringValue];
}

@end
