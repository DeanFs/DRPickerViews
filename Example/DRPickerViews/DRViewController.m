//
//  DRViewController.m
//  DRPickerViews
//
//  Created by Dean_F on 07/14/2019.
//  Copyright (c) 2019 Dean_F. All rights reserved.
//

#import "DRViewController.h"
#import <YYModel/YYModel.h>
#import <DRPickerViews/DRPickerFactory.h>
#import <DRCategories/NSDate+DRExtension.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import "DRPickerContainerView.h"

@interface DRViewController ()

@end

@implementation DRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self showPicker:indexPath.row];
}

- (void)showPicker:(DRPickerType)type {
    DRPickerOptionBase *opt;
    switch (type) {
        case DRPickerTypeYMD: {
            opt = [DRPickerDateOption optionWithTitle:@"选择日期" currentDate:[NSDate date] minDate:[NSDate minDate] maxDate:[NSDate maxDate]];
        } break;
            
        case DRPickerTypeWithLunar: {
            opt = [DRPickerWithLunarOption optionWithTitle:@"农历" minDate:[NSDate minDate] maxDate:[NSDate maxDate]];
            DRPickerWithLunarOption *lunarOpt = (DRPickerWithLunarOption *)opt;
            lunarOpt.year = 2018;
            lunarOpt.month = 12;
            lunarOpt.day = 4;
            lunarOpt.isLunar = NO;
            lunarOpt.leapMonth = NO;
        } break;
            
        case DRPickerTypeBirthday: {
            opt = [DRPickerBirthdayOption optionWithTitle:@"生日" minDate:[NSDate minDate] maxDate:[NSDate maxDate]];
            DRPickerBirthdayOption *lunarOpt = (DRPickerBirthdayOption *)opt;
            lunarOpt.year = -1;
            lunarOpt.month = 12;
            lunarOpt.day = 4;
            lunarOpt.isLunar = YES;
            lunarOpt.leapMonth = NO;
            lunarOpt.ignoreYear = NO;
        } break;
            
        case DRPickerTypePlanEnd: {
            opt = [DRPickerPlanEndOption optionWithTitle:@"计划结束时间" currentDate:nil startDate:[NSDate date].lastMonth maxDate:[NSDate maxDate]];
        } break;
            
        case DRPickerTypeYearMoth: {
            opt = [DRPickerDateOption optionWithTitle:@"选择月份" currentDate:[NSDate date] minDate:[NSDate minDate] maxDate:[NSDate maxDate]];
        } break;
            
        case DRPickerTypeYearMothFileter: {
            opt = [DRPickerYearMonthFilterOption optionWithTitle:@"选择月份" currentDate:[NSDate date] minDate:[NSDate minDate] maxDate:[NSDate maxDate]];
            ((DRPickerYearMonthFilterOption *)opt).monthViewFilterIndexs = @[@(0), @(2)];
        } break;
            
        case DRPickerTypeOneWeek: {
            opt = [DRPickerDateOption optionWithTitle:@"选择一周" currentDate:[NSDate date] minDate:[NSDate minDate] maxDate:[NSDate maxDate]];
        } break;
            
        case DRPickerTypeHMForDate: {
            opt = [DRPickerHMForDateOption optionWithTitle:@"修改小时分钟" currentDate:[NSDate date]];
        } break;
            
        case DRPickerTypeHMOnly: {
            opt = [DRPickerHMOnlyOption optionWithTitle:@"选择时间点"];
            ((DRPickerHMOnlyOption *)opt).currentTime = @"1229";
            ((DRPickerHMOnlyOption *)opt).forDuration = YES;
            ((DRPickerHMOnlyOption *)opt).canClean = YES;
            ((DRPickerHMOnlyOption *)opt).onCleanTimeBlock = ^(id deletedObj) {
                kDR_LOG(@"清除时间： %@", deletedObj);
            };
        } break;
            
        case DRPickerTypeHMPlanWeek: {
            opt = [DRPickerHMPlanWeekOption optionWithTitle:@"选择周时间点"];
//            ((DRPickerHMOnlyOption *)opt).currentTime = @"1229";
            ((DRPickerHMPlanWeekOption *)opt).forDuration = NO;
            ((DRPickerHMPlanWeekOption *)opt).weekDays = @[@(1), @(3), @(7)];
            ((DRPickerHMPlanWeekOption *)opt).onlyWeekDay = NO;
        } break;
            
        case DRPickerTypeTimeConsuming: {
            opt = [DRPickerTimeConsumingOption optionWithTitle:@"请选择消耗时长" timeConsuming:0/*2*24*3600+5*3600+33*60*/];
        } break;
            
        case DRPickerTypeRemindAhead: {
            opt = [DRPickerOptionBase optionWithTitle:@"设置提前提醒"];
        } break;
            
        case DRPickerTypeValueSelect: {
            opt = [DRPickerValueSelectOption optionWithTitle:@"请选择年龄" currentValue:25 minValue:12 maxValue:99 valueUnit:@"岁"];
        } break;
            
        case DRPickerTypeStringSelect: {
            opt = [DRPickerStringSelectOption optionWithTitle:@"请选择重复类型" stringOptions:@[@"快速复制", @"每天", @"每周", @"每月", @"自定义"]];
            ((DRPickerStringSelectOption *)opt).currentStringIndex = 2;
        } break;
            
        case DRPickerTypeOptionCard: {
            opt = [DRPickerOptionCardOption optionWithTitle:@"选项卡"];
            DRPickerOptionCardOption *cardOpt = (DRPickerOptionCardOption *)opt;
            cardOpt.allOptions = @[@"快速复制", @"每天", @"每周", @"每月", @"自定义", @"选项卡", @"选项卡", @"选项卡", @"选项卡"];
            cardOpt.selectedIndexs = @[@(1), @(3), @(7)];
            cardOpt.mutableSelection = YES;
            cardOpt.showPageControl = YES;
            cardOpt.lineCount = 2;
            cardOpt.belowMinAlert = @"不能再少啦！";
            cardOpt.sectionTip = @"最多选择3项";
        } break;
            
        default:
            break;
    }
    opt.dismissBlock = ^{
        kDR_LOG(@"picker dismiss");
    };
    opt.cancelBlock = ^{
        kDR_LOG(@"picker cancel");
    };
    opt.autoDismissWhenPicked = NO;
    
    [DRPickerFactory showPickerViewWithType:type pickerOption:opt pickDoneBlock:^(DRBaseAlertPicker * _Nonnull picker, id  _Nonnull pickedObject) {
        kDR_LOG(@"%@", pickedObject);
        [picker dismiss];
    }];
}

@end
