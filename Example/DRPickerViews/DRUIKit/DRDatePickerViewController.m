//
//  DRDatePickerViewController.m
//  DRUIWidget_Example
//
//  Created by 冯生伟 on 2019/10/9.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRDatePickerViewController.h"
#import <DRPickerViews/DRDatePickerView.h>
#import <DRPickerViews/DRNormalDataPickerView.h>
#import <DRPickerViews/DROptionCardView.h>
#import <DRCategories/NSDate+DRExtension.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import <DRPickerViews/DRCheckboxGroupView.h>
#import <DRPickerViews/DRClassTermPickerView.h>
#import <DRPickerViews/DRWeekPickerView.h>

@interface DRDatePickerViewController ()

@property (weak, nonatomic) IBOutlet DRDatePickerView *datePickerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControll;
@property (weak, nonatomic) IBOutlet DRNormalDataPickerView *normalDataPicker;
@property (weak, nonatomic) IBOutlet DROptionCardView *optionCard;
@property (weak, nonatomic) IBOutlet DRCheckboxGroupView *checkboxView;
@property (weak, nonatomic) IBOutlet DRClassTermPickerView *classTermPicker;
@property (weak, nonatomic) IBOutlet DRWeekPickerView *weekPickerView;

@end

@implementation DRDatePickerViewController

+ (instancetype)viewController {
    return kDR_LOAD_STORYBOARD_NAMED(@"DatePicker");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [NSDate setCalendarWeekFirstday:7];
    [self.datePickerView setupWithCurrentDate:[NSDate date]
                                      minDate:[NSDate minDate]
                                      maxDate:[NSDate maxDate]
                                        month:5
                                          day:5];
    kDRWeakSelf
    NSArray *arr1 = @[@"前一天",@"当天"];
    NSMutableArray *arr2 = [NSMutableArray array];
    for (NSInteger i=0; i<24; i++) {
        [arr2 addObject:[NSString stringWithFormat:@"%02ld", i]];
    }
    NSMutableArray *arr3 = [NSMutableArray array];
    for (NSInteger i=0; i<60; i+=5) {
        [arr3 addObject:[NSString stringWithFormat:@"%02ld", i]];
    }
    self.normalDataPicker.dataSource = @[arr1, @[@""], arr2, arr3];
    self.normalDataPicker.onSelectedChangeBlock = ^(NSInteger section, NSInteger index, NSString *selectedString) {
        NSLog(@"组：%ld，行：%ld，值：%@", (long)section, (long)index, selectedString);
        NSLog(@"%@", weakSelf.normalDataPicker.currentSelectedStrings);
    };
    self.normalDataPicker.getFontForSectionWithBlock = ^UIFont *(NSInteger section, NSInteger row) {
        if (section == 0) {
            return [UIFont dr_PingFangSC_MediumWithSize:17];
        }
        if (section == 1) {
            return [UIFont systemFontOfSize:6];
        }
        return [UIFont dr_PingFangSC_RegularWithSize:26];
    };
    self.normalDataPicker.getWidthForSectionWithBlock = ^CGFloat(NSInteger section) {
        if (section == 0) {
            return 100;
        }
        if (section == 1) {
            return 14;
        }
        return 60;
    };
    self.normalDataPicker.getTextAlignmentForSectionBlock = ^NSTextAlignment(NSInteger section) {
        if (section == 0) {
            return NSTextAlignmentRight;
        }
        if (section == 2) {
            return NSTextAlignmentRight;
        }
        return NSTextAlignmentLeft;
    };
    self.normalDataPicker.getSeparateTextBeforeSectionBlock = ^NSString *(NSInteger section) {
        if (section == 2) {
            return @"/";
        }
        return @"";
    };
    self.normalDataPicker.getIsLoopForSectionBlock = ^BOOL(NSInteger section) {
        if (section == 0 || section == 1) {
            return NO;
        }
        return YES;
    };
    self.normalDataPicker.currentSelectedStrings = @[@"当天", @"", @"08", @"00"];


    NSMutableArray *options = [NSMutableArray array];
    NSMutableArray *selecteds = [NSMutableArray array];
    for (NSInteger i=1; i<26; i++) {
        NSString *opt = [NSString stringWithFormat:@"%ld", i];
        [options addObject:opt];
        if (i % 2 == 0) {
            [selecteds addObject:opt];
        }
    }
    self.optionCard.allOptions = options;
    self.optionCard.selectedOptions = selecteds;


    self.checkboxView.optionTitles = @[@"单周", @"双周", @"每周"];
    self.checkboxView.selectedIndexs = @[@(1)];
    self.checkboxView.onSelectedChangeBlock = ^(NSArray<NSNumber *> * _Nonnull selectedIndexs, NSArray<NSString *> * _Nonnull selectedOptions) {
        kDR_LOG(@"%@-%@", selectedIndexs.firstObject, selectedOptions.firstObject);
    };

    self.classTermPicker.edudationSource = @[@[@"大一", @"大二", @"大三", @"大四", @"大五"],
                                             @[@"研一", @"研二", @"研三", @"研四", @"研五"]];
    
    
    [self.weekPickerView setupWithCurrentDate:[NSDate dateWithString:@"20190131" dateFormat:@"yyyyMMdd"] minDate:[NSDate minDate] maxDate:[NSDate maxDate] selectChangeBlock:^(DRWeekPickerDateModel *currentWeek) {
        kDR_LOG(@"%@", currentWeek.firstDateInWeek);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onModeChange:(UISegmentedControl *)sender {
    self.datePickerView.dateMode = sender.selectedSegmentIndex;
}

@end
