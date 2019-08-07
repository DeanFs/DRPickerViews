//
//  DRPickerContainerView.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/2.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DRPickerShowPosition) {
    DRPickerShowPositionBottom,
    DRPickerShowPositionCenter,
    DRPickerShowPositionTop
};

@interface DRPickerContainerView : UIView

#pragma mark - 子类根据需要重写
// 水平方向距离屏幕边缘距离，默认 16
- (CGFloat)horizontalPadding;
// 选择器高度 默认 260
- (CGFloat)picerViewHeight;
// 底部距离安全区域边缘距离 默认 16
- (CGFloat)bottomPaddingFromSafeArea;
// 顶部距离状态栏的距离 默认 16
- (CGFloat)topPaddingFromStatusBar;
// 从中间弹出时，中心偏离距离，默认向上偏离20，即返回-20
// 圆角半径，默认 12
- (CGFloat)cornerRadius;

#pragma mark - 子类中直接调用
// 高不调整
- (void)pickerViewHeightChange:(CGFloat)newHeight;
// 弹出显示
- (void)showFromPostion:(DRPickerShowPosition)position;
// 隐藏退出
- (void)dismiss;

@end
