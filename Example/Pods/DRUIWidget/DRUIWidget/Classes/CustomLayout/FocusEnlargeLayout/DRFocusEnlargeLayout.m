//
//  DRFocusEnlargeLayout.m
//  DRUIWidget_Example
//
//  Created by Cyfuer on 2019/10/8.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRFocusEnlargeLayout.h"

@interface DRFocusEnlargeLayout ()

@property(nonatomic, assign) CGFloat lastProposedContentOffset;

@end


@implementation DRFocusEnlargeLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

-(void)prepareLayout{
    [super prepareLayout];
    //每个section的inset，用来设定最左和最右item距离边界的距离，此处设置在中间
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) / 2;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

//cell缩放的设置
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    //取出父类算出的布局属性
    //不能直接修改需要copy
    NSArray * original = [super layoutAttributesForElementsInRect:rect];
    NSArray * attsArray = [[NSArray alloc] initWithArray:original copyItems:YES];
    //    NSArray *attsArray = [super layoutAttributesForElementsInRect:rect];
    
    //collectionView中心点的值
    //屏幕中心点对应于collectionView中content位置
    CGFloat centerX = self.collectionView.frame.size.width / 2 + self.collectionView.contentOffset.x;
    //cell中的item一个个取出来进行更改
    for (UICollectionViewLayoutAttributes *atts in attsArray) {
        // cell的中心点x 和 屏幕中心点 的距离
        CGFloat space = ABS(atts.center.x - centerX);
        CGFloat scale = 1 - (space/self.collectionView.frame.size.width/2);
        
        
        
        CGFloat offsetSpace = atts.center.x - centerX;
        
        CGFloat width = self.collectionView.bounds.size.width;
        CGFloat transX = offsetSpace/width/2*atts.size.width*0.1*[UIScreen mainScreen].scale;  // 通过间距进行计算
  
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-transX, 0);
        atts.transform = CGAffineTransformScale(transform, scale, scale);
        atts.alpha = scale;
    }
    return attsArray;
}


//设置滑动停止时的collectionView的位置
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    //1. 获取UICollectionView停止的时候的可视范围
    CGRect rangeFrame;
    rangeFrame.size = self.collectionView.frame.size;
    rangeFrame.origin = proposedContentOffset;
    
    NSArray *array = [self layoutAttributesForElementsInRect:rangeFrame];
    
    //2. 计算在可视范围的距离中心线最近的Item
    CGFloat minCenterX = CGFLOAT_MAX;
    
    CGFloat collectionCenterX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if(ABS(attrs.center.x - collectionCenterX) < ABS(minCenterX)){
            minCenterX = attrs.center.x - collectionCenterX;
        }
    }
    
    //3. 补回ContentOffset，则正好将Item居中显示
    CGFloat proposedX = proposedContentOffset.x + minCenterX;
    
    //4. 滑动阻滞，保证只切回一个视图
    // 滑动一屏时的偏移量
    CGFloat ipageScreenBounds = self.itemSize.width + self.minimumLineSpacing;
    // 正向滑动仅滑动一屏
    if (proposedX - self.lastProposedContentOffset >= ipageScreenBounds) {
        proposedX = ipageScreenBounds + self.lastProposedContentOffset;
    }
    // 反向滑动仅滑动一屏
    if (proposedX - self.lastProposedContentOffset <= -ipageScreenBounds) {
        proposedX = -ipageScreenBounds + self.lastProposedContentOffset;
    }
    
    self.lastProposedContentOffset = proposedX;
    
    CGPoint finialProposedContentOffset = CGPointMake(proposedX, proposedContentOffset.y);
    return finialProposedContentOffset;
}

@end
