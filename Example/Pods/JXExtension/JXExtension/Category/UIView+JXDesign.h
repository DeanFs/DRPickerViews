//
//  UIView+JXDesign.h
//  JXExtension
//
//  Created by Jeason on 2017/7/14.
//  Copyright © 2017年 Jeason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDVersion/SDiOSVersion.h>

@interface UIView (JXDesign)

+ (CGFloat)jx_designValue:(CGFloat)value;
+ (CGFloat)jx_designValue:(CGFloat)value deviceSize:(DeviceSize)deviceSize;

@end
