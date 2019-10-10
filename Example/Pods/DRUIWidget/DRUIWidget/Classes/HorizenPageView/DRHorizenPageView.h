//
//  DRHorizenPageView.h
//  DRUIWidget_Example
//
//  Created by Cyfuer on 2019/10/9.
//  Copyright © 2019 Dean_F. All rights reserved.
//
/**
 水平布局视图view
 */
#import <UIKit/UIKit.h>

@class DRHorizenPageView;

@protocol DRHorizenPageViewDelegate  <NSObject>

- (void)pageView:(DRHorizenPageView *)pageView didTapCell:(UICollectionViewCell *)cell atIndex:(NSIndexPath *)indexPath;

@required
/**
 配置Cell展示样式
 */
- (void)pageView:(DRHorizenPageView *)pageView configurateCell:(__kindof UICollectionViewCell *)cell forIndex:(NSIndexPath *)indexPath;

@end



IB_DESIGNABLE

@interface DRHorizenPageView : UIView

/**
 注册Cell
 */
- (void)registerCell:(Class)cell withIdentifier:(NSString *)identifier;

- (void)registerCellWithNib:(UINib *)nib withIdentifier:(NSString *)identifier;

/**
 代理
 */
@property (nonatomic, weak) id <DRHorizenPageViewDelegate> delegate;

/**
 总共几行
 */
@property (nonatomic, assign) IBInspectable NSInteger rowCount;

/**
 总共几列
 */
@property (nonatomic, assign) IBInspectable NSInteger colunmCount;

/**
 数据源信息
 */
@property (nonatomic, strong) NSArray * datasource;

#pragma mark - 分页符处理

/**
 是否显示分页符, 默认为NO
 */
@property (nonatomic, assign) IBInspectable BOOL showPageControl;

/*
 其他未选中点颜色
 */
@property(nonatomic,strong) IBInspectable UIColor *normalColor;

/*
 当前点颜色
 */
@property(nonatomic,strong) IBInspectable UIColor *currentColor;

//当前点h是高度的倍数,默认2, 1 是圆点
@property(nonatomic) IBInspectable NSInteger currentRatio;


/*
 * 1. 需要传入cell
 * 2. cell的尺寸大小
 * 3. 间距信息
 * 4. pageControl
 * 5. 联动效果
 * 6. 点击事件
 */

@end

