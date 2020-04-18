//
//  QCCardContainerController.m
//  Records
//
//  Created by 冯生伟 on 2020/4/8.
//  Copyright © 2020 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "QCCardContainerController.h"
#import <RTRootNavigationController/RTRootNavigationController.h>
#import <Aspects/Aspects.h>
#import <Masonry/Masonry.h>
#import <BlocksKit/NSObject+BKBlockObservation.h>
#import <BlocksKit/UIGestureRecognizer+BlocksKit.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIView+DRExtension.h>
#import <DRCategories/UITabBar+DRExtension.h>
#import <DRCategories/UIFont+DRExtension.h>
#import <objc/message.h>
#import "QCCardContainerBaseService.h"
#import "DRUIWidgetUtil.h"

#define kHeaderBarHeight 56
#define kBottomBarHeight 56
#define kMinPanSpace 80

@interface QCCardContainerController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIView *containerView;
@property (weak, nonatomic) UIView *headerBarView;
@property (weak, nonatomic) UIButton *titleButton;
@property (weak, nonatomic) UIButton *leftButton;
@property (weak, nonatomic) UIButton *rightButton;
@property (weak, nonatomic) DRDragSortTableView *tableView;
@property (weak, nonatomic) UIView *bottomBarView;

@property (assign, nonatomic) QCCardContentPosition position;
@property (strong, nonatomic) QCCardContainerBaseService *service;
@property (strong, nonatomic) id<QCCardContentDelegate> contentObj;
@property (assign, nonatomic) UIStatusBarStyle statusBarStyle;
@property (assign, nonatomic) CGFloat topBarHeight;
@property (assign, nonatomic) CGFloat bottomBarHeight;
@property (assign, nonatomic) CGFloat maxHeight;
@property (assign, nonatomic) BOOL firstLayout;
@property (strong, nonatomic) NSMutableArray<id<AspectToken>> *aspectTokens;
@property (assign, nonatomic) CGFloat normalTop;

@end

@implementation QCCardContainerController

#pragma mark - API
/// 通过业务管理类，定义显示内容
/// @param service 业务逻辑
+ (void)showContainerWithService:(QCCardContainerBaseService *)service {
    QCCardContainerController *card = [[QCCardContainerController alloc] initWithPosition:QCCardContentPositionBottom];
    card.autoFitHeight = YES;
    card.service = service;
    [self showCardContainer:card];
}

/// 将contentVc添加到卡片中显示
/// @param contentVc 内容vc
/// @param position 弹出位置
+ (void)showContainerWithContentVc:(UIViewController<QCCardContentDelegate> *)contentVc
                        atPosition:(QCCardContentPosition)position {
    QCCardContainerController *card = [[QCCardContainerController alloc] initWithPosition:position];
    card.contentObj = contentVc;
    [self showCardContainer:card];
}

/// 将contentView添加到卡片中显示
/// @param contentView 内容vc
/// @param position 弹出位置
+ (void)showContainerWithContentView:(UIView<QCCardContentDelegate> *)contentView
                          atPosition:(QCCardContentPosition)position {
    QCCardContainerController *card = [[QCCardContainerController alloc] initWithPosition:position];
    card.contentObj = contentView;
    [self showCardContainer:card];
}

/// 更新高度，重新读取高度相关信息，动画更新展示高度
- (void)onContentHeightChange {
    if (self.autoFitHeight) {
        return;
    }
    if (self.position == QCCardContentPositionBottom) {
        self.maxHeight = kDRScreenHeight - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - self.minTopSpaceInSafeArea + self.contentCornerRadius;
        [self animationChangeHeight:self.maxHeight];
    } else if (self.position == QCCardContentPositionCenter) {
        CGFloat width = kDRScreenWidth - 80;
        CGFloat height = self.maxHeight;
        CGFloat offsetY = 0;
        if ([self.contentObj respondsToSelector:@selector(horizontalPadding)]) {
            width = kDRScreenWidth - [self.contentObj horizontalPadding] * 2;
        } else if ([self.contentObj respondsToSelector:@selector(contentWidth)]) {
            width = [self.contentObj contentWidth];
        }
        if ([self.contentObj respondsToSelector:@selector(contentHeight)]) {
            height = [self.contentObj contentHeight];
        }
        if ([self.contentObj respondsToSelector:@selector(contentCenterYUpOffset)]) {
            offsetY = [self.contentObj contentCenterYUpOffset];
        }
        if (height > self.maxHeight) {
            height = self.maxHeight;
        }
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, height));
            make.centerY.mas_offset(-offsetY);
        }];
    }
}

