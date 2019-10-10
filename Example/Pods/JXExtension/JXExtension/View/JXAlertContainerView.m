//
//  JXAlertContainerView.m
//  JXExtension
//
//  Created by Jeason on 2017/8/2.
//  Copyright © 2017年 Jeason. All rights reserved.
//

#import "JXAlertContainerView.h"

static const CGFloat kGlobalAnimationDuration = 0.25;
static const CGFloat JXAlertContainerViewMotionEffectExtentValue = 15.0;

@implementation JXAlertContainerView

#pragma mark - Public Method

- (void)popToShow {
    self.alpha = 0.0;
    self.layer.opacity = 0.4;
    self.layer.transform = CATransform3DMakeScale(0.2, 0.2, 1.0);
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.0;
        self.layer.opacity = 1.0;
        self.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
    } completion:^(BOOL finished) {
        [self addMotionEffect:self.motionEffectGroup];
    }];
}

- (void)popToDismiss {
    [self popToDismissWithRemove:YES];
}

- (void)popToDismissWithRemove:(BOOL)remove {
    CATransform3D currentTransform = self.layer.transform;
    self.layer.opacity = 1.0;
    
    [UIView animateWithDuration:kGlobalAnimationDuration delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.layer.opacity = 0.0;
        self.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.2, 0.2, 1.0));
    } completion:^(BOOL finished) {
        !remove ? : [self removeFromSuperview];
    }];
}

#pragma mark - Property Method

- (UIMotionEffectGroup *)motionEffectGroup {
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-JXAlertContainerViewMotionEffectExtentValue);
    horizontalEffect.maximumRelativeValue = @(JXAlertContainerViewMotionEffectExtentValue);
    
    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-JXAlertContainerViewMotionEffectExtentValue);
    verticalEffect.maximumRelativeValue = @(JXAlertContainerViewMotionEffectExtentValue);
    
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];
    return motionEffectGroup;
}

@end
