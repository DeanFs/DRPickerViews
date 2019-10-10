//
//  JXTransitionConstant.h
//  JXExtension
//
//  Created by Jeason on 2018/5/7.
//  Copyright © 2018年 Jeason.Lee. All rights reserved.
//

#ifndef JXTransitionConstant_h
#define JXTransitionConstant_h

typedef NS_OPTIONS(NSUInteger, JXAnimatorDirection) {
    JXAnimatorDirectionNone   = 0,
    JXAnimatorDirectionRight  = 1 << 0,
    JXAnimatorDirectionLeft   = 1 << 1,
    JXAnimatorDirectionTop    = 1 << 2,
    JXAnimatorDirectionBottom = 1 << 3,
};

static const JXAnimatorDirection JXAnimatorDirectionAll = JXAnimatorDirectionRight | JXAnimatorDirectionLeft | JXAnimatorDirectionTop | JXAnimatorDirectionBottom;

#endif /* JXTransitionConstant_h */
