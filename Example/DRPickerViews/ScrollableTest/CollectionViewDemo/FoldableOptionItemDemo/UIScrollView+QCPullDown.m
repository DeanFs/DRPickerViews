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

@property (weak, nonatomic) QCAppletePullDownView *qc_pull_pullDownView;
@property (assign, nonatomic) CGFloat qc_pull_originY;
@property (assign, nonatomic) CGFloat qc_pull_pullViewHeight;
@property (assign, nonatomic) BOOL qc_pull_haveExpand;

@end

@implementation UIView (PullDownContainer)

- (QCAppletePullDownView *)qc_pull_pullDownView {
    return [self bk_associatedValueForKey:@selector(qc_pull_pullDownView)];
}

- (void)setQc_pull_pullDownView:(QCAppletePullDownView *)pullDownView {
    [self bk_associateValue:pullDownView withKey:@selector(qc_pull_pullDownView)];
}

- (CGFloat)qc_pull_originY {
    return [[self bk_associatedValueForKey:@selector(qc_pull_originY)] floatValue];
}

- (void)setQc_pull_originY:(CGFloat)originY {
    [self bk_associateValue:@(originY) withKey:@selector(qc_pull_originY)];
}

- (CGFloat)qc_pull_pullViewHeight {
    return [[self bk_associatedValueForKey:@selector(qc_pull_pullViewHeight)] floatValue];
}

- (void)setQc_pull_pullViewHeight:(CGFloat)qc_pull_pullViewHeight {
    [self bk_associateValue:@(qc_pull_pullViewHeight) withKey:@selector(qc_pull_pullViewHeight)];
}

- (BOOL)qc_pull_haveExpand {
    return [[self bk_associatedValueForKey:@selector(qc_pull_haveExpand)] boolValue];
}

- (void)setQc_pull_haveExpand:(BOOL)haveExpand {
    [self bk_associateValue:@(haveExpand) withKey:@selector(qc_pull_haveExpand)];
}

- (void)preparePullDown {
    if (self.qc_pull_pullDownView == nil) {
        QCAppletePullDownView *pullView = [QCAppletePullDownView pullDownView];
        [pullView.superview recover];
        pullView.y = self.y;
        [self.superview insertSubview:pullView belowSubview:self];
        self.qc_pull_originY = self.y;
        self.qc_pull_pullDownView = pullView;
    }
}

- (void)recover {
    self.y = self.qc_pull_originY;
    [self.qc_pull_pullDownView expandChangeToHeight:0];
    [self.qc_pull_pullDownView removeFromSuperview];
    self.qc_pull_pullDownView = nil;
    self.qc_pull_haveExpand = NO;
}

- (void)dragEnd {
    self.userInteractionEnabled = NO;
    if (self.y - self.qc_pull_originY >= kAppletPullViewHeight) {
        [UIView animateWithDuration:DRGlobalAnimationDuration animations:^{
            self.y = self.qc_pull_originY + self.qc_pull_pullViewHeight;
            self.qc_pull_pullDownView.y = self.qc_pull_originY;
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = finished;
        }];
        self.qc_pull_haveExpand = YES;
    } else {
        [UIView animateWithDuration:DRGlobalAnimationDuration animations:^{
            self.y = self.qc_pull_originY;
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = finished;
        }];
        [self.qc_pull_pullDownView expandChangeToHeight:0];
        self.qc_pull_haveExpand = NO;
    }
}

- (void)pullDownWithDistance:(CGFloat)distance {
    if (distance < 0) {
        return;
    }
    self.y = self.qc_pull_originY + distance;
    self.qc_pull_pullDownView.y = self.qc_pull_originY;
    if (self.y > self.qc_pull_originY + self.qc_pull_pullViewHeight) {
        self.qc_pull_pullDownView.y = self.y - self.qc_pull_pullViewHeight;
    }
    if (!self.qc_pull_haveExpand || distance < self.qc_pull_pullViewHeight) {
        [self.qc_pull_pullDownView expandChangeToHeight:distance];
    }
}

@end

@interface UIScrollView ()<UIScrollViewDelegate>

@property (weak, nonatomic) UIView *qc_pull_containerView;
@property (weak, nonatomic) NSString *qc_pull_currentDelegate;
@property (strong, nonatomic) NSMutableArray<id<AspectToken>> *qc_pull_delegateAspectTokens;
@property (assign, nonatomic) CGFloat qc_pull_pullDistance;

@end

@implementation UIScrollView (QCPullDown)

/// 设置ScrollView可以下拉出小程序，每个scrollView仅可以调用一次
/// @param containerView 下拉时整体可以移动的view，不能为空
/// @param bottomInset 默认高度104，实际高度 104 - bottomInset
- (void)setupCanPullDownWithContainerView:(UIView *)containerView
                              bottomInset:(CGFloat)bottomInset {
    if (self.qc_pull_containerView == nil && containerView != nil) {
        containerView.qc_pull_pullViewHeight = kAppletPullViewHeight - bottomInset;
        self.qc_pull_containerView = containerView;
        kWeakSelf
        [self bk_addObserverForKeyPath:@"delegate" task:^(id target) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setupScrollDelegate:weakSelf.delegate];
            });
        }];
        if (self.delegate == nil) {
            self.delegate = self;
        } else {
            [self setupScrollDelegate:self.delegate];
        }
        self.alwaysBounceVertical = YES;
    }
}

