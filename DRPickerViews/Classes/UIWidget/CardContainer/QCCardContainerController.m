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
#import "QCCardContainerBaseService.h"
#import "DRUIWidgetUtil.h"

#define kHeaderBarHeight 56
#define kBottomBarHeight 56
#define kMinPanSpace 80
#define kMinTableViewHeight 50

typedef NS_ENUM(NSInteger, QCCardContentType) {
    QCCardContentTypeService,
    QCCardContentTypeController,
    QCCardContentTypeView
};

@interface QCCardContainerController ()

@property (strong, nonatomic) UIView *containerView;
@property (weak, nonatomic) UIView *headerBarView;
@property (weak, nonatomic) UIButton *titleButton;
@property (weak, nonatomic) UIButton *leftButton;
@property (weak, nonatomic) UIButton *rightButton;
@property (weak, nonatomic) DRDragSortTableView *tableView;
@property (weak, nonatomic) UIView *bottomBarView;

@property (assign, nonatomic) QCCardContentType contentType;
@property (assign, nonatomic) QCCardContentPosition position;
@property (strong, nonatomic) QCCardContainerBaseService *service;
@property (weak, nonatomic) UIViewController<QCCardContentDelegate> *contentController;
@property (weak, nonatomic) UIView<QCCardContentDelegate> *contentView;
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
    QCCardContainerController *card = [QCCardContainerController cardWithContentType:QCCardContentTypeService  position:QCCardContentPositionBottom];
    card.autoFitHeight = YES;
    card.service = service;
    [self showCardContainer:card];
}

/// 将contentVc添加到卡片中显示
/// @param contentVc 内容vc
/// @param position 弹出位置
+ (void)showContainerWithContentVc:(UIViewController<QCCardContentDelegate> *)contentVc
                        atPosition:(QCCardContentPosition)position {
    QCCardContainerController *card = [QCCardContainerController cardWithContentType:QCCardContentTypeController  position:position];
    [card addChildViewController:contentVc];
    card.contentController = contentVc;
    [self showCardContainer:card];
}

/// 将contentView添加到卡片中显示
/// @param contentView 内容vc
/// @param position 弹出位置
+ (void)showContainerWithContentView:(UIView<QCCardContentDelegate> *)contentView
                          atPosition:(QCCardContentPosition)position {
    QCCardContainerController *card = [QCCardContainerController cardWithContentType:QCCardContentTypeView  position:position];
    [card.containerView addSubview:contentView];
    card.contentView = contentView;
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
        if (self.contentType == QCCardContentTypeController) {
            if ([self.contentController respondsToSelector:@selector(horizontalPadding)]) {
                width = kDRScreenWidth - [self.contentController horizontalPadding] * 2;
            } else if ([self.contentController respondsToSelector:@selector(contentWidth)]) {
                width = [self.contentController contentWidth];
            }
            if ([self.contentController respondsToSelector:@selector(contentHeight)]) {
                height = [self.contentController contentHeight];
            }
            if ([self.contentController respondsToSelector:@selector(contentCenterYUpOffset)]) {
                offsetY = [self.contentController contentCenterYUpOffset];
            }
        } else if (self.contentType == QCCardContentTypeView) {
            width = self.contentView.width;
            if ([self.contentView respondsToSelector:@selector(horizontalPadding)]) {
                width = kDRScreenWidth - [self.contentView horizontalPadding] * 2;
            } else if ([self.contentView respondsToSelector:@selector(contentWidth)]) {
                width = [self.contentView contentWidth];
            }
            height = self.contentView.height;
            if ([self.contentView respondsToSelector:@selector(contentHeight)]) {
                height = [self.contentView contentHeight];
            }
            if ([self.contentView respondsToSelector:@selector(contentCenterYUpOffset)]) {
                offsetY = [self.contentView contentCenterYUpOffset];
            }
        }
        if (height > self.maxHeight) {
            height = self.maxHeight;
        }
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
    }
}

