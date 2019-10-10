//
//  JXTransitionAnimator.m
//  JXExtension
//
//  Created by Jeason on 2017/9/2.
//  Copyright © 2017年 Jeason.Lee. All rights reserved.
//

#import "JXTransitionAnimator.h"
#import "JXTransitionObject.h"

@interface JXTransitionAnimator ()

@property (nonatomic, strong) JXTransitionObject *toTransition;
@property (nonatomic, strong) JXTransitionObject *backTransition;

@end

@implementation JXTransitionAnimator

- (instancetype)init {
    self = [super init];
    if (self) {
        _toDuration = 0.3;
        _backDuration = 0.3;
    }
    return self;
}

- (void)jx_setToAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    //子类重写
}

- (void)jx_setBackAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    //子类重写
}

#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return self.presentationControllerBlock ? self.presentationControllerBlock(presented, presenting) : nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.toTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.backTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.backInteractive.isInteractive ? self.backInteractive : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.toInteractive.isInteractive ? self.toInteractive : nil;
}

#pragma mark - Property Method

- (JXTransitionObject *)toTransition {
    if (!_toTransition) {
        _toTransition = [[JXTransitionObject alloc] initWithDuration:_toDuration animationBlock:^(id<UIViewControllerContextTransitioning> transitionContext) {
            [self jx_setToAnimation:transitionContext];
        }];
    }
    return _toTransition;
}

- (JXTransitionObject *)backTransition {
    if (!_backTransition) {
        _backTransition = [[JXTransitionObject alloc] initWithDuration:_backDuration animationBlock:^(id<UIViewControllerContextTransitioning> transitionContext) {
            [self jx_setBackAnimation:transitionContext];
        }];
    }
    return _backTransition;
}

- (void)setToInteractive:(JXInteractiveTransition *)toInteractive {
    _toInteractive = toInteractive;
    toInteractive.delegate = self;
}

- (void)setBackInteractive:(JXInteractiveTransition *)backInteractive {
    _backInteractive = backInteractive;
    backInteractive.delegate = self;
}



@end