/// 收起已经下拉的小程序
- (void)foldBack {
    [self.qc_pull_containerView recover];
}

#pragma mark - private
- (BOOL)qc_pull_allowUpBounce {
    NSNumber *allowUpBounce = [self bk_associatedValueForKey:@selector(qc_pull_allowUpBounce)];
    if (allowUpBounce == nil) {
        return YES;
    }
    return [allowUpBounce boolValue];
}

- (void)setQc_pull_allowUpBounce:(BOOL)qc_pull_allowUpBounce {
    [self bk_associateValue:@(qc_pull_allowUpBounce) withKey:@selector(qc_pull_allowUpBounce)];
}

- (UIView *)qc_pull_containerView {
    return [self bk_associatedValueForKey:@selector(qc_pull_containerView)];
}

- (void)setQc_pull_containerView:(UIView *)containerView {
    [self bk_associateValue:containerView withKey:@selector(qc_pull_containerView)];
}

- (void (^)(CGFloat))qc_pull_onPullChangeBlock {
    return [self bk_associatedValueForKey:@selector(qc_pull_onPullChangeBlock)];
}

- (void)setQc_pull_onPullChangeBlock:(void (^)(CGFloat))onPullChangeBlock {
    [self bk_associateValue:onPullChangeBlock withKey:@selector(qc_pull_onPullChangeBlock)];
}

- (CGFloat)qc_pull_pullDistance {
    return [[self bk_associatedValueForKey:@selector(qc_pull_pullDistance)] floatValue];
}

- (void)setQc_pull_pullDistance:(CGFloat)pullDistance {
    [self bk_associateValue:@(pullDistance) withKey:@selector(qc_pull_pullDistance)];
}

- (NSString *)qc_pull_currentDelegate {
    return [self bk_associatedValueForKey:@selector(qc_pull_currentDelegate)];
}

- (void)setQc_pull_currentDelegate:(NSString *)currentDelegate {
    [self bk_associateValue:currentDelegate withKey:@selector(qc_pull_currentDelegate)];
}

- (NSMutableArray<id<AspectToken>> *)qc_pull_delegateAspectTokens {
    NSMutableArray *tokens = [self bk_associatedValueForKey:@selector(qc_pull_delegateAspectTokens)];
    if (tokens == nil) {
        tokens = [NSMutableArray array];
        [self bk_associateValue:tokens withKey:@selector(qc_pull_delegateAspectTokens)];
    }
    return tokens;
}

- (void)setupScrollDelegate:(id<UIScrollViewDelegate>)delegate {
    if (delegate == nil || [self.qc_pull_currentDelegate isEqualToString:[NSString stringWithFormat:@"%@", delegate]]) {
        return;
    }
    for (id<AspectToken> token in self.qc_pull_delegateAspectTokens) {
        [token remove];
    }
    [self.qc_pull_delegateAspectTokens removeAllObjects];
    self.qc_pull_currentDelegate = [NSString stringWithFormat:@"%@", delegate];
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
        [weakSelf qc_pull_scrollViewWillBeginDragging:weakSelf];
    } error:nil];
    if (token) {
        [self.qc_pull_delegateAspectTokens addObject:token];
    }
    token = [(NSObject *)delegate aspect_hookSelector:@selector(scrollViewDidScroll:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
        [weakSelf qc_pull_scrollViewDidScroll:weakSelf];
    } error:nil];
    if (token) {
        [self.qc_pull_delegateAspectTokens addObject:token];
    }
    token = [(NSObject *)delegate aspect_hookSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
        [weakSelf qc_pull_scrollViewWillEndDragging:weakSelf
                                       withVelocity:CGPointZero
                                targetContentOffset:nil];
    } error:nil];
    if (token) {
        [self.qc_pull_delegateAspectTokens addObject:token];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)qc_pull_scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.qc_pull_containerView preparePullDown];
    self.qc_pull_pullDistance = self.qc_pull_containerView.qc_pull_haveExpand * self.qc_pull_containerView.qc_pull_pullViewHeight;
}

- (void)qc_pull_scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat insetTop = scrollView.contentInset.top;
    if (@available(iOS 11.0, *)) {
        insetTop += scrollView.adjustedContentInset.top;
    }
    offsetY += insetTop;
    if (offsetY < 0 || self.qc_pull_pullDistance > 0) {
        self.qc_pull_pullDistance -= offsetY*0.5;
        if (!scrollView.decelerating && scrollView.dragging) {
            [self.qc_pull_containerView pullDownWithDistance:self.qc_pull_pullDistance];
        }
        if (offsetY != 0) {
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -insetTop)];
        }
    } else if (!self.qc_pull_allowUpBounce) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -insetTop)];
    }
}

- (void)qc_pull_scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self.qc_pull_containerView dragEnd];
}

@end
