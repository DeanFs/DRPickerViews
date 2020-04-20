//
//  DROptionCardView.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/7/31.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DROptionCardView : UIView

@property (nonatomic, assign) IBInspectable NSInteger columnCount;      // default 3
@property (nonatomic, assign) IBInspectable CGFloat columnSpace;        // default 6.5
@property (nonatomic, assign) IBInspectable NSInteger lineCount;        // default 3
@property (nonatomic, assign) IBInspectable CGFloat lineHeight;         // default 32
@property (nonatomic, assign) IBInspectable CGFloat fontSize;           // default 13
@property (nonatomic, assign) IBInspectable CGFloat itemCornerRadius;   // default 16
@property (nonatomic, assign) IBInspectable BOOL mutableSelection;      // default NO
@property (nonatomic, assign) IBInspectable NSInteger maxSelectCount;   // default 3, effective when mutableSelection is YES
@property (nonatomic, copy) IBInspectable NSString *beyondMaxAlert;     // 多余最大限制的提示文案
@property (nonatomic, assign) IBInspectable NSInteger minSelectCount;   // default 1, effective when mutableSelection is YES
@property (nonatomic, assign) IBInspectable NSString *belowMinAlert;     // 低于最低限制的提示文案
@property (nonatomic, assign) IBInspectable BOOL showPageControl;      // 超过一页时，显示分页控制器 default NO
@property (nonatomic, assign) IBInspectable CGFloat pageControlHeight; // 分页控制器显示高度        default 30
@property (strong, nonatomic) IBInspectable UIColor *pageControlTintColor;
@property (strong, nonatomic) IBInspectable UIColor *pageControlCurrentColor;
@property (assign, nonatomic) IBInspectable UIEdgeInsets contentInset;

@property (nonatomic, strong) NSArray<NSString *> *allOptions;
@property (nonatomic, strong) NSArray<NSString *> *selectedOptions;     // 反显
@property (nonatomic, strong) NSArray<NSNumber *> *selectedIndexs;

@property (nonatomic, copy) void (^onSelectionChangeBlock)(NSArray<NSString *> *selectedOptions, NSArray<NSNumber *> *selectedIndexs);

- (void)reloadData;

/// setup自定义选项Cell
/// @param registerBlock 注册Cell回调
/// @param getCellBlock 获取Cell回调
- (void)setupCustomCellWithRegisterBlock:(void (^)(UICollectionView *collectionView))registerBlock
                getCellForIndexPathBlock:(UICollectionViewCell *(^)(UICollectionView *collectionView,
                                                                    NSIndexPath *indexPath,
                                                                    id optionModel))getCellBlock;

@end
