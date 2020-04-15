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
#import <DRCategories/UIView+DRExtension.h>

@interface DROptionCardView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageControlH;

@property (strong, nonatomic) DROptionCardLayout *layout;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSString *> *selectMap;
@property (nonatomic, assign) CGPoint targetOffset;
@property (nonatomic, assign) BOOL didRrawRect;

@end

@implementation DROptionCardView

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)setColumnCount:(NSInteger)columnCount {
    _columnCount = columnCount;
    self.layout.columnCount = columnCount;
}

- (void)setColumnSpace:(CGFloat)columnSpace {
    _columnSpace = columnSpace;
    self.layout.columnSpace = columnSpace;
    [self.collectionView reloadData];
}

- (void)setLineCount:(NSInteger)lineCount {
    _lineCount = lineCount;
    self.layout.lineCount = lineCount;
}

- (void)setLineHeight:(CGFloat)lineHeight {
    _lineHeight = lineHeight;
    self.layout.lineHeight = lineHeight;
}

- (void)setShowPageControl:(BOOL)showPageControll {
    _showPageControl = showPageControll;
    self.layout.showPageControl = showPageControll;
}

- (void)setPageControlHeight:(CGFloat)pageControllHeight {
    _pageControlHeight = pageControllHeight;
    self.layout.pageControlHeight = pageControllHeight;
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
        if (self.layout.pageCount > 1) {
            self.pageControl.hidden = NO;
            self.pageControl.numberOfPages = self.layout.pageCount;
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
    cardCell.itemSize = self.layout.itemSize;
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.decelerating) {
        [scrollView setContentOffset:self.targetOffset animated:YES];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger index = floor(scrollView.contentOffset.x / self.layout.pageWidth);
    CGFloat rest = scrollView.contentOffset.x - index * self.layout.pageWidth;
    if (velocity.x > 0) { // 向左加速滑
        if ((rest > scrollView.width / 2 || velocity.x > 0.4) && index < self.layout.pageCount - 1) {
            *targetContentOffset = CGPointMake((index + 1) * self.layout.pageWidth, 0);
        } else {
            *targetContentOffset = CGPointMake(index * self.layout.pageWidth, 0);
        }
    } else if (velocity.x < 0) { // 向右加速滑
        if (index >= 0 && (rest < scrollView.width / 2 || velocity.x < -0.4)) {
            *targetContentOffset = CGPointMake(index * self.layout.pageWidth, 0);
        } else {
            *targetContentOffset = CGPointMake((index + 1) * self.layout.pageWidth, 0);
        }
    } else { // 无加速
        if (rest > scrollView.width / 2) {
            *targetContentOffset = CGPointMake((index + 1) * self.layout.pageWidth, 0);
        } else {
            *targetContentOffset = CGPointMake(index * self.layout.pageWidth, 0);
        }
    }
    self.targetOffset = *targetContentOffset;
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
        
        self.layout = [DROptionCardLayout new];
        [self.collectionView setCollectionViewLayout:self.layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DROptionCardCell class]) bundle:KDR_CURRENT_BUNDLE] forCellWithReuseIdentifier:NSStringFromClass([DROptionCardCell class])];
        self.itemFace = DROptionCardViewItemFaceBorder;
        self.columnCount = 3;
        self.columnSpace = 6.5;
        self.lineCount = 3;
        self.lineHeight = 32;
        self.fontSize = 13;
        self.itemCornerRadius = 16;
        self.mutableSelection = NO;
        self.maxSelectCount = 3;
        self.minSelectCount = 1;
        self.showPageControl = NO;
        self.pageControlHeight = 30;
        
        kDRWeakSelf
        self.layout.layoutDoneBlock = ^{
            [weakSelf setupPageControl];
        };
        self.pageControl.pageIndicatorTintColor = [DRUIWidgetUtil descColor];
        self.pageControl.currentPageIndicatorTintColor = [DRUIWidgetUtil highlightColor];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if (CGRectIsEmpty(rect)) {
        return;
    }
    if (!self.didRrawRect) {
        self.didRrawRect = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
}

- (NSMutableDictionary<NSNumber *, NSString *> *)selectMap {
    if (!_selectMap) {
        _selectMap = [NSMutableDictionary dictionary];
    }
    return _selectMap;
}

@end
