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
#import <BlocksKit/UIView+BlocksKit.h>

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
            opt = [DRPickerWithLunarOption optionWithTitle:@"农历"];
            DRPickerWithLunarOption *lunarOpt = (DRPickerWithLunarOption *)opt;
            lunarOpt.type = DRYMDWithLunarPickerTypeCanIngnoreYear;
            lunarOpt.showDoubleCalendarTip = YES;
            lunarOpt.year = 2018;
            lunarOpt.month = 12;
            lunarOpt.day = 4;
            lunarOpt.isLunar = NO;
//            lunarOpt.leapMonth = NO;
//            lunarOpt.ignoreYear = NO;
        } break;
            
        case DRPickerTypePlanEnd: {
            opt = [DRPickerPlanEndOption optionWithTitle:@"计划结束时间" currentDate:nil startDate:[NSDate date].lastMonth maxDate:[NSDate maxDate]];
        } break;
            
        case DRPickerTypeYearMoth: {
            opt = [DRPickerDateOption optionWithTitle:@"选择月份" currentDate:[NSDate date] minDate:[NSDate minDate] maxDate:[NSDate maxDate]];
        } break;

        case DRPickerTypeYearOrYearMoth: {
            opt = [DRPickerYearOrYearMonthOption optionWithTitle:@"选择时间段" currentDate:[NSDate date] minDate:[NSDate minDate] maxDate:[NSDate maxDate]];
            ((DRPickerYearOrYearMonthOption *)opt).isOnlyYear = YES;
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
//            ((DRPickerHMOnlyOption *)opt).canClean = YES;
//            ((DRPickerHMOnlyOption *)opt).showDurationTip = NO;
            ((DRPickerHMOnlyOption *)opt).minDuration = ((DRPickerHMOnlyOption *)opt).timeScale;
            ((DRPickerHMOnlyOption *)opt).allowBeyondDay = YES;
            ((DRPickerHMOnlyOption *)opt).onCleanTimeBlock = ^(id deletedObj) {
                kDR_LOG(@"清除时间： %@", deletedObj);
            };
            opt.cancelButtonTitle = @"清除";
        } break;
            
        case DRPickerTypeHMPlanWeek: {
            opt = [DRPickerHMPlanWeekOption optionWithTitle:@"选择周时间点"];
            ((DRPickerHMOnlyOption *)opt).currentTime = @"1229";
            ((DRPickerHMPlanWeekOption *)opt).forDuration = YES;
            ((DRPickerHMPlanWeekOption *)opt).weekDays = @[@(1), @(3), @(7)];
            ((DRPickerHMPlanWeekOption *)opt).onlyWeekDay = NO;
        } break;
            
        case DRPickerTypeTimeConsuming: {
            opt = [DRPickerTimeConsumingOption optionWithTitle:@"请选择消耗时长" timeConsuming:10*60/*2*24*3600+5*3600+33*60*/];
            ((DRPickerTimeConsumingOption*)opt).maxTimeConsume = 24*60-1;
            ((DRPickerTimeConsumingOption*)opt).minTimeConsume = 30;
        } break;
            
        case DRPickerTypeRemindAhead: {
            opt = [DRPickerOptionBase optionWithTitle:@"设置提前提醒"];
        } break;
            
        case DRPickerTypeValueSelect: {
            opt = [DRPickerValueSelectOption optionWithTitle:@"请选择年龄" currentValue:25 minValue:12 maxValue:99 valueUnit:@"岁"];
            ((DRPickerValueSelectOption *)opt).tipText = @"测试一下";
        } break;
            
        case DRPickerTypeStringSelect: {
            opt = [DRPickerStringSelectOption optionWithTitle:@"请选择重复类型" stringOptions:@[@"快速复制放辣椒发", @"每天", @"每周", @"每月", @"自定义"]];
//            ((DRPickerStringSelectOption *)opt).currentStringIndex = 2;
            ((DRPickerStringSelectOption *)opt).currentStringOption = @"每天";
//            ((DRPickerStringSelectOption *)opt).tipText = @"哈哈哈哈哈";
            ((DRPickerStringSelectOption *)opt).valueUnit = @"定期";
            ((DRPickerStringSelectOption *)opt).prefixUnit = @"每个";
        } break;
            
        case DRPickerTypeOptionCard: {
            opt = [DRPickerOptionCardOption optionWithTitle:@"选项卡"];
            DRPickerOptionCardOption *cardOpt = (DRPickerOptionCardOption *)opt;
            cardOpt.allOptions = @[@"快速复制", @"每天", @"每周", @"每月", @"自定义", @"选项卡", @"选项卡", @"选项卡", @"选项卡", @"快速复制", @"每天", @"每周", @"每月", @"自定义", @"选项卡", @"选项卡", @"选项卡", @"选项卡"];
            cardOpt.selectedIndexs = @[@(1), @(3), @(7)];
            cardOpt.mutableSelection = YES;
            cardOpt.showPageControl = YES;
            cardOpt.lineCount = 2;
            cardOpt.belowMinAlert = @"不能再少啦！";
            cardOpt.sectionTip = @"最多选择3项";
        } break;

        case DRPickerTypeCity: {
            opt = [DRPickerCityOption optionWithTitle:@"选择城市" cityCode:222400];
        } break;

        case DRPickerTypeClassTable: {
            opt = [DRPickerClassTableOption optionWithTitle:@"选择课程周数"];
            ((DRPickerClassTableOption *)opt).classWeeks = @[@(2), @(4)];
        } break;

        case DRPickerTypeClassTerm: {
            opt = [DRPickerClassTermOption new];
            ((DRPickerClassTermOption *)opt).currentTerm = 2;
            ((DRPickerClassTermOption *)opt).currentYear = 2019;
            ((DRPickerClassTermOption *)opt).enterYear = 2014;
            ((DRPickerClassTermOption *)opt).education = 1;
        } break;

        case DRPickerTypeClassDuration: {
            opt = [DRPickerClassDurationOption optionWithTitle:@"选择课程节数"];
            ((DRPickerClassDurationOption *)opt).weekDay = 1;
            ((DRPickerClassDurationOption *)opt).startClass = 1;
            ((DRPickerClassDurationOption *)opt).endClass = 2;
        } break;

        case DRPickerTypeClassRemindTime: {
            opt = [DRPickerClassRemindTimeOption optionWithTitle:@"每日提醒时间"];
            ((DRPickerClassRemindTimeOption *)opt).isThisDay = YES;
            ((DRPickerClassRemindTimeOption *)opt).hour = 8;
            ((DRPickerClassRemindTimeOption *)opt).minute = 0;
//            ((DRPickerClassRemindTimeOption *)opt).hourMinute @"0800";
        } break;
            
        case DRPickerTypeLinkage: {
            opt = [DRPickerLinkageOption optionWithTitle:@"选择计量"];
            ((DRPickerLinkageOption *)opt).unitArray = @[@"片", @"颗", @"毫升"];
            ((DRPickerLinkageOption *)opt).optionArray = @[@[@"1", @"1.5", @"2", @"2.5", @"3", @"4", @"5", @"6", @"7", @"8", @"7", @"10"],
                                                           @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"],
                                                           @[@"10", @"20", @"30", @"40", @"50", @"60", @"70", @"80", @"90", @"100"]];
            ((DRPickerLinkageOption *)opt).currentSelectUnit = @"颗";
            ((DRPickerLinkageOption *)opt).currentSelectValue = @"5";
        } break;
            
        case DRPickerTypeMultipleColumn: {
            opt = [DRPickerMultipleColumnOption optionWithTitle:@"随便选"];
            ((DRPickerMultipleColumnOption *)opt).optionArray = @[@[@"1", @"1.5", @"2", @"2.5", @"3", @"4", @"5", @"6", @"7", @"8", @"7", @"10"],
                                                                  @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"],
                                                                  @[@"10", @"20", @"30", @"40", @"50", @"60", @"70", @"80", @"90", @"100"]];;
            ((DRPickerMultipleColumnOption *)opt).currentSelectedStrings = @[@"2.5", @"8", @"100"];
            ((DRPickerMultipleColumnOption *)opt).tipText = @"测试一下";
        } break;
            
        case DRPickerTypeDateToNow: {
            opt = [DRPickerDateOption optionWithTitle:@"选择日期" currentDate:[NSDate dateWithString:@"20191212" dateFormat:@"yyyyMMdd"] minDate:[NSDate minDate] maxDate:[NSDate maxDate]];
        } break;
            
        default:
            break;
    }
    opt.dismissBlock = ^{
        kDR_LOG(@"picker dismiss");
    };
    opt.cancelBlock = ^{
        kDR_LOG(@"picker cancel");
        kDR_LOG(@"清除");
    };
    opt.autoDismissWhenPicked = NO;
    
//    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDRScreenWidth - 40, 70)];
//    customView.backgroundColor = [UIColor whiteColor];
//    customView.userInteractionEnabled = YES;
//    opt.customBottomView = customView;
//    [customView bk_whenTapped:^{
//        [opt.pickerView dismiss];
//    }];
    
    [DRPickerFactory showPickerViewWithType:type pickerOption:opt pickDoneBlock:^(DRBaseAlertPicker * _Nonnull picker, id  _Nonnull pickedObject) {
        kDR_LOG(@"%@", pickedObject);
        [picker dismiss];
    }];
}

@end
