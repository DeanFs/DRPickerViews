//
//  DRStarRateViewController.m
//  DRUIWidget_Example
//
//  Created by Cyfuer on 2019/10/8.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRStarRateViewController.h"
#import "DRStarRateView.h"
#import <Masonry/Masonry.h>

@interface DRStarRateViewController ()

@end

@implementation DRStarRateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    DRStarRateView *rateView1 = [[DRStarRateView alloc] init];
    
//    rateView1.backgroundColor = [UIColor redColor];
    rateView1.frame = CGRectMake(20, 300, 280, 60);
    [rateView1 setupNumberOfStar:10 currentrating:3.5 completion:^(CGFloat currentScore) {
        NSLog(@"点击了：%.2f",currentScore);
    }];
    
    [self.view addSubview:rateView1];
    
    
    DRStarRateView *rateView2 = [[DRStarRateView alloc] init];
    [rateView2 setupNumberOfStar:5 currentrating:1.5 completion:^(CGFloat currentScore) {
        NSLog(@"点击了：%.2f",currentScore);
    }];
    rateView2.numberOfStar = 8;
          
    [self.view addSubview:rateView2];
    
    [rateView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(400);
        make.left.mas_offset(20);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(30);
    }];
}


@end