/// 卡片内容区域的内容发生变更
- (void)onContentViewChange {
    [self setupPanClose];
}

/// 退出页面
- (void)dismissComplete:(dispatch_block_t)complete {
    for (id<AspectToken> token in self.aspectTokens) {
        [token remove];
    }
    if (self.position == QCCardContentPositionBottom) {
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kDRScreenHeight);
        }];
        [UIView animateWithDuration:kDRAnimationDuration animations:^{
            self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:^{
                kDR_SAFE_BLOCK(complete);
                kDR_SAFE_BLOCK(self.onHideAnimationDone);
            }];
        }];
    } else if (self.position == QCCardContentPositionCenter) {
        [UIView animateWithDuration:kDRAnimationDuration animations:^{
            self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
            self.containerView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.containerView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:^{
                kDR_SAFE_BLOCK(complete);
                kDR_SAFE_BLOCK(self.onHideAnimationDone);
            }];
        }];
    }
}

/// 用于获取真实页面
- (UIViewController *)topViewController {
    if ([self.contentObj isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)self.contentObj;
    }
    return self;
}

#pragma mark - TopBar property set
/// left button
- (void)setLeftButtonTitle:(NSString *)leftButtonTitle {
    _leftButtonTitle = leftButtonTitle;
    [self.leftButton setTitle:leftButtonTitle forState:UIControlStateNormal];
    self.leftButton.hidden = NO;
    if (leftButtonTitle.length > 0) {
        self.leftButtonImage = nil;
    } else if (self.leftButtonImage == nil) {
        self.leftButton.hidden = YES;
    }
}

- (void)setLeftButtonImage:(UIImage *)leftButtonImage {
    _leftButtonImage = [leftButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.leftButton setImage:leftButtonImage forState:UIControlStateNormal];
    self.leftButton.hidden = NO;
    if (leftButtonImage != nil) {
        self.leftButtonTitle = nil;
    } else if (self.leftButtonTitle.length == 0) {
        self.leftButton.hidden = YES;
    }
}

- (void)setOnLeftButtonTapBlock:(dispatch_block_t)onLeftButtonTapBlock {
    _onLeftButtonTapBlock = onLeftButtonTapBlock;
    if (self.leftButtonAutoHighlight) {
        if (onLeftButtonTapBlock != nil) {
            [self.leftButton setTitleColor:[DRUIWidgetUtil highlightColor] forState:UIControlStateNormal];
            self.leftButton.tintColor = [DRUIWidgetUtil highlightColor];
        } else {
            [self.leftButton setTitleColor:[DRUIWidgetUtil cancelColor] forState:UIControlStateNormal];
            self.leftButton.tintColor = [DRUIWidgetUtil cancelColor];
        }
    }
}

/// center button
- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    [self.titleButton setTitle:title forState:UIControlStateNormal];
    self.titleButton.hidden = NO;
    if (title.length == 0) {
        self.titleButton.hidden = YES;
    }
}

