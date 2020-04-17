//
//  DRComponentPageController.m
//  DRUIWidget_Example
//
//  Created by Cyfuer on 2019/10/9.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRComponentPageController.h"
#import <DRHorizenPageView.h>
#import "DRPageTemplateCell.h"

@interface DRComponentPageController ()<DRHorizenPageViewDelegate>
@property (weak, nonatomic) IBOutlet DRHorizenPageView *mainView;

/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray * datasource;

@end

@implementation DRComponentPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

- (void)initSubViews {
    
    self.view.backgroundColor = [UIColor blueColor];
//    self.mainView.backgroundColor = [UIColor clearColor];
    
    [self.mainView registerCellWithNib:[UINib nibWithNibName:NSStringFromClass(DRPageTemplateCell.class) bundle:nil] withIdentifier:NSStringFromClass(DRPageTemplateCell.class)];
    
    self.mainView.delegate = self;
    self.mainView.controlHeight = 15;
    self.mainView.currentRatio = 2;
    
    self.mainView.datasource = self.datasource;
}

#pragma mark - delegate
- (void)pageView:(DRHorizenPageView *)pageView configurateCell:(__kindof DRPageTemplateCell *)cell forIndex:(NSIndexPath *)indexPath {
       UIColor *randomColor = [UIColor colorWithRed:arc4random()%255/255.0f green:arc4random()%255/255.0f blue:arc4random()%255/255.0f alpha:1];
       cell.backgroundColor = randomColor;
}

- (void)pageView:(DRHorizenPageView *)pageView didTapCell:(UICollectionViewCell *)cell atIndex:(NSIndexPath *)indexPath {
    // 数据选中
    NSLog(@"选中了第%ld条数据",indexPath.row);
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
        for (int i = 0; i< 10; i++) {
            NSString *tmpString = [NSString stringWithFormat:@"hahaha%ld",i];
            [_datasource addObject:tmpString];
        }
    }
    return _datasource;
}



@end
