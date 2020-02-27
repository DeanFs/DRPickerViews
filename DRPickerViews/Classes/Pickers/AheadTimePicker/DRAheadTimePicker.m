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
#import <DRUIWidgetKit/DRNormalDataPickerView.h>
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
    self.pickerView.currentSelectedStrings = @[@"提前", @"0", @"小时", @"30", @"分钟"];
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

#pragma mark - lazy load
- (NSDictionary *)hourMinuteMap {
    if (!_hourMinuteMap) {
        DRPickerRemindAheadOption *option = (DRPickerRemindAheadOption *)self.pickerOption;
        NSInteger timeScale = option.timeScale;
        NSMutableArray *mins = [NSMutableArray array];
        NSInteger min = ceil(1.0 * option.minAheadTime / timeScale);
        for (NSInteger i=min; i<(60 / timeScale); i++) {
            [mins addObject:@(i * timeScale).stringValue];
        }
        _hourMinuteMap = @{
            @"0": mins,
            @"1": @[@"0", @"30"],
            @"2": @[@"0", @"30"],
            @"3": @[@"0", @"30"],
            @"4": @[@"0", @"30"],
            @"5": @[@"0", @"30"],
            @"6": @[@"0", @"30"],
            @"12": @[@"0"],
            @"24": @[@"0"],
            @"48": @[@"0"]
        };
    }
    return _hourMinuteMap;
}

- (NSArray *)hours {
    if (!_hours) {
        _hours = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"12", @"24", @"48"];
    }
    return _hours;
}

- (NSArray *)minutes {
    return self.hourMinuteMap[@(self.hour).stringValue];
}

@end
