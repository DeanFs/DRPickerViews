//
//  NSString+JXDecimalCalculate.h
//  JXExtension
//
//  Created by Jeason on 2017/7/7.
//  Copyright © 2017年 Jeason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JXDecimalCalculate)

/**
 加法  被加数 * 加数 = 和
 
 @param addendNumberString 被加数
 @param addNumberString    加数
 
 @return 和
 */
+ (NSString *)jx_decimalAddWithAddendNumberString:(NSString *)addendNumberString addNumberString:(NSString *)addNumberString;
- (NSString *)jx_decimalAddWithAddNumberString:(NSString *)addNumberString;

/**
 减法  被减数 * 减数 = 差
 
 @param minuendNumberString    被减数
 @param subtrahendNumberString 减数
 
 @return 差
 */
+ (NSString *)jx_decimalSubtracteWithMinuendNumberString:(NSString *)minuendNumberString subtrahendNumberString:(NSString *)subtrahendNumberString;
- (NSString *)jx_decimalSubtracteWithSubtrahendNumberString:(NSString *)subtrahendNumberString;

/**
 乘法  被乘数 * 乘数 = 积
 
 @param multiplicandNumberString 被乘数
 @param multiplierNumberString   乘数
 
 @return 积
 */
+ (NSString *)jx_decimalMultiplyWithMultiplicandNumberString:(NSString *)multiplicandNumberString multiplierNumberString:(NSString *)multiplierNumberString;
- (NSString *)jx_decimalMultiplyWithMultiplierNumberString:(NSString *)multiplierNumberString;

/**
 除法  被除数 / 除数 = 商
 
 @param dividendNumberString 被除数
 @param divisorNumberString  除数
 
 @return 商
 */
+ (NSString *)jx_decimalDivideWithDividendNumberString:(NSString *)dividendNumberString divisorNumberString:(NSString *)divisorNumberString;
- (NSString *)jx_decimalDivideWithDivisorNumberString:(NSString *)divisorNumberString;

/**
 比较两个数的大小
 
 @param firstNumberString  第一个数
 @param secondNumberString 第二个数
 
 @return 结果
 */
+ (NSComparisonResult)jx_compareWithFirstNumberString:(NSString *)firstNumberString secondNumberString:(NSString *)secondNumberString;
- (NSComparisonResult)jx_compareToNumberString:(NSString *)numberString;
- (BOOL)jx_lessThanNumberString:(NSString *)numberString;
- (BOOL)jx_lessThanOrEqualToNumberString:(NSString *)numberString;
- (BOOL)jx_greatThanNumberString:(NSString *)numberString;
- (BOOL)jx_greatThanOrEqualToNumberString:(NSString *)numberString;

/**
 金额精度补0设置  比如scale=2, 那么3就会转换为3.00
 注意当前转换是直接失去后面的数据，不是四舍五入
 @param scale 精度
 
 @return 转换后结果
 */
- (NSString *)jx_decimalWithScale:(NSUInteger)scale;

@end
