//
//  DRHorizenPageView.m
//  DRUIWidget_Example
//
//  Created by Cyfuer on 2019/10/9.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRHorizenPageView.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <Masonry/Masonry.h>
#import "DRCustomPageControl.h"
#import "DRHorizenPageLayout.h"

@interface DRHorizenPageView  ()<UICollectionViewDelegate, UICollectionViewDataSource>
/**
 容器
 */
@property (weak, nonatomic) IBOutlet UIView *containerView;
/**
 主视图
 */
@property (weak, nonatomic) IBOutlet UICollectionView *mainView;
@property (weak, nonatomic) IBOutlet DRHorizenPageLayout *layout;   // 布局
/**
 页面布局
 */
@property (weak, nonatomic) IBOutlet DRCustomPageControl *pageControl;

/**
 描述标识
 */
@property (nonatomic, copy) NSString *identifier;

/**
 总共多少页
 */
@property (nonatomic, assign) NSUInteger totalPages;

/**
 底部间距，不显示pagecontrol需要置为0
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainBottomConst;
@end

@implementation DRHorizenPageView

#pragma mark - 初始化

- (instancetype)init {
    if (self = [super init]) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    if (!self.containerView) {
           self.containerView = kDR_LOAD_XIB_NAMED(NSStringFromClass([self class]));
           [self addSubview:self.containerView];
           [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.left.bottom.right.mas_offset(0);
           }];
        
        self.mainView.delegate = self;
        self.mainView.dataSource = self;
        self.pageControl.positionType = DRPageControlPositionTypeMiddle;
        self.mainView.showsVerticalScrollIndicator = NO;
        self.mainView.showsHorizontalScrollIndicator = NO;
       }
    
    // 将nib创建的视图关联上来
}

#pragma mark - public
/**
 需要注册cell
 */
- (void)registerCell:(Class)cell withIdentifier:(NSString *)identifier {
    [self.mainView registerClass:cell forCellWithReuseIdentifier:identifier];
    self.identifier = identifier;
}

- (void)registerCellWithNib:(UINib *)nib withIdentifier:(NSString *)identifier {
    [self.mainView registerNib:nib forCellWithReuseIdentifier:identifier];
    self.identifier = identifier;
}


#pragma mark - private method

- (void)updateSubViews {
    [self.mainView reloadData];
    // 配置页数
    
    if (!(self.colunmCount > 0 & self.rowCount > 0 & self.datasource.count > 0)) return;
    
    NSInteger pages = (self.datasource.count - 1) / (self.colunmCount * self.rowCount) + 1;
    self.pageControl.numberOfPages = pages;
    
    self.pageControl.hidden = pages == 1;
    
    NSInteger currentPage = self.mainView.contentOffset.x / (int)self.mainView.bounds.size.width;
    self.pageControl.currentPage = currentPage;
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger currentPage = targetContentOffset->x / (int)self.mainView.bounds.size.width;
    self.pageControl.currentPage = currentPage;
}


#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.identifier forIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(pageView:configurateCell:forIndex:)]) {
        [self.delegate pageView:self configurateCell:cell forIndex:indexPath];
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(pageView:didTapCell:atIndex:)]) {
        [self.delegate pageView:self didTapCell:cell atIndex:indexPath];
    }
}



#pragma mark - setter & getter
- (void)setColunmCount:(NSInteger)colunmCount
{
    _colunmCount = colunmCount;
    self.layout.columnCount = colunmCount;
    [self updateSubViews];
}

- (void)setRowCount:(NSInteger)rowCount {
    _rowCount = rowCount;
    self.layout.rowCount = _rowCount;
    [self updateSubViews];
}

- (void)setDatasource:(NSArray *)datasource {
    _datasource = datasource;
    [self updateSubViews];
}


- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    self.pageControl.normalColor = normalColor;
}

- (void)setCurrentColor:(UIColor *)currentColor {
    _currentColor = currentColor;
    self.pageControl.currentColor = currentColor;
}

- (void)setCurrentRatio:(NSInteger)currentRatio {
    _currentRatio = currentRatio;
    self.pageControl.currentRatio = currentRatio;
}

- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    self.mainBottomConst.constant = _showPageControl ? 20 : 0;
    self.pageControl.hidden = !_showPageControl;
}

@end
