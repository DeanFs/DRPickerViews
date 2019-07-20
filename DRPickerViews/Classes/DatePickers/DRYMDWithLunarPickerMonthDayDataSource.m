//
//  DRYMDWithLunarPickerMonthDayDataSource.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/19.
//

#import "DRYMDWithLunarPickerMonthDayDataSource.h"
#import "FBLFunctional.h"
#import "NSDate+DRExtension.h"
#import "NSDictionary+DRExtension.h"
#import <MJExtension/MJExtension.h>
#import <DRSandboxManager/DRSandboxManager.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <SSZipArchive/SSZipArchive.h>

@implementation DRYMDWithLunarPickerMonthDayDataSource

- (NSDate *)date {return nil;}
- (void)resetIndexfromSolarDate:(NSDate *)date {}
- (NSInteger)column { return 2; }
- (void)safeCheck {}
- (BOOL)ignoreYear {return true;}
- (NSInteger)rowForComponent:(NSInteger)component {return 0;}
- (NSString *)titleForComponent:(NSInteger)component row:(NSInteger)row {return nil;}

@end


@implementation DRYMDWithLunarPickerSolarDataSource

- (void)safeCheck {
    if(self.monthIndex >= [self rowForComponent:0] || self.monthIndex < 0) {
        self.monthIndex = [self rowForComponent:0] - 1;
    }
    
    if(self.dayIndex >= [self rowForComponent:1] || self.dayIndex < 0) {
        self.dayIndex = [self rowForComponent:1] - 1;
    }
}

- (NSInteger)rowForComponent:(NSInteger)component {
    if(component == 0) {
        return 12;
    }else {
        if(self.monthIndex == 1) {
            return 29;
        }else if(self.monthIndex == 3
                 || self.monthIndex == 5
                 || self.monthIndex == 8
                 || self.monthIndex == 10) {
            return 30;
        }
        
        return 31;
    }
}

- (NSString *)titleForComponent:(NSInteger)component row:(NSInteger)row {
    if(component == 0) {
        return @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"][row];
    }else {
        return @[@"1日", @"2日",@"3日",@"4日",@"5日",@"6日",@"7日",@"8日",@"9日",@"10日",
                 @"11日", @"12日",@"13日",@"14日",@"15日",@"16日",@"17日",@"18日",@"19日",@"20日",
                 @"21日", @"22日",@"23日",@"24日",@"25日",@"26日",@"27日",@"28日",@"29日",@"30日",@"31日"][row];
    }
}

@end


@implementation DRYMDWithLunarPickerLunarDataSource

- (void)safeCheck {
    if(self.monthIndex >= [self rowForComponent:0] || self.monthIndex < 0) {
        self.monthIndex = [self rowForComponent:0] - 1;
    }
    
    if(self.dayIndex >= [self rowForComponent:1] || self.dayIndex < 0) {
        self.dayIndex = [self rowForComponent:1] - 1;
    }
}

- (NSInteger)rowForComponent:(NSInteger)component {
    if(component == 0) {
        return 12;
    }else {
        return 30;
    }
}

- (NSString *)titleForComponent:(NSInteger)component row:(NSInteger)row {
    if(component == 0) {
        return @[@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"冬月",@"腊月"][row];
    }else {
        return @[@"初一", @"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十"][row];
    }
}

@end


@implementation  DRYMDWithLunarPickerCanlendarSolarDataSource

@synthesize yearIndex = __yearIndex;
@synthesize monthIndex = __monthIndex;
@synthesize minDate = __minDate;
@synthesize maxDate = __maxDate;

- (NSDate *)date {return self.dayArray[self.dayIndex];}

- (NSInteger)column { return 3; }

- (BOOL)ignoreYear {
    return false;
}

- (void)setMinDate:(NSDate *)minDate {
    NSInteger myear = minDate.year;
    __minDate = minDate;
    self.yearArray = [self.yearArray fbl_filter:^BOOL(NSNumber *value) {
        return value.integerValue >= myear;
    }];
}

- (void)setMaxDate:(NSDate *)maxDate {
    NSInteger myear = maxDate.year;
    __maxDate = maxDate;
    
    self.yearArray = [self.yearArray fbl_filter:^BOOL(NSNumber *value) {
        return value.integerValue <= myear;
    }];
}

- (void)safeCheck {
    if(self.monthIndex >= self.monthArray.count || self.monthIndex < 0) {
        if(self.monthArray.count == 0) {
            if(self.maxDate) {
                self.monthArray = @[self.maxDate];
            }else {
                self.monthArray = @[[NSDate date]];
            }
            
            self.monthIndex = 0;
        }else {
            self.monthIndex = self.monthArray.count - 1;
        }
    }
    
    if(self.dayIndex >= self.dayArray.count || self.dayIndex < 0) {
        if(self.dayArray.count == 0) {
            if(self.maxDate) {
                self.dayArray = @[self.maxDate];
            }else {
                self.dayArray = @[[NSDate date]];
            }
            
            self.dayIndex = 0;
        }else {
            self.dayIndex = self.dayArray.count - 1;
        }
    }
}

