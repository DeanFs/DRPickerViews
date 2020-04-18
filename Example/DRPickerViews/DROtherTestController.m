//
//  DROtherTestController.m
//  DRPickerViews_Example
//
//  Created by 冯生伟 on 2020/4/17.
//  Copyright © 2020 Dean_F. All rights reserved.
//

#import "DROtherTestController.h"
#import "DRDragSortTableViewController.h"
#import <DRPickerViews/QCActionSheet.h>

@interface DROtherTestController ()

@end

@implementation DROtherTestController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        DRDragSortTableViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DRDragSortTableViewController"];;
        [QCCardContainerController showContainerWithContentVc:vc
                                                   atPosition:QCCardContentPositionBottom];
    } else if (indexPath.row == 3) {
        NSArray *options = @[@"仅删除当天", @"删除今天及未来的重复", @"删除全部重复"];
        [QCActionSheet showActionSheetWithOptions:options icons:nil setupBlock:nil selectAction:^(NSArray<NSNumber *> *indexs, NSArray<id> *options, QCActionSheet *theSheet) {
            NSLog(@"index: %@", indexs.firstObject);
        } cancelBlock:^(BOOL isCancelButton) {
            
        }];
    } else if (indexPath.row == 4) {
        DRDragSortTableViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DRDragSortTableViewController"];;
        [QCCardContainerController showContainerWithContentVc:vc
                                                   atPosition:QCCardContentPositionCenter];
    }
}

@end
