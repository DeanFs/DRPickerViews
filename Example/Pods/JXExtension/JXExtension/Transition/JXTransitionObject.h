//
//  JXTransitionObject.h
//  JXExtension
//
//  Created by Jeason on 2017/9/2.
//  Copyright © 2017年 Jeason.Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JXTransitionAnimationConfig)(id<UIViewControllerContextTransitioning> transitionContext);

@interface JXTransitionObject : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithDuration:(NSTimeInterval)duration animationBlock:(void(^)(id<UIViewControllerContextTransitioning> transitionContext))config;;

@end
