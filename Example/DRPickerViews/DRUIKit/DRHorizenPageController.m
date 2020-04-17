//
//  DRHorizenPangeController.m
//  DRUIWidget_Example
//
//  Created by Cyfuer on 2019/10/8.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRHorizenPageController.h"
#import "DRCustomPageControl.h"

@interface DRHorizenPageController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *mainView;
@property (weak, nonatomic) IBOutlet DRCustomPageControl *pageController;

@end

@implementation DRHorizenPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

- (void)initSubViews {
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    
    UIColor *randomColor = [UIColor colorWithRed:arc4random()%255/255.0f green:arc4random()%255/255.0f blue:arc4random()%255/255.0f alpha:1];
    cell.backgroundColor = randomColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger currentPage = targetContentOffset->x / (int)self.mainView.bounds.size.width;
    self.pageController.currentPage = currentPage;
}

@end
