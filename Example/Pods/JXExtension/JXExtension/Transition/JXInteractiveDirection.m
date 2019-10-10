//
//  JXInteractiveDirection.m
//  JXExtension
//
//  Created by Jeason on 2018/5/8.
//  Copyright © 2018年 Jeason.Lee. All rights reserved.
//

#import "JXInteractiveDirection.h"

@implementation JXInteractiveDirection

+ (JXInteractiveDirection *)directionWithTo:(JXAnimatorDirection)to back:(JXAnimatorDirection)back {
    JXInteractiveDirection *direction = [[JXInteractiveDirection alloc] init];
    direction.toDirection = to;
    direction.backDirection = back;
    return direction;
}

@end
