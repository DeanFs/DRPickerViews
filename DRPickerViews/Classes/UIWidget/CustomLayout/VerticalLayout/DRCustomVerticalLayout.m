//
//  DRCustomVerticalLayout.m
//  DRUIWidget_Example
//
//  Created by Cyfuer on 2019/10/9.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRCustomVerticalLayout.h"
#import <HexColors/HexColors.h>

@interface DRCustomVerticalLayout ()
/**
 布局缓存
 */
@property (nonatomic, strong) NSMutableArray * cachedAttributes;
/**
 最大contentSize
 */
@property (nonatomic, assign) CGSize contentSize;
@end

@implementation DRCustomVerticalLayout

/**
 继承自collectionViewFlowLayout
 */
- (void)prepareLayout {
    [super prepareLayout];
    /*
     * 此方法会再第一次布局和reloadData()以及invalidateLayout时会调用，
     * 对于那些不会随视图滚动而改变的布局的对象，都应该在这里计算好，进行缓存
     */
    self.collectionView.scrollEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;

    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat insetX = (self.collectionView.bounds.size.width - self.itemSize.width * self.columnsCount - (self.columnsCount - 1) * self.minimumInteritemSpacing)/2.0f;
    
    self.sectionInset = UIEdgeInsetsMake(5, insetX, 5, insetX);
    
    [self caculateAllAttributes];
}


- (void)caculateAllAttributes {
    
    [self.cachedAttributes removeAllObjects];
    
    NSInteger sections = [self.collectionView numberOfSections];
      
      CGFloat maxY = 0;
      
      for (int section = 0; section < sections; section ++) {

          // 判断每个section有多少item
          NSInteger numbers = [self.collectionView numberOfItemsInSection:section];
        
          // TODO: 判header
          UICollectionViewLayoutAttributes *headerAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
          
          if (headerAttr) {
              headerAttr.frame = CGRectMake(0, maxY, self.collectionView.bounds.size.width, self.headerReferenceSize.height);
              maxY = CGRectGetMaxY(headerAttr.frame);
              [self.cachedAttributes addObject:headerAttr];
          }
          
          maxY += self.sectionInset.top;
          
          for (int i = 0; i<numbers; i++) {
              UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section]];
          
               // item的所在列、行
              NSInteger col = i % self.columnsCount;
              NSInteger row = i / self.columnsCount;
              
              CGFloat x = (self.itemSize.width + self.minimumInteritemSpacing) * col + self.sectionInset.left;
              CGFloat y = (self.itemSize.height + self.minimumLineSpacing) * row + maxY;
              
              // 如果在中间需要居中展示
              if (i == numbers - 1 && col == 0 && self.singleItemCenter) {
                  x = self.collectionView.bounds.size.width / 2.0f - self.itemSize.width/2.0f;
              }

              attr.frame = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
          
              [self.cachedAttributes addObject:attr];
              if (i  == numbers - 1) {
                  maxY = CGRectGetMaxY(attr.frame) + self.sectionInset.bottom;
              }
          }
          // 处理sectionHeader
      }
      
      if (maxY < self.collectionView.bounds.size.height) {
          maxY = self.collectionView.bounds.size.height;
      }
      
      self.contentSize = CGSizeMake(self.collectionView.bounds.size.width, maxY);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    NSMutableArray *tmpArr = @[].mutableCopy;
    for (UICollectionViewLayoutAttributes *attr in self.cachedAttributes) {
        if (CGRectContainsRect(rect, attr.frame) || CGRectIntersectsRect(rect, attr.frame)) {
            // 判断处理布局信息
            [tmpArr addObject:attr];
        }
    }
    return tmpArr;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 需要返回原有位置的布局信息
  UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
      
    return attri;
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSMutableArray *)cachedAttributes {
    if (!_cachedAttributes) {
        _cachedAttributes = [[NSMutableArray alloc] init];
    }
    return _cachedAttributes;
}

- (void)setItemSize:(CGSize)itemSize {
    [super setItemSize:itemSize];
    [self invalidateLayout];
}
@end
