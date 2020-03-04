//
//  UIImage+DRExtension.m
//  Records
//
//  Created by Zube on 2017/11/3.
//  Copyright © 2017年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "UIImage+DRExtension.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRSandboxManager/DRSandboxManager.h>
#import "CALayer+DRExtension.h"

@implementation DRImageAppendImageView

+ (instancetype)appendImageViewWithView:(UIView *)view
                                      x:(CGFloat)x
                                      y:(CGFloat)y {
    DRImageAppendImageView *appendView = [DRImageAppendImageView new];
    appendView.image = [UIImage imageFromView:view];
    appendView.point = CGPointMake(x, y);
    return appendView;
}

+ (instancetype)appendImageViewWithView:(UIView *)view
                                originX:(CGFloat)originX
                                originY:(CGFloat)originY {
    CGFloat x = originX + view.frame.origin.x;
    CGFloat y = originY + view.frame.origin.y;
    DRImageAppendImageView *appendView = [DRImageAppendImageView new];
    appendView.image = [UIImage imageFromView:view];
    appendView.point = CGPointMake(x, y);
    return appendView;
}

+ (instancetype)appendImageViewWithLayer:(CALayer *)layer
                                 originX:(CGFloat)originX
                                 originY:(CGFloat)originY {
    CGFloat x = originX + layer.frame.origin.x;
    CGFloat y = originY + layer.frame.origin.y;
    DRImageAppendImageView *appendView = [DRImageAppendImageView new];
    appendView.image = [UIImage imageFromLayer:layer];
    appendView.point = CGPointMake(x, y);
    return appendView;
}

+ (instancetype)appendImageViewWithImage:(UIImage *)image
                                       x:(CGFloat)x
                                       y:(CGFloat)y {
    DRImageAppendImageView *appendView = [DRImageAppendImageView new];
    appendView.image = image;
    appendView.point = CGPointMake(x, y);
    return appendView;
}

@end

@implementation UIImage (DRExtension)

#pragma mark - 创建图片
/**
 创建纯色图片
 size:(1,1)
 
 @param color 图片颜色
 @return 返回图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self pureImageWithColor:color
                               size:CGSizeMake(1.0f, 1.0f)
                       cornerRadius:0];
}

/**
 创建纯色图片
 size:(screenWidth, 0.25)
 
 @param color 图片颜色
 @return 返回图片
 */
+ (UIImage *)navigationShadowImageWithColor:(UIColor *)color {
    return [self pureImageWithColor:color
                               size:CGSizeMake(kDRScreenWidth, 0.25f)
                       cornerRadius:0];
}

/**
 创建纯色图片
 
 @param color 图片颜色
 @param size 图片尺寸
 @param cornerRadius 图片圆角半径
 @return 返回图片
 */
+ (UIImage *)pureImageWithColor:(UIColor *)color
                           size:(CGSize)size
                   cornerRadius:(CGFloat)cornerRadius {
    NSString *key = [NSString stringWithFormat:@"%@%@%f", [self rgbaStringFromColor:color], NSStringFromCGSize(size), cornerRadius];
    UIImage *image = [self imageForKey:key];
    if (!image) {
        CALayer *layer = [CALayer pureColorLayerWithRect:CGRectMake(0, 0, size.width, size.height)
                                                   color:color
                                            cornerRadius:cornerRadius];
        image = [self imageFromLayer:layer];
        [self cacheImage:image forKey:key];
    }
    return image;
}

/**
 给icon设置圆形背景色，大小和圆角生成新图片
 
 @param icon 待合成图片
 @param color 待添加的背景色
 @param size 生成图片的尺寸
 @return 返回新图片
 */
+ (UIImage *)circleDrawSimpleIcon:(UIImage *)icon
                inBackgroundColor:(UIColor *)color
                         withSize:(CGSize)size {
    return [self drawSimpleIcon:icon
              inBackgroundColor:color
                       withSize:size
                   cornerRadius:size.width/2];
}

