//
//  UIViewController+JXTransition.h
//  JXExtension
//
//  Created by Jeason on 2017/9/2.
//  Copyright © 2017年 Jeason.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXTransitionConstant.h"
#import "JXTransitionAnimator.h"

@interface UIViewController (JXTransition)

/**
 *  通过指定的转场animator来present控制器
 *
 *  @param viewController 被modal出的控制器
 *  @param animator       转场animator
 *  @param completion     完成后回调
 */
- (void)jx_presentViewController:(UIViewController *)viewController animator:(JXTransitionAnimator *)animator completion:(void (^)(void))completion;

/**
 注册转场手势

 @param direction 手势方向
 @param minPersent 最少滑动比例
 @param transitonBlock 过渡回调
 */
- (void)jx_registerToInteractiveTransitionWithDirection:(JXAnimatorDirection)direction minPersent:(CGFloat)minPersent transitonBlock:(JXInteractiveGestureDirectionBlock)transitonBlock;

/**
 注册转场手势
 
 @param direction 手势方向
 @param minPersent 最少滑动比例
 @param transitonBlock 过渡回调
 */
- (void)jx_registerBackInteractiveTransitionWithDirection:(JXAnimatorDirection)direction minPersent:(CGFloat)minPersent transitonBlock:(JXInteractiveGestureDirectionBlock)transitonBlock;

@end
