//
//  NSMutableDictionary+JXSafeAccess.h
//  JXExtension
//
//  Created by JeasonLee on 2019/1/21.
//  Copyright © 2019 Jeason.Lee. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (JXSafeAccess)

- (void)jx_safeSetObject:(id)object forKey:(id <NSCopying>)key;

@end

NS_ASSUME_NONNULL_END