- (void)setOnTitleTapBlock:(dispatch_block_t)onTitleTapBlock {
    _onTitleTapBlock = onTitleTapBlock;
    self.titleButton.userInteractionEnabled = NO;
    if (onTitleTapBlock != nil) {
        self.titleButton.userInteractionEnabled = YES;
        [self.titleButton setTitleColor:[DRUIWidgetUtil highlightColor] forState:UIControlStateNormal];
    } else {
        [self.titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

/// right button
- (void)setRightButtonEnble:(BOOL)rightButtonEnble {
    _rightButtonEnble = rightButtonEnble;
    self.rightButton.enabled = rightButtonEnble;
}

- (void)setRightButtonTitle:(NSString *)rightButtonTitle {
    _rightButtonTitle = rightButtonTitle;
    [self.rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
}

#pragma mark - lifecycle
- (instancetype)initWithPosition:(QCCardContentPosition)position {
    if (self = [super init]) {
        _statusBarStyle = [[DRUIWidgetUtil topViewController] preferredStatusBarStyle];
        _firstLayout = YES;
        _autoDismissWhenRightButtonAction = YES;
        _allowPanClose = YES;
        _autoFitHeight = NO;
        _alwaysBounceVertical = YES;
        _contentCornerRadius = 16;
        _minTopSpaceInSafeArea = 24;
        _minContentHeight = 50;
        _leftButtonAutoHighlight = YES;
        _showBottomBar = NO;
        _bottomBarTitle = @"取消";
        _bottomBarTintColor = [DRUIWidgetUtil cancelColor];
        _bottomBarTopSpace = 4;
        _position = position;
        
        UIView *containerView = [[UIView alloc] init];
        containerView.backgroundColor = [UIColor clearColor];
        containerView.layer.cornerRadius = self.contentCornerRadius;
        containerView.clipsToBounds = YES;
        containerView.hidden = YES;
        _containerView = containerView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.service != nil) {
        self.service.navigationController = self.navigationController;
        self.service.containerVc = self;
        self.service.view = self.view;
        [self.service setupCardContainerViwContoller];
    } else {
        [self.contentObj setupCardContainerVc:self];
    }
    [self.service viewDidLoad];
    if ([self.contentObj respondsToSelector:@selector(card_viewDidLoad)]) {
        [self.contentObj card_viewDidLoad];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    if (self.containerView.hidden) {
        [self initSubviews];
        [self setupPanClose];
        if (self.position == QCCardContentPositionBottom) {
            if (!self.autoFitHeight || self.service == nil) {
                [self animationChangeHeight:self.maxHeight];
            }
        } else {
            self.containerView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.containerView.hidden = NO;
                self.containerView.alpha = 0.0f;
                [UIView animateWithDuration:kDRAnimationDuration animations:^{
                    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.24];
                    self.containerView.transform = CGAffineTransformIdentity;
                    self.containerView.alpha = 1.0f;
                } completion:^(BOOL finished) {
                    kDR_SAFE_BLOCK(self.onShowAnimationDone);
                }];
            });
        }
    }
    if ([self.contentObj respondsToSelector:@selector(card_viewWillAppear:)]) {
        [self.contentObj card_viewWillAppear:animated];
    }
    [self.service viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.contentObj respondsToSelector:@selector(card_viewDidAppear:)]) {
        [self.contentObj card_viewDidAppear:animated];
    }
    [self.service viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.firstLayout) {
        self.firstLayout = NO;
        if (self.position == QCCardContentPositionBottom) {
            [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(kDRScreenHeight);
            }];
            [UIView performWithoutAnimation:^{
                [self.view layoutIfNeeded];
            }];
        }
    }
    if ([self.contentObj respondsToSelector:@selector(card_viewDidLayoutSubviews)]) {
        [self.contentObj card_viewDidLayoutSubviews];
    }
    [self.service viewDidLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.contentObj respondsToSelector:@selector(card_viewWillDisappear:)]) {
        [self.contentObj card_viewWillDisappear:animated];
    }
    [self.service viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([self.contentObj respondsToSelector:@selector(card_viewDidDisappear:)]) {
        [self.contentObj card_viewDidDisappear:animated];
    }
    [self.self.service viewDidDisappear:animated];
}

- (void)dealloc {
    kDR_LOG(@"%@ dealloc and removeObserver", [self class])
}

