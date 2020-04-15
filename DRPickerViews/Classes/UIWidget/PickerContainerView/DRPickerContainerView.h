//
//  DRPickerContainerView.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/2.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCCardContainerController.h"

// Dialog弹出方向定义
typedef NS_ENUM(NSInteger, DRPickerShowPosition) {
    DRPickerShowPositionBottom, // 从屏幕底部弹出
    DRPickerShowPositionCenter, // 从屏幕中心弹出
};

@interface DRPickerContainerView : UIView <QCCardContentDelegate>

/// 卡片容器控制器
@property (weak, nonatomic, readonly) QCCardContainerController *cardContainerVc;

#pragma mark - 子类根据需要重写
// 选择器高度 默认 260
- (CGFloat)pickerViewHeight;
// 从中间弹出时，水平方向距离屏幕边缘距离，默认 16pt
- (CGFloat)horizontalPadding;
// 从中间弹出时，中心偏离距离，默认向上偏离20
- (CGFloat)centerTopOffset;
// 圆角半径，默认 16
- (CGFloat)cornerRadius;
// 点击空白区域时触发，告知是否dismiss
- (BOOL)shouldDismissWhenTapSpaceArea;
// 显示动画已经执行完成
- (void)viewDidShow;
// 隐藏动画执行完成
- (void)viewDidDismiss;

#pragma mark - 子类中直接调用
// 弹出显示
- (void)showFromPostion:(DRPickerShowPosition)position;

// 高度变更，调用该方法，动画调整容器高度
- (void)pickerViewHeightChange:(CGFloat)newHeight;

// 隐藏退出
- (void)dismissComplete:(dispatch_block_t)complete;

@end
