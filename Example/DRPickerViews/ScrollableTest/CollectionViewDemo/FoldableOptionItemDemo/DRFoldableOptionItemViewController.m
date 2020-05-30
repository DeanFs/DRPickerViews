//
//  DRFoldableOptionItemViewController.m
//  DRScrollableViews_Example
//
//  Created by 冯生伟 on 2019/9/4.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRFoldableOptionItemViewController.h"
#import "UIScrollView+QCPullDown.h"
#import <DRMacroDefines/DRMacroDefines.h>

@interface DRFoldableOptionItemViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DRFoldableOptionItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setContentInset:UIEdgeInsetsMake(-100, 0, 0, 0)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.tableView setupCanPullDownWithContainerView:self.tableView onPullChangeBlock:nil];
}

- (void)dealloc {
    kDR_LOG(@"%@ dealloc", NSStringFromClass([self class]))
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = @"下拉查看下程序";
    return cell;
}

@end
