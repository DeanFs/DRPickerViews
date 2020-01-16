//
//  JXTextField.m
//  JXExtension
//
//  Created by Jeason on 2017/6/15.
//  Copyright © 2017年 JeasonLee. All rights reserved.
//

#import "JXTextField.h"

@implementation JXTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    UIEdgeInsets insets = UIEdgeInsetsMake(self.topInset, self.leftInset, self.bottomInset, self.rightInset);
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    UIEdgeInsets insets = UIEdgeInsetsMake(self.topInset, self.leftInset, self.bottomInset, self.rightInset);
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)];
}

- (void)deleteBackward {
    [super deleteBackward];
    if ([self.keyInputDelegate respondsToSelector:@selector(textFieldDidDeleteBackward:)]) {
        [self.keyInputDelegate textFieldDidDeleteBackward:self];
    }
}

#pragma mark - Property method

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    [self setPlaceholderFont:self.placeholderFont];
    [self setPlaceholderColor:self.placeholderColor];
}

- (void)setMasksToBounds:(BOOL)masksToBounds {
    _masksToBounds = masksToBounds;
    self.layer.masksToBounds = masksToBounds;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    if (self.placeholder.length && placeholderColor) {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self.attributedPlaceholder attributesAtIndex:0 effectiveRange:NULL]];
        [attributes setObject:placeholderColor forKey:NSForegroundColorAttributeName];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attributes];
    }
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    if (self.placeholder.length && placeholderFont) {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self.attributedPlaceholder attributesAtIndex:0 effectiveRange:NULL]];
        [attributes setObject:placeholderFont forKey:NSFontAttributeName];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attributes];
    }
}

@end
