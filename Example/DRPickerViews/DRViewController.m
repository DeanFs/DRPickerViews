//
//  DRViewController.m
//  DRPickerViews
//
//  Created by Dean_F on 07/14/2019.
//  Copyright (c) 2019 Dean_F. All rights reserved.
//

#import "DRViewController.h"
#import <YYModel/YYModel.h>
#import <DRPickerViews/DRDatePickerFactory.h>
#import <DRCategories/NSDate+DRExtension.h>

@interface DRViewController ()

@end

@implementation DRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self showPicker:indexPath.row];
}

- (void)showPicker:(DRDatePickerType)type {
    DRDatePickerOption *option = [[DRDatePickerOption alloc] init];
    //    option.isLunar = YES;
    //    option.ignoreYear = YES;
    //    option.month = 3;
    //    option.day = 3;
    option.cancelBlock = ^{
        NSLog(@"cancel");
    };
    option.dismissBlock = ^{
        NSLog(@"dismiss");
    };
    
    //    option.canClean = YES;
    option.cleanBlock = ^(id _Nonnull deletedObj) {
        NSLog(@"clean button tapped \nobject: %@", deletedObj);
    };
    option.title = @"test title";
    option.weekDays = @[@2, @4, @7];
    option.currentTime = @"2211";
    option.forDuration = YES;
    option.currentDuration = 44*60;
    option.onlyWeekDay = YES;
    
    //    option.autoDismissWhenPicked = NO;
    
    NSDate *date = [NSDate dateWithDateString:@"2019-04-10 10:56:00" dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *minDate = [NSDate dateWithDateString:@"2018-11-01" dateFormat:@"yyyy-MM-dd"];
    NSDate *maxDate = [NSDate dateWithDateString:@"2019-10-22" dateFormat:@"yyyy-MM-dd"];
    
    [DRDatePickerFactory showDatePickerWithType:type
                                    currentDate:date
                                        minDate:minDate
                                        maxDate:maxDate
                                    otherOption:option
                                  pickDoneBlock:^(DRBaseDatePicker *picker, id pickedObject) {
                                      NSLog(@"%@ \n %@", pickedObject, [pickedObject yy_modelToJSONString]);
                                  }];
}

@end
