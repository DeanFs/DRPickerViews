//
//  UIView+JXClass.m
//  JXExtension
//
//  Created by JeasonLee on 2019/1/21.
//  Copyright © 2019 Jeason.Lee. All rights reserved.
//

#import "UIView+JXClass.h"

@implementation UIView (JXClass)

@end

@implementation UITableViewCell (JXClass)

+ (CGFloat)jx_cellHeight {
    return CGFLOAT_MIN;
}

+ (NSString *)jx_cellIdentifier {
    return NSStringFromClass([self class]);
}

@end

@implementation UICollectionViewCell (JXClass)

+ (CGSize)jx_cellSize {
    return CGSizeZero;
}

+ (NSString *)jx_cellIdentifier {
    return NSStringFromClass([self class]);
}

@end

@implementation UICollectionReusableView (JXClass)

+ (CGSize)jx_viewSize {
    return CGSizeZero;
}

+ (NSString *)jx_viewIdentifier {
    return NSStringFromClass([self class]);
}

@end
