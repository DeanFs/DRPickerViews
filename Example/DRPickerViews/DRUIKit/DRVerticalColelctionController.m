//
//  DRVerticalColelctionController.m
//  DRUIWidget_Example
//
//  Created by Cyfuer on 2019/10/9.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRVerticalColelctionController.h"
#import "DRCustomVerticalLayout.h"

@interface DRVerticalColelctionController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *mainView;
@property (weak, nonatomic) IBOutlet DRCustomVerticalLayout *layout;

/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray <NSMutableArray *>* datasource;
@end

@implementation DRVerticalColelctionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

- (void)initSubViews {
    
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    
    self.layout.itemSize = CGSizeMake(80, 100);
    self.layout.minimumInteritemSpacing = 20;
    
    
    self.layout.headerReferenceSize = CGSizeMake(self.mainView.bounds.size.width, 40);
    
    [self.mainView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.datasource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource[section].count;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (![kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return nil;
    }
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"myHeader" forIndexPath:indexPath];
    headerView.backgroundColor = UIColor.redColor;
    return headerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    cell.backgroundColor = self.datasource[indexPath.section][indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 添加一个元素
    
    UIColor *randomColor = [UIColor colorWithRed:arc4random()%255/255.0f green:arc4random()%255/255.0f blue:arc4random()%255/255.0f alpha:1];
    NSMutableArray *tmpArr = self.datasource[indexPath.section];
    [tmpArr addObject:randomColor];

    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.layout invalidateLayout];
        [self.mainView reloadData];
    });
    
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = @[].mutableCopy;
        
        
        for (int i = 0; i< 3; i++) {
            NSMutableArray *tmpArr = @[].mutableCopy;
            
            for (int i = 0; i< 2; i++) {
                UIColor *randomColor = [UIColor colorWithRed:arc4random()%255/255.0f green:arc4random()%255/255.0f blue:arc4random()%255/255.0f alpha:1];
                [tmpArr addObject:randomColor];
            }
            
            [_datasource addObject:tmpArr];
        }
        
    }
    return _datasource;
}

@end
