//
//  UIViewController+JXTransition.m
//  JXExtension
//
//  Created by Jeason on 2017/9/2.
//  Copyright © 2017年 Jeason.Lee. All rights reserved.
//

#import "UIViewController+JXTransition.h"
#import <objc/runtime.h>

NSString *const kJXToInteractiveKey = @"kJXToInteractiveKey";
NSString *const kJXAnimatorKey = @"kJXAnimatorKey";

@implementation UIViewController (JXTransition)

- (void)jx_presentViewController:(UIViewController *)viewController animator:(JXTransitionAnimator *)animator completion:(void (^)(void))completion {
    if (!viewController) return;
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    viewController.modalPresentationCapturesStatusBarAppearance = YES;
    if (!animator) animator = [[JXTransitionAnimator alloc] init];
    viewController.transitioningDelegate = animator;
    JXInteractiveTransition *toInteractive = objc_getAssociatedObject(self, &kJXToInteractiveKey);
    if (toInteractive) { //有注册转场手势则赋值
        animator.toInteractive = toInteractive;
    }
    UIViewController *targetViewController;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        targetViewController = navigationController.visibleViewController;
    } else {
        targetViewController = viewController;
    }
     objc_setAssociatedObject(targetViewController, &kJXAnimatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self presentViewController:viewController animated:YES completion:completion];
}

- (void)jx_registerToInteractiveTransitionWithDirection:(JXAnimatorDirection)direction minPersent:(CGFloat)minPersent transitonBlock:(JXInteractiveGestureDirectionBlock)transitonBlock {
    if (!transitonBlock) return;
    JXInteractiveTransition *interactive = [[JXInteractiveTransition alloc] initWithType:JXInteractiveTypePresent];
    interactive.enadleDirection = direction;
    interactive.timerEable = YES;
    interactive.minPersent = minPersent;
    interactive.configBlock = transitonBlock;
    [interactive addPanGestureForView:self.view];
    objc_setAssociatedObject(self, &kJXToInteractiveKey, interactive, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)jx_registerBackInteractiveTransitionWithDirection:(JXAnimatorDirection)direction minPersent:(CGFloat)minPersent transitonBlock:(JXInteractiveGestureDirectionBlock)transitonBlock {
    if (!transitonBlock) return;
    JXInteractiveTransition *interactive = [[JXInteractiveTransition alloc] initWithType:JXInteractiveTypeDismiss];
    interactive.enadleDirection = direction;
    interactive.timerEable = YES;
    interactive.minPersent = minPersent;
    interactive.configBlock = transitonBlock;
    [interactive addPanGestureForView:self.view];
    JXTransitionAnimator *animator = objc_getAssociatedObject(self, &kJXAnimatorKey);
    if (animator) { //设置返回转场手势
        interactive.enadleDirection = direction == JXAnimatorDirectionNone ? animator.toInteractive.direction.backDirection : direction;
        animator.backInteractive = interactive;
    }
}

@end
