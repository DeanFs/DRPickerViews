//
//  DROptionCardCell.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/7/31.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DROptionCardCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger itemFace;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat itemCornerRadius;
@property (nonatomic, assign) CGSize itemSize;

@end
