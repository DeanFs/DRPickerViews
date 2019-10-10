//
//  NSDate+JXExtension.h
//  JXExtension
//
//  Created by Jeason Lee on 2019/8/12.
//  Copyright © 2019 Jeason.Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (JXExtension)

//日期相等
- (BOOL)jx_dateEqualTo:(NSDate *)date;
//大于传参日期
- (BOOL)jx_dateGreaterThan:(NSDate *)date;
//大于等于传参日期
- (BOOL)jx_dateGreaterThanOrEqualTo:(NSDate *)date;
//小于传参日期
- (BOOL)jx_dateLessThan:(NSDate *)date;
//小于等于传参日期
- (BOOL)jx_dateLessThanOrEqualTo:(NSDate *)date;

//NSDate转字符串
- (NSString *)jx_dateStringFromFormatterString:(NSString *)string;

//字符串转NSDate
+ (NSDate *)jx_dateWithString:(NSString *)string;
+ (NSDate *)jx_dateWithString:(NSString *)string dateFormat:(NSString *)dateFormat;

//时间戳转字符串
+ (NSString *)jx_dateWithTimeInterval:(NSTimeInterval)timeInterval dateFormat:(NSString *)dateFormat;

@end

NS_ASSUME_NONNULL_END
