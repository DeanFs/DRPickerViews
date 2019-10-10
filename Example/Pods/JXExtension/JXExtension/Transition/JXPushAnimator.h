//
//  JXPushAnimator.h
//  JXExtension
//
//  Created by Jeason on 2017/9/2.
//  Copyright © 2017年 Jeason.Lee. All rights reserved.
//

#import "JXTransitionAnimator.h"

@interface JXPushAnimator : JXTransitionAnimator

//推出方式
@property (nonatomic, assign) JXAnimatorDirection animatorMode;
//偏移量, 范围:-1至1, 默认:0
@property (nonatomic, assign) CGFloat offset;

@end
