//
//  DRYMDPicker.m
//  Records
//
//  Created by 冯生伟 on 2018/10/30.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRYMDPicker.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/NSDate+DRExtension.h>
#import "DRDatePickerView.h"
#import "DROptionCardView.h"
#import "DRUIWidgetUtil.h"

typedef NS_ENUM(NSInteger, DRYMDPickerType) {
    DRYMDPickerTypeStart, // 计划开始日期的设置
    DRYMDPickerTypeEnd, // 计划结束日期的设置
    DRYMDPickerTypeDateOnly, // 普通的日期选择器
};

@interface DRYMDPicker ()

@property (weak, nonatomic) IBOutlet DROptionCardView *quikOptionView;
// 日期滚轮
@property (weak, nonatomic) IBOutlet DRDatePickerView *datePickerView;
// 选择长期时的描述区
@property (weak, nonatomic) IBOutlet UIView *foreverDescView;
// 选择快速日期(21天，1个月...)时的提示区
@property (weak, nonatomic) IBOutlet UIView *selectDateView;
// 快选择计算出来的结束日期
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDescLabel;
// 按钮容器
@property (weak, nonatomic) IBOutlet UIView *buttonsContentView;

@property (weak, nonatomic) IBOutlet UIImageView *downImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;
@property (weak, nonatomic) IBOutlet UILabel *foreverTipLabel;
@property (weak, nonatomic) IBOutlet UIView *tipView;

@property (weak, nonatomic) IBOutlet UIView *planSettingContentView;
// 整个快速选择区高度，包括提示区
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quickTimeOptionHeight;
// 快速选择时的底部描述区高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewHeight;

@property (nonatomic, assign) DRYMDPickerType pickerType;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *quickDate; // 选择快速日期按钮计算出来的日期
@property (nonatomic, assign) BOOL forever; // 选择长期
//@property (nonatomic, weak) JXButton *selectedButton;
@property (nonatomic, assign) CGFloat tipViewH;
@property (nonatomic, assign) CGFloat buttonContainerH;
@property (nonatomic, assign) CGFloat wholeH;

@end

@implementation DRYMDPicker

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tipImageView.tintColor = [DRUIWidgetUtil descColor];
    self.endDateLabel.textColor = [DRUIWidgetUtil highlightColor];
    self.endDescLabel.textColor = [DRUIWidgetUtil descColor];
    self.foreverTipLabel.textColor = [DRUIWidgetUtil descColor];
}

- (void)prepareToShow {
    if (self.pickerType == DRYMDPickerTypeEnd) {
        self.quikOptionView.allOptions = @[@"21天", @"1个月", @"3个月", @"6个月", @"长期", @"选择日期"];
        if (!self.currentDate) {
            self.quikOptionView.selectedIndexs = @[@(4)];
        } else {
            self.quikOptionView.selectedIndexs = @[@(5)];
        }
        kDRWeakSelf
        self.quikOptionView.onSelectionChangeBlock = ^(NSArray<NSString *> *selectedOptions, NSArray<NSNumber *> *selectedIndexs) {
            NSInteger index = selectedIndexs.firstObject.integerValue;
            if (index == 5) {
                weakSelf.quickDate = nil;
                weakSelf.forever = NO;
                weakSelf.datePickerView.hidden = NO;
                [weakSelf pickerViewHeightChange:380];
                [UIView animateWithDuration:kDRAnimationDuration animations:^{
                    weakSelf.tipViewHeight.constant = 0;
                    [weakSelf layoutIfNeeded];
                } completion:^(BOOL finished) {
                    weakSelf.tipView.hidden = YES;
                }];
            } else {
                weakSelf.datePickerView.hidden = YES;
                [weakSelf pickerViewHeightChange:228];
                [UIView animateWithDuration:kDRAnimationDuration animations:^{
                    weakSelf.tipViewHeight.constant = 70;
                    [weakSelf layoutIfNeeded];
                } completion:^(BOOL finished) {
                    weakSelf.tipView.hidden = NO;
                }];
                if (index == 4) {
                    weakSelf.foreverDescView.hidden = NO;
                    weakSelf.selectDateView.hidden = YES;
                    weakSelf.quickDate = nil;
                    weakSelf.forever = YES;
                } else {
                    weakSelf.foreverDescView.hidden = YES;
                    weakSelf.selectDateView.hidden = NO;
                    weakSelf.forever = NO;
                    if (index == 0) {
                        weakSelf.quickDate = [weakSelf.startDate nextDayWithCount:20];
                    } else if (index == 1) {
                        weakSelf.quickDate = [weakSelf.startDate nextMonthWithCount:1];
                    } else if (index == 2) {
                        weakSelf.quickDate = [weakSelf.startDate nextMonthWithCount:3];
                    } else if (index == 3) {
                        weakSelf.quickDate = [weakSelf.startDate nextMonthWithCount:6];
                    }
                }
            }
        };
    }
}

