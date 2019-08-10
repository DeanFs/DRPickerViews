//
//  DRYMDWithLunarPicker.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/18.
//

#import "DRYMDWithLunarPicker.h"
#import "DRSegmentBar.h"
#import "DRDatePickerView.h"
#import "DRLunarDatePickerView.h"
#import "NSDate+DRExtension.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIView+DRExtension.h>

@interface DRYMDWithLunarPicker ()

@property (weak, nonatomic) IBOutlet DRSegmentBar *segmentBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) DRDatePickerView *solarPickerView;
@property (nonatomic, strong) DRLunarDatePickerView *lunarPickerView;
@property (nonatomic, strong) DRPickerWithLunarOption *lunarOption;
@property (nonatomic, strong) DRPickerBirthdayOption *birthdayOption;

@end

@implementation DRYMDWithLunarPicker

- (CGFloat)picerViewHeight {
    return 303;
}

- (Class)pickerOptionClass {
    if (self.isForBirthday) {
        self.birthdayOption = (DRPickerBirthdayOption *)self.pickerOption;
        return [DRPickerBirthdayOption class];
    }
    self.lunarOption = (DRPickerWithLunarOption *)self.pickerOption;
    return [DRPickerWithLunarOption class];
}

//- (void)prepareToShow {
//    kDRWeakSelf
//    // 添加日期选择器
//
//
//    if (self.isForBirthday) {
//
//        self.topBar.leftButtonActionBlock = ^(DRPickerTopBar *topBar, UIButton *tappedButton) {
//            weakSelf.isIgnoreYear = !weakSelf.isIgnoreYear;
//        };
//    }
//
//    [self.segmentBar setupWithAssociatedScrollView:self.scrollView titles:@[@"公历", @"农历"]];
//    self.segmentBar.selectedIndex = self.isLunar;
//    self.segmentBar.onSelectChangeBlock = ^(NSInteger index) {
//        weakSelf.isLunar = (index == 1);
//    };
//
//    [self.scrollView addSubview:self.solarPickerView];
//    [self.scrollView addSubview:self.lunarPickerView];
//    [self.lunarPickerView setupWithCurrentDate:self.currentDate minDate:self.minDate maxDate:self.maxDate month:self.month day:self.day leapMonth:self.isLeapMonth selectChangeBlock:^(NSDate *date, NSInteger month, NSInteger day, BOOL leapMonth) {
//        weakSelf.currentDate = date;
//        weakSelf.month = month;
//        weakSelf.day = day;
//        weakSelf.isLeapMonth = leapMonth;
//        [weakSelf.solarPickerView refreshWithDate:date month:month day:day];
//    }];
//    [self.solarPickerView setupWithCurrentDate:self.currentDate minDate:self.minDate maxDate:self.maxDate month:self.month day:self.day selectChangeBlock:^(NSDate *date, NSInteger month, NSInteger day) {
//        weakSelf.currentDate = date;
//        weakSelf.month = month;
//        weakSelf.day = day;
//        [weakSelf.lunarPickerView refreshWithDate:date month:month day:day leapMonth:NO];
//    }];
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.scrollView.contentSize = CGSizeMake(self.scrollView.width*2, self.scrollView.height);
//
//        [self.solarPickerView setNeedsLayout];
//        self.solarPickerView.frame = CGRectMake(0, 0, self.scrollView.width, self.scrollView.height);
//        [self.solarPickerView layoutIfNeeded];
//
//        [self.lunarPickerView setNeedsLayout];
//        self.lunarPickerView.frame = CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height);
//        [self.lunarPickerView layoutIfNeeded];
//    });
//}
//
//+ (void)showWithCurrentDate:(NSDate *)currentDate
//                    minDate:(NSDate *)minDate
//                    maxDate:(NSDate *)maxDate
//                      month:(NSInteger)month
//                        day:(NSInteger)day
//                 ignoreYear:(BOOL)ignoreYear
//                    isLunar:(BOOL)isLunar
//                  leapMonth:(BOOL)leapMonth
//              pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
//                 setupBlock:(DRDatePickerSetupBlock)setupBlock {
//    DRYMDWithLunarPicker *pickerView = [DRYMDWithLunarPicker pickerView];
//    kDR_SAFE_BLOCK(setupBlock, pickerView);
//    pickerView.pickDoneBlock = pickDoneBlock;
//    pickerView.currentDate = currentDate;
//    pickerView.minDate = minDate;
//    pickerView.maxDate = maxDate;
//    pickerView.month = month;
//    pickerView.day = day;
//    pickerView.isIgnoreYear = ignoreYear;
//    pickerView.isLunar = isLunar;
//    pickerView.isLeapMonth = leapMonth;
//    pickerView.isForBirthday = YES;
//    [pickerView show];
//}
//
//- (void)setupTopLeftButton {
//    if (self.birthdayOption.ignoreYear) {
//        self.topBar.leftButtonTitle = @"显示年份";
//        self.solarPickerView.dateMode = DRDatePickerModeMD;
//    } else {
//        self.topBar.leftButtonTitle = @"忽略年份";
//        self.solarPickerView.dateMode = DRDatePickerModeYMD;
//    }
//    self.lunarPickerView.ignoreYear = self.birthdayOption.ignoreYear;
//}
//
///**
// 限定公历时间范围选择时间，可选择农历，不可忽略年份
//
// @param currentDate 当前公历日期
// @param minDate 最小可选日期
// @param maxDate 最大可选日期
// @param isLunar 是否反显农历
// @param pickDoneBlock 选择完成：selectedDate(公历日期) isLunar是否是农历
// @param setupBlock 便于以后扩展参数的传入和初始化逻辑增加
// */
//+ (void)showWithCurrentDate:(NSDate *)currentDate
//                    minDate:(NSDate *)minDate
//                    maxDate:(NSDate *)maxDate
//                    isLunar:(BOOL)isLunar
//                  leapMonth:(BOOL)leapMonth
//              pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
//                 setupBlock:(DRDatePickerSetupBlock)setupBlock {
////    DRYMDWithLunarPicker *pickerView = [DRYMDWithLunarPicker loadPickerView];
////    kDR_SAFE_BLOCK(setupBlock, pickerView);
////    pickerView.pickDoneBlock = pickDoneBlock;
////    [pickerView setupCurrentDate:currentDate minDate:minDate maxDate:maxDate];
////
////    //显示选择的日期
////    pickerView.segmentedControl.selectedSegmentIndex = isLunar ? 1 : 0;
////    pickerView.ignoreButton.hidden = true;
////    [pickerView.dataSource resetIndexfromSolarDate:pickerView.selectDate];
////
////    pickerView.solarMonthSource.monthIndex = pickerView.dataSource.monthIndex;
////    pickerView.solarMonthSource.dayIndex = pickerView.dataSource.dayIndex;
////    pickerView.lunarMonthSource.monthIndex = pickerView.dataSource.monthIndex;
////    pickerView.lunarMonthSource.dayIndex = pickerView.dataSource.dayIndex;
////
////    [pickerView.solarMonthSource safeCheck];
////    [pickerView.lunarMonthSource safeCheck];
////
////    [pickerView selectedCurrentDateWithAnimated:false];
////
////    [pickerView show];
//}
//
//#pragma mark - lazy load
//- (DRDatePickerView *)solarPickerView {
//    if (!_solarPickerView) {
//        _solarPickerView = [[DRDatePickerView alloc] init];
//    }
//    return _solarPickerView;
//}
//
//- (DRLunarDatePickerView *)lunarPickerView {
//    if (!_lunarPickerView) {
//        _lunarPickerView = [[DRLunarDatePickerView alloc] init];
//    }
//    return _lunarPickerView;
//}

@end
