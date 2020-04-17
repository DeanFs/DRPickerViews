//
//  DRFocusTempleViewController.m
//  DRUIWidget_Example
//
//  Created by Cyfuer on 2019/10/8.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRFocusTempleViewController.h"
#import "DRFocusEnlargeLayout.h"

@interface DRFocusTempleViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *mainView;

/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray * datasource;

@end

@implementation DRFocusTempleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

- (void)initSubViews {
    
    self.mainView.dataSource = self;
    self.mainView.delegate = self;
    
    DRFocusEnlargeLayout *layout = [[DRFocusEnlargeLayout alloc] init];
    layout.itemSize = CGSizeApplyAffineTransform(self.mainView.bounds.size, CGAffineTransformMakeScale(0.8, 1));
    layout.minimumLineSpacing = -self.mainView.bounds.size.width * 0.2f * 0.3f;
    
    [self.mainView setCollectionViewLayout:layout];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myLayoutCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = self.datasource[indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [[NSMutableArray alloc] initWithCapacity:5];
        for (int i = 0; i< 5; i++) {
            UIColor *randomColor = [UIColor colorWithRed:arc4random()%255/255.0f green:arc4random()%255/255.0f blue:arc4random()%255/255.0f alpha:1];
            [_datasource addObject:randomColor];
        }
    }
    return _datasource;
}
@end