#pragma mark - setup views
- (void)initSubviews {
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    [self.view addSubview:self.containerView];
    if (self.position == QCCardContentPositionBottom) {
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_offset(0);
            make.width.mas_equalTo(kDRScreenWidth);
            make.height.mas_equalTo(kDRScreenHeight);
        }];
        self.maxHeight = kDRScreenHeight - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - self.minTopSpaceInSafeArea + self.contentCornerRadius;
        [self setupHeaderBar];
        [self setupBottomBar];
        if (self.service != nil) {
            [self setupTableView];
            self.service.tableView = self.tableView;
            [self.service registerTableViewCells];
            self.tableView.dr_dragSortDelegate = self.service;
        } else {
            [self setupContentObj];
        }
    } else {
        self.maxHeight = kDRScreenHeight - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)*2;
        CGFloat width = kDRScreenWidth - 80;
        CGFloat height = self.maxHeight;
        CGFloat offsetY = 0;
        if ([self.contentObj respondsToSelector:@selector(horizontalPadding)]) {
            width = kDRScreenWidth - [self.contentObj horizontalPadding] * 2;
        } else if ([self.contentObj respondsToSelector:@selector(contentWidth)]) {
            width = [self.contentObj contentWidth];
        }
        if ([self.contentObj respondsToSelector:@selector(contentHeight)]) {
            height = [self.contentObj contentHeight];
        }
        if ([self.contentObj respondsToSelector:@selector(contentCenterYUpOffset)]) {
            offsetY = [self.contentObj contentCenterYUpOffset];
        }
        if (height > self.maxHeight) {
            height = self.maxHeight;
        }
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_offset(0);
            make.centerY.mas_offset(-offsetY);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        [self setupContentObj];
    }
}

- (void)setupContentObj {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *contentView = (UIView *)self.contentObj;
        if ([self.contentObj isKindOfClass:[UIViewController class]]) {
            [self addChildViewController:(UIViewController *)self.contentObj];
            contentView = ((UIViewController *)self.contentObj).view;
        }
        [self.containerView addSubview:contentView];
        if (self.position == QCCardContentPositionBottom) {
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(self.topBarHeight);
                make.bottom.mas_offset(-self.bottomBarHeight);
                make.left.right.mas_offset(0);
            }];
        } else {
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.right.mas_offset(0);
            }];
        }
    });
}