/**
 给icon设置背景色，大小和圆角生成新图片
 
 @param icon 待合成图片
 @param color 待添加的背景色
 @param size 生成图片的尺寸
 @param cornerRadius 图片圆角
 @return 返回新图片
 */
+ (UIImage *)drawSimpleIcon:(UIImage *)icon
          inBackgroundColor:(UIColor *)color
                   withSize:(CGSize)size
               cornerRadius:(CGFloat)cornerRadius {
    CALayer *containerLayer = [CALayer layer];
    containerLayer.frame = CGRectMake(0, 0, size.width, size.height);
    containerLayer.cornerRadius = cornerRadius;
    containerLayer.masksToBounds = YES;
    containerLayer.backgroundColor = color.CGColor;
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake((size.width-icon.size.width)/2,
                                  (size.height-icon.size.height)/2,
                                  icon.size.width,
                                  icon.size.height);
    imageLayer.contents = (__bridge id)icon.CGImage;
    imageLayer.contentsGravity = kCAGravityResizeAspect;
    [containerLayer addSublayer:imageLayer];
    return [self imageFromLayer:containerLayer];
}

/**
 创建圆圈图片
 
 @param color 圆圈颜色
 @param size 圆圈大小
 @param borderWidth 圆圈线宽
 @return 返回圆圈图片
 */
+ (UIImage *)circleBorderImageWithColor:(UIColor *)color
                                   size:(CGSize)size
                            borderWidth:(CGFloat)borderWidth {
    NSString *key = [NSString stringWithFormat:@"%@%@%f", [self rgbaStringFromColor:color], NSStringFromCGSize(size), borderWidth];
    UIImage *image = [self imageForKey:key];
    if (!image) {
        CALayer *layer = [CALayer circleBorderLayerWithRect:CGRectMake(0, 0, size.width, size.height)
                                                      color:color
                                                borderWidth:borderWidth];
        image = [self imageFromLayer:layer];
        [self cacheImage:image forKey:key];
    }
    return image;
}

/**
 构建圆圈中带勾的图片
 
 @param size 圆圈大小
 @param checkColor 勾线条颜色
 @param checkWidth 勾线条宽度
 @param borderColor 圆圈颜色
 @param borderWidth 圆圈宽度
 @return 返回图片
 */
+ (UIImage *)checkInCircleBorderImageWithSize:(CGSize)size
                                   checkColor:(UIColor *)checkColor
                                   checkWidth:(CGFloat)checkWidth
                                  borderColor:(UIColor *)borderColor
                                  borderWidth:(CGFloat)borderWidth {
    NSString *key = [NSString stringWithFormat:@"check_circleb_%@%@%@%f%f", [self rgbaStringFromColor:checkColor], [self rgbaStringFromColor:borderColor], NSStringFromCGSize(size), checkWidth, borderWidth];
    UIImage *image = [self imageForKey:key];
    if (!image) {
        CALayer *layer = [CALayer checkInCircleBorderLayerWithRect:CGRectMake(0, 0, size.width, size.height)
                                                        checkColor:checkColor
                                                        checkWidth:checkWidth
                                                       borderColor:borderColor
                                                       borderWidth:borderWidth];
        image = [self imageFromLayer:layer];
        [self cacheImage:image forKey:key];
    }
    return image;
}

/**
 构建纯色圆圈背景中带勾的图片
 
 @param size 纯色圆圈背景大小
 @param checkColor 勾线条颜色
 @param checkWidth 勾线条宽度
 @param backgroundColor 纯色背景
 @return 返回图片
 */
+ (UIImage *)checkInCirclePureColorImageWithSize:(CGSize)size
                                      checkColor:(UIColor *)checkColor
                                      checkWidth:(CGFloat)checkWidth
                                 backgroundColor:(UIColor *)backgroundColor {
    NSString *key = [NSString stringWithFormat:@"check_circlep_%@%@%@%f", [self rgbaStringFromColor:checkColor], [self rgbaStringFromColor:backgroundColor], NSStringFromCGSize(size), checkWidth];
    UIImage *image = [self imageForKey:key];
    if (!image) {
        CALayer *layer = [CALayer checkInCirclePureColorLayerWithRect:CGRectMake(0, 0, size.width, size.height)
                                                           checkColor:checkColor
                                                           checkWidth:checkWidth
                                                      backgroundColor:backgroundColor];
        image = [self imageFromLayer:layer];
        [self cacheImage:image forKey:key];
    }
    return image;
}

