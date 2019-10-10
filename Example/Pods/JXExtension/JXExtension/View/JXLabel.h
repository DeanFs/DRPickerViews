//
//  JXLabel.h
//  JXExtension
//
//  Created by Jeason on 2017/6/15.
//  Copyright © 2017年 JeasonLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXLabel : UILabel

@property (nonatomic) IBInspectable CGFloat insetTop;
@property (nonatomic) IBInspectable CGFloat insetLeft;
@property (nonatomic) IBInspectable CGFloat insetBottom;
@property (nonatomic) IBInspectable CGFloat insetRight;

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGSize  shadowOffset;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable UIColor *shadowColor;

+ (instancetype)labelWithText:(NSString *)text insets:(UIEdgeInsets)insets;

+ (instancetype)labelWithText:(NSString *)text
                       insets:(UIEdgeInsets)insets
                         font:(UIFont *)font
                    textColor:(UIColor *)textColor
              backgroundColor:(UIColor *)backgroundColor;

+ (instancetype)labelWithText:(NSString *)text
                       insets:(UIEdgeInsets)insets
                         font:(UIFont *)font
                    textColor:(UIColor *)textColor
                    fillColor:(UIColor *)fillColor
                  borderColor:(UIColor *)borderColor
                  borderWidth:(CGFloat)borderWidth
                 cornerRadius:(CGFloat)cornerRadius;

@end