- (void)setupHeaderBar {
    self.topBarHeight = 0;
    if (![self.contentObj isKindOfClass:[UIView class]]) {
        /// 标题
        if (self.title != nil) {
            [self.titleButton setTitle:self.title forState:UIControlStateNormal];
            self.topBarHeight = kHeaderBarHeight;
            if (self.title.length == 0) {
                self.titleButton.hidden = YES;
            }
        }
        
        // 左边按钮
        if (self.topBarHeight > 0 ||
            self.leftButtonTitle != nil ||
            self.leftButtonImage != nil ||
            self.onLeftButtonTapBlock != nil) {
            if (self.leftButtonTitle == nil && self.leftButtonImage == nil) {
                [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
            } else {
                if (self.leftButtonImage != nil) {
                    [self.leftButton setImage:self.leftButtonImage forState:UIControlStateNormal];
                } else if (self.leftButtonTitle.length > 0) {
                    [self.leftButton setTitle:self.leftButtonTitle forState:UIControlStateNormal];
                } else {
                    self.leftButton.hidden = YES;
                }
            }
            self.topBarHeight = kHeaderBarHeight;
        }
        
        // 确定/保存按钮
        if (self.rightButtonTitle.length > 0 ||
            self.onRightButtonTapBlock != nil) {
            if (self.rightButtonTitle == nil) {
                [self.rightButton setTitle:@"确定" forState:UIControlStateNormal];
                if ([self.contentObj isKindOfClass:[UIViewController class]]) {
                    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
                }
            }
            self.topBarHeight = kHeaderBarHeight;
        }
    }
}

- (void)setupBottomBar {
    kDRWeakSelf
    self.bottomBarHeight = [UITabBar safeHeight] + self.contentCornerRadius;
    if (![self.contentObj isKindOfClass:[UIView class]]) {
        if (self.customBottomBar != nil) {
            self.bottomBarHeight += self.customBottomBar.height;
            [self.bottomBarView addSubview:self.customBottomBar];
            [self.customBottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_offset(0);
                make.height.mas_equalTo(weakSelf.customBottomBar.height);
            }];
            self.customBottomBar = nil;
        } else {
            if (self.showBottomBar) {
                self.bottomBarHeight += (kBottomBarHeight + self.bottomBarTopSpace);
                
                UIView *line = [[UIView alloc] init];
                line.backgroundColor = [DRUIWidgetUtil thickLineColor];
                if (self.bottomBarTopSpace < 1) {
                    line.backgroundColor = [DRUIWidgetUtil borderColor];
                }
                [self.bottomBarView addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.mas_offset(0);
                    make.height.mas_equalTo(weakSelf.bottomBarTopSpace);
                }];
                
                UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
                actionButton.titleLabel.font = [UIFont dr_PingFangSC_MediumWithSize:15];
                actionButton.tintColor = self.bottomBarTintColor;
                [actionButton setTitleColor:self.bottomBarTintColor forState:UIControlStateNormal];
                [actionButton setTitle:@"取消" forState:UIControlStateNormal];
                if (self.bottomBarTitle.length > 0) {
                    [actionButton setTitle:self.bottomBarTitle forState:UIControlStateNormal];
                }
                if (self.bottomBarIcon != nil) {
                    UIImage *image = [self.bottomBarIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    [actionButton setImage:image forState:UIControlStateNormal];
                    [actionButton setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 0)];
                }
                [actionButton addTarget:self action:@selector(onBottomBarTappedAction) forControlEvents:UIControlEventTouchUpInside];
                [self.bottomBarView addSubview:actionButton];
                [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_offset(weakSelf.bottomBarTopSpace);
                    make.height.mas_equalTo(kBottomBarHeight);
                    make.left.right.mas_offset(0);
                }];
            }
        }
    }
    [self.bottomBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_offset(0);
        make.height.mas_equalTo(weakSelf.bottomBarHeight);
    }];
}

- (void)setupTableView {
    kDRWeakSelf
    DRDragSortTableView *tableView = [[DRDragSortTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if (self.autoFitHeight) {
        id token1 = [tableView aspect_hookSelector:@selector(reloadData) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf countHeight];
            });
        } error:nil];
        id token2 = [tableView aspect_hookSelector:@selector(endUpdates) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDRAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf countHeight];
            });
        } error:nil];
        [self.aspectTokens addObject:token1];
        [self.aspectTokens addObject:token2];
    }
    [self.containerView addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(weakSelf.topBarHeight);
        make.bottom.mas_offset(-weakSelf.bottomBarHeight);
        make.left.right.mas_offset(0);
    }];
    self.tableView = tableView;
}

