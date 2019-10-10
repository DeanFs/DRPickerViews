//
//  NSMutableArray+JXSafeAccess.m
//  JXExtension
//
//  Created by JeasonLee on 2019/1/21.
//  Copyright © 2019 Jeason.Lee. All rights reserved.
//

#import "NSMutableArray+JXSafeAccess.h"

@implementation NSMutableArray (JXSafeAccess)

- (void)jx_safeAddObject:(id)object {
    if (object) {
        [self addObject:object];
    }
}

- (void)jx_safeInsertObject:(id)object atIndex:(NSUInteger)index {
    if (object) {
        [self insertObject:object atIndex:index];
    }
}

- (void)jx_safeAddObject:(id)anObject placeholder:(id)placeholder {
    if (anObject) {
        [self addObject:anObject];
    } else {
        [self jx_safeAddObject:placeholder];
    }
}

- (void)jx_safeInsertObject:(id)object atIndex:(NSUInteger)index placeholder:(id)placeholder {
    if (object) {
        [self insertObject:object atIndex:index];
    } else {
        [self jx_safeInsertObject:placeholder atIndex:index];
    }
}

@end