/// 退出页面
- (void)dismissComplete:(dispatch_block_t)complete {
    kDRWeakSelf
    for (id<AspectToken> token in self.aspectTokens) {
        [token remove];
    }
    if (self.position == QCCardContentPositionBottom) {
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kDRScreenHeight);
        }];
        [UIView animateWithDuration:kDRAnimationDuration animations:^{
            weakSelf.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
            [weakSelf.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [weakSelf dismissViewControllerAnimated:NO completion:^{
                kDR_SAFE_BLOCK(complete);
                kDR_SAFE_BLOCK(weakSelf.onHideAnimationDone);
            }];
        }];
    } else if (self.position == QCCardContentPositionCenter) {
        [UIView animateWithDuration:kDRAnimationDuration animations:^{
            weakSelf.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
            weakSelf.containerView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.containerView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [weakSelf dismissViewControllerAnimated:NO completion:^{
                kDR_SAFE_BLOCK(complete);
                kDR_SAFE_BLOCK(weakSelf.onHideAnimationDone);
            }];
        }];
    }
}

/// 用于获取真实页面
- (UIViewController *)topViewController {
    if (self.contentController != nil) {
        return self.contentController;
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
+ (instancetype)cardWithContentType:(QCCardContentType)contentType position:(QCCardContentPosition)position {
    QCCardContainerController *card = [[QCCardContainerController alloc] initWithContentType:contentType position:position];
    return card;
}

- (instancetype)initWithContentType:(QCCardContentType)contentType position:(QCCardContentPosition)position {
    if (self = [super init]) {
        _statusBarStyle = [[DRUIWidgetUtil topViewController] preferredStatusBarStyle];
        _firstLayout = YES;
        _autoDismissWhenRightButtonAction = YES;
        _allowPanClose = YES;
        _autoFitHeight = NO;
        _alwaysBounceVertical = YES;
        _contentCornerRadius = 16;
        _minTopSpaceInSafeArea = 24;
        _leftButtonAutoHighlight = YES;
        _showBottomBar = NO;
        _bottomBarTitle = @"取消";
        _bottomBarTintColor = [DRUIWidgetUtil cancelColor];
        _bottomBarTopSpace = 4;
        _contentType = contentType;
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
    
    if (self.contentType == QCCardContentTypeService) {
        self.service.navigationController = self.navigationController;
        self.service.containerVc = self;
        self.service.view = self.view;
        [self.service setupCardContainerViwContoller];
    } else if (self.contentType == QCCardContentTypeController) {
        [self.contentController setupCardContainerVc:self];
    } else if (self.contentType == QCCardContentTypeView) {
        [self.contentView setupCardContainerVc:self];
    }
    [self initSubviews];
    [self.service viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.service viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.position == QCCardContentPositionBottom) {
        if (!self.autoFitHeight) {
            [self animationChangeHeight:self.maxHeight];
        }
    } else {
        if (self.containerView.hidden) {
            self.containerView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.containerView.hidden = NO;
                self.containerView.alpha = 0.0f;
                [UIView animateWithDuration:kDRAnimationDuration animations:^{
                    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.24];
                    self.containerView.transform = CGAffineTransformIdentity;
                    self.containerView.alpha = 1.0f;
                } completion:^(BOOL finished) {
                    [self setupViews];
                }];
            });
        }
    }
    [self.service viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.service viewDidLayoutSubviews];
    
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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.service viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.self.service viewDidDisappear:animated];
}

- (void)dealloc {
    kDR_LOG(@"%@ dealloc and removeObserver", [self class])
}

