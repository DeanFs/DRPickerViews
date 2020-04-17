//
//  DRUIKitViewController.m
//  DRUIWidget
//
//  Created by Dean_F on 10/08/2019.
//  Copyright (c) 2019 Dean_F. All rights reserved.
//

#import "DRUIKitViewController.h"
#import "DRDatePickerViewController.h"

@interface DRUIKitViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 数据源
 */
@property (nonatomic, strong) NSArray * dataSource;
@end

@implementation DRUIKitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSubViews];
}

- (void)initSubViews {
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


#pragma mark - delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"starRateDetail" sender:nil];
    } else if(indexPath.row == 1) {
        [self performSegueWithIdentifier:@"enlargeLayout" sender:nil];
    } else if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"showWaveController" sender:nil];
    } else if (indexPath.row == 3) {
        [self performSegueWithIdentifier:@"HorizenPageShow" sender:nil];
    } else if (indexPath.row == 4) {
        [self performSegueWithIdentifier:@"verticalShowAction" sender:nil];
    } else if (indexPath.row == 5) {
        DRDatePickerViewController *datePickerVc = [DRDatePickerViewController viewController];
        [self.navigationController pushViewController:datePickerVc animated:YES];
    } else if (indexPath.row == 6) {
        [self performSegueWithIdentifier:@"showComponent" sender:nil];
    } else if (indexPath.row == 7) {
           [self performSegueWithIdentifier:@"showSegmentBar" sender:nil];
    }
    
    // 页面展示
    NSLog(@"did selected index: %@",indexPath);
}


#pragma mark - setter & getter
- (NSArray *)dataSource {
    return @[@"星星评级",@"中间滑动放大视图",@"音频水波",@"水平分页",@"竖直布局",@"日期选择器",@"横向布局合并pageControl",@"segmentBar"];
}
@end