- (void)setupPanClose {
    BOOL allowPan = self.allowPanClose && self.position == QCCardContentPositionBottom;
    if (!allowPan) {
        return;
    }
    
    // 显示顶部栏则给顶部栏下滑退出手势
    if (self.topBarHeight && self.headerBarView.tag != 333) {
        [self.headerBarView addGestureRecognizer:[self panGesture]];
        self.headerBarView.tag = 333;
    }
    
    // 获取ScrollView代理
    UIScrollView *scrollView = self.tableView;
    id<UIScrollViewDelegate> delegate = self.service;
    if (delegate == nil) {
        scrollView = [self.contentObj supportCardPanCloseScrollView];
        if (scrollView != nil) {
            if (scrollView.delegate != nil) {
                delegate = scrollView.delegate;
            } else {
                scrollView.delegate = self;
                return;
            }
        } else {
            // 没有scrollView则添加滑动手势
            [self.containerView addGestureRecognizer:[self panGesture]];
            return;
        }
    }
    
    kDRWeakSelf
    // 方法不存在则添加方法
    scrollView.delegate = nil;
    if (![delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self addSelector:@selector(scrollViewDidScroll:)
                   forObj:delegate
                      imp:(IMP)add_scrollViewDidScroll];
    }
    if (![delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self addSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)
                   forObj:delegate
                      imp:(IMP)add_scrollViewWillEndDragging];
    }
    scrollView.delegate = delegate;
    id token1 = [(NSObject *)delegate aspect_hookSelector:@selector(scrollViewDidScroll:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
        [weakSelf scrollViewDidScroll:(UIScrollView *)[[aspectInfo arguments] firstObject]];
    } error:nil];
    id token2 = [(NSObject *)delegate aspect_hookSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
        NSArray *arguments = [aspectInfo arguments];
        CGPoint targetContentOffset;
        [weakSelf scrollViewWillEndDragging:[aspectInfo arguments].firstObject
                               withVelocity:[(NSValue *)arguments[1] CGPointValue]
                        targetContentOffset:&targetContentOffset];
    } error:nil];
    [self.aspectTokens addObject:token1];
    [self.aspectTokens addObject:token2];
}

- (void)countHeight {
    CGFloat tableViewHeight = 0;
    if (self.tableView.tableHeaderView != nil) {
        tableViewHeight += self.tableView.tableHeaderView.height;
    }
    if (self.tableView.tableFooterView != nil) {
        tableViewHeight = self.tableView.tableFooterView.height;
    }
    NSInteger sectionCount = 1;
    if ([self.service respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sectionCount = [self.service numberOfSectionsInTableView:self.tableView];
    }
    for (NSInteger section=0; section<sectionCount; section ++) {
        if ([self.service respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
            tableViewHeight += [self.service tableView:self.tableView heightForFooterInSection:section];
        }
        if ([self.service respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
            tableViewHeight += [self.service tableView:self.tableView heightForHeaderInSection:section];
        }
        NSInteger rowCount = [self.service tableView:self.tableView numberOfRowsInSection:section];
        if ([self.service respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
            for (NSInteger row=0; row<rowCount; row++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                tableViewHeight += [self.service tableView:self.tableView heightForRowAtIndexPath:indexPath];
            }
        } else {
            tableViewHeight += (rowCount * self.tableView.rowHeight);
        }
    }
    if (tableViewHeight < self.minContentHeight) {
        return;
    }
    
    if (@available(iOS 11.0, *)) {
        tableViewHeight += self.tableView.adjustedContentInset.top;
        tableViewHeight += self.tableView.adjustedContentInset.bottom;
    } else {
        tableViewHeight += self.tableView.contentInset.top;
        tableViewHeight += self.tableView.contentInset.bottom;
    }
    
    CGFloat containerHeight = tableViewHeight + self.topBarHeight + self.bottomBarHeight;
    if (containerHeight > self.maxHeight) {
        containerHeight = self.maxHeight;
    }
    [self animationChangeHeight:containerHeight];
}

- (void)animationChangeHeight:(CGFloat)containerHeight {
    kDRWeakSelf
    if (containerHeight < self.minContentHeight) {
        return;
    }
    self.normalTop = kDRScreenHeight - containerHeight + self.contentCornerRadius;
    if (self.containerView.hidden) {
        self.containerView.hidden = NO;
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(containerHeight);
        }];
        [UIView performWithoutAnimation:^{
            [self.view layoutIfNeeded];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakSelf.normalTop);
            }];
            [UIView animateWithDuration:kDRAnimationDuration animations:^{
                self.view.backgroundColor = [DRUIWidgetUtil coverBgColor];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                kDR_SAFE_BLOCK(self.onShowAnimationDone);
            }];
        });
    } else {
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(containerHeight);
            make.top.mas_offset(weakSelf.normalTop);
        }];
        [UIView animateWithDuration:kDRAnimationDuration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - events
- (void)onRightButtonAction {
    [self.view endEditing:YES];
    if (self.autoDismissWhenRightButtonAction) {
        [self dismissComplete:^{
            kDR_SAFE_BLOCK(self.onRightButtonTapBlock);
        }];
    } else {
        kDR_SAFE_BLOCK(self.onRightButtonTapBlock);
    }
}

- (void)onLeftButtonAction {
    [self.view endEditing:YES];
    if (self.onLeftButtonTapBlock == nil) {
        [self dismissComplete:nil];
    } else {
        self.onLeftButtonTapBlock();
    }
}

- (void)onBottomBarTappedAction {
    kDR_SAFE_BLOCK(self.onBottomBarTappedBlock);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    if (!CGRectContainsPoint(self.containerView.frame, location)) {
        if (self.dismissWhenTouchSpaceBlock == nil || self.dismissWhenTouchSpaceBlock()) {
            [self dismissComplete:nil];
        }
    }
}

#pragma mark - private
+ (void)showCardContainer:(QCCardContainerController *)vc {
    RTRootNavigationController *navController = [[RTRootNavigationController alloc] initWithRootViewController:vc];
    navController.modalPresentationStyle = UIModalPresentationCustom;
    navController.modalPresentationCapturesStatusBarAppearance = YES;
    navController.view.backgroundColor = [UIColor clearColor];
    [[DRUIWidgetUtil topViewController] presentViewController:navController
                                                     animated:NO
                                                   completion:nil];
}

#pragma mark - lazy load
- (UIView *)headerBarView {
    if (!_headerBarView) {
        if (self.position == QCCardContentPositionBottom && ![self.contentObj isKindOfClass:[UIView class]]) {
            UIView *headerBarView = [[UIView alloc] init];
            headerBarView.backgroundColor = [UIColor whiteColor];
            [self.containerView addSubview:headerBarView];
            [headerBarView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_offset(0);
                make.height.mas_equalTo(kHeaderBarHeight);
            }];
            _headerBarView = headerBarView;
        }
    }
    return _headerBarView;
}

