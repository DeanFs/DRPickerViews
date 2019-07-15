//
//  DRYMDWithLunarPickerMonthDayDataSource.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRYMDWithLunarPickerMonthDayDataSource : NSObject

- (NSDate *)date;
- (NSInteger)column;
- (void)safeCheck;
- (BOOL)ignoreYear;

- (void)resetIndexfromSolarDate:(NSDate *)date;
- (NSInteger)rowForComponent:(NSInteger)component;
- (NSString *)titleForComponent:(NSInteger)component row:(NSInteger)row;

@property (nonatomic, assign) NSInteger yearIndex, monthIndex, dayIndex;
@property (nonatomic, strong) NSDate *minDate, *maxDate;

@end


@interface DRYMDWithLunarPickerSolarDataSource : DRYMDWithLunarPickerMonthDayDataSource
@end


@interface DRYMDWithLunarPickerLunarDataSource : DRYMDWithLunarPickerMonthDayDataSource
@end


@interface DRYMDWithLunarPickerCanlendarSolarDataSource : DRYMDWithLunarPickerMonthDayDataSource

@property (nonatomic, strong) NSArray<NSNumber *> *yearArray;
@property (nonatomic, strong) NSArray<NSDate *> *monthArray, *dayArray;
@property (nonatomic, strong) NSDictionary<NSString *,NSArray*> *lunarDictionary;

@end


@interface DRYMDWithLunarPickerCanlendarLunarDataSource : DRYMDWithLunarPickerCanlendarSolarDataSource
@end

NS_ASSUME_NONNULL_END
