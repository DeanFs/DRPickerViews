//
//  JXPushAnimator.m
//  JXExtension
//
//  Created by Jeason on 2017/9/2.
//  Copyright © 2017年 Jeason.Lee. All rights reserved.
//

#import "JXPushAnimator.h"
#import "JXInteractiveTransition.h"

@interface JXPushAnimator ()

@property (nonatomic, weak) id <UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation JXPushAnimator

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

/**
 类似push动画效果
 */
- (void)jx_setToAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //转场的容器图，动画完成之后会消失
    UIView *containerView = transitionContext.containerView;
    self.containerView = containerView;
    UIView *fromView;
    UIView *toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    //对应关系
    BOOL isPresent = (toViewController.presentingViewController == fromViewController);
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    CGFloat toX = 0, toY = 0, fromX = 0, fromY = 0;
    switch (self.animatorMode) {
        case JXAnimatorDirectionLeft: {
            toX = toFrame.size.width;
            fromX = toX * self.offset;
        } break;
        case JXAnimatorDirectionRight: {
            toX = -toFrame.size.width;
            fromX = toX * self.offset;
        } break;
        case JXAnimatorDirectionBottom: {
            toY = -toFrame.size.height;
            fromY = toY * self.offset;
        } break;
        case JXAnimatorDirectionTop: {
            toY = toFrame.size.height;
            fromY = toY * self.offset;
        } break;
        default: break;
    }
    if (isPresent) {
        fromView.frame = fromFrame;
        toView.frame = CGRectOffset(toFrame, toX, toY);
        [containerView addSubview:toView];
    }
    NSTimeInterval transitionDuration = self.toDuration;
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresent) {
            toView.frame = toFrame;
            fromView.frame = CGRectOffset(fromFrame, fromX, fromY);
        }
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        wasCancelled ? [toView removeFromSuperview] : nil;
        [transitionContext completeTransition:!wasCancelled];
    }];
}

/**
 类似pop动画效果
 */
- (void)jx_setBackAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //转场的容器图，动画完成之后会消失
    UIView *containerView = transitionContext.containerView;
    self.containerView = containerView;
    UIView *fromView;
    UIView *toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    //对应关系
    BOOL isDismiss = (fromViewController.presentingViewController == toViewController);
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    CGFloat toX = 0, toY = 0, fromX = 0, fromY = 0;
    switch (self.animatorMode) {
        case JXAnimatorDirectionLeft: {
            fromX = fromFrame.size.width;
            toX = fromX * self.offset;
        } break;
        case JXAnimatorDirectionRight: {
            fromX = -fromFrame.size.width;
            toX = fromX * self.offset;
        } break;
        case JXAnimatorDirectionBottom: {
            fromY = -fromFrame.size.height;
            toY = fromY * self.offset;
        } break;
        case JXAnimatorDirectionTop: {
            fromY = fromFrame.size.height;
            toY = fromY * self.offset;
        } break;
        default: break;
    }
    if (isDismiss) {
        fromView.frame = fromFrame;
        toView.frame = CGRectOffset(toFrame, toX, toY);
        [containerView insertSubview:toView belowSubview:fromView];
    }
    NSTimeInterval transitionDuration = self.backDuration;
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isDismiss) {
            toView.frame = toFrame;
            fromView.frame = CGRectOffset(fromFrame, fromX, fromY);
        }
    } completion:^(BOOL finished) {
        BOOL wasCancel = [transitionContext transitionWasCancelled];
        if (wasCancel) {
            [toView removeFromSuperview];
        }
        [transitionContext completeTransition:!wasCancel];
    }];
}

#pragma mark - JXInteractiveTransitionDelegate

- (void)jx_interactiveTransitionWillBegin:(JXInteractiveTransition *)interactiveTransition {
    self.containerView.userInteractionEnabled = NO;
}

- (void)jx_interactiveTransition:(JXInteractiveTransition *)interactiveTransition willEndWithSuccessFlag:(BOOL)flag percent:(CGFloat)percent {
    self.containerView.userInteractionEnabled = YES;
}

@end
