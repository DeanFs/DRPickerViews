//
//  UIView+JXFrame.m
//  JXExtension
//
//  Created by Jeason on 2017/8/21.
//  Copyright © 2017年 Jeason.Lee. All rights reserved.
//

#import "UIView+JXFrame.h"

@implementation UIView (JXFrame)

- (CGFloat)jx_top {
    return self.frame.origin.y;
}

- (void)setJx_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)jx_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setJx_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)jx_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setJx_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)jx_left {
    return self.frame.origin.x;
}

- (void)setJx_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)jx_width {
    return self.frame.size.width;
}

- (void)setJx_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)jx_height {
    return self.frame.size.height;
}

- (void)setJx_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)jx_origin {
    return self.frame.origin;
}

- (void)setJx_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)jx_size {
    return self.frame.size;
}

- (void)setJx_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)jx_centerX {
    return self.center.x;
}

- (void)setJx_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)jx_centerY {
    return self.center.y;
}

- (void)setJx_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)jx_x {
    return self.frame.origin.x;
}

- (void)setJx_x:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)jx_y {
    return self.frame.origin.y;
}

- (void)setJx_y:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

@end
