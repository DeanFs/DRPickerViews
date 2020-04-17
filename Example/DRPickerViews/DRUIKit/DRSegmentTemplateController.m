//
//  DRSegmentTemplateController.m
//  DRUIWidget_Example
//
//  Created by Cyfuer on 2019/10/9.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRSegmentTemplateController.h"
#import <DRSegmentBar.h>
#import <Masonry/Masonry.h>
#import <DRCategories/DRCategories.h>

@interface DRSegmentTemplateController ()
@property (weak, nonatomic) IBOutlet DRSegmentBar *segmentBar;

@property (weak, nonatomic) IBOutlet DRSegmentBar *segmentBar1;

@property (weak, nonatomic) IBOutlet DRSegmentBar *segmentBar2;

@end

@implementation DRSegmentTemplateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

- (void)initSubViews {
    // 配置项
    [self configureSegmentSubViews];
    [self configureSegment1SubViews];
    [self configureSegment2SubViews];
}


- (void)configureSegmentSubViews {
    UIScrollView *container = [[UIScrollView alloc] init];
    [self.view addSubview:container];
       [container mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(self.segmentBar.mas_bottom);
           make.left.right.mas_equalTo(self.view);
           make.height.mas_equalTo(100);
       }];
       [container setNeedsLayout];
       [container layoutIfNeeded];
       // 创建多个视图添加上去
       
       NSMutableArray *titles = @[].mutableCopy;
       
       for (int i = 0; i<2; i++) {
           
           CGFloat x = i * self.view.width;
           UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(x , 0, self.view.width, container.height)];
           UIColor *randomColor = [UIColor colorWithRed:arc4random()%255/255.0f green:arc4random()%255/255.0f blue:arc4random()%255/255.0f alpha:1];
           tmpView.backgroundColor = randomColor;
           [container addSubview:tmpView];
           container.pagingEnabled = YES;
           NSString *title = [NSString stringWithFormat:@"测试%d",i];
           if (i == 2) {
               title = @"这是一个";
           }
           [titles addObject:title];
       }
       
       container.contentSize = CGSizeMake(self.view.width * 5, container.height);
       
       [self.segmentBar setupWithAssociatedScrollView:container titles:titles];
}


- (void)configureSegment1SubViews {
    UIScrollView *container = [[UIScrollView alloc] init];
    [self.view addSubview:container];
       [container mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(self.segmentBar1.mas_bottom);
           make.left.right.mas_equalTo(self.view);
           make.height.mas_equalTo(100);
       }];
       [container setNeedsLayout];
       [container layoutIfNeeded];
       // 创建多个视图添加上去
       
       NSMutableArray *titles = @[].mutableCopy;
       
       for (int i = 0; i<5; i++) {
           
           CGFloat x = i * self.view.width;
           UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(x , 0, self.view.width, container.height)];
           UIColor *randomColor = [UIColor colorWithRed:arc4random()%255/255.0f green:arc4random()%255/255.0f blue:arc4random()%255/255.0f alpha:1];
           tmpView.backgroundColor = randomColor;
           [container addSubview:tmpView];
           container.pagingEnabled = YES;
           NSString *title = [NSString stringWithFormat:@"测试%d",i];
           if (i == 2) {
               title = @"这是一个";
           }
           [titles addObject:title];
       }
       
       container.contentSize = CGSizeMake(self.view.width * 5, container.height);
       
       [self.segmentBar1 setupWithAssociatedScrollView:container titles:titles];
}


- (void)configureSegment2SubViews {
    UIScrollView *container = [[UIScrollView alloc] init];
    [self.view addSubview:container];
       [container mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(self.segmentBar2.mas_bottom);
           make.left.right.mas_equalTo(self.view);
           make.height.mas_equalTo(100);
       }];
       [container setNeedsLayout];
       [container layoutIfNeeded];
       // 创建多个视图添加上去
       
       NSMutableArray *titles = @[].mutableCopy;
       
       for (int i = 0; i<5; i++) {
           
           CGFloat x = i * self.view.width;
           UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(x , 0, self.view.width, container.height)];
           UIColor *randomColor = [UIColor colorWithRed:arc4random()%255/255.0f green:arc4random()%255/255.0f blue:arc4random()%255/255.0f alpha:1];
           tmpView.backgroundColor = randomColor;
           [container addSubview:tmpView];
           container.pagingEnabled = YES;
           NSString *title = [NSString stringWithFormat:@"测试%d",i];
           if (i == 2) {
               title = @"这是一个";
           }
           [titles addObject:title];
       }
       
       container.contentSize = CGSizeMake(self.view.width * 5, container.height);
       [self.segmentBar2 setupWithAssociatedScrollView:container titles:titles];
    self.segmentBar2.flagImageOffsetBottom = -self.segmentBar2.flagImage.size.height/2.0f;
}


@end
