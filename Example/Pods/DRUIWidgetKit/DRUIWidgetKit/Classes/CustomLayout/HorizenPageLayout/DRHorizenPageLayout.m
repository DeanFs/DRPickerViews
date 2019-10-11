//
//  DRHorizenPageLayout.m
//  DRUIWidget_Example
//
//  Created by Cyfuer on 2019/10/8.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRHorizenPageLayout.h"

@interface DRHorizenPageLayout ()

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat minItemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) NSInteger itemCount;

/**
 缓存布局信息
 */
@property (nonatomic, strong) NSMutableArray  <UICollectionViewLayoutAttributes *>* cachedAttributes;

@end

@implementation DRHorizenPageLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    // 确保不为空，避免÷0问题
    _columnCount = _columnCount > 0 ? _columnCount : 1;
    _rowCount = _rowCount > 0 ? _rowCount : 1;
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.pagingEnabled = YES;
    [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.itemCount = [self.collectionView numberOfItemsInSection:0];
    
    self.height = CGRectGetHeight(self.collectionView.frame);
    self.width = CGRectGetWidth(self.collectionView.frame) ;
    // 保证每个cell宽度都为0.5的整数倍
    CGFloat rate = 1 / [UIScreen mainScreen].scale;
    self.minItemWidth = floor((self.width - self.sectionInset.left - self.sectionInset.right) / self.columnCount / rate) * rate;
    self.itemHeight = floor((self.height - self.sectionInset.top - self.sectionInset.bottom)/ self.rowCount / rate) * rate;
    
    
    
    [self.cachedAttributes removeAllObjects];
    
  for (NSInteger i=0; i<self.itemCount; i++) {
       NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
       UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
       [self.cachedAttributes addObject:attr];
    }
    
}

- (CGSize)collectionViewContentSize {
    NSInteger pageItemCount = self.rowCount * self.columnCount; // 一页个数
    NSInteger pageCount = self.itemCount / pageItemCount + (self.itemCount % pageItemCount > 0);
    return CGSizeMake(pageCount * self.width, self.height);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.cachedAttributes;
}

// 计算itemframe
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSInteger item = indexPath.item;
    // 总页数
    NSInteger pageNumber = item / (self.rowCount * self.columnCount);
    // 该页中item的序号
    NSInteger itemInPage = item % (self.rowCount * self.columnCount);
    // item的所在列、行
    NSInteger col = itemInPage % self.columnCount;
    NSInteger row = itemInPage / self.columnCount;
    
    CGFloat x = self.sectionInset.left + self.minItemWidth * col + pageNumber * self.width;
    CGFloat y = self.sectionInset.top + self.itemHeight * row ;
    
    CGFloat width = self.minItemWidth;
//    if ((item + 1) % self.columnCount == 0) { // 每行的最后一个item撑满collectionView,可以设置间距
//        width = self.width - (self.columnCount-1) * self.minItemWidth;
//    }
    attri.frame = CGRectMake(x, y, width, self.itemHeight);
    
    return attri;
}


- (void)setColumnCount:(NSInteger)columnCount {
    if (columnCount == 0) return;
    _columnCount = columnCount;
    [self invalidateLayout];
}

- (void)setRowCount:(NSInteger)rowCount {
    if (rowCount == 0) return;
    
    _rowCount = rowCount;
    [self invalidateLayout];
}



- (NSMutableArray<UICollectionViewLayoutAttributes *> *)cachedAttributes {
    if (!_cachedAttributes) {
        _cachedAttributes = @[].mutableCopy;
    }
    return _cachedAttributes;
}
@end