- (UIButton *)titleButton {
    if (!_titleButton) {
        if (self.position == QCCardContentPositionBottom && ![self.contentObj isKindOfClass:[UIView class]]) {
            UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            titleButton.userInteractionEnabled = NO;
            titleButton.titleLabel.font = [UIFont dr_PingFangSC_MediumWithSize:16];
            titleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            titleButton.titleLabel.numberOfLines = 1;
            titleButton.titleLabel.adjustsFontSizeToFitWidth = YES;
            [self.headerBarView addSubview:titleButton];
            [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.centerY.mas_offset(0);
                make.height.mas_equalTo(22.5);
            }];
            _titleButton = titleButton;
        }
    }
    return _titleButton;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        if (self.position == QCCardContentPositionBottom && ![self.contentObj isKindOfClass:[UIView class]]) {
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            leftButton.titleLabel.font = [UIFont dr_PingFangSC_MediumWithSize:15];
            [leftButton setTitleColor:[DRUIWidgetUtil cancelColor] forState:UIControlStateNormal];
            [leftButton addTarget:self action:@selector(onLeftButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 14, 0, 0)];
            [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
            [self.headerBarView addSubview:leftButton];
            [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.mas_offset(0);
                make.width.mas_greaterThanOrEqualTo(90);
            }];
            _leftButton = leftButton;
        }
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        if (self.position == QCCardContentPositionBottom && ![self.contentObj isKindOfClass:[UIView class]]) {
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rightButton.titleLabel.font = [UIFont dr_PingFangSC_MediumWithSize:15];
            [rightButton setTitleColor:[DRUIWidgetUtil highlightColor] forState:UIControlStateNormal];
            [rightButton setTitleColor:[DRUIWidgetUtil disableColor] forState:UIControlStateDisabled];
            [rightButton addTarget:self action:@selector(onRightButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 16)];
            [self.headerBarView addSubview:rightButton];
            [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.bottom.mas_offset(0);
                make.width.mas_greaterThanOrEqualTo(90);
            }];
            _rightButton = rightButton;
        }
    }
    return _rightButton;
}

