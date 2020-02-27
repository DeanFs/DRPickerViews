//
//  DRTimeConsumingPicker.m
//  AFNetworking
//
//  Created by 冯生伟 on 2019/4/26.
//

#import "DRTimeConsumingPicker.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import <DRUIWidgetKit/DRUIWidgetUtil.h>
#import <DRUIWidgetKit/DRNormalDataPickerView.h>
#import <DRCategories/NSArray+DRExtension.h>

@interface DRTimeConsumingPicker ()

@property (weak, nonatomic) IBOutlet DRNormalDataPickerView *pickerView;

@property (nonatomic, assign) NSInteger sectionCount;
@property (assign, nonatomic) NSInteger minDay;
@property (assign, nonatomic) NSInteger maxDay;
@property (assign, nonatomic) NSInteger minHour;
@property (assign, nonatomic) NSInteger maxHour;
@property (assign, nonatomic) NSInteger minMinute;
@property (assign, nonatomic) NSInteger maxMinute;

@end

@implementation DRTimeConsumingPicker

- (void)prepareToShow {
    DRPickerTimeConsumingOption *option = (DRPickerTimeConsumingOption *)self.pickerOption;
    [self setupDataWithOption:option];
    
    kDRWeakSelf
    self.pickerView.getFontForSectionWithBlock = ^UIFont *(NSInteger section, NSInteger row) {
        if (section % 2 == 0) {
            return [UIFont systemFontOfSize:26];
        }
        return [UIFont systemFontOfSize:15];
    };
    self.pickerView.getWidthForSectionWithBlock = ^CGFloat(NSInteger section) {
        if (section % 2 == 0) {
            if (weakSelf.sectionCount == 2) {
                return 100;
            }
            if (weakSelf.sectionCount == 4) {
                return 40;
            }
            return 35;
        }
        return 32;
    };
    self.pickerView.getSeparateTextBeforeSectionBlock = ^NSString *(NSInteger section) {
        return @"";
    };
    self.pickerView.getTextAlignmentForSectionBlock = ^NSTextAlignment(NSInteger section) {
        return NSTextAlignmentCenter;
    };
    self.pickerView.onSelectedChangeBlock = ^(NSInteger section, NSInteger index, NSString *selectedString) {
        if (section % 2 == 0 && section != weakSelf.sectionCount - 2 && weakSelf.sectionCount > 2) {
            [weakSelf reloadData];
            [weakSelf.pickerView reloadData];
        }
    };
}

// 解析配置，设置返显
- (void)setupDataWithOption:(DRPickerTimeConsumingOption *)option {
    // 最小时长解析
    int64_t minTimeConsume = option.minTimeConsume;
    if (minTimeConsume >= 1440) {
        _minDay = (NSInteger)(minTimeConsume / 1440);
        minTimeConsume %= 1440;
    }
    if (minTimeConsume >= 60) {
        _minHour = (NSInteger)(minTimeConsume / 60);
        minTimeConsume %= 60;
    }
    _minMinute = (NSInteger)minTimeConsume;
    
    // 最大时长解析
    int64_t maxTimeConsume = option.maxTimeConsume;
    if (maxTimeConsume >= 1440) {
        _sectionCount = 6;
        _maxDay = (NSInteger)(maxTimeConsume / 1440);
        maxTimeConsume %= 1440;
        _maxHour = (NSInteger)(maxTimeConsume / 60);
        maxTimeConsume %= 60;
        _maxMinute = (NSInteger)maxTimeConsume;
    } else if (maxTimeConsume >= 60) {
        _sectionCount = 4;
        _maxHour = (NSInteger)(maxTimeConsume / 60);
        maxTimeConsume %= 60;
        _maxMinute = (NSInteger)maxTimeConsume;
    } else {
        _sectionCount = 2;
        _maxMinute = (NSInteger)maxTimeConsume;
    }
    
    NSInteger day = self.minDay;
    NSInteger hour = self.minHour;
    NSInteger minute = self.minMinute;
    int64_t timeConsume = option.timeConsuming / 60;
    if (timeConsume == 0 || timeConsume > maxTimeConsume || timeConsume < minTimeConsume) {
        timeConsume = minTimeConsume;
    } else {
        if (timeConsume >= 1440) {
            day = (NSInteger)(timeConsume / 1440);
            timeConsume = timeConsume % 1440;
        }
        if (timeConsume >= 60) {
            hour = (NSInteger)(timeConsume / 60);
            timeConsume = timeConsume % 60;
        }
        minute = (NSInteger)timeConsume;
    }
    
    if (self.sectionCount == 2) {
        self.pickerView.currentSelectedStrings = @[@(minute).stringValue, @"分钟"];
    } else if (self.sectionCount == 4) {
        self.pickerView.currentSelectedStrings = @[@(hour).stringValue, @"小时", @(minute).stringValue, @"分钟"];
    } else {
        self.pickerView.currentSelectedStrings = @[@(day).stringValue, @"天", @(hour).stringValue, @"小时", @(minute).stringValue, @"分钟"];
    }
    
    [self reloadData];
}