/**
 圆圈进度图片
 
 @param size 圆圈大小
 @param progressColor 进图条颜色
 @param trackColor 进度底色
 @param strokeWidth 进度条宽度
 @param progress 进度值
 @return 返回图片
 */
+ (UIImage *)circleProgressImageWithSize:(CGSize)size
                           progressColor:(UIColor *)progressColor
                              trackColor:(UIColor *)trackColor
                             strokeWidth:(CGFloat)strokeWidth
                                progress:(CGFloat)progress {
    NSString *key = [NSString stringWithFormat:@"circle_pregress_%@%@%@%f%f", [self rgbaStringFromColor:progressColor], [self rgbaStringFromColor:trackColor], NSStringFromCGSize(size), strokeWidth, progress];
    UIImage *image = [self imageForKey:key];
    if (!image) {
        CALayer *layer = [CALayer circleProgressLayerWithRect:CGRectMake(0, 0, size.width, size.height)
                                                progressColor:progressColor
                                                   trackColor:trackColor
                                                  strokeWidth:strokeWidth
                                                     progress:progress];
        image = [UIImage imageFromLayer:layer];
        [self cacheImage:image forKey:key];
    }
    return image;
}

/**
 构建勾图片
 
 @param size 勾外围尺寸
 @param lineWidth 勾线条宽度
 @param lineColor 勾线条颜色
 @return 勾图片
 */
+ (UIImage *)checkLineImageWithSize:(CGSize)size
                          lineWidth:(CGFloat)lineWidth
                          lineColor:(UIColor *)lineColor {
    NSString *key = [NSString stringWithFormat:@"check_line_%@%@%f", [self rgbaStringFromColor:lineColor], NSStringFromCGSize(size), lineWidth];
    UIImage *image = [self imageForKey:key];
    if (!image) {
        CAShapeLayer *layer = [CAShapeLayer checkLayerWithRect:CGRectMake(0, 0, size.width, size.height)
                                                    checkColor:lineColor
                                                    checkWidth:lineWidth];
        image = [UIImage imageFromLayer:layer];
        [self cacheImage:image forKey:key];
    }
    return image;
}

#pragma mark - 截图
// scale = 0.0
+ (UIImage *)screenshot {
    return [UIImage screenshotWithScale:0.0f];
}

