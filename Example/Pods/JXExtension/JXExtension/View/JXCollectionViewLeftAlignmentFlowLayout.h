//
//  JXCollectionViewLeftAlignmentFlowLayout.h
//  JXExtension
//
//  Created by Jeason on 2017/8/22.
//  Copyright © 2017年 Jeason.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewLayoutAttributes (LeftAlignment)

- (void)jx_leftAlignmentFrameWithSectionInset:(UIEdgeInsets)sectionInset;

@end

@interface JXCollectionViewLeftAlignmentFlowLayout : UICollectionViewFlowLayout

@end