- (void)setMonthArray:(NSArray<NSDate *> *)monthArray {
    if(self.minDate || self.maxDate) {
        monthArray = [monthArray fbl_filter:^BOOL(NSDate *value) {
            if(self.minDate && [self.minDate earlierDate:value] == value && ![self.maxDate dateEqualTo:value]) {
                return false;
            }
            
            if(self.maxDate && [self.maxDate laterDate:value] == value && ![self.maxDate dateEqualTo:value]) {
                return false;
            }
            
            return true;
        }];
    }
    
    _monthArray = monthArray;
}

- (void)setDayArray:(NSArray<NSDate *> *)dayArray {
    if(self.minDate || self.maxDate) {
        dayArray = [dayArray fbl_filter:^BOOL(NSDate *value) {
            if(self.minDate && [self.minDate earlierDate:value] == value && ![self.minDate dateEqualTo:value]) {
                return false;
            }
            
            if(self.maxDate && [self.maxDate laterDate:value] == value && ![self.maxDate dateEqualTo:value]) {
                return false;
            }
            
            return true;
        }];
    }
    
    _dayArray = dayArray;
}

- (void)resetIndexfromSolarDate:(NSDate *)date {
    NSInteger yearRow = [self.yearArray indexOfObject:@(self.ignoreYear ? [NSDate date].year : date.year)];
    self.yearIndex = yearRow;
    self.monthIndex = date.month - 1;
    self.dayIndex = date.day - 1;
    
    [self safeCheck];
}

- (NSInteger)rowForComponent:(NSInteger)component {
    if(component == 0) {
        return self.yearArray.count;
    }else if(component == 1) {
        return self.monthArray.count;
    }else {
        return self.dayArray.count;
    }
}

- (NSString *)titleForComponent:(NSInteger)component row:(NSInteger)row {
    if (component == 0) {
        return [NSString stringWithFormat:@"%@年", self.yearArray[row]];
    } else if (component == 1) {
        return [NSString stringWithFormat:@"%@月",  @(self.monthArray[row].month)];
    } else {
        return [NSString stringWithFormat:@"%@日", @(self.dayArray[row].day)];
    }
}

- (NSDictionary<NSString *,NSArray *> *)lunarDictionary {
    if (!_lunarDictionary) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[[self calendarLunarJson] mj_JSONObject]];
        for (NSString *key in dictionary.allKeys) {
            NSArray *dateArray = [dictionary[key] fbl_map:^id _Nullable(NSArray *array) {
                return array;
            }];
            [dictionary safeSetObject:dateArray forKey:key];
        }
        _lunarDictionary = dictionary.copy;
    }
    return _lunarDictionary;
}

- (NSArray<NSNumber *> *)yearArray {
    if (!_yearArray) {
        NSMutableArray *array = [NSMutableArray array];
        NSInteger year = 2099;
        
        for (NSInteger i = 1918; i <= year; i++) {
            [array addObject:@(i)];
        }
        
        _yearArray = array;
    }
    
    return _yearArray;
}

- (void)setYearIndex:(NSInteger)yearIndex {
    if(yearIndex < 0 || yearIndex > self.yearArray.count) {
        yearIndex = self.yearArray.count - 1;
    }
    
    if(__yearIndex != yearIndex || self.monthArray == nil) {
        __yearIndex = yearIndex;
        
        self.monthArray = [NSDate monthDateArrayInYear:[self.yearArray[__yearIndex] integerValue]];
        [self safeCheck];
        
        self.monthIndex = self.monthIndex;
        [self safeCheck];
    }
}

- (void)setMonthIndex:(NSInteger)monthIndex {
    if(monthIndex < 0) {
        monthIndex = 0;
    }
    
    __monthIndex = monthIndex;
    
    NSDate *date = self.monthArray[__monthIndex];
    self.dayArray = [date dayDateArrayInCurrentMonth];
    [self safeCheck];
}

#pragma mark - 日历json文件读取操作
+ (void)load {
    [self unzipCanlendarData];
}

+ (NSString *)baseCalendarPath {
    __block NSString *baseCalendarPath;
    [DRSandBoxManager getDirectoryInDocumentWithName:@"DRBasicKit/CalendarData" doneBlock:^(BOOL success, NSError * _Nonnull error, NSString * _Nonnull dirPath) {
        if (!error) {
            baseCalendarPath = dirPath;
        }
    }];
    return baseCalendarPath;
}

+ (NSString *)calendarLunarDataPath {
    return [[[DRYMDWithLunarPickerCanlendarSolarDataSource baseCalendarPath] stringByAppendingPathComponent:@"calendar_lunar"] stringByAppendingPathExtension:@"json"];
}

+ (void)unzipCanlendarData {
    if ([DRSandBoxManager isExistsFileAtPath:[DRYMDWithLunarPickerCanlendarSolarDataSource calendarLunarDataPath]]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *tempPath = [KDR_CURRENT_BUNDLE pathForResource:@"calendar_data" ofType:@"zip"];
        [SSZipArchive unzipFileAtPath:tempPath toDestination:[DRYMDWithLunarPickerCanlendarSolarDataSource baseCalendarPath]];
    });
}

