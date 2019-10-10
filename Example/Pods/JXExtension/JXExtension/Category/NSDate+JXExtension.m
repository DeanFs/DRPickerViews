//
//  NSDate+JXExtension.m
//  JXExtension
//
//  Created by Jeason Lee on 2019/8/12.
//  Copyright © 2019 Jeason.Lee. All rights reserved.
//

#import "NSDate+JXExtension.h"

@implementation NSDate (JXExtension)

//日期相等
- (BOOL)jx_dateEqualTo:(NSDate *)date {
    return [self timeIntervalSinceDate:date] == 0;
}

//大于传参日期
- (BOOL)jx_dateGreaterThan:(NSDate *)date {
    return [self timeIntervalSinceDate:date] > 0;
}

//大于等于传参日期
- (BOOL)jx_dateGreaterThanOrEqualTo:(NSDate *)date {
    return [self timeIntervalSinceDate:date] >= 0;
}

//小于传参日期
- (BOOL)jx_dateLessThan:(NSDate *)date {
    return [self timeIntervalSinceDate:date] < 0;
}

//小于等于传参日期
- (BOOL)jx_dateLessThanOrEqualTo:(NSDate *)date {
    return [self timeIntervalSinceDate:date] <= 0;
}

/**
 *  NSDate转字符串
 *  将0时区的NSDate 转成 8时区的时间文本
 */
- (NSString *)jx_dateStringFromFormatterString:(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    formatter.dateFormat = string;
    NSString *dateString = [formatter stringFromDate:self];
    return dateString;
}

//字符串转NSDate
+ (NSDate *)jx_dateWithString:(NSString *)string {
    return [self jx_dateWithString:string dateFormat:@"yyyy-MM-dd"];
}

/**
 *  字符串转NSDate
 *  将8时区的时间文本 转成 0时区的NSDate
 */
+ (NSDate *)jx_dateWithString:(NSString *)string dateFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:dateFormat];
    return [formatter dateFromString:string];
}

//时间戳转字符串
+ (NSString *)jx_dateWithTimeInterval:(NSTimeInterval)timeInterval dateFormat:(NSString *)dateFormat {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [date jx_dateStringFromFormatterString:dateFormat];
}

@end
