//
//  JXInteractiveDirection.h
//  JXExtension
//
//  Created by Jeason on 2018/5/8.
//  Copyright © 2018年 Jeason.Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXTransitionConstant.h"

@interface JXInteractiveDirection : NSObject

@property (nonatomic, assign) JXAnimatorDirection toDirection; //正方向
@property (nonatomic, assign) JXAnimatorDirection backDirection; //反方向

+ (JXInteractiveDirection *)directionWithTo:(JXAnimatorDirection)to back:(JXAnimatorDirection)back;

@end
