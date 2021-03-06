//
//  DRSegmentBar.m
//  Pickers
//
//  Created by 冯生伟 on 2019/7/30.
//  Copyright © 2019 冯生伟. All rights reserved.
//

#import "DRSegmentBar.h"
#import <Masonry/Masonry.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <BlocksKit/UIView+BlocksKit.h>
#import <BlocksKit/NSObject+BKBlockObservation.h>
#import <DRCategories/UIView+DRExtension.h>
#import <DRCategories/UIFont+DRExtension.h>
#import <Aspects/Aspects.h>
#import <objc/message.h>
#import "DRUIWidgetUtil.h"

@interface DRSegmentBarItem : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, copy) void (^onTapBlock) (DRSegmentBarItem *barItem);
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign, readonly) CGRect titleRect;


/**
 cell类型
 */
@property (nonatomic, assign) DRSegmentBarShowType showType;

/**
 字体，如果不设置使用系统展示字体
 */
@property (nonatomic, assign) CGFloat titleFontSize;

/**
 选中字体颜色, 默认为主题色
 */
@property (nonatomic, strong) UIColor * selectColor;

/**
 未选中字体颜色, 默认为黑色
 */
@property (nonatomic, strong) UIColor * normalColor;

+ (instancetype)itemWithTitle:(NSString *)title
                 whenTapBlock:(void(^)(DRSegmentBarItem *barItem))whenTapBlock;

@end

@implementation DRSegmentBarItem {
    CGRect _titleRect;
}

+ (instancetype)itemWithTitle:(NSString *)title
                 whenTapBlock:(void(^)(DRSegmentBarItem *barItem))whenTapBlock {
    DRSegmentBarItem *item = kDR_LOAD_XIB_NAMED(NSStringFromClass([self class]));
    item.titleLabel.text = title;
    item.onTapBlock = whenTapBlock;
    item.selected = NO;
    return item;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    kDRWeakSelf
    [self bk_whenTapped:^{
        kDR_SAFE_BLOCK(weakSelf.onTapBlock, weakSelf);
    }];
    _titleRect = CGRectZero;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self updateItemSubviewState];
}

- (CGRect)titleRect {
    if (CGRectIsEmpty(_titleRect)) {
        _titleRect = [self convertRect:self.titleLabel.frame toView:self.superview];
    }
    return _titleRect;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.showType == DRSegmentBarShowTypeHighlightButton) {
        self.layer.cornerRadius = self.height / 2;
    }
}

/**
 更新状态
 */