+ (UIImage *)screenshotWithScale:(float)scale {
    CGSize imageSize = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 将layer绘制成图片
 
 @param layer 要绘制的layer
 @return 返回图片
 */
+ (UIImage *)imageFromLayer:(CALayer *)layer {
    return [self imageFromLayer:layer bgColor:nil];
}

+ (UIImage *)imageFromLayer:(CALayer *)layer bgColor:(UIColor *)bgColor {
    CGSize imageSize = layer.bounds.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    
    if (bgColor != nil) {
        // 绘制纯色背景
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        layer.backgroundColor = bgColor.CGColor;
        [layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 将view绘制成图片
 
 @param view 要绘制成图片的UIview
 @return 返回图片
 */
+ (UIImage *)imageFromView:(UIView *)view {
    return [self imageFromView:view bgColor:nil];
}

+ (UIImage *)imageFromView:(UIView *)view bgColor:(UIColor *)bgColor {
    if (view == nil || CGSizeEqualToSize(view.bounds.size, CGSizeZero)) {
        return [[UIImage alloc] init];
    }
    return [self imageFromLayer:view.layer bgColor:bgColor];
}

/// 对scrollView内容截图（UITableView，UICollectionView）图片尺寸与ScrollView内容相等
/// @param scrollView scrollView
/// @param color 截出图片背景色
/// @param complete 完成回调
+ (void)imageWithWithScrollView:(UIScrollView *)scrollView
                        bgColor:(UIColor *)color
                       complete:(void(^)(UIImage *image))complete {
    [self imageWithWithScrollView:scrollView
                          bgColor:color
                            inset:UIEdgeInsetsZero
                         complete:complete];
}

/// 对scrollView内容截图（UITableView，UICollectionView）
/// @param scrollView scrollView
/// @param bgColor 截出图片背景色
/// @param inset 截出图片与ScrollView的边缘的边距，正数表示比scrollView大
/// @param complete 完成回调
+ (void)imageWithWithScrollView:(UIScrollView *)scrollView
                        bgColor:(UIColor *)bgColor
                          inset:(UIEdgeInsets)inset
                       complete:(void(^)(UIImage *image))complete {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIImageView *coverView = [[UIImageView alloc] initWithImage:[UIImage imageFromView:keyWindow]];
        coverView.userInteractionEnabled = YES;
        coverView.frame = keyWindow.bounds;
        [keyWindow addSubview:coverView];
        CGPoint oldOffset = scrollView.contentOffset;
        
        CGSize contentSize = scrollView.contentSize;
        CGFloat height = CGRectGetHeight(scrollView.bounds);
        if (contentSize.height < height) {
            contentSize.height = height;
        }
        CGFloat insetWidth = inset.left + inset.right;
        CGFloat top, left, bottom, right;
        if (@available(iOS 11.0, *)) {
            left = inset.left + scrollView.adjustedContentInset.left;
            right = inset.right + scrollView.adjustedContentInset.right;
            insetWidth += (scrollView.adjustedContentInset.left + scrollView.adjustedContentInset.right);
        } else {
            left = inset.left + scrollView.contentInset.left;
            right = inset.right + scrollView.contentInset.right;
            insetWidth += (scrollView.contentInset.left + scrollView.contentInset.right);
        }
        CGFloat insetHeight = inset.top + inset.bottom;
        if (@available(iOS 11.0, *)) {
            top = inset.top + scrollView.adjustedContentInset.top;
            bottom = inset.bottom + scrollView.adjustedContentInset.bottom;
            insetHeight += (scrollView.adjustedContentInset.top + scrollView.adjustedContentInset.bottom);
        } else {
            top = inset.top + scrollView.contentInset.top;
            bottom = inset.bottom + scrollView.contentInset.bottom;
            insetHeight += (scrollView.contentInset.top + scrollView.contentInset.bottom);
        }
        UIEdgeInsets imageInset = UIEdgeInsetsMake(top, left, bottom, right);
        CGSize imageSize = CGSizeMake(contentSize.width + insetWidth, contentSize.height + insetHeight);
        
        void(^appendAction)(NSArray<DRImageAppendImageView *> *appendViews) = ^(NSArray<DRImageAppendImageView *> *appendViews){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = [self imageAppendedFromViews:appendViews
                                                    imageSize:imageSize
                                                      bgColor:bgColor];
                dispatch_async(dispatch_get_main_queue(), ^{
                    scrollView.contentOffset = oldOffset;
                    [coverView removeFromSuperview];
                    kDR_SAFE_BLOCK(complete, image);
                });
            });
        };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            scrollView.contentOffset = CGPointZero;
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([scrollView isKindOfClass:[UICollectionView class]]) {
                    UICollectionView *collectionView = (UICollectionView *)scrollView;
                    if ([collectionView numberOfSections] > 0) {
                        [self collectionViewAppendViewCells:collectionView inset:imageInset complete:^(NSArray<DRImageAppendImageView *> *collectionViewAppendViews) {
                            appendAction(collectionViewAppendViews);
                        }];
                        return;
                    }
                } else if ([scrollView isKindOfClass:[UITableView class]]) {
                    UITableView *tableView = (UITableView *)scrollView;
                    if ([tableView numberOfSections] > 0) {
                        appendAction([self tableViewAppendViewCells:tableView
                                                              inset:imageInset]);
                        return;
                    }
                }
                appendAction([self scrollViewAppendViewCells:scrollView
                                                       inset:imageInset]);
            });
        });
    });
}

