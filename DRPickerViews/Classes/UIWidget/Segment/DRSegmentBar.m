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

#import "DRUIWidgetUtil.h"

@interface DRSegmentBarItem : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, copy) void (^onTapBlock) (DRSegmentBarItem *barItem);
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign, readonly) CGRect titleRect;

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
    if (selected) {
        self.titleLabel.textColor = [DRUIWidgetUtil highlightColor];
        self.titleLabel.font = [UIFont dr_PingFangSC_MediumWithSize:13];
    } else {
        self.titleLabel.textColor = [DRUIWidgetUtil normalColor];
        self.titleLabel.font = [UIFont dr_PingFangSC_RegularWithSize:13];
    }
}

- (CGRect)titleRect {
    if (CGRectEqualToRect(_titleRect, CGRectZero)) {
        _titleRect = [self convertRect:self.titleLabel.frame toView:self.superview];
    }
    return _titleRect;
}

@end

@interface DRSegmentBar () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UIView *selectMarkView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectMarkViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectMarkViewWidth;

@property (nonatomic, weak) DRSegmentBarItem *currentItem;
@property (nonatomic, assign) CGRect currentItemTitleRect;
@property (nonatomic, weak) UIScrollView *associatedScrollView;
@property (nonatomic, assign) BOOL haveDrag;

@end

@implementation DRSegmentBar

- (void)setupWithAssociatedScrollView:(UIScrollView *)associatedScrollView
                               titles:(NSArray<NSString *> *)titles {
    self.associatedScrollView = associatedScrollView;
    
    kDRWeakSelf
    for (NSInteger i=0; i<titles.count; i++) {
        DRSegmentBarItem *item = [DRSegmentBarItem itemWithTitle:titles[i] whenTapBlock:^(DRSegmentBarItem *barItem) {
            weakSelf.selectedIndex = barItem.tag;
        }];
        item.tag = i;
        [self.stackView addArrangedSubview:item];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex == _selectedIndex) {
        return;
    }
    
    _selectedIndex = selectedIndex;
    dispatch_async(dispatch_get_main_queue(), ^{
        DRSegmentBarItem *barItem = [self.stackView viewWithTag:selectedIndex];
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
    kDR_SAFE_BLOCK(self.onSelectChangeBlock, selectedIndex);
}

- (void)setAssociatedScrollView:(UIScrollView *)associatedScrollView {
    _associatedScrollView = associatedScrollView;
    
    associatedScrollView.showsVerticalScrollIndicator = NO;
    associatedScrollView.showsHorizontalScrollIndicator = NO;
    associatedScrollView.pagingEnabled = YES;
    associatedScrollView.bounces = NO;
    associatedScrollView.delegate = self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.containerView.backgroundColor = backgroundColor;
    self.stackView.backgroundColor = backgroundColor;
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

- (void)setup {
    if (!self.containerView) {
        self.containerView = kDR_LOAD_XIB_NAMED(NSStringFromClass([self class]));
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_offset(0);
        }];
        
        _selectedIndex = -1;
        self.selectMarkView.backgroundColor = [DRUIWidgetUtil highlightColor];
    }
}

@end