#pragma mark - setup views
- (void)initSubviews {
    kDRWeakSelf
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
        if (self.contentType == QCCardContentTypeService) {
            [self setupTableView];
            self.service.tableView = self.tableView;
            [self.service registerTableViewCells];
            self.tableView.dr_dragSortDelegate = self.service;
        } else {
            if (self.contentType == QCCardContentTypeController) {
                [self.containerView addSubview:self.contentController.view];
                [self.contentController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_offset(weakSelf.topBarHeight);
                    make.bottom.mas_offset(-weakSelf.bottomBarHeight);
                    make.left.right.mas_offset(0);
                }];
            } else if (self.contentType == QCCardContentTypeView) {
                [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_offset(weakSelf.topBarHeight);
                    make.bottom.mas_offset(-weakSelf.bottomBarHeight);
                    make.left.right.mas_offset(0);
                }];
            }
        }
    } else {
        self.maxHeight = kDRScreenHeight - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)*2;
        CGFloat width = kDRScreenWidth - 80;
        CGFloat height = self.maxHeight;
        CGFloat offsetY = 0;
        if (self.contentType == QCCardContentTypeController) {
            if ([self.contentController respondsToSelector:@selector(horizontalPadding)]) {
                width = kDRScreenWidth - [self.contentController horizontalPadding] * 2;
            } else if ([self.contentController respondsToSelector:@selector(contentWidth)]) {
                width = [self.contentController contentWidth];
            }
            if ([self.contentController respondsToSelector:@selector(contentHeight)]) {
                height = [self.contentController contentHeight];
            }
            if ([self.contentController respondsToSelector:@selector(contentCenterYUpOffset)]) {
                offsetY = [self.contentController contentCenterYUpOffset];
            }
        } else if (self.contentType == QCCardContentTypeView) {
            width = self.contentView.width;
            if ([self.contentView respondsToSelector:@selector(horizontalPadding)]) {
                width = kDRScreenWidth - [self.contentView horizontalPadding] * 2;
            } else if ([self.contentView respondsToSelector:@selector(contentWidth)]) {
                width = [self.contentView contentWidth];
            }
            height = self.contentView.height;
            if ([self.contentView respondsToSelector:@selector(contentHeight)]) {
                height = [self.contentView contentHeight];
            }
            if ([self.contentView respondsToSelector:@selector(contentCenterYUpOffset)]) {
                offsetY = [self.contentView contentCenterYUpOffset];
            }
        }
        if (height > self.maxHeight) {
            height = self.maxHeight;
        }
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_offset(0);
            make.centerY.mas_offset(-offsetY);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        if (self.contentType == QCCardContentTypeController) {
            [self.containerView addSubview:self.contentController.view];
            [self.contentController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.right.mas_offset(0);
            }];
        } else if (self.contentType == QCCardContentTypeView) {
            [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.right.mas_offset(0);
            }];
        }
    }
}