+ (NSArray<DRImageAppendImageView *> *)tableViewAppendViewCells:(UITableView *)tableView inset:(UIEdgeInsets)inset {
    CGFloat x = inset.left;
    CGFloat y = inset.top;
    NSMutableArray<DRImageAppendImageView *> *appendViews = [NSMutableArray array];
    
    if (tableView.tableHeaderView != nil) {
        DRImageAppendImageView *tableViewHeader = [DRImageAppendImageView appendImageViewWithView:tableView.tableHeaderView x:x y:y];
        [appendViews addObject:tableViewHeader];
        y += CGRectGetHeight(tableView.tableHeaderView.bounds);
    }
    for (int section=0; section<tableView.numberOfSections; section++) {
        UIView *sectionHeaderView = [tableView headerViewForSection:section];
        if (sectionHeaderView != nil) {
            DRImageAppendImageView *sectionHeaderAppendView = [DRImageAppendImageView appendImageViewWithView:sectionHeaderView x:x y:y];
            [appendViews addObject:sectionHeaderAppendView];
            y += CGRectGetHeight(sectionHeaderView.bounds);
        }
        
        for (int row=0; row<[tableView numberOfRowsInSection:section]; row++) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [tableView beginUpdates];
            [tableView scrollToRowAtIndexPath:cellIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [tableView endUpdates];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:cellIndexPath];
            DRImageAppendImageView *cellAppendView = [DRImageAppendImageView appendImageViewWithView:cell x:x y:y];
            [appendViews addObject:cellAppendView];
            y += CGRectGetHeight(cell.bounds);
        }
        
        UIView *sectionFooterView = [tableView footerViewForSection:section];
        if (sectionFooterView != nil) {
            DRImageAppendImageView *sectionFooterAppendView = [DRImageAppendImageView appendImageViewWithView:sectionFooterView x:x y:y];
            [appendViews addObject:sectionFooterAppendView];
            y += CGRectGetHeight(sectionFooterView.bounds);
        }
    }
    
    if (tableView.tableFooterView != nil) {
        DRImageAppendImageView *tableViewFooter = [DRImageAppendImageView appendImageViewWithView:tableView.tableFooterView x:x y:y];
        [appendViews addObject:tableViewFooter];
        y += CGRectGetHeight(tableView.tableFooterView.bounds);
    }
    return appendViews;
}

+ (void)collectionViewAppendViewCells:(UICollectionView *)collectionView inset:(UIEdgeInsets)inset complete:(void(^)(NSArray<DRImageAppendImageView *> *collectionViewAppendViews))complete {
    CGFloat x = inset.left;
    CGFloat y = inset.top;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *sections = [NSMutableArray array];
        NSMutableArray *headerFooters = [NSMutableArray array];
        [self getSectionsWithCollectionView:collectionView sectionCount:[collectionView numberOfSections] sections:sections headerFooters:headerFooters x:x y:y complete:^{
            NSMutableArray *appedViews = [NSMutableArray array];
            [appedViews addObjectsFromArray:headerFooters];
            for (NSArray *arr in sections) {
                [appedViews addObjectsFromArray:arr];
            }
            complete(appedViews);
        }];
    });
}

