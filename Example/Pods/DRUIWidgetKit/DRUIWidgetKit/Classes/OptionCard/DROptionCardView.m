//
//  DROptionCardView.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/7/31.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DROptionCardView.h"
#import <Masonry/Masonry.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRToastView/DRToastView.h>
#import "DROptionCardLayout.h"
#import "DROptionCardCell.h"
#import "DRUIWidgetUtil.h"

@interface DROptionCardView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageControlH;

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSString *> *selectMap;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat velocity;


@end

@implementation DROptionCardView

- (void)setColumnCount:(NSInteger)columnCount {
    _columnCount = columnCount;
    DROptionCardLayout *layout = (DROptionCardLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = columnCount;
}

- (void)setColumnSpace:(CGFloat)columnSpace {
    _columnSpace = columnSpace;
    DROptionCardLayout *layout = (DROptionCardLayout *)self.collectionView.collectionViewLayout;
    layout.columnSpace = columnSpace;
    [self.collectionView reloadData];
}

- (void)setLineCount:(NSInteger)lineCount {
    _lineCount = lineCount;
    DROptionCardLayout *layout = (DROptionCardLayout *)self.collectionView.collectionViewLayout;
    layout.lineCount = lineCount;
}

- (void)setLineHeight:(CGFloat)lineHeight {
    _lineHeight = lineHeight;
    DROptionCardLayout *layout = (DROptionCardLayout *)self.collectionView.collectionViewLayout;
    layout.lineHeight = lineHeight;
}

- (void)setShowPageControl:(BOOL)showPageControll {
    _showPageControl = showPageControll;
    DROptionCardLayout *layout = (DROptionCardLayout *)self.collectionView.collectionViewLayout;
    layout.showPageControl = showPageControll;
}

- (void)setPageControlHeight:(CGFloat)pageControllHeight {
    _pageControlHeight = pageControllHeight;
    DROptionCardLayout *layout = (DROptionCardLayout *)self.collectionView.collectionViewLayout;
    layout.pageControlHeight = pageControllHeight;
    self.pageControlH.constant = pageControllHeight;
}

- (void)setMutableSelection:(BOOL)mutableSelection {
    _mutableSelection = mutableSelection;
    self.collectionView.allowsMultipleSelection = mutableSelection;
}

- (void)setAllOptions:(NSArray<NSString *> *)allOptions {
    _allOptions = allOptions;
    [self.collectionView reloadData];
}

- (void)setItemFaceXib:(NSInteger)itemFaceXib {
    self.itemFace = itemFaceXib;
}

- (void)setSelectedOptions:(NSArray<NSString *> *)selectedOptions {
    _selectedOptions = selectedOptions;

    [self.selectMap removeAllObjects];
    NSMutableArray *indexs = [NSMutableArray array];
    for (NSString *option in selectedOptions) {
        for (NSInteger i=0; i<self.allOptions.count; i++) {
            if ([option isEqualToString:self.allOptions[i]]) {
                if (!self.selectMap[@(i)]) {
                    self.selectMap[@(i)] = option;
                    [indexs addObject:@(i)];
                    break;
                }
            }
        }
    }
    _selectedIndexs = indexs;
    [self.collectionView reloadData];
}

- (void)setSelectedIndexs:(NSArray<NSNumber *> *)selectedIndexs {
    _selectedIndexs = selectedIndexs;

    [self.selectMap removeAllObjects];
    NSMutableArray *options = [NSMutableArray array];
    for (NSNumber *number in selectedIndexs) {
        NSString *option = self.allOptions[number.integerValue];
        if (option.length > 0) {
            [options addObject:option];
        }
        self.selectMap[number] = option;
    }
    _selectedOptions = options;
    [self.collectionView reloadData];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.containerView.backgroundColor = backgroundColor;
    self.collectionView.backgroundColor = backgroundColor;
}

- (void)setupPageControl {
    if (self.showPageControl) {
        DROptionCardLayout *layout = (DROptionCardLayout *)self.collectionView.collectionViewLayout;
        if (layout.pageCount > 1) {
            self.pageControl.hidden = NO;
            self.pageControl.numberOfPages = layout.pageCount;
            self.pageControl.currentPage = self.collectionView.contentOffset.x / CGRectGetWidth(self.collectionView.frame);
        } else {
            self.pageControl.hidden = YES;
        }
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allOptions.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DROptionCardCell class]) forIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    DROptionCardCell *cardCell = (DROptionCardCell *)cell;
    cardCell.itemSize = ((DROptionCardLayout *)self.collectionView.collectionViewLayout).itemSize;
    cardCell.itemFace = self.itemFace;
    cardCell.fontSize = self.fontSize;
    cardCell.itemCornerRadius = self.itemCornerRadius;
    if ([self.selectMap objectForKey:@(indexPath.item)]) {
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    } else {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
    cardCell.title = self.allOptions[indexPath.row];
    cardCell.selected = [self.selectMap objectForKey:@(indexPath.item)] != nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *option = self.allOptions[indexPath.row];
    if (self.mutableSelection) {
        if (self.selectMap.count >= self.maxSelectCount) {
            [collectionView deselectItemAtIndexPath:indexPath animated:NO];
            NSString *alert = self.beyondMaxAlert;
            if (!alert.length) {
                alert = [NSString stringWithFormat:@"最多选择 %ld 项", self.maxSelectCount];
            }
            [DRToastView showWithMessage:alert complete:nil];
        } else {
            [self.selectMap setObject:option forKey:@(indexPath.item)];
        }
    } else { // 单选
        [self.selectMap setObject:option forKey:@(indexPath.item)];
    }
    [self selectChange];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.mutableSelection) {
        if (self.selectMap.count > self.minSelectCount) { // 取消选中
            [collectionView deselectItemAtIndexPath:indexPath animated:NO];
            [self.selectMap removeObjectForKey:@(indexPath.item)];
        } else {
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            NSString *alert = self.belowMinAlert;
            if (!alert.length) {
                alert = [NSString stringWithFormat:@"最少选择 %ld 项", self.minSelectCount];
            }
            [DRToastView showWithMessage:alert complete:nil];
        }
        [self selectChange];
    } else {
        [self.selectMap removeObjectForKey:@(indexPath.item)];
    }
}

