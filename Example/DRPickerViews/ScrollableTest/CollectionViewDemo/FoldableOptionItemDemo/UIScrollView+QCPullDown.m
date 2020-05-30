//
//  UIScrollView+QCPullDown.m
//  DRPickerViews_Example
//
//  Created by 冯生伟 on 2020/5/30.
//  Copyright © 2020 Dean_F. All rights reserved.
//

#import "UIScrollView+QCPullDown.h"
#import "QCAppletModel.h"
#import <DRPickerViews/DRFoldableOptionItemLayout.h>
#import <Aspects/Aspects.h>

#define kAppletPullViewHeight 104
#define kAppletPullViewItemWidth 83

@interface QCAppletePullItemCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *iconView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIColor *textColor;

@end

@implementation QCAppletePullItemCell

- (void)setTextColor:(UIColor *)textColor {
    self.titleLabel.textColor = textColor;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        JXImageView *imageView = [[JXImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.cornerRadius = 25;
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(10);
            make.centerX.mas_offset(0);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        _iconView = imageView;
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont dr_PingFangSC_RegularWithSize:12];
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconView.mas_bottom).mas_offset(8);
            make.centerX.mas_offset(0);
            make.height.mas_equalTo(16);
            make.left.mas_greaterThanOrEqualTo(10);
        }];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

@end

@interface QCAppletePullDownView : UIView<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) DRFoldableOptionItemLayout *layout;
@property (nonatomic, strong) NSArray<QCAppletModel *> *datas;
@property (strong, nonatomic) UIColor *textColor;
@property (nonatomic, assign) BOOL isReachableLastTime;

@end

@implementation QCAppletePullDownView

+ (instancetype)pullDownView {
    static QCAppletePullDownView *pullView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pullView = [[QCAppletePullDownView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kAppletPullViewHeight)];
    });
    return pullView;
}

- (void)expandChangeToHeight:(CGFloat)height {
    self.layout.expandHeight = height;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QCAppletModel *appletModel = self.datas[indexPath.item];
    QCAppletePullItemCell *cell = [collectionView dequeueCell:NSStringFromClass([QCAppletePullItemCell class]) indexPath:indexPath];
    cell.iconView.image = [UIImage imageNamed:appletModel.appletIcon];
    cell.titleLabel.text = appletModel.appletName;
    cell.textColor = self.textColor;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击：%@", self.datas[indexPath.item].appletName);
}

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
        [self loadData];
        [self addObserver];
    }
    return self;
}

- (void)setup {
    if (!self.collectionView) {
        DRFoldableOptionItemLayout *layout = [DRFoldableOptionItemLayout new];
        layout.itemWidth = kAppletPullViewItemWidth;
        layout.expandHeight = 0;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.contentInset = UIEdgeInsetsMake(0, 2.5, 0, 2.5);
        [self addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_offset(0);
        }];
        self.collectionView = collectionView;
        self.layout = layout;
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.collectionView registerClass:[QCAppletePullItemCell class]
                forCellWithReuseIdentifier:NSStringFromClass([QCAppletePullItemCell class])];
        [self onThemeChange];
    }
}

- (void)loadData {
    NSMutableArray *datas = [NSMutableArray array];
    for (NSInteger i=0; i<10; i++) {
        QCAppletModel *appletModel = [QCAppletModel new];
        appletModel.appletName = [NSString stringWithFormat:@"标题_%ld", i];
        appletModel.appletIcon = [NSString stringWithFormat:@"icon_foldable%ld", i];
        [datas addObject:appletModel];
    }
    self.datas = datas;
    [self.collectionView reloadData];
}

- (void)onThemeChange {
    if([[QCThemeManager manager] isWithTheme]) {
        self.textColor = [DRUIWidgetUtil normalColor];
    } else {
        self.textColor = [UIColor whiteColor];
    }
}