- (void)setupHeaderBar {
    self.topBarHeight = 0;
    if (self.contentType != QCCardContentTypeView) {
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
                if (self.contentType == QCCardContentTypeController) {
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
    if (self.contentType == QCCardContentTypeService || self.customBottomBar != nil) {
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

- (void)setupViews {
    kDRWeakSelf
    BOOL allowPan = self.allowPanClose && self.position == QCCardContentPositionBottom;
    if (self.topBarHeight > 0 && allowPan) {
        [self.headerBarView addGestureRecognizer:[self panGesture]];
    }
    
    if (allowPan) {
        id<UIScrollViewDelegate> delegate = nil;
        if (self.contentType == QCCardContentTypeService) {
            delegate = self.service;
        } else if (self.contentType == QCCardContentTypeController) {
            if ([self.contentController respondsToSelector:@selector(cardContentScrollViewDelegate)]) {
                delegate = [self.contentController cardContentScrollViewDelegate];
            }
        } else if (self.contentType == QCCardContentTypeView) {
            if ([self.contentView respondsToSelector:@selector(cardContentScrollViewDelegate)]) {
                delegate = [self.contentView cardContentScrollViewDelegate];
            }
        }
        if (delegate != nil) {
            if ([delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
                id token = [(NSObject *)delegate aspect_hookSelector:@selector(scrollViewDidScroll:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
                    UIScrollView *scrollView = (UIScrollView *)[[aspectInfo arguments] firstObject];
                    CGFloat offsetY = scrollView.contentOffset.y;
                    CGFloat insetTop = scrollView.contentInset.top;
                    if (@available(iOS 11.0, *)) {
                        insetTop += scrollView.adjustedContentInset.top;
                    }
                    offsetY += insetTop;
                    if (offsetY < 0 ||
                        (scrollView.dragging && weakSelf.autoFitHeight && scrollView.contentSize.height <= scrollView.height) ||
                        (!weakSelf.alwaysBounceVertical && scrollView.contentSize.height <= scrollView.height) ||
                        (offsetY > 0 && weakSelf.containerView.y > weakSelf.normalTop)) {
                        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -insetTop)];
                        if (offsetY < 0 || weakSelf.containerView.y > weakSelf.normalTop) {
                            CGFloat top = weakSelf.containerView.y - offsetY;
                            if (top < weakSelf.normalTop) {
                                top = weakSelf.normalTop;
                            }
                            if (!scrollView.decelerating) {
                                [weakSelf.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                                    make.top.mas_equalTo(top);
                                }];
                            }
                        }
                    } else {
                        [weakSelf.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(weakSelf.normalTop);
                        }];
                    }
                } error:nil];
                [self.aspectTokens addObject:token];
            } else {
#if DEBUG
                NSAssert(NO, @"scrollView.delegate未实现scrollViewDidScroll:代理方法，无法实现下滑退出页面");
#endif
            }
            if ([delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
                id token = [(NSObject *)delegate aspect_hookSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
                    NSArray *arguments = [aspectInfo arguments];
                    CGPoint velocity = [(NSValue *)arguments[1] CGPointValue];
                    CGFloat space = weakSelf.containerView.y - weakSelf.normalTop;
                    if (space >= kMinPanSpace || (space > 20 && velocity.y < -1)) {
                        [weakSelf dismissComplete:nil];
                    } else {
                        [weakSelf.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(weakSelf.normalTop);
                        }];
                        [UIView animateWithDuration:kDRAnimationDuration animations:^{
                            [weakSelf.view layoutIfNeeded];
                        }];
                    }
                } error:nil];
                [self.aspectTokens addObject:token];
            } else {
#if DEBUG
                NSAssert(NO, @"scrollView.delegate未实现scrollViewWillEndDragging:withVelocity:targetContentOffset:代理方法，无法实现下滑退出页面");
#endif
            }
        } else {
            [self.containerView addGestureRecognizer:[self panGesture]];
        }
    }
    kDR_SAFE_BLOCK(self.onShowAnimationDone);
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
    if (tableViewHeight < kMinTableViewHeight) {
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
                [self setupViews];
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
    if (self.autoDismissWhenRightButtonAction) {
        kDRWeakSelf
        [self dismissComplete:^{
            kDR_SAFE_BLOCK(weakSelf.onRightButtonTapBlock);
        }];
    } else {
        kDR_SAFE_BLOCK(self.onRightButtonTapBlock);
    }
}

- (void)onLeftButtonAction {
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
        if (self.position == QCCardContentPositionBottom && self.contentType != QCCardContentTypeView) {
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
        if (self.position == QCCardContentPositionBottom && self.contentType != QCCardContentTypeView) {
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
        if (self.position == QCCardContentPositionBottom && self.contentType != QCCardContentTypeView) {
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
        if (self.position == QCCardContentPositionBottom && self.contentType != QCCardContentTypeView) {
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
            CGFloat y = kDRScreenHeight - weakSelf.containerView.height + self.contentCornerRadius + offset;
            weakSelf.containerView.y = y;
        } else {
            CGPoint velocity = [(UIPanGestureRecognizer *)sender velocityInView:weakSelf.view];
            if (offset + velocity.y >= kMinPanSpace) {
                [weakSelf dismissComplete:nil];
            } else {
                CGFloat y = kDRScreenHeight - weakSelf.containerView.height + self.contentCornerRadius;
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

@end
