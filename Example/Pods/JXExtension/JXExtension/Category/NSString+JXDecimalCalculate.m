//
//  NSString+JXDecimalCalculate.m
//  JXExtension
//
//  Created by Jeason on 2017/7/7.
//  Copyright © 2017年 Jeason. All rights reserved.
//

#import "NSString+JXDecimalCalculate.h"

@implementation NSString (JXDecimalCalculate)

+ (NSString *)jx_decimalAddWithAddendNumberString:(NSString *)addendNumberString addNumberString:(NSString *)addNumberString {
    NSDecimalNumber *addendNumber = [NSDecimalNumber decimalNumberWithString:[self checkNumberString:addendNumberString]];
    NSDecimalNumber *addNumber = [NSDecimalNumber decimalNumberWithString:[self checkNumberString:addNumberString]];
    NSDecimalNumber *resultDecimalNumber = [addendNumber decimalNumberByAdding:addNumber];
    return [resultDecimalNumber stringValue];
}

- (NSString *)jx_decimalAddWithAddNumberString:(NSString *)addNumberString {
    return [NSString jx_decimalAddWithAddendNumberString:self addNumberString:addNumberString];
}

+ (NSString *)jx_decimalSubtracteWithMinuendNumberString:(NSString *)minuendNumberString subtrahendNumberString:(NSString *)subtrahendNumberString {
    NSDecimalNumber *minuendNumber = [NSDecimalNumber decimalNumberWithString:[self checkNumberString:minuendNumberString]];
    NSDecimalNumber *subtrahendNumber = [NSDecimalNumber decimalNumberWithString:[self checkNumberString:subtrahendNumberString]];
    NSDecimalNumber *resultDecimalNumber = [minuendNumber decimalNumberBySubtracting:subtrahendNumber];
    return [resultDecimalNumber stringValue];
}

- (NSString *)jx_decimalSubtracteWithSubtrahendNumberString:(NSString *)subtrahendNumberString {
    return [NSString jx_decimalSubtracteWithMinuendNumberString:self subtrahendNumberString:subtrahendNumberString];
}

+ (NSString *)jx_decimalMultiplyWithMultiplicandNumberString:(NSString *)multiplicandNumberString multiplierNumberString:(NSString *)multiplierNumberString {
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:[self checkNumberString:multiplicandNumberString]];
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:[self checkNumberString:multiplierNumberString]];
    NSDecimalNumber *resultDecimalNumber = [multiplierNumber decimalNumberByMultiplyingBy:multiplicandNumber];
    return [resultDecimalNumber stringValue];
}

- (NSString *)jx_decimalMultiplyWithMultiplierNumberString:(NSString *)multiplierNumberString {
    return [NSString jx_decimalMultiplyWithMultiplicandNumberString:self multiplierNumberString:multiplierNumberString];
}

+ (NSString *)jx_decimalDivideWithDividendNumberString:(NSString *)dividendNumberString divisorNumberString:(NSString *)divisorNumberString {
    NSDecimalNumber *dividendNumber = [NSDecimalNumber decimalNumberWithString:[self checkNumberString:dividendNumberString]];
    NSDecimalNumber *divisorNumber = [NSDecimalNumber decimalNumberWithString:[self checkNumberString:divisorNumberString]];
    NSDecimalNumber *resultDecimalNumber = [dividendNumber decimalNumberByDividingBy:divisorNumber];
    return [resultDecimalNumber stringValue];
}

- (NSString *)jx_decimalDivideWithDivisorNumberString:(NSString *)divisorNumberString {
    return [NSString jx_decimalDivideWithDividendNumberString:self divisorNumberString:divisorNumberString];
}

+ (NSComparisonResult)jx_compareWithFirstNumberString:(NSString *)firstNumberString secondNumberString:(NSString *)secondNumberString {
    NSDecimalNumber *firstNumber = [NSDecimalNumber decimalNumberWithString:[self checkNumberString:firstNumberString]];
    NSDecimalNumber *secondNumber = [NSDecimalNumber decimalNumberWithString:[self checkNumberString:secondNumberString]];
    return [firstNumber compare:secondNumber];
}

- (NSComparisonResult)jx_compareToNumberString:(NSString *)numberString {
    return [NSString jx_compareWithFirstNumberString:[NSString checkNumberString:self] secondNumberString:[NSString checkNumberString:numberString]];
}

- (BOOL)jx_lessThanNumberString:(NSString *)numberString  {
    switch ([self jx_compareToNumberString:numberString]) {
        case NSOrderedDescending: {
            return NO;
        }
        case NSOrderedSame: {
            return NO;
        }
        case NSOrderedAscending: {
            return YES;
        }
    }
}

- (BOOL)jx_lessThanOrEqualToNumberString:(NSString *)numberString {
    switch ([self jx_compareToNumberString:numberString]) {
        case NSOrderedDescending: {
            return NO;
        }
        case NSOrderedSame:
        case NSOrderedAscending: {
            return YES;
        }
    }
}

- (BOOL)jx_greatThanNumberString:(NSString *)numberString {
    switch ([self jx_compareToNumberString:numberString]) {
        case NSOrderedSame: {
            return NO;
        }
        case NSOrderedDescending: {
            return YES;
        }
        case NSOrderedAscending: {
            return NO;
        }
    }
}

- (BOOL)jx_greatThanOrEqualToNumberString:(NSString *)numberString {
    switch ([self jx_compareToNumberString:numberString]) {
        case NSOrderedSame:
        case NSOrderedDescending: {
            return YES;
        }
        case NSOrderedAscending: {
            return NO;
        }
    }
}

- (NSString *)jx_decimalWithScale:(NSUInteger)scale {
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithString:[NSString checkNumberString:self]];
    NSDecimalNumberHandler * handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundDown scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    decimalNumber = [decimalNumber decimalNumberByRoundingAccordingToBehavior:handler];
    NSString *decimalNumberString = [decimalNumber stringValue];
    if (scale > 0) {
        if ([decimalNumberString containsString:@"."]) {
            NSArray<NSString *> *decimalNumberStringArray = [decimalNumberString componentsSeparatedByString:@"."];
            if (decimalNumberStringArray.count > 1) {
                for (NSInteger index = decimalNumberStringArray[1].length; index < scale; index++) {
                    decimalNumberString = [decimalNumberString stringByAppendingString:@"0"];
                }
            }
        } else {
            decimalNumberString = [decimalNumberString stringByAppendingString:@".00"];
        }
    }
    return decimalNumberString;
}

#pragma mark - Private Method

+ (NSString *)checkNumberString:(NSString *)numberString {
    if (numberString.length <= 0) {
        return @"0";
    }
    return numberString;
}

@end
