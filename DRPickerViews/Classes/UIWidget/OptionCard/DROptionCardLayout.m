//
//  DROptionCardLayout.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/7/31.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DROptionCardLayout.h"
#import <DRMacroDefines/DRMacroDefines.h>

@interface DROptionCardLayout ()

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, assign) NSInteger itemCount;

@end

@implementation DROptionCardLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.height = CGRectGetHeight(self.collectionView.frame);
    if (self.showPageControl) {
        self.height -= self.pageControlHeight;
    }
    CGFloat columnSpace = self.columnSpace;
    if (kDRScreenWidth < 375) {
        columnSpace *= (kDRScreenWidth / 375);
    }
    self.width = CGRectGetWidth(self.collectionView.frame);
    CGFloat itemWidth = (self.width - (self.columnCount - 1) * columnSpace) / self.columnCount;
    self.itemSize = CGSizeMake(itemWidth, self.lineHeight);
}

- (CGSize)collectionViewContentSize {
    self.itemCount = [self.collectionView numberOfItemsInSection:0];
    NSInteger pageItemCount = self.lineCount * self.columnCount; // 一页个数
    _pageCount = self.itemCount / pageItemCount + (self.itemCount % pageItemCount > 0);
    self.lineSpace = 0;
    if (self.lineCount > 1) { // 多行lineSpace才有意义
        self.lineSpace = (self.height - self.lineCount * self.lineHeight) / (self.lineCount - 1);
    }
    [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    return CGSizeMake(self.pageCount * self.width, self.height);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i=0; i<self.itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        [arr addObject:attr];
    }
    kDR_SAFE_BLOCK(self.layoutDoneBlock);
    return arr;
}

// 计算itemframe
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSInteger item = indexPath.item;
    // 总页数
    NSInteger pageNumber = item / (self.lineCount * self.columnCount);
    // 该页中item的序号
    NSInteger itemInPage = item % (self.lineCount * self.columnCount);
    // item的所在列、行
    NSInteger col = itemInPage % self.columnCount;
    NSInteger row = itemInPage / self.columnCount;
    
    CGFloat x = (self.itemSize.width + self.columnSpace)*col + pageNumber * self.collectionView.bounds.size.width;
    CGFloat y = (self.itemSize.height + self.lineSpace)*row ;
    
    attri.frame = CGRectMake(x, y, self.itemSize.width, self.itemSize.height);
    
    return attri;
}

@end