- (void)appNetworkChangedNotification:(NSNotification *)notification {
    if (!self.isReachableLastTime && [AFNetworkReachabilityManager sharedManager].isReachable) {
        [self loadData];
    }
    AFNetworkReachabilityStatus status = [notification.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    self.isReachableLastTime = (status > 0);
}

- (void)addObserver {
    DRADDNOTIFY(DRNotificationNameAccountLoginSucess, @selector(loadData))
    DRADDNOTIFY(DRNotificationNameDidChangeThemeNotification, @selector(onThemeChange))
    DRADDNOTIFY(AFNetworkingReachabilityDidChangeNotification, @selector(appNetworkChangedNotification:))
    DRADDNOTIFY(DRFastAppletUpdateNotification, @selector(loadData))
}

@end

@interface UIView (QCPullDownContainer)

@property (weak, nonatomic) QCAppletePullDownView *pullDownView;
@property (assign, nonatomic) CGFloat originY;
@property (assign, nonatomic) BOOL haveExpand;

@end

@implementation UIView (PullDownContainer)

- (QCAppletePullDownView *)pullDownView {
    return [self bk_associatedValueForKey:@selector(pullDownView)];
}

- (void)setPullDownView:(QCAppletePullDownView *)pullDownView {
    [self bk_associateValue:pullDownView withKey:@selector(pullDownView)];
}

- (CGFloat)originY {
   return [[self bk_associatedValueForKey:@selector(originY)] floatValue];
}

- (void)setOriginY:(CGFloat)originY {
    [self bk_associateValue:@(originY) withKey:@selector(originY)];
}

- (BOOL)haveExpand {
    return [[self bk_associatedValueForKey:@selector(haveExpand)] boolValue];
}

- (void)setHaveExpand:(BOOL)haveExpand {
    [self bk_associateValue:@(haveExpand) withKey:@selector(haveExpand)];
}

- (void)preparePullDown {
    if (self.pullDownView == nil) {
        QCAppletePullDownView *pullView = [QCAppletePullDownView pullDownView];
        [pullView.superview recover];
        pullView.y = self.y;
        [self.superview insertSubview:pullView belowSubview:self];
        self.originY = self.y;
        self.pullDownView = pullView;
    }
}

- (void)recover {
    self.y = self.originY;
    [self.pullDownView expandChangeToHeight:0];
    [self.pullDownView removeFromSuperview];
    self.pullDownView = nil;
    self.haveExpand = NO;
}

- (void)dragEnd {
    self.userInteractionEnabled = NO;
    if (self.y - self.originY >= kAppletPullViewHeight) {
        [UIView animateWithDuration:DRGlobalAnimationDuration animations:^{
            self.y = self.originY + kAppletPullViewHeight;
            self.pullDownView.y = self.originY;
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = finished;
        }];
        self.haveExpand = YES;
    } else {
        [UIView animateWithDuration:DRGlobalAnimationDuration animations:^{
            self.y = self.originY;
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = finished;
        }];
        [self.pullDownView expandChangeToHeight:0];
        self.haveExpand = NO;
    }
}

- (void)pullDownWithDistance:(CGFloat)distance {
    self.y = self.originY + distance;
    self.pullDownView.y = self.originY;
    if (self.y > self.originY + kAppletPullViewHeight) {
        self.pullDownView.y = self.y - kAppletPullViewHeight;
    }
    [self.pullDownView expandChangeToHeight:distance];
}

@end

@interface UIScrollView () <UIScrollViewDelegate>

@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) id<UIScrollViewDelegate> currentDelegate;
@property (copy, nonatomic) void (^onPullChangeBlock)(CGFloat pullDistance);
@property (strong, nonatomic) NSMutableArray<id<AspectToken>> *delegateAspectTokens;
@property (assign, nonatomic) CGFloat pullDistance;

@end

@implementation UIScrollView (QCPullDown)

/// 设置ScrollView可以下拉出小程序
/// @param containerView 下拉时整体可以移动的view
/// @param onPullChangeBlock 下拉距离实时反馈回调
- (void)setupCanPullDownWithContainerView:(UIView *)containerView
                        onPullChangeBlock:(void(^)(CGFloat pullDistance))onPullChangeBlock {
    if (self.containerView == nil) {
        self.containerView = containerView;
        self.onPullChangeBlock = onPullChangeBlock;
        if (self.delegate == nil) {
            self.delegate = self;
        } else {
            [self setupScrollDelegate:self.delegate];
        }
        kWeakSelf
        [self bk_addObserverForKeyPath:@"delegate" task:^(id target) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setupScrollDelegate:weakSelf.delegate];
            });
        }];
    }
}

