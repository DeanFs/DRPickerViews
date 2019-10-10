//
//  JXTransitionAnimator.h
//  JXExtension
//
//  Created by Jeason on 2017/9/2.
//  Copyright © 2017年 Jeason.Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JXInteractiveTransition.h"

@interface JXTransitionAnimator : NSObject <UIViewControllerTransitioningDelegate, JXInteractiveTransitionDelegate>

//to转场时间 默认0.3
@property (nonatomic, assign) NSTimeInterval toDuration;
//back转场时间 默认0.3
@property (nonatomic, assign) NSTimeInterval backDuration;

@property (nonatomic, strong) JXInteractiveTransition *toInteractive;
@property (nonatomic, strong) JXInteractiveTransition *backInteractive;

@property (nonatomic, copy) UIPresentationController *(^presentationControllerBlock)(UIViewController *presented, UIViewController *presenting);

/**
 *  配置To过程动画,自定义转场动画复写该方法
 */
- (void)jx_setToAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;
/**
 *  配置Back过程动画,自定义转场动画复写该方法
 */
- (void)jx_setBackAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