- (UIView *)bottomBarView {
    if (!_bottomBarView) {
        UIView *bottomBarView = [[UIView alloc] init];
        bottomBarView.backgroundColor = [UIColor whiteColor];
        [self.containerView addSubview:bottomBarView];
        _bottomBarView = bottomBarView;
    }
    return _bottomBarView;
}

- (NSMutableArray<id<AspectToken>> *)aspectTokens {
    if (!_aspectTokens) {
        _aspectTokens = [NSMutableArray array];
    }
    return _aspectTokens;
}

- (UIPanGestureRecognizer *)panGesture {
    kDRWeakSelf
    return [UIPanGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        CGFloat offset = [(UIPanGestureRecognizer *)sender translationInView:weakSelf.view].y * 0.95;
        if (state == UIGestureRecognizerStateBegan) {
            
        } else if (state == UIGestureRecognizerStateChanged) {
            if (offset < 0) {
                offset = 0;
            }
            CGFloat y = kDRScreenHeight - weakSelf.containerView.height + weakSelf.contentCornerRadius + offset;
            weakSelf.containerView.y = y;
        } else {
            CGPoint velocity = [(UIPanGestureRecognizer *)sender velocityInView:weakSelf.view];
            if (offset + velocity.y >= kMinPanSpace) {
                [weakSelf dismissComplete:nil];
            } else {
                CGFloat y = kDRScreenHeight - weakSelf.containerView.height + weakSelf.contentCornerRadius;
                [UIView animateWithDuration:kDRAnimationDuration animations:^{
                    weakSelf.containerView.y = y;
                }];
            }
        }
    }];
}

#pragma mark - NavigationBar Configuration
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (BOOL)navigationBarTranslucent {
    return YES;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - 滚动支持动态添加方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat insetTop = scrollView.contentInset.top;
    if (@available(iOS 11.0, *)) {
        insetTop += scrollView.adjustedContentInset.top;
    }
    offsetY += insetTop;
    if (offsetY < 0 ||
        (scrollView.dragging && self.autoFitHeight && scrollView.contentSize.height <= scrollView.height) ||
        (!self.alwaysBounceVertical && scrollView.contentSize.height <= scrollView.height) ||
        (offsetY > 0 && self.containerView.y > self.normalTop)) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -insetTop)];
        if (offsetY < 0 || self.containerView.y > self.normalTop) {
            CGFloat top = self.containerView.y - offsetY;
            if (top < self.normalTop) {
                top = self.normalTop;
            }
            if (!scrollView.decelerating) {
                [self.view endEditing:YES];
                [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(top);
                }];
            }
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat space = self.containerView.y - self.normalTop;
    if (space >= kMinPanSpace || (space > 20 && velocity.y < -1)) {
        [self dismissComplete:nil];
    } else {
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.normalTop);
        }];
        [UIView animateWithDuration:kDRAnimationDuration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)addSelector:(SEL)selector forObj:(id)obj imp:(IMP)imp {
    Method exchangeM = class_getInstanceMethod([self class], selector);
    BOOL success = class_addMethod([obj class],
                                   selector,
                                   imp,
                                   method_getTypeEncoding(exchangeM));
    kDR_LOG(@"方法%@添加成功：%d", NSStringFromSelector(selector), success)
}

void add_scrollViewDidScroll(id self, SEL _cmd, UIScrollView *scrollView) {
    kDR_LOG(@"调用了%@ %@ %@", self, NSStringFromSelector(_cmd), scrollView);
}

void add_scrollViewWillEndDragging(id self, SEL _cmd, UIScrollView *scrollView, CGPoint velocity, CGPoint *targetContentOffset) {
    kDR_LOG(@"调用了%@ %@ %@ %@ %@", self, NSStringFromSelector(_cmd), scrollView, NSStringFromCGPoint(velocity), NSStringFromCGPoint(*targetContentOffset));
}

@end
