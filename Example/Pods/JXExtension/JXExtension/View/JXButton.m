//
//  JXButton.m
//  JXExtension
//
//  Created by Jeason on 2017/6/15.
//  Copyright © 2017年 JeasonLee. All rights reserved.
//

#import "JXButton.h"
#import "UIImage+JXExtension.h"

@implementation JXButton

#pragma mark - Property method

- (BOOL)masksToBounds {
    return self.layer.masksToBounds;
}

- (void)setMasksToBounds:(BOOL)masksToBounds {
    self.layer.masksToBounds = masksToBounds;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    if (borderColor) {
        self.layer.borderColor = borderColor.CGColor;
    }
}

- (CGFloat)shadowOpacity {
    return self.layer.shadowOpacity;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}

- (CGFloat)shadowRadius {
    return self.layer.shadowRadius;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    self.layer.shadowRadius = shadowRadius;
}

- (CGSize)shadowOffset {
    return self.layer.shadowOffset;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    self.layer.shadowOffset = shadowOffset;
}

- (UIColor *)shadowColor {
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = shadowColor.CGColor;
}

- (UIColor *)normalBackgroundColor {
    return [[self backgroundImageForState:UIControlStateNormal] jx_colorAtPixel:CGPointMake(0, 0)];
}

- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor {
    if (normalBackgroundColor) {
        [self setBackgroundImage:[UIImage jx_imageWithColor:normalBackgroundColor] forState:UIControlStateNormal];
    } else {
        [self setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

- (UIColor *)highlightedBackgroundColor {
     return [[self backgroundImageForState:UIControlStateHighlighted] jx_colorAtPixel:CGPointMake(0, 0)];
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    if (highlightedBackgroundColor) {
        [self setBackgroundImage:[UIImage jx_imageWithColor:highlightedBackgroundColor] forState:UIControlStateHighlighted];
    } else {
        [self setBackgroundImage:nil forState:UIControlStateHighlighted];
    }
}

- (UIColor *)selectedBackgroundColor {
    return [[self backgroundImageForState:UIControlStateSelected] jx_colorAtPixel:CGPointMake(0, 0)];
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor {
    if (selectedBackgroundColor) {
        [self setBackgroundImage:[UIImage jx_imageWithColor:selectedBackgroundColor] forState:UIControlStateSelected];
    } else {
        [self setBackgroundImage:nil forState:UIControlStateSelected];
    }
}

- (UIColor *)disabledBackgroundColor {
    return [[self backgroundImageForState:UIControlStateDisabled] jx_colorAtPixel:CGPointMake(0, 0)];
}

- (void)setDisabledBackgroundColor:(UIColor *)disabledBackgroundColor {
    if (disabledBackgroundColor) {
        [self setBackgroundImage:[UIImage jx_imageWithColor:disabledBackgroundColor] forState:UIControlStateDisabled];
    } else {
        [self setBackgroundImage:nil forState:UIControlStateDisabled];
    }
}

@end
