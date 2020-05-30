//
//  UIScrollView+QCPullDown.h
//  DRPickerViews_Example
//
//  Created by 冯生伟 on 2020/5/30.
//  Copyright © 2020 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (QCPullDown)

/// 设置ScrollView可以下拉出小程序，每个scrollView仅可以调用一次
/// @param containerView 下拉时整体可以移动的view，不能为空
/// @param onPullChangeBlock 下拉距离实时反馈回调
- (void)setupCanPullDownWithContainerView:(UIView *)containerView
                        onPullChangeBlock:(void(^)(CGFloat pullDistance))onPullChangeBlock;

/// 收起已经下拉的小程序
- (void)foldBack;

@end
