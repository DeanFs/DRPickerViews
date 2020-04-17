//
//  QCCardContainerBaseService.m
//  Records
//
//  Created by 冯生伟 on 2020/4/8.
//  Copyright © 2020 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "QCCardContainerBaseService.h"
#import <DRMacroDefines/DRMacroDefines.h>

@implementation QCCardContainerBaseService

+ (instancetype)viewController {
    return [self new];
}

#pragma mark - 页面生命周期
- (void)setupCardContainerViwContoller {}
- (void)registerTableViewCells {}
- (void)viewDidLoad {}
- (void)viewWillAppear:(BOOL)animated {}
- (void)viewDidAppear:(BOOL)animated {}
- (void)viewDidLayoutSubviews {}
- (void)viewWillDisappear:(BOOL)animated {}
- (void)viewDidDisappear:(BOOL)animated {}
- (void)dealloc {
    kDR_LOG(@"%@ dealloc", NSStringFromClass([self class]))
}

#pragma mark - UITableViewDataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
