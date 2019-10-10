//
//  JXCollectionViewLeftAlignmentFlowLayout.m
//  JXExtension
//
//  Created by Jeason on 2017/8/22.
//  Copyright © 2017年 Jeason.Lee. All rights reserved.
//

#import "JXCollectionViewLeftAlignmentFlowLayout.h"

@implementation UICollectionViewLayoutAttributes (LeftAlignment)

- (void)jx_leftAlignmentFrameWithSectionInset:(UIEdgeInsets)sectionInset {
    CGRect frame = self.frame;
    frame.origin.x = sectionInset.left;
    self.frame = frame;
}

@end

@interface JXCollectionViewLeftAlignmentFlowLayout ()

@property (nonatomic, strong) NSMutableArray *itemAttributes;

@end

@implementation JXCollectionViewLeftAlignmentFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *updateAttributes = [NSMutableArray arrayWithArray:originalAttributes];
    for (UICollectionViewLayoutAttributes *attributes in originalAttributes) {
        if (!attributes.representedElementKind) {
            NSUInteger index = [updateAttributes indexOfObject:attributes];
            updateAttributes[index] = [self layoutAttributesForItemAtIndexPath:attributes.indexPath];
        }
    }
    return updateAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *currentItemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath].copy;
    
    UIEdgeInsets sectionInset = self.sectionInset;
    CGFloat layoutWidth = CGRectGetWidth(self.collectionView.frame) - sectionInset.left - sectionInset.right;
    
    BOOL isFirstItemInSection = indexPath.item == 0;
    if (isFirstItemInSection) {
        [currentItemAttributes jx_leftAlignmentFrameWithSectionInset:sectionInset];
        return currentItemAttributes;
    }
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
    CGRect lastFrame = [self layoutAttributesForItemAtIndexPath:lastIndexPath].frame;
    CGFloat lastFrameRightPoint = lastFrame.origin.x + lastFrame.size.width;
    CGRect currentFrame = currentItemAttributes.frame;
    CGRect changedCurrentFrame = CGRectMake(sectionInset.left, currentFrame.origin.y, layoutWidth, currentFrame.size.height);
    
    BOOL isFirstItemInRow = !CGRectIntersectsRect(lastFrame, changedCurrentFrame);
    if (isFirstItemInRow) {
        [currentItemAttributes jx_leftAlignmentFrameWithSectionInset:sectionInset];
        return currentItemAttributes;
    }
    
    CGRect frame = currentItemAttributes.frame;
    frame.origin.x = lastFrameRightPoint + self.minimumInteritemSpacing;
    currentItemAttributes.frame = frame;
    return currentItemAttributes;
}

@end
