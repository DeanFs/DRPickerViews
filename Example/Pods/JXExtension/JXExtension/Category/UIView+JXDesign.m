//
//  UIView+JXDesign.m
//  JXExtension
//
//  Created by Jeason on 2017/7/14.
//  Copyright © 2017年 Jeason. All rights reserved.
//

#import "UIView+JXDesign.h"

@implementation UIView (JXDesign)

+ (CGFloat)jx_designValue:(CGFloat)value {
    return [self jx_designValue:value deviceSize:self.defultDeviceSize];
}

+ (CGFloat)jx_designValue:(CGFloat)value deviceSize:(DeviceSize)deviceSize {
    CGFloat scale = [self scaleWithDeviceSize:deviceSize];
    return value * scale;
}

#pragma mark - Pirvate Method

+ (DeviceSize)defultDeviceSize {
    return Screen4Dot7inch;
}

+ (CGFloat)scaleWithDeviceSize:(DeviceSize)deviceSize {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat width;
    switch (deviceSize) {
        case Screen3Dot5inch: {
            width = 320.0;
            break;
        }
        case Screen4inch: {
            width = 320.0;
            break;
        }
        case Screen4Dot7inch: {
            width = 375.0;
            break;
        }
        case Screen5Dot5inch: {
            width = 414.0;
            break;
        }
        default: {
            width = 320.0;
            break;
        }
    }
    return screenWidth / width;
}

@end
