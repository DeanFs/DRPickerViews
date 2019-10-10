//
//  DRHorizenPageLayout.h
//  DRUIWidget_Example
//
//  Created by Cyfuer on 2019/10/8.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface DRHorizenPageLayout : UICollectionViewFlowLayout

/**
 每页有多少列
 */
@property (nonatomic, assign) IBInspectable NSInteger columnCount;

/**
 每页最多有几行
 */
@property (nonatomic, assign) IBInspectable NSInteger rowCount;

@end

