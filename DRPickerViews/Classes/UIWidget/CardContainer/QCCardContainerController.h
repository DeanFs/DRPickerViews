//
//  QCCardContainerController.h
//  Records
//
//  Created by 冯生伟 on 2020/4/8.
//  Copyright © 2020 DuoRong Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QCCardContentPosition) {
    QCCardContentPositionBottom,
    QCCardContentPositionCenter
};

@class QCCardContainerController;
@protocol QCCardContentDelegate <NSObject>

/// 设置卡片控制器的属性
/// @param cardContainerVc 卡片控制器，若要引用cardContainerVc需要使用 weak 弱引用
- (void)setupCardContainerVc:(QCCardContainerController *)cardContainerVc;

/// 插入到卡片容器的视图View.SubViews中，
/// 有铺满整个View的，用于支持滑动退出的可滚视图
/// 如果没有，可返回nil，
/// 如待插入到卡片的ViewController.view中，有一个撑满的tableView，
/// 则这里返回这个tableView
- (UIScrollView *)supportCardPanCloseScrollView;

@optional
#pragma mark - 卡片页面的生命周期
- (void)card_viewDidLoad;
- (void)card_viewWillAppear:(BOOL)animated;
- (void)card_viewDidAppear:(BOOL)animated;
- (void)card_viewDidLayoutSubviews;
- (void)card_viewWillDisappear:(BOOL)animated;
- (void)card_viewDidDisappear:(BOOL)animated;

#pragma mark - 从中间弹出时可选实现，加载ViewController时必须实现
/// 从中间弹出时水平距离屏幕间距，不实现默认：40pt
- (CGFloat)horizontalPadding;

/// 从中间弹出时，显示宽度，不实现默认：view.width，与horizontalPadding二选一实现
- (CGFloat)contentWidth;

/// 从中间弹出时显示高度，不实现默认：view.height
- (CGFloat)contentHeight;

/// 从中间弹出时，纵向居中向上偏移量，不实现默认：0
- (CGFloat)contentCenterYUpOffset;

@end

@class QCCardContainerBaseService;
@interface QCCardContainerController : UIViewController

#pragma mark - 操作及显示控制
/// 点击右边按钮后自动退出页面，默认：YES，contentVc及service类型弹出才有效
@property (assign, nonatomic) BOOL autoDismissWhenRightButtonAction;
/// 允许下滑退出，默认YES，从底部弹出才有效
@property (assign, nonatomic) BOOL allowPanClose;
/// 根据内容自适应高度，默认：YES，service类型弹出才有效
@property (assign, nonatomic) BOOL autoFitHeight;
/// 当内容不足时也允许回弹效果，默认：YES
@property (assign, nonatomic) BOOL alwaysBounceVertical;
/// 在安全距离内，顶部预留的最小空间，默认 24
@property (assign, nonatomic) CGFloat minTopSpaceInSafeArea;
/// 最小显示高度，默认：50
@property (assign, nonatomic) CGFloat minContentHeight;
/// 内容区域显示圆角，默认：16
@property (assign, nonatomic) CGFloat contentCornerRadius;
/// 入场动画执行完成
@property (copy, nonatomic) dispatch_block_t onShowAnimationDone;
/// 出场动画执行完成
@property (copy, nonatomic) dispatch_block_t onHideAnimationDone;
/// 点击空白区域是否退出页面，不实现默认：YES，可用于捕获点击空白区域事件
@property (copy, nonatomic) BOOL(^dismissWhenTouchSpaceBlock)(void);

#pragma mark - 顶部栏，以下至少有一项不为空时才显示顶部栏，contentVc及service类型弹出才有效，且从底部弹出
/// 左边按钮标题，与leftButtonImage互斥
@property (copy, nonatomic) NSString *leftButtonTitle;
/// 左边按钮图标，与leftButtonTitle互斥
@property (strong, nonatomic) UIImage *leftButtonImage;
/// 左边按钮在设置点击回调后自动高亮，默认：YES
@property (assign, nonatomic) BOOL leftButtonAutoHighlight;
/// 左边按钮点击事件，设置非空回调后，若leftButtonAutoHighlight=YES，则左边按钮显示高亮
@property (copy, nonatomic) dispatch_block_t onLeftButtonTapBlock;
/// 点击标题的响应，设置非空回调后，标题高亮显示
@property (copy, nonatomic) dispatch_block_t onTitleTapBlock;
/// 右边按钮是否可点
@property (assign, nonatomic) BOOL rightButtonEnble;
/// 右边按钮标题，默认：若弹出UIViewController则按钮为"保存"，否则"确定"
@property (copy, nonatomic) NSString *rightButtonTitle;
/// 右边按钮点击响应
@property (copy, nonatomic) dispatch_block_t onRightButtonTapBlock;

#pragma mark - 底部悬浮按钮，如取消，添加等，contentVc及service类型弹出才有效，且从底部弹出
/// 在底部悬浮显示按钮，默认：NO
@property (assign, nonatomic) BOOL showBottomBar;
/// 默认：取消
@property (copy, nonatomic) NSString *bottomBarTitle;
/// 默认：空
@property (strong, nonatomic) UIImage *bottomBarIcon;
/// 默认：#3C3C43,不透明85%
@property (strong, nonatomic) UIColor *bottomBarTintColor;
/// 默认：空
@property (copy, nonatomic) dispatch_block_t onBottomBarTappedBlock;
/// 默认：4pt
@property (assign, nonatomic) CGFloat bottomBarTopSpace;
/// 自定义底部视图
@property (strong, nonatomic) UIView *customBottomBar;

#pragma mark - API
/// 通过业务管理类，定义显示内容
/// @param service 业务逻辑
+ (void)showContainerWithService:(QCCardContainerBaseService *)service;

/// 将contentVc添加到卡片中显示
/// @param contentVc 内容vc
/// @param position 弹出位置
+ (void)showContainerWithContentVc:(UIViewController<QCCardContentDelegate> *)contentVc
                        atPosition:(QCCardContentPosition)position;

/// 将contentView添加到卡片中显示
/// @param contentView 内容vc
/// @param position 弹出位置
+ (void)showContainerWithContentView:(UIView<QCCardContentDelegate> *)contentView
                          atPosition:(QCCardContentPosition)position;

/// 更新高度，重新读取高度相关信息，动画更新展示高度
/// autoFitHeight = YES 自适应高度时无效
- (void)onContentHeightChange;

/// 卡片内容区域的内容发生变更
- (void)onContentViewChange;

/// 退出页面
- (void)dismissComplete:(dispatch_block_t)complete;

/// 用于获取真实页面
- (UIViewController *)topViewController;

@end
