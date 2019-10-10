//
//  UIImage+JXExtension.h
//  JXExtension
//
//  Created by Jeason on 2017/8/11.
//  Copyright © 2017年 Jeason.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JXExtension)

/**
 获取LaunchImage
 */
+ (UIImage *)jx_launchImage;

/**
 根据view生成图片
 */
+ (UIImage *)jx_imageWithView:(UIView *)view;

/**
 根据color生成图片
 */
+ (UIImage *)jx_imageWithColor:(UIColor *)color;
+ (UIImage *)jx_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 变换图片颜色
 */
- (UIImage *)jx_imageChangeColor:(UIColor *)color;

/**
 图片指定位置取颜色
 */
- (UIColor *)jx_colorAtPixel:(CGPoint)point;

/**
 返回该图片是否有透明度通道
 */
- (BOOL)jx_hasAlphaChannel;

@end
