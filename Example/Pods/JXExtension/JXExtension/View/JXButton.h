//
//  JXButton.h
//  JXExtension
//
//  Created by Jeason on 2017/6/15.
//  Copyright © 2017年 JeasonLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXButton : UIButton

@property (nonatomic) IBInspectable BOOL masksToBounds;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGSize  shadowOffset;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable UIColor *shadowColor;

@property (nonatomic) IBInspectable UIColor *normalBackgroundColor;
@property (nonatomic) IBInspectable UIColor *highlightedBackgroundColor;
@property (nonatomic) IBInspectable UIColor *selectedBackgroundColor;
@property (nonatomic) IBInspectable UIColor *disabledBackgroundColor;

@end
