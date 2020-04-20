//
//  DROptionCardLayout.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/7/31.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DROptionCardLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, assign) CGFloat columnSpace;
@property (nonatomic, assign) NSInteger lineCount;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) BOOL showPageControl;
@property (assign, nonatomic) CGFloat pageControlTopSpace;
@property (nonatomic, assign) CGFloat pageControlHeight;
@property (nonatomic, assign, readonly) CGFloat pageWidth;
@property (nonatomic, assign, readonly) NSInteger pageCount;
@property (nonatomic, copy) dispatch_block_t layoutDoneBlock;

@end