+ (void)getSectionsWithCollectionView:(UICollectionView *)collectionView
                         sectionCount:(NSInteger)sectionCount
                             sections:(NSMutableArray *)sections
                        headerFooters:(NSMutableArray<DRImageAppendImageView *> *)headerFooters
                                    x:(CGFloat)x
                                    y:(CGFloat)y
                             complete:(dispatch_block_t)complete {
    if (sectionCount == sections.count) {
        complete();
        return;
    }
    NSInteger section = sections.count;
    
    UIView *sectionHeaderView = [collectionView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    if (sectionHeaderView != nil) {
        DRImageAppendImageView *sectionHeaderAppendView = [DRImageAppendImageView appendImageViewWithView:sectionHeaderView
                                                                                                  originX:x
                                                                                                  originY:y];
        [headerFooters addObject:sectionHeaderAppendView];
    }
    
    NSMutableArray *cells = [NSMutableArray array];
    [self getCellsInSection:section collectionView:collectionView count:[collectionView numberOfItemsInSection:section] cellsArr:cells x:x y:y complete:^{
        [sections addObject:cells];
        
        UIView *sectionFooterView = [collectionView supplementaryViewForElementKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        if (sectionFooterView != nil) {
            DRImageAppendImageView *sectionFooterAppendView = [DRImageAppendImageView appendImageViewWithView:sectionFooterView
                                                                                                      originX:x
                                                                                                      originY:y];
            [headerFooters addObject:sectionFooterAppendView];
        }
        
        [self getSectionsWithCollectionView:collectionView
                               sectionCount:sectionCount
                                   sections:sections
                              headerFooters:headerFooters
                                          x:x
                                          y:y
                                   complete:complete];
    }];
}

+ (void)getCellsInSection:(NSInteger)section
           collectionView:(UICollectionView *)collectionView
                    count:(NSInteger)count
                 cellsArr:(NSMutableArray<DRImageAppendImageView *> *)cells
                        x:(CGFloat)x
                        y:(CGFloat)y
                 complete:(dispatch_block_t)complete {
    if (count == cells.count) {
        complete();
        return;
    }
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:cells.count inSection:section];
    [collectionView performBatchUpdates:^{
        [collectionView scrollToItemAtIndexPath:cellIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    } completion:^(BOOL finished) {
        if (finished) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:cellIndexPath];
            DRImageAppendImageView *cellAppendView = [DRImageAppendImageView appendImageViewWithView:cell
                                                                                             originX:x
                                                                                             originY:y];
            [cells addObject:cellAppendView];
            [self getCellsInSection:section collectionView:collectionView
                              count:count
                           cellsArr:cells
                                  x:x
                                  y:y
                           complete:complete];
        }
    }];
}

+ (NSArray<DRImageAppendImageView *> *)scrollViewAppendViewCells:(UIScrollView *)scrollView inset:(UIEdgeInsets)inset {
    CGFloat x = inset.left;
    CGFloat y = inset.top;
    NSMutableArray<DRImageAppendImageView *> *appendViews = [NSMutableArray array];
    
    for (UIView *view in scrollView.subviews) {
        DRImageAppendImageView *appendView = [DRImageAppendImageView appendImageViewWithView:view
                                                                                     originX:x
                                                                                     originY:y];
        [appendViews addObject:appendView];
    }
    for (CALayer *layer in scrollView.layer.sublayers) {
        DRImageAppendImageView *appendView = [DRImageAppendImageView appendImageViewWithLayer:layer
                                                                                      originX:x
                                                                                      originY:y];
        [appendViews addObject:appendView];
    }
    
    return appendViews;
}

/// 将视图拼接到一张图，透明背景，0边距
/// @param appendViews 视图数组
/// @param imageSize 图片尺寸
/// @param color 指定图片背景色
+ (UIImage *)imageAppendedFromViews:(NSArray<DRImageAppendImageView *> *)appendViews
                          imageSize:(CGSize)imageSize
                            bgColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    
    // 绘制纯色背景
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    layer.backgroundColor = color.CGColor;
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 图片拼接
    for (DRImageAppendImageView *appendView in appendViews) {
        [appendView.image drawAtPoint:appendView.point];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - utils
//按比例压缩图片大小
- (UIImage*)compressWithScale:(CGFloat)scale {
    CGSize size = self.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    CGSize targetSize = CGSizeMake(scaledWidth, scaledHeight);
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, scaledWidth, scaledHeight)];
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  更改图片颜色
 *
 *  @param color 填充色
 *
 *  @return UIImage
 */
- (UIImage *)changeColorTo:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Cache
+ (UIImage *)imageForKey:(NSString *)key {
    return [UIImage imageWithContentsOfFile:[self imageCachePathForKey:key]];
}

+ (void)cacheImage:(UIImage *)image forKey:(NSString *)key {
    BOOL result = [UIImagePNGRepresentation(image) writeToFile:[self imageCachePathForKey:key]
                                                    atomically:YES];
    if (result) {
        kDR_LOG(@"图片保存成功");
    }
}