- (void)updateItemSubviewState {
    if (self.selected) {
        self.titleLabel.textColor = self.selectColor;
        self.titleLabel.font = [UIFont dr_PingFangSC_RegularWithSize:self.titleFontSize > 0 ? self.titleFontSize : 13];
        if (self.showType == DRSegmentBarShowTypeHighlightButton) {
            self.backgroundColor = self.selectColor;
            self.titleLabel.textColor = [UIColor whiteColor];
        }
    } else {
        self.titleLabel.textColor = self.normalColor;
        self.titleLabel.font = [UIFont dr_PingFangSC_RegularWithSize:self.titleFontSize > 0 ? self.titleFontSize : 13];
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)setSelectColor:(UIColor *)selectColor {
    _selectColor = selectColor;
    [self updateItemSubviewState];
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [self updateItemSubviewState];
}

- (void)setTitleFontSize:(CGFloat)titleFontSize {
    _titleFontSize = titleFontSize;
    [self updateItemSubviewState];
}

@end

@interface DRSegmentBar ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UIView *selectMarkView;
@property (weak, nonatomic) IBOutlet UIImageView *selectFlagView;   // 图片，默认隐藏
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flagViewBottomConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectMarkViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectMarkViewWidth;

@property (nonatomic, weak) DRSegmentBarItem *currentItem;
@property (nonatomic, assign) CGRect currentItemTitleRect;
@property (nonatomic, weak) UIScrollView *associatedScrollView;
@property (nonatomic, assign) BOOL haveDrag;
@property (nonatomic, assign) BOOL didDrawRect;
@property (weak, nonatomic) id<UIScrollViewDelegate> currentDelegate;

@end

@implementation DRSegmentBar

- (void)setupWithAssociatedScrollView:(UIScrollView *)associatedScrollView
                               titles:(NSArray<NSString *> *)titles {
    self.associatedScrollView = associatedScrollView;
    
    kDRWeakSelf
    for (DRSegmentBarItem *item in self.stackView.arrangedSubviews) {
        [item removeFromSuperview];
    }
    for (NSInteger i=0; i<titles.count; i++) {
        DRSegmentBarItem *item = [DRSegmentBarItem itemWithTitle:titles[i] whenTapBlock:^(DRSegmentBarItem *barItem) {
            weakSelf.selectedIndex = barItem.tag;
        }];
        item.tag = i;
        item.showType = weakSelf.showType;
        if (weakSelf.titleFontSize > 0) {
            item.titleFontSize = weakSelf.titleFontSize;
        }
        if (weakSelf.selectColor) {
            item.selectColor = weakSelf.selectColor;
        }
        
        if (weakSelf.normalColor) {
            item.normalColor = weakSelf.normalColor;
        }
        
        [self.stackView addArrangedSubview:item];
    }
    if (self.selectColor) {
        self.selectMarkView.backgroundColor = self.selectColor;
    }
    
    // 默认选中第0个
    if (self.selectedIndex < 0) {
        self.selectedIndex = 0;
    }
    
    if (self.showType == DRSegmentBarShowTypeHighlightButton) {
        self.stackView.spacing = self.buttonHorizontalSpacing;
    }
}

- (void)setButtonHorizontalSpacing:(CGFloat)buttonHorizontalSpacing {
    if (self.showType == DRSegmentBarShowTypeHighlightButton) {
        self.stackView.spacing = buttonHorizontalSpacing;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex == _selectedIndex) {
        return;
    }
    _selectedIndex = selectedIndex;
    
    if (!self.didDrawRect) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        DRSegmentBarItem *barItem = [self.stackView viewWithTag:self.selectedIndex];
        barItem.selected = YES;
        
        self.currentItemTitleRect = [barItem titleRect];
        [UIView animateWithDuration:self.currentItem?kDRAnimationDuration:0 animations:^{
            self.selectMarkViewLeft.constant = self.currentItemTitleRect.origin.x;
            self.selectMarkViewWidth.constant = self.currentItemTitleRect.size.width;
            [self layoutIfNeeded];
        }];
        CGPoint offset = CGPointMake(barItem.tag * self.associatedScrollView.width, 0);
        [self.associatedScrollView setContentOffset:offset
                                           animated:self.currentItem!=nil];
        
        self.currentItem.selected = NO;
        self.currentItem = barItem;
    });
    kDR_SAFE_BLOCK(self.onSelectChangeBlock, self.selectedIndex);
}

- (void)setAssociatedScrollView:(UIScrollView *)associatedScrollView {
    if (_associatedScrollView == associatedScrollView) {
        return;
    }
    _associatedScrollView = associatedScrollView;
    
    associatedScrollView.showsVerticalScrollIndicator = NO;
    associatedScrollView.showsHorizontalScrollIndicator = NO;
    associatedScrollView.pagingEnabled = YES;
    associatedScrollView.bounces = NO;
    if (associatedScrollView.delegate == nil) {
        associatedScrollView.delegate = self;
        self.currentDelegate = self;
    } else {
        [self setupScrollDelegate:associatedScrollView.delegate];
    }
    
    kDRWeakSelf
    [associatedScrollView bk_addObserverForKeyPath:@"delegate" task:^(id target) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setupScrollDelegate:weakSelf.associatedScrollView.delegate];
        });
    }];
}

