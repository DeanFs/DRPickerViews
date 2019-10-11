//
//  DRCustomPageControl.h
//  XHPageControl
//
//  Created by Cyfuer on 2019/10/9.
//  Copyright © 2019 xuanhe. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

typedef NS_ENUM(NSUInteger,DRPageControlPositionType){
    DRPageControlPositionTypeMiddle = 0,    // 整体居中
    DRPageControlPositionTypeRight,         // 整体靠右
    DRPageControlPositionTypeLeft           // 整体靠左
};

@interface DRCustomPageControl : UIView

//其他点是高度的倍数,默认1
@property(nonatomic) NSInteger normalRatio;
//当前点h是高度的倍数,默认2
@property(nonatomic) IBInspectable NSInteger currentRatio;
/*
 分页数量
 */
@property(nonatomic) IBInspectable NSInteger numberOfPages;
/*
 当前点所在下标
 */
@property(nonatomic) IBInspectable NSInteger currentPage;
/*
 点的高度
 */
@property(nonatomic) IBInspectable NSInteger controlHeight;
/*
 点的间距
 */
@property(nonatomic) IBInspectable NSInteger controlSpacing;
/*
 其他未选中点颜色
 */
@property(nonatomic,strong) IBInspectable UIColor *normalColor;
/*
 当前点颜色
 */
@property(nonatomic,strong) IBInspectable UIColor *currentColor;


/**
 是否可以点击， 默认不可点击
 */
@property (nonatomic, assign) BOOL actionAble;
/**
 点击了pageControl上某个点
 */
@property (nonatomic, copy) void (^tapAction)(NSInteger tapIndex);

/**
 控件位置,默认中间
 */
@property (nonatomic, assign) DRPageControlPositionType positionType;
/*
 当前点背景图片
 */
@property(nonatomic,strong) UIImage *currentBkImg;

/*
 其他点背景图片
 */
@property(nonatomic,strong) UIImage *normalBkImg;

@end
