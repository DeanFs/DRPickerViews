//
//  UIAlertController+JXExtension.m
//  JXExtension
//
//  Created by Jeason on 2017/8/19.
//  Copyright © 2017年 Jeason.Lee. All rights reserved.
//

#import "UIAlertController+JXExtension.h"
#import <objc/runtime.h>

@implementation UIAlertController (JXExtension)

@dynamic titleColor;
@dynamic titleFont;
@dynamic messageColor;
@dynamic messageFont;

#pragma mark - Property Method

- (UIColor *)titleColor {
    UIColor *titleColor = objc_getAssociatedObject(self, @selector(titleColor));
    if (titleColor == nil) {
        titleColor = [UIColor blackColor];
        objc_setAssociatedObject(self, @selector(titleColor), titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return titleColor;
}

- (void)setTitleColor:(UIColor *)titleColor {
    objc_setAssociatedObject(self, @selector(titleColor), titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.title.length) {
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.titleAttributedString];
        [attributed addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, self.title.length)];
        [self setValue:attributed forKey:@"attributedTitle"];
    }
}

- (UIFont *)titleFont {
    UIFont *titleFont = objc_getAssociatedObject(self, @selector(titleFont));
    if (titleFont == nil) {
        titleFont = [UIFont boldSystemFontOfSize:16.0];
        objc_setAssociatedObject(self, @selector(titleFont), titleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return titleFont;
}

- (void)setTitleFont:(UIFont *)titleFont {
    objc_setAssociatedObject(self, @selector(titleFont), titleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.title.length) {
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.titleAttributedString];
        [attributed addAttribute:NSFontAttributeName value:titleFont range:NSMakeRange(0, self.title.length)];
        [self setValue:attributed forKey:@"attributedTitle"];
    }
}

- (UIColor *)messageColor {
    UIColor *messageColor = objc_getAssociatedObject(self, @selector(messageColor));
    if (messageColor == nil) {
        messageColor = [UIColor blackColor];
        objc_setAssociatedObject(self, @selector(messageColor), messageColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return messageColor;
}

- (void)setMessageColor:(UIColor *)messageColor {
    objc_setAssociatedObject(self, @selector(messageColor), messageColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.message.length) {
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.messageAttributedString];
        [attributed addAttribute:NSForegroundColorAttributeName value:messageColor range:NSMakeRange(0, self.message.length)];
        [self setValue:attributed forKey:@"attributedMessage"];
    }
}

- (UIFont *)messageFont {
    UIFont *messageFont = objc_getAssociatedObject(self, @selector(messageFont));
    if (messageFont == nil) {
        messageFont = [UIFont systemFontOfSize:14.0];
        objc_setAssociatedObject(self, @selector(messageFont), messageFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return messageFont;
}

- (void)setMessageFont:(UIFont *)messageFont {
    objc_setAssociatedObject(self, @selector(messageFont), messageFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.message.length) {
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithAttributedString:self.messageAttributedString];
        [attributed addAttribute:NSFontAttributeName value:messageFont range:NSMakeRange(0, self.message.length)];
        [self setValue:attributed forKey:@"attributedMessage"];
    }
}

#pragma mark - Private Method

- (NSAttributedString *)titleAttributedString {
    NSAttributedString *attributed = [self valueForKey:@"attributedTitle"];
    if (attributed == nil) {
        attributed = [[NSMutableAttributedString alloc] initWithString:self.title];
    }
    return attributed;
}

- (NSAttributedString *)messageAttributedString {
    NSAttributedString *attributed = [self valueForKey:@"attributedMessage"];
    if (attributed == nil) {
        attributed = [[NSMutableAttributedString alloc] initWithString:self.message];
    }
    return attributed;
}

@end
