//
//  DROtherTestController.m
//  DRPickerViews_Example
//
//  Created by 冯生伟 on 2020/4/17.
//  Copyright © 2020 Dean_F. All rights reserved.
//

#import "DROtherTestController.h"
#import "DRDragSortTableViewController.h"


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
    }
}

@end
