//
//  UIView+JXClass.h
//  JXExtension
//
//  Created by JeasonLee on 2019/1/21.
//  Copyright © 2019 Jeason.Lee. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JXClass)

@end

@interface UITableViewCell (JXClass)

+ (CGFloat)jx_cellHeight;
+ (NSString *)jx_cellIdentifier;

@end

@interface UICollectionViewCell (JXClass)

+ (CGSize)jx_cellSize;
+ (NSString *)jx_cellIdentifier;

@end

@interface UICollectionReusableView (JXClass)

+ (CGSize)jx_viewSize;
+ (NSString *)jx_viewIdentifier;

@end

NS_ASSUME_NONNULL_END