- (CGFloat)picerViewHeight  {
    if (self.pickerType == DRYMDPickerTypeStart || self.pickerType == DRYMDPickerTypeDateOnly) {
        self.quickTimeOptionHeight.constant = 0;
        self.tipViewHeight.constant = 0;
        self.planSettingContentView.hidden = YES;
        return 260;
    }
    if (!self.currentDate) {
        return 228;
    }
    self.tipViewHeight.constant = 0;
    self.tipView.hidden = YES;
    return 380;
}

// 快速设置日期：21天，1个月，3个月....
- (void)setQuickDate:(NSDate *)quickDate {
    _quickDate = quickDate;
    [UIView performWithoutAnimation:^{
        self.endDateLabel.text = [NSDate stringFromeDate:quickDate formatterString:@"yyyy/MM/dd"];
    }];
}

#pragma mark - api
+ (void)showStartDatePickerWithCurrentDate:(NSDate *)currentDate
                                   minDate:(NSDate *)minDate
                             pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                                setupBlock:(DRDatePickerSetupBlock)setupBlock {
    DRYMDPicker *pickerView = [DRYMDPicker pickerView];
    kDR_SAFE_BLOCK(setupBlock, pickerView);
    pickerView.topBar.centerButtonTitle = @"开始日期";
    pickerView.currentDate = currentDate;
    pickerView.pickDoneBlock = pickDoneBlock;
    pickerView.pickerType = DRYMDPickerTypeStart;
    [pickerView setupPickerView:currentDate minDate:minDate maxDate:nil];
    [pickerView show];
}

+ (void)showEndDatePickerWithCurrentDate:(NSDate *)currentDate
                               startDate:(NSDate *)startDate
                           pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                              setupBlock:(DRDatePickerSetupBlock)setupBlock {
    DRYMDPicker *pickerView = [DRYMDPicker pickerView];
    kDR_SAFE_BLOCK(setupBlock, pickerView);
    pickerView.currentDate = currentDate;
    pickerView.startDate = startDate;
    pickerView.pickDoneBlock = pickDoneBlock;
    pickerView.pickerType = DRYMDPickerTypeEnd;
    if (!currentDate) {
        if ([startDate compare:[NSDate date].endOfDate] == NSOrderedDescending) {
            currentDate = startDate;
        }
    }
    [pickerView setupPickerView:currentDate minDate:startDate maxDate:nil];
    [pickerView show];
}

+ (void)showDatePickerWithCurrentDate:(NSDate *)currentDate
                              minDate:(NSDate *)minDate
                              maxDate:(NSDate *)maxDate
                        pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                           setupBlock:(DRDatePickerSetupBlock)setupBlock {
    DRYMDPicker *pickerView = [DRYMDPicker pickerView];
    kDR_SAFE_BLOCK(setupBlock, pickerView);
    pickerView.currentDate = currentDate;
    pickerView.minDate = minDate;
    pickerView.maxDate = maxDate;
    pickerView.pickDoneBlock = pickDoneBlock;
    pickerView.pickerType = DRYMDPickerTypeDateOnly;
    [pickerView setupPickerView:currentDate minDate:minDate maxDate:maxDate];
    [pickerView show];
}

- (void)setupPickerView:(NSDate *)currentDate minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate {

    [self.datePickerView setupWithCurrentDate:currentDate minDate:minDate maxDate:maxDate month:1 day:1 selectChangeBlock:nil];
}

#pragma mark - actions
- (id)pickedObject {
    if (self.pickerType == DRYMDPickerTypeEnd) {
        if (self.quickDate) {
            return self.quickDate.endOfDate;
        } else if (self.forever) {
            return nil;
        } else {
            return self.datePickerView.selectedDate;
        }
    } else {
        return self.datePickerView.selectedDate;
    }
}

@end
