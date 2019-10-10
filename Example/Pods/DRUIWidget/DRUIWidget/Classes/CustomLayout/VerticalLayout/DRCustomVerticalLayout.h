//
//  DRCustomVerticalLayout.h
//  DRUIWidget_Example
//
//  Created by Cyfuer on 2019/10/9.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface DRCustomVerticalLayout : UICollectionViewFlowLayout

/**
 共多少列
 */
@property (nonatomic, assign) IBInspectable NSInteger columnsCount;

/**
 一行只有一个是否居中，默认为NO
 */
@property (nonatomic, assign) IBInspectable BOOL singleItemCenter;

@end

NS_ASSUME_NONNULL_END
