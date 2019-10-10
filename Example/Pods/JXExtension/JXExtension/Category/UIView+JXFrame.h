//
//  UIView+JXFrame.h
//  JXExtension
//
//  Created by Jeason on 2017/8/21.
//  Copyright © 2017年 Jeason.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JXFrame)

@property (nonatomic) CGPoint jx_origin;
@property (nonatomic) CGSize jx_size;

@property (nonatomic) CGFloat jx_centerX;
@property (nonatomic) CGFloat jx_centerY;

@property (nonatomic) CGFloat jx_x;
@property (nonatomic) CGFloat jx_y;

@property (nonatomic) CGFloat jx_top;
@property (nonatomic) CGFloat jx_bottom;
@property (nonatomic) CGFloat jx_right;
@property (nonatomic) CGFloat jx_left;

@property (nonatomic) CGFloat jx_width;
@property (nonatomic) CGFloat jx_height;

@end
