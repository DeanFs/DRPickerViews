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
#import <DRUIWidget/DRDatePickerView.h>
#import <DRUIWidget/DROptionCardView.h>
#import <DRUIWidget/DRUIWidgetUtil.h>

@interface DRYMDPicker ()

@property (weak, nonatomic) IBOutlet UIView *planSettingContentView;
@property (weak, nonatomic) IBOutlet DROptionCardView *quikOptionView;
@property (weak, nonatomic) IBOutlet UIView *tipView;
// 选择长期时的描述区
@property (weak, nonatomic) IBOutlet UIView *foreverDescView;
@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;
@property (weak, nonatomic) IBOutlet UILabel *foreverTipLabel;
// 选择快速日期(21天，1个月...)时的提示区
@property (weak, nonatomic) IBOutlet UIView *selectDateView;
// 快选择计算出来的结束日期
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDescLabel;

// 日期滚轮
@property (weak, nonatomic) IBOutlet DRDatePickerView *datePickerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionViewTop;
// 整个快速选择区高度，包括提示区
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quickTimeOptionHeight;
// 快速选择时的底部描述区高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewHeight;

@property (nonatomic, strong) NSDate *quickDate; // 选择快速日期按钮计算出来的日期
@property (nonatomic, assign) BOOL forever; // 选择长期
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
    NSDate *currentDate;
    NSDate *minDate;
    NSDate *maxDate;
    if (self.type == DRYMDPickerTypePlanEnd) {
        DRPickerPlanEndOption *endOption = (DRPickerPlanEndOption *)self.pickerOption;
        currentDate = endOption.currentDate;
        minDate = endOption.startDate;
        maxDate = endOption.maxDate;
        self.quikOptionView.allOptions = @[@"21天", @"1个月", @"3个月", @"6个月", @"长期", @"选择日期"];
        if (!endOption.currentDate) {
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
                [weakSelf.datePickerView setNeedsDisplay];
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
                        weakSelf.quickDate = [endOption.startDate nextDayWithCount:20];
                    } else if (index == 1) {
                        weakSelf.quickDate = [endOption.startDate nextMonthWithCount:1];
                    } else if (index == 2) {
                        weakSelf.quickDate = [endOption.startDate nextMonthWithCount:3];
                    } else if (index == 3) {
                        weakSelf.quickDate = [endOption.startDate nextMonthWithCount:6];
                    }
                }
            }
        };
    } else {
        DRPickerDateOption *dateOption = (DRPickerDateOption *)self.pickerOption;
        currentDate = dateOption.currentDate;
        minDate = dateOption.minDate;
        maxDate = dateOption.maxDate;
    }
    [self.datePickerView setupWithCurrentDate:currentDate
                                      minDate:minDate
                                      maxDate:maxDate
                                        month:1
                                          day:1];
}

- (CGFloat)picerViewHeight  {
    if (self.type == DRYMDPickerTypeNormal) {
        self.quickTimeOptionHeight.constant = 0;
        self.tipViewHeight.constant = 0;
        self.optionViewTop.constant = 0;
        self.planSettingContentView.hidden = YES;
        return 260;
    }
    if (!((DRPickerPlanEndOption *)self.pickerOption).currentDate) {
        return 228;
    }
    self.tipViewHeight.constant = 0;
    self.tipView.hidden = YES;
    return 380;
}

// 快速设置日期：21天，1个月，3个月....
- (void)setQuickDate:(NSDate *)quickDate {
    _quickDate = quickDate;
    self.endDateLabel.text = [NSDate stringFromeDate:quickDate formatterString:@"yyyy/MM/dd"];
}

- (Class)pickerOptionClass {
    if (self.type == DRYMDPickerTypePlanEnd) {
        return [DRPickerPlanEndOption class];
    }
    return [DRPickerDateOption class];
}

#pragma mark - actions
- (id)pickedObject {
    if (self.type == DRYMDPickerTypePlanEnd) {
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