// 设置数据源
- (void)reloadData {
    NSInteger timeScale = ((DRPickerTimeConsumingOption *)self.pickerOption).timeScale;
    if (self.sectionCount == 2) {
        NSMutableArray *minutes = [NSMutableArray array];
        NSInteger i = ceil(1.0 * self.minMinute / timeScale);
        for (; i<=self.maxMinute/timeScale; i++) {
            [minutes addObject:@(i*timeScale).stringValue];
        }
        self.pickerView.dataSource = @[minutes, @[@"分钟"]];
    } else if (self.sectionCount == 4) {
        NSInteger hour = [self.pickerView.currentSelectedStrings.firstObject integerValue];
        NSMutableArray *hours = [NSMutableArray array];
        for (NSInteger i=self.minHour; i<=self.maxHour; i++) {
            [hours addObject:@(i).stringValue];
        }
        NSMutableArray *minutes = [NSMutableArray array];
        if (hour == self.minHour) {
            NSInteger min = ceil(1.0 * self.minMinute / timeScale);
            for (NSInteger i=min; i<60/timeScale; i++) {
                [minutes addObject:@(i*timeScale).stringValue];
            }
        } else if (hour == self.maxHour) {
            NSInteger max = floor(1.0 * self.maxMinute / timeScale);
            for (NSInteger i=0; i<=max; i++) {
                [minutes addObject:@(i*timeScale).stringValue];
            }
        } else {
            for (NSInteger i=0; i<60/timeScale; i++) {
                [minutes addObject:@(i*timeScale).stringValue];
            }
        }
        self.pickerView.dataSource = @[hours, @[@"小时"], minutes, @[@"分钟"]];
    } else {
        NSInteger day = [self.pickerView.currentSelectedStrings.firstObject integerValue];
        NSInteger hour = [self.pickerView.currentSelectedStrings[2] integerValue];
        NSMutableArray *days = [NSMutableArray array];
        for (NSInteger i=self.minDay; i<=self.maxDay; i++) {
            [days addObject:@(i).stringValue];
        }
        NSMutableArray *hours = [NSMutableArray array];
        if (day == self.minDay) {
            for (NSInteger i=self.minHour; i<24; i++) {
                [hours addObject:@(i).stringValue];
            }
            if (hour < self.minHour) {
                hour = self.minHour;
            }
        } else if (day == self.maxDay) {
            for (NSInteger i=0; i<= self.maxHour; i++) {
                [hours addObject:@(i).stringValue];
            }
            if (hour > self.maxHour) {
                hour = self.maxHour;
            }
        } else {
            for (NSInteger i=0; i<24; i++) {
                [hours addObject:@(i).stringValue];
            }
        }
        NSMutableArray *minutes = [NSMutableArray array];
        if (day == self.minDay && hour == self.minHour) {
            NSInteger min = ceil(1.0 * self.minMinute / timeScale);
            for (NSInteger i=min; i<60/timeScale; i++) {
                [minutes addObject:@(i*timeScale).stringValue];
            }
        } else if (day == self.maxDay && hour == self.maxHour) {
            NSInteger max = floor(1.0 * self.maxMinute / timeScale);
            for (NSInteger i=0; i<=max; i++) {
                [minutes addObject:@(i*timeScale).stringValue];
            }
        } else {
            for (NSInteger i=0; i<60/timeScale; i++) {
                [minutes addObject:@(i*timeScale).stringValue];
            }
        }
        self.pickerView.dataSource = @[days, @[@"天"], hours, @[@"小时"], minutes, @[@"分钟"]];
    }
}

- (Class)pickerOptionClass {
    return [DRPickerTimeConsumingOption class];
}

#pragma mark - actions
- (id)pickedObject {
    NSInteger day = 0;
    NSInteger hour = 0;
    NSInteger minute = 0;
    if (self.sectionCount == 2) {
        minute = [self.pickerView.currentSelectedStrings.firstObject integerValue];
    } else if (self.sectionCount == 4) {
        hour = [self.pickerView.currentSelectedStrings.firstObject integerValue];
        minute = [[self.pickerView.currentSelectedStrings safeGetObjectWithIndex:2] integerValue];
    } else {
        day = [self.pickerView.currentSelectedStrings.firstObject integerValue];
        hour = [[self.pickerView.currentSelectedStrings safeGetObjectWithIndex:2] integerValue];
        minute = [[self.pickerView.currentSelectedStrings safeGetObjectWithIndex:4] integerValue];
    }

    NSMutableString *timeString = [NSMutableString string];
    if (day > 0) {
        [timeString appendFormat:@"%ld天", day];
    }
    if (hour > 0) {
        [timeString appendFormat:@"%ld小时", hour];
    }
    if (minute > 0) {
        [timeString appendFormat:@"%ld分钟", minute];
    }
    if (timeString.length == 0) {
        [timeString appendFormat:@"0分钟"];
    }
    int64_t duration = day * 86400 + hour * 3600 + minute * 60;

    DRPickerTimeConsumingPickedObj *obj = [DRPickerTimeConsumingPickedObj objWithTimeConsuming:duration
                                                                                      timeDesc:timeString];
    obj.day = day;
    obj.hour = hour;
    obj.minute = minute;
    return obj;
}

@end
