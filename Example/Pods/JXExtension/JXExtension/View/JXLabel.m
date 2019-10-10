//
//  JXLabel.m
//  JXExtension
//
//  Created by Jeason on 2017/6/15.
//  Copyright © 2017年 JeasonLee. All rights reserved.
//

#import "JXLabel.h"

@interface JXLabel ()

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

@end

@implementation JXLabel

#pragma mark - LifeCycle

+ (instancetype)labelWithText:(NSString *)text insets:(UIEdgeInsets)insets {
    JXLabel *label = [[JXLabel alloc] init];
    label.text = text;
    label.contentEdgeInsets = insets;
    return label;
}

+ (instancetype)labelWithText:(NSString *)text insets:(UIEdgeInsets)insets font:(UIFont *)font textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor {
    JXLabel *label = [[JXLabel alloc] init];
    label.text = text;
    label.contentEdgeInsets = insets;
    label.font = font;
    label.textColor = textColor;
    label.backgroundColor = backgroundColor;
    return label;
}

+ (instancetype)labelWithText:(NSString *)text insets:(UIEdgeInsets)insets font:(UIFont *)font textColor:(UIColor *)textColor fillColor:(UIColor *)fillColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius {
    JXLabel *label = [[JXLabel alloc] init];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.backgroundColor = fillColor;
    label.contentEdgeInsets = insets;
    label.borderWidth = borderWidth;
    label.borderColor = borderColor;
    label.cornerRadius = cornerRadius;
    return label;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.contentEdgeInsets)];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.contentEdgeInsets) limitedToNumberOfLines:numberOfLines];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize value = [super sizeThatFits:size];
    value.width += self.contentEdgeInsets.left + self.contentEdgeInsets.right;
    value.height += self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
    return value;
}

- (CGSize)intrinsicContentSize {
    CGSize intrinsicContentSize = [super intrinsicContentSize];
    intrinsicContentSize.width += self.contentEdgeInsets.left + self.contentEdgeInsets.right + 0.1;
    intrinsicContentSize.height += self.contentEdgeInsets.top + self.contentEdgeInsets.bottom + 0.1;
    return intrinsicContentSize;
}

#pragma mark - Property method

- (CGFloat)insetTop {
    return self.contentEdgeInsets.top;
}

- (void)setInsetTop:(CGFloat)insetTop {
    self.contentEdgeInsets = UIEdgeInsetsMake(insetTop, self.insetLeft, self.insetBottom, self.insetRight);
}

- (CGFloat)insetLeft {
    return self.contentEdgeInsets.left;
}

- (void)setInsetLeft:(CGFloat)insetLeft {
    self.contentEdgeInsets = UIEdgeInsetsMake(self.insetTop, insetLeft, self.insetBottom, self.insetRight);
}

- (CGFloat)insetBottom {
    return self.contentEdgeInsets.top;
}

- (void)setInsetBottom:(CGFloat)insetBottom {
    self.contentEdgeInsets = UIEdgeInsetsMake(self.insetTop, self.insetLeft, insetBottom, self.insetRight);
}

- (CGFloat)insetRight {
    return self.contentEdgeInsets.top;
}

- (void)setInsetRight:(CGFloat)insetRight {
    self.contentEdgeInsets = UIEdgeInsetsMake(self.insetTop, self.insetLeft, self.insetBottom, insetRight);
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.masksToBounds = cornerRadius > 0;
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
    self.layer.borderColor = borderColor.CGColor;
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

@end