/// 收起已经下拉的小程序
- (void)foldBack {
    [self.containerView recover];
    DR_SAFE_BLOCK(self.onPullChangeBlock, 0);
}

#pragma mark - private
- (UIView *)containerView {
    return [self bk_associatedValueForKey:@selector(containerView)];
}

- (void)setContainerView:(UIView *)containerView {
    [self bk_associateValue:containerView withKey:@selector(containerView)];
}

- (void (^)(CGFloat))onPullChangeBlock {
    return [self bk_associatedValueForKey:@selector(onPullChangeBlock)];
}

- (void)setOnPullChangeBlock:(void (^)(CGFloat))onPullChangeBlock {
    [self bk_associateValue:onPullChangeBlock withKey:@selector(onPullChangeBlock)];
}

- (CGFloat)pullDistance {
    return [[self bk_associatedValueForKey:@selector(pullDistance)] floatValue];
}

- (void)setPullDistance:(CGFloat)pullDistance {
    [self bk_associateValue:@(pullDistance) withKey:@selector(pullDistance)];
}

- (id<UIScrollViewDelegate>)currentDelegate {
    return [self bk_associatedValueForKey:@selector(currentDelegate)];
}

- (void)setCurrentDelegate:(id<UIScrollViewDelegate>)currentDelegate {
    [self bk_associateValue:currentDelegate withKey:@selector(currentDelegate)];
}

- (NSMutableArray<id<AspectToken>> *)delegateAspectTokens {
    NSMutableArray *tokens = [self bk_associatedValueForKey:@selector(delegateAspectTokens)];
    if (tokens == nil) {
        tokens = [NSMutableArray array];
        [self bk_associateValue:tokens withKey:@selector(delegateAspectTokens)];
    }
    return tokens;
}

- (void)setupScrollDelegate:(id<UIScrollViewDelegate>)delegate {
    if (delegate == nil || self.currentDelegate == delegate) {
        return;
    }
    for (id<AspectToken> token in self.delegateAspectTokens) {
        [token remove];
    }
    [self.delegateAspectTokens removeAllObjects];
    self.currentDelegate = delegate;
    kWeakSelf
    // 方法不存在则添加方法
    self.delegate = nil;
    if (![delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [DRUIWidgetUtil addSelector:@selector(scrollViewWillBeginDragging:)
                             forObj:delegate
                            fromObj:self
                                imp:(IMP)add_scrollViewWillBeginDragging];
    }
    if (![delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [DRUIWidgetUtil addSelector:@selector(scrollViewDidScroll:)
                             forObj:delegate
                            fromObj:self
                                imp:(IMP)add_scrollViewDidScroll];
    }
    if (![delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [DRUIWidgetUtil addSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)
                             forObj:delegate
                            fromObj:self
                                imp:(IMP)add_scrollViewWillEndDragging];
    }
    self.delegate = delegate;
    id token = [(NSObject *)delegate aspect_hookSelector:@selector(scrollViewWillBeginDragging:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
        [weakSelf scrollViewWillBeginDragging:weakSelf];
    } error:nil];
    if (token) {
        [self.delegateAspectTokens addObject:token];
    }
    token = [(NSObject *)delegate aspect_hookSelector:@selector(scrollViewDidScroll:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
        [weakSelf scrollViewDidScroll:weakSelf];
    } error:nil];
    if (token) {
        [self.delegateAspectTokens addObject:token];
    }
    token = [(NSObject *)delegate aspect_hookSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
        [weakSelf.containerView dragEnd];
    } error:nil];
    if (token) {
        [self.delegateAspectTokens addObject:token];
    }
    self.currentDelegate = nil; // 防止循环引用
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.containerView preparePullDown];
    self.pullDistance = self.containerView.haveExpand * kAppletPullViewHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat insetTop = scrollView.contentInset.top;
    if (@available(iOS 11.0, *)) {
        insetTop += scrollView.adjustedContentInset.top;
    }
    offsetY += insetTop;
    if (offsetY < 0 || self.pullDistance > 0) {
        self.pullDistance -= offsetY*0.5;
        if (!scrollView.decelerating) {
            [self.containerView pullDownWithDistance:self.pullDistance];
        }
        if (offsetY != 0) {
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -insetTop)];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self.containerView dragEnd];
}

@end
