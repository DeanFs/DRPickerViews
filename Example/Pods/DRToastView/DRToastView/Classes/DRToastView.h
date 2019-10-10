//
//  DRToastView.h
//  Records
//
//  Created by admin on 2018/6/6.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DRToastViewCompleteBlock)(BOOL isDelete);

@interface DRToastView : UIView

+ (void)setupBackgroundColor:(UIColor *)backgroundColor
                   textColor:(UIColor *)textColor
                    textFont:(UIFont *)textFont;

+ (void)showWithMessage:(NSString *)message complete:(DRToastViewCompleteBlock)complete;

// 可设置向上偏移的距离
+ (void)showWithMessage:(NSString *)message
               upOffset:(CGFloat)upOffset
               complete:(DRToastViewCompleteBlock)complete;

@end