- (void)setupScrollDelegate:(id<UIScrollViewDelegate>)delegate {
    if (delegate == nil || self.currentDelegate == delegate) {
        return;
    }
    self.currentDelegate = delegate;
    self.associatedScrollView.delegate = nil;
    if (![delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [DRUIWidgetUtil addSelector:@selector(scrollViewDidScroll:)
                             forObj:delegate
                            fromObj:self
                                imp:(IMP)add_scrollViewDidScroll];
    }
    if (![delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [DRUIWidgetUtil addSelector:@selector(scrollViewWillBeginDragging:)
                             forObj:delegate
                            fromObj:self
                                imp:(IMP)add_scrollViewWillBeginDragging];
    }
    if (![delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [DRUIWidgetUtil addSelector:@selector(scrollViewDidEndDecelerating:)
                             forObj:delegate
                            fromObj:self
                                imp:(IMP)add_scrollViewDidEndDecelerating];
    }
    if (![delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [DRUIWidgetUtil addSelector:@selector(scrollViewDidEndScrollingAnimation:)
                             forObj:delegate
                            fromObj:self
                                imp:(IMP)add_scrollViewDidEndScrollingAnimation];
    }
    self.associatedScrollView.delegate = delegate;
    
    kDRWeakSelf
    [(NSObject *)delegate aspect_hookSelector:@selector(scrollViewDidScroll:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
        [weakSelf scrollViewDidScroll:[aspectInfo arguments].firstObject];
    } error:nil];
    [(NSObject *)delegate aspect_hookSelector:@selector(scrollViewWillBeginDragging:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
        [weakSelf scrollViewWillBeginDragging:[aspectInfo arguments].firstObject];
    } error:nil];
    [(NSObject *)delegate aspect_hookSelector:@selector(scrollViewDidEndDecelerating:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
        [weakSelf scrollViewDidEndDecelerating:[aspectInfo arguments].firstObject];
    } error:nil];
    [(NSObject *)delegate aspect_hookSelector:@selector(scrollViewDidEndScrollingAnimation:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
        [weakSelf scrollViewDidEndScrollingAnimation:[aspectInfo arguments].firstObject];
    } error:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.haveDrag) {
        return;
    }
    // selectMarkView的位置调整
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat width = scrollView.width;
    CGFloat changeOffset = offsetX - self.currentItem.tag * width;
    CGRect targetTitleRect;
    if (changeOffset < 0) { // 右滑
        targetTitleRect = [(DRSegmentBarItem *)[self.stackView viewWithTag:self.currentItem.tag-1] titleRect];
    } else {
        targetTitleRect = [(DRSegmentBarItem *)[self.stackView viewWithTag:self.currentItem.tag+1] titleRect];
    }
    CGFloat distance = fabs(targetTitleRect.origin.x - self.currentItemTitleRect.origin.x);
    CGFloat rate = changeOffset / width;
    CGFloat remarkOffset = distance * rate;
    self.selectMarkViewLeft.constant = self.currentItemTitleRect.origin.x + remarkOffset;
    
    // selectMarkView宽度调整
    CGFloat changeWidth = targetTitleRect.size.width - self.currentItemTitleRect.size.width;
    self.selectMarkViewWidth.constant = self.currentItemTitleRect.size.width + changeWidth * fabs(rate);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView.contentSize.width != scrollView.width * self.self.stackView.arrangedSubviews.count) {
        scrollView.contentSize = CGSizeMake(scrollView.width * self.self.stackView.arrangedSubviews.count, scrollView.height);
    }
    self.haveDrag = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.haveDrag = NO;
    self.selectedIndex = self.associatedScrollView.contentOffset.x / self.associatedScrollView.width;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.selectedIndex = self.associatedScrollView.contentOffset.x / self.associatedScrollView.width;
}

#pragma mark - setup xib
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    [self.associatedScrollView bk_removeAllBlockObservers];
}

- (void)setup {
    if (!self.containerView) {
        self.containerView = kDR_LOAD_XIB_NAMED(NSStringFromClass([self class]));
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_offset(0);
        }];
        _showType = DRSegmentBarShowTypeNormal;
        _selectedIndex = -1;
        self.selectMarkView.backgroundColor = [DRUIWidgetUtil highlightColor];
        self.selectColor = [DRUIWidgetUtil highlightColor];
        self.normalColor = [DRUIWidgetUtil normalColor];
        _buttonHorizontalSpacing = 4;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.selectedIndex == -1) {
        return;
    }
    if (!self.didDrawRect) {
        self.didDrawRect = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            DRSegmentBarItem *barItem = [self.stackView viewWithTag:self.selectedIndex];
            barItem.selected = YES;
            
            self.currentItemTitleRect = [barItem titleRect];
            self.selectMarkViewLeft.constant = self.currentItemTitleRect.origin.x;
            self.selectMarkViewWidth.constant = self.currentItemTitleRect.size.width;
            
            CGPoint offset = CGPointMake(barItem.tag * self.associatedScrollView.width, 0);
            [self.associatedScrollView setContentOffset:offset
                                               animated:NO];
            self.currentItem = barItem;
        });
    }
}

#pragma mark - setter & getter
- (void)setShowType:(NSUInteger)showType {
    _showType = showType;
    
    self.selectMarkView.hidden = (_showType != DRSegmentBarShowTypeNormal);
    self.selectFlagView.hidden = (_showType != DRSegmentBarShowTypeLineImg);
    self.sepratorLine.hidden = (_showType == DRSegmentBarShowTypeHighlightButton);
}

- (void)setFlagImage:(UIImage *)flagImage {
    _flagImage = flagImage;
    self.selectFlagView.image = _flagImage;
}
- (void)setFlagImageOffsetBottom:(CGFloat)flagImageOffsetBottom {
    _flagImageOffsetBottom = flagImageOffsetBottom;
    self.flagViewBottomConst.constant = _flagImageOffsetBottom;
}

@end