+ (void)cleanCache {
    [DRSandBoxManager getDirectoryInDocumentWithName:@"DRBasicKit/ImageCache" doneBlock:^(BOOL success, NSError * _Nonnull error, NSString * _Nonnull dirPath) {
        [DRSandBoxManager deleteFileAtPath:dirPath
                                 doneBlock:^(NSString * _Nonnull filePath, BOOL success, NSError * _Nonnull error) {
            if (success) {
                kDR_LOG(@"已清除图片缓存");
            }
        }];
    }];
}

#pragma mark - private
+ (NSString *)imageCachePathForKey:(NSString *)key {
    __block NSString *cachePath;
    [DRSandBoxManager getFilePathWithName:[NSString stringWithFormat:@"icon_%@@%dx.png", key, (int)[UIScreen mainScreen].scale]
                                    inDir:@"DRBasicKit/ImageCache"
                                doneBlock:^(NSError * _Nonnull error, NSString * _Nonnull filePath) {
        if (!error && filePath) {
            cachePath = filePath;
        }
    }];
    return cachePath;
}

+ (NSString *)rgbaStringFromColor:(UIColor *)color {
    if (!color) {
        return nil;
    }
    
    CGFloat rgba[4];
    [color getRed:&rgba[0] green:&rgba[1] blue:&rgba[2] alpha:&rgba[3]];
    NSMutableString *rgbaStr = [NSMutableString string];
    for (NSInteger i=0; i<4; i++) {
        [rgbaStr appendFormat:@"%@", @(rgba[i]).stringValue];
    }
    return [rgbaStr stringByReplacingOccurrencesOfString:@"." withString:@""];
}

@end


@implementation UIImage (DRWaterMark)

- (UIImage*)imageWaterMarkWithImage:(UIImage *)image imageRect:(CGRect)imgRect alpha:(CGFloat)alpha
{
    return [self imageWaterMarkWithString:nil rect:CGRectZero attribute:nil image:image imageRect:imgRect alpha:alpha];
}

- (UIImage*)imageWaterMarkWithImage:(UIImage*)image imagePoint:(CGPoint)imgPoint alpha:(CGFloat)alpha
{
    return [self imageWaterMarkWithString:nil point:CGPointZero attribute:nil image:image imagePoint:imgPoint alpha:alpha];
}

- (UIImage*)imageWaterMarkWithString:(NSString*)str rect:(CGRect)strRect attribute:(NSDictionary *)attri
{
    return [self imageWaterMarkWithString:str rect:strRect attribute:attri image:nil imageRect:CGRectZero alpha:0];
}

- (UIImage*)imageWaterMarkWithString:(NSString*)str point:(CGPoint)strPoint attribute:(NSDictionary*)attri
{
    return [self imageWaterMarkWithString:str point:strPoint attribute:attri image:nil imagePoint:CGPointZero alpha:0];
}

- (UIImage*)imageWaterMarkWithString:(NSString*)str point:(CGPoint)strPoint attribute:(NSDictionary*)attri image:(UIImage*)image imagePoint:(CGPoint)imgPoint alpha:(CGFloat)alpha
{
    // 开启和原图一样大小的上下文（保证图片不模糊的方法）
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
    [self drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeNormal alpha:1.0];
    if (image) {
        [image drawAtPoint:imgPoint blendMode:kCGBlendModeNormal alpha:alpha];
    }
    
    if (str) {
        [str drawAtPoint:strPoint withAttributes:attri];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
    
}

- (UIImage*)imageWaterMarkWithString:(NSString*)str rect:(CGRect)strRect attribute:(NSDictionary *)attri image:(UIImage *)image imageRect:(CGRect)imgRect alpha:(CGFloat)alpha
{
    // 开启和原图一样大小的上下文（保证图片不模糊的方法）
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    if (image) {
        [image drawInRect:imgRect blendMode:kCGBlendModeNormal alpha:alpha];
    }
    
    if (str) {
        [str drawInRect:strRect withAttributes:attri];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
