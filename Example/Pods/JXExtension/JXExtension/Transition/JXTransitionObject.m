//
//  JXTransitionObject.m
//  JXExtension
//
//  Created by Jeason on 2017/9/2.
//  Copyright © 2017年 Jeason.Lee. All rights reserved.
//

#import "JXTransitionObject.h"

@implementation JXTransitionObject {
    NSTimeInterval _duration;
    JXTransitionAnimationConfig _config;
}

- (instancetype)initWithDuration:(NSTimeInterval)duration animationBlock:(JXTransitionAnimationConfig)config {
    self = [super init];
    if (self) {
        _duration = duration;
        _config = config;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return _duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    _config ? _config(transitionContext) : nil;
}

@end
