//
//  NSMutableArray+JXSafeAccess.h
//  JXExtension
//
//  Created by JeasonLee on 2019/1/21.
//  Copyright © 2019 Jeason.Lee. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (JXSafeAccess)

- (void)jx_safeAddObject:(id)object;
- (void)jx_safeInsertObject:(id)object atIndex:(NSUInteger)index;
- (void)jx_safeAddObject:(id)anObject placeholder:(id)placeholder;

@end

NS_ASSUME_NONNULL_END