- (NSString *)calendarLunarJson {
    NSString *lunarJsonPath = [DRYMDWithLunarPickerCanlendarSolarDataSource calendarLunarDataPath];
    return [NSString stringWithContentsOfFile:lunarJsonPath encoding:NSUTF8StringEncoding error:nil];
}

@end


@implementation  DRYMDWithLunarPickerCanlendarLunarDataSource

@synthesize yearIndex = ___yearIndex;
@synthesize monthIndex = ___monthIndex;
@synthesize minDate = ___minDate;
@synthesize maxDate = ___maxDate;

- (void)setMinDate:(NSDate *)minDate {
    __block NSInteger myear;
    
    [minDate solarToLunarWithComplelte:^(NSInteger year, NSInteger month, NSInteger day, BOOL leapMonth) {
        myear = year;
    }];
    
    ___minDate = minDate;
    self.yearArray = [self.yearArray fbl_filter:^BOOL(NSNumber *value) {
        return value.integerValue >= myear;
    }];
}

- (void)setMaxDate:(NSDate *)maxDate {
    __block NSInteger myear;
    
    [maxDate solarToLunarWithComplelte:^(NSInteger year, NSInteger month, NSInteger day, BOOL leapMonth) {
        myear = year;
    }];
    
    if(myear < 1918) {
        myear = [NSDate date].year;
    }
    
    ___maxDate = maxDate;
    self.yearArray = [self.yearArray fbl_filter:^BOOL(NSNumber *value) {
        return value.integerValue <= myear;
    }];
}

- (BOOL)isGreaterThanLeapMonth:(NSDate *)date {
    if(date == nil) {
        date = [NSDate date];
    }
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *localeComp = [localeCalendar components:NSCalendarUnitYear fromDate:date];
    NSInteger year = localeComp.year;
    
    while(true) {
        NSDateComponents *localeComp = [localeCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
        
        if(localeComp.year != year) {
            break;
        }
        
        if(localeComp.leapMonth) {
            return true;
        }
        
        date = [date nextDayWithCount:-20];
    }
    
    return false;
}

- (void)solarToLunar:(NSDate *)date
           complelte:(void (^)(NSInteger, NSInteger, NSInteger, BOOL leapMonth))complete {
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    if(complete) {
        complete(localeComp.year, localeComp.month, localeComp.day, localeComp.leapMonth);
    }
}

- (void)resetIndexfromSolarDate:(NSDate *)date {
    NSInteger month = date.month, year = date.year;
    __block NSInteger lYear, lMonth, lDay;
    
    [self solarToLunar:date
             complelte:^(NSInteger lunarYear, NSInteger lunarMonth, NSInteger lunarDay, BOOL leapMonth) {
                 lMonth = lunarMonth;
                 lDay = lunarDay;
             }];
    
    if(month < lMonth) {
        lYear = year - 1;
    }else {
        lYear = year;
    }
    
    NSInteger number = [self isGreaterThanLeapMonth:date] ? lMonth + 1 : lMonth;
    NSInteger yearRow = [self.yearArray indexOfObject:@(lYear)];
    self.yearIndex = yearRow;
    self.monthIndex = number - 1;
    self.dayIndex = lDay - 1;
    
    [self safeCheck];
}

- (void)setYearIndex:(NSInteger)yearIndex {
    if(yearIndex < 0 || yearIndex > self.yearArray.count) {
        yearIndex = self.yearArray.count - 1;
    }
    
    if(___yearIndex != yearIndex || self.monthArray == nil) {
        ___yearIndex = yearIndex;
        
        NSArray *lunarMonthArray = [self.lunarDictionary[self.yearArray[___yearIndex].stringValue] fbl_map:^id _Nullable(NSArray * _Nonnull array) {
            return [NSDate dateWithString:[NSString stringWithFormat:@"%@", array.firstObject]
                               dateFormat:@"yyyyMMdd"];
        }];
        
        self.monthArray = lunarMonthArray;
        [self safeCheck];
        self.monthIndex = self.monthIndex;
        [self safeCheck];
    }
}

- (void)setMonthIndex:(NSInteger)monthIndex {
    ___monthIndex = monthIndex;
    NSDate *date = self.monthArray[___monthIndex];
    
    self.dayArray = [date lunarDayDateArrayInCurrentMonth];
    [self safeCheck];
}

- (NSString *)titleForComponent:(NSInteger)component row:(NSInteger)row {
    if (component == 0) {
        NSNumber *year = self.yearArray[row];
        NSDate *date = [[NSDate dateWithString:[NSString stringWithFormat:@"%@-06-01", year] dateFormat:@"yyyy-MM-dd"] firstLunarDayInThisYear];
        return [NSString stringWithFormat:@"%@(%@)", date.lunarYear, year];
    } else if (component == 1) {
        NSDate *date = self.monthArray[row];
        return date.lunarMonth;
    } else {
        NSDate *date = self.dayArray[row];
        return date.lunarDay;
    }
}

@end
