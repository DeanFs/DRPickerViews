//
//  QCCardContainerBaseService.h
//  Records
//
//  Created by 冯生伟 on 2020/4/8.
//  Copyright © 2020 DuoRong Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRDragSortTableView.h"
#import "QCCardContainerController.h"

@interface QCCardContainerBaseService : NSObject<DRDragSortTableViewDelegate>

+ (instancetype)viewController;

#pragma mark - 当前卡片容器控制器
@property (weak, nonatomic) UINavigationController *navigationController;
@property (weak, nonatomic) QCCardContainerController *containerVc;
@property (weak, nonatomic) DRDragSortTableView *tableView;
@property (weak, nonatomic) UIView *view; // 当前containerVc.view

#pragma mark - 页面生命周期
- (void)setupCardContainerViwContoller;
- (void)registerTableViewCells;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewDidLayoutSubviews;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;

@end