- (void)selectChange {
    NSMutableArray *options = [NSMutableArray array];
    NSMutableArray *optionIndexs =  [NSMutableArray array];
    for (NSInteger i=0; i<self.allOptions.count; i++) {
        if (self.selectMap[@(i)]) {
            [options addObject:self.allOptions[i]];
            [optionIndexs addObject:@(i)];
        }
    }
    _selectedOptions = options;
    _selectedIndexs = optionIndexs;
    kDR_SAFE_BLOCK(self.onSelectionChangeBlock, options, optionIndexs);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.startPoint = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = self.collectionView.contentOffset.x;
    DROptionCardLayout *layout = (DROptionCardLayout *)self.collectionView.collectionViewLayout;
    
    if (fabs(offsetX - self.startPoint.x) >= layout.pageWidth) {
        if (offsetX < self.startPoint.x) {
            offsetX += (self.startPoint.x - offsetX - layout.pageWidth) + layout.pageWidth / 3;
        }
        CGFloat x = (floor(offsetX / layout.pageWidth)) * layout.pageWidth;
        scrollView.contentOffset = CGPointMake(x, 0);
    } else if (fabs(self.velocity) > 0 && fabs(self.velocity) < 3) {
        CGFloat postion = self.velocity / fabs(self.velocity);
        CGFloat x = self.startPoint.x + layout.pageWidth * postion;
        [scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
        self.velocity = 0;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView.contentOffset.x == self.startPoint.x) {
        if (self.startPoint.x == 0 || self.startPoint.x == scrollView.contentSize.width - CGRectGetWidth(scrollView.frame)) {
            return;
        }
    }
    self.velocity = velocity.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self resetContentOffset];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self resetContentOffset];
}

- (void)resetContentOffset {
    CGFloat offsetX = self.collectionView.contentOffset.x;
    DROptionCardLayout *layout = (DROptionCardLayout *)self.collectionView.collectionViewLayout;
    
    NSInteger passCount = (NSInteger)floor(offsetX / layout.pageWidth);
    CGFloat restX = offsetX - passCount * layout.pageWidth;
    CGPoint targetOffset;
    if (restX < layout.pageWidth / 2) {
        targetOffset = CGPointMake(layout.pageWidth * passCount, 0);
    } else {
        targetOffset = CGPointMake(layout.pageWidth * (passCount + 1), 0);
    }
    [self.collectionView setContentOffset:targetOffset animated:YES];
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
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DROptionCardCell class]) bundle:KDR_CURRENT_BUNDLE] forCellWithReuseIdentifier:NSStringFromClass([DROptionCardCell class])];

        self.itemFace = DROptionCardViewItemFaceBorder;
        self.columnCount = 3;
        self.columnSpace = 13;
        self.lineCount = 3;
        self.lineHeight = 32;
        self.fontSize = 13;
        self.itemCornerRadius = 6;
        self.mutableSelection = NO;
        self.maxSelectCount = 3;
        self.minSelectCount = 1;
        self.showPageControl = NO;
        self.pageControlHeight = 30;
        self.velocity = 0;
        
        kDRWeakSelf
        DROptionCardLayout *layout = (DROptionCardLayout *)self.collectionView.collectionViewLayout;
        layout.layoutDoneBlock = ^{
            [weakSelf setupPageControl];
        };
        self.pageControl.pageIndicatorTintColor = [DRUIWidgetUtil descColor];
        self.pageControl.currentPageIndicatorTintColor = [DRUIWidgetUtil highlightColor];
    }
}

- (NSMutableDictionary<NSNumber *, NSString *> *)selectMap {
    if (!_selectMap) {
        _selectMap = [NSMutableDictionary dictionary];
    }
    return _selectMap;
}

@end
