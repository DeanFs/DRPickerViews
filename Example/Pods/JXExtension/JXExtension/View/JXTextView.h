//
//  JXTextView.h
//  JXExtension
//
//  Created by Jeason on 2017/6/15.
//  Copyright © 2017年 JeasonLee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JXTextHeightDidChangeBlock)(NSString *text, CGFloat height);

@interface JXTextView : UITextView

@property (nonatomic) IBInspectable BOOL masksToBounds;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

@property (nonatomic, copy) IBInspectable NSString *placeholder;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

@property (nonatomic, copy) JXTextHeightDidChangeBlock changeBlcok;
@property (nonatomic, assign) NSUInteger maxNumberOfLines;
@property (nonatomic, assign) BOOL isFixed;

@end
