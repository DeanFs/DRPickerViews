//
//  DRPickerContainerView.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/2.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRPickerContainerView.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UITabBar+DRExtension.h>
#import <BlocksKit/UIGestureRecognizer+BlocksKit.h>
#import <DRCategories/UIView+DRExtension.h>
#import <HexColors/HexColors.h>

@interface DRPickerContainerView () 

@property (nonatomic, assign) DRPickerShowPosition position;
@property (assign, nonatomic) CGFloat changeToHeight;

@end

@implementation DRPickerContainerView

#pragma mark - 子类中直接调用
- (void)showFromPostion:(DRPickerShowPosition)position {
    self.position = position;
    QCCardContentPosition cardPosition = QCCardContentPositionBottom;
    if (position == DRPickerShowPositionCenter) {
        cardPosition = QCCardContentPositionCenter;
    }
    [QCCardContainerController showContainerWithContentView:self
                                                 atPosition:cardPosition];
}

- (void)dismissComplete:(dispatch_block_t)complete {
    kDRWeakSelf
    [self.cardContainerVc dismissComplete:^{
        [weakSelf viewDidDismiss];
        kDR_SAFE_BLOCK(complete);
    }];
}

- (void)pickerViewHeightChange:(CGFloat)newHeight {
    if (self.position == QCCardContentPositionBottom) {
        [self setupTopSpaceInSafeAreaWithHeight:newHeight];
        [self.cardContainerVc onContentHeightChange];
    } else {
        self.changeToHeight = newHeight;
        [self.cardContainerVc onContentHeightChange];
    }
}

#pragma mark - 子类根据需要重写
// 选择器高度 默认 260
- (CGFloat)pickerViewHeight {
    return 260;
}

// 从中间弹出时，中心偏离距离，默认向上偏离20，即返回-20
- (CGFloat)centerTopOffset {
    return 20;
}

// 圆角半径，默认 16
- (CGFloat)cornerRadius {
    return 16;
}

// 点击空白区域时触发，告知是否dismiss
- (BOOL)shouldDismissWhenTapSpaceArea {
    return YES;
}

// 显示动画已经执行完成
- (void)viewDidShow {
    
}

// 隐藏动画执行完成
- (void)viewDidDismiss {
    
}

#pragma mark - QCCardContentDelegate
- (void)setupCardContainerVc:(QCCardContainerController *)cardContainerVc {
    kDRWeakSelf
    _cardContainerVc = cardContainerVc;
    cardContainerVc.contentCornerRadius = [self cornerRadius];
    cardContainerVc.onShowAnimationDone = ^{
        [weakSelf viewDidShow];
    };
    cardContainerVc.dismissWhenTouchSpaceBlock = ^BOOL{
        return [self shouldDismissWhenTapSpaceArea];
    };
    if (self.position == DRPickerShowPositionBottom) {
        [self setupTopSpaceInSafeAreaWithHeight:[self pickerViewHeight]];
    }
    self.changeToHeight = -1;
}

/// 从中间弹出时，水平方向距离屏幕边缘距离，默认 16pt
- (CGFloat)horizontalPadding {
    return 16;
}

/// 从中间弹出时显示高度，不实现默认：view.height
- (CGFloat)contentHeight {
    if (self.changeToHeight < 0) {
        return [self pickerViewHeight];
    }
    return self.changeToHeight;
}

/// 从中间弹出时，纵向居中向上偏移量，不实现默认：0
- (CGFloat)contentCenterYUpOffset {
    return [self centerTopOffset];
}

#pragma mark - private
- (void)setupTopSpaceInSafeAreaWithHeight:(CGFloat)height {
    CGFloat statusBar = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat space = kDRScreenHeight - [UITabBar safeHeight] - statusBar - height;
    if (space < 0) {
        space = 0;
    }
    self.cardContainerVc.minTopSpaceInSafeArea = space;
}

@end
