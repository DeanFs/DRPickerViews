//
//  DRYMDPicker.m
//  Records
//
//  Created by 冯生伟 on 2018/10/30.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRYMDPicker.h"
#import <JXExtension/JXExtension.h>
#import <HexColors/HexColors.h>
#import "NSDate+DRExtension.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import "UITabBar+DRExtension.h"

typedef NS_ENUM(NSInteger, DRYMDPickerType) {
    DRYMDPickerTypeStart, // 计划开始日期的设置
    DRYMDPickerTypeEnd, // 计划结束日期的设置
    DRYMDPickerTypeDateOnly, // 普通的日期选择器
};

@interface DRYMDPicker ()

// 日期滚轮
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
// 选择长期时的描述区
@property (weak, nonatomic) IBOutlet UIView *foreverDescView;
// 选择快速日期(21天，1个月...)时的提示区
@property (weak, nonatomic) IBOutlet UIView *selectDateView;
// 快选择计算出来的结束日期
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
// 按钮容器
@property (weak, nonatomic) IBOutlet UIView *buttonsContentView;

@property (weak, nonatomic) IBOutlet UIImageView *downImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;

// 整个快速选择区高度，包括提示区
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeButtonContentHeight;
// 按钮容器高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsContainerViewHeight;
// 快速选择时的底部描述区高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewHeight;

@property (nonatomic, assign) DRYMDPickerType pickerType;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *quickDate; // 选择快速日期按钮计算出来的日期
@property (nonatomic, assign) BOOL forever; // 选择长期
@property (nonatomic, weak) JXButton *selectedButton;
@property (nonatomic, assign) CGFloat tipViewH;
@property (nonatomic, assign) CGFloat buttonContainerH;
@property (nonatomic, assign) CGFloat wholeH;

@end

@implementation DRYMDPicker

+ (instancetype)pickerView {
    NSDate *today = [NSDate date];
    NSDateComponents *cmp = [[NSDateComponents alloc] init];
    cmp.year = today.year + 1;
    cmp.month = 12;
    cmp.day = 31;
    
    DRYMDPicker *pickerView = [super pickerView];
    pickerView.datePickerView.minimumDate = [NSDate date];
    pickerView.datePickerView.maximumDate = [pickerView.calendar dateFromComponents:cmp];
    return pickerView;
}

- (void)show {
    __block CGFloat toShowConstant = 0;
    [UIView performWithoutAnimation:^{
        if (self.pickerType == DRYMDPickerTypeStart || self.pickerType == DRYMDPickerTypeDateOnly) {
            self.datePickerView.date = self.currentDate;
            self.typeButtonContentHeight.constant = 0;
            self.containerViewHeight.constant = 256;
            self.containerViewBottom.constant = - (self.containerViewHeight.constant + [UITabBar safeHeight]);
        } else {
            [self setupButtons];
            self.titleLabel.text = @"结束日期";
            self.containerViewBottom.constant = - (self.containerViewHeight.constant + [UITabBar safeHeight]);
            if (!self.currentDate) {
                toShowConstant = self.containerViewBottom.constant + self.typeButtonContentHeight.constant + 45;
                if ([self.startDate compare:[NSDate date].endOfDate] == NSOrderedDescending) {
                    self.datePickerView.date = self.startDate;
                } else {
                    self.datePickerView.date = [NSDate date];
                }
                self.forever = YES;
                self.selectedButton = [self.buttonsContentView.subviews objectAtIndex:4];
            } else {
                self.datePickerView.date = self.currentDate;
                self.selectedButton = self.buttonsContentView.subviews.lastObject;
                self.containerViewHeight.constant -= self.self.tipViewH;
                self.typeButtonContentHeight.constant -= self.tipViewH;
                self.tipViewHeight.constant = 0;
            }
        }
        [self layoutIfNeeded];
    }];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.containerViewBottom.constant = toShowConstant;
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)setupButtons {
    CGFloat rate = kDRScreenWidth < 375 ? kDRScreenWidth/375.0 : 1;
    CGFloat startX = 20*rate;
    CGFloat startY = 15*rate;
    CGFloat buttonW = 75*rate;
    CGFloat buttonH = 30*rate;
    CGFloat gap = (kDRScreenWidth - buttonW*4 - startX*2)/3;
    UIFont *font = [UIFont systemFontOfSize:14*rate];
    
    // 得到目前屏幕下按钮区高度
    self.buttonContainerH = 2*(buttonH + startY) + gap;
    self.tipViewH = 70*rate;
    
    // 调整按钮区高度约束和整个区域高度
    CGFloat buttonContainerHCut = self.buttonsContainerViewHeight.constant - self.buttonContainerH;
    self.containerViewHeight.constant -= buttonContainerHCut;
    self.typeButtonContentHeight.constant -= buttonContainerHCut;
    self.buttonsContainerViewHeight.constant = self.buttonContainerH;
    
    // 调整提示区高度约束和整个区域高度
    CGFloat tipViewHCut = self.tipViewHeight.constant - self.tipViewH;
    self.containerViewHeight.constant -= tipViewHCut;
    self.typeButtonContentHeight.constant -= tipViewHCut;
    self.tipViewHeight.constant = self.tipViewH;
    self.wholeH = self.containerViewHeight.constant;
    
    // 添加6个快速选择按钮
    NSArray *titles = @[@"21天", @"1个月", @"3个月", @"6个月", @"长期", @"选择日期"];
    for (NSInteger i=0; i<titles.count; i++) {
        JXButton *button = [[JXButton alloc] initWithFrame:CGRectMake(startX+(buttonW+gap)*(i%4), startY+(buttonH+gap)*(i/4), buttonW, buttonH)];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor hx_colorWithHexRGBAString:@"222222"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(onQuickButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = font;
        button.borderColor = [UIColor hx_colorWithHexRGBAString:@"E7E7E7"];
        button.borderWidth = 1;
        button.cornerRadius = buttonH/2;
        button.tag = i+100;
        [self.buttonsContentView addSubview:button];
    }
}

// 快速设置日期：21天，1个月，3个月....
- (void)setQuickDate:(NSDate *)quickDate {
    _quickDate = quickDate;
    
    [UIView performWithoutAnimation:^{
        self.endDateLabel.text = [NSDate stringFromeDate:quickDate formatterString:@"yyyy年M月d日"];
    }];
}

- (void)setSelectedButton:(JXButton *)selectedButton {
    if (_selectedButton == selectedButton) {
        return;
    }
    _selectedButton.selected = NO;
    _selectedButton.backgroundColor = [UIColor clearColor];
    _selectedButton.borderWidth = 1;
    
    if (_selectedButton) {
        if (selectedButton.tag == 105) { // 选择日期
            [UIView animateWithDuration:kDRAnimationDuration animations:^{
                self.containerViewHeight.constant = self.wholeH - self.self.tipViewH;
                self.typeButtonContentHeight.constant = self.buttonContainerH + 7;
                self.tipViewHeight.constant = 0;
                self.containerViewBottom.constant = 0;
                [self layoutIfNeeded];
            }];
            self.quickDate = nil;
            self.forever = NO;
        } else {
            [UIView animateWithDuration:kDRAnimationDuration animations:^{
                self.containerViewHeight.constant = self.wholeH;
                self.typeButtonContentHeight.constant = self.buttonContainerH + self.tipViewH + 7;
                self.tipViewHeight.constant = self.tipViewH;
                self.containerViewBottom.constant = - (self.containerViewHeight.constant + [UITabBar safeHeight]) + self.typeButtonContentHeight.constant + 45;
                [self layoutIfNeeded];
            }];
            if (selectedButton.tag == 104) { // 长期
                self.foreverDescView.hidden = NO;
                self.selectDateView.hidden = YES;
                self.quickDate = nil;
                self.forever = YES;
            } else {
                self.foreverDescView.hidden = YES;
                self.selectDateView.hidden = NO;
                self.forever = NO;
                if (selectedButton.tag == 100) {
                    self.quickDate = [self.startDate nextDayWithCount:20];
                } else if (selectedButton.tag == 101) {
                    self.quickDate = [self.startDate nextMonthWithCount:1];
                } else if (selectedButton.tag == 102) {
                    self.quickDate = [self.startDate nextMonthWithCount:3];
                } else if (selectedButton.tag == 103) {
                    self.quickDate = [self.startDate nextMonthWithCount:6];
                }
            }
        }
    }
    
    _selectedButton = selectedButton;
    _selectedButton.selected = YES;
    _selectedButton.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"4E8BFF"];
    _selectedButton.borderWidth = 0;
}

- (void)setupPlanEndPickerImages {
    
    self.downImageView.image = [self pngImageWithName:@"icon_sanjiao_endtime"];
    self.tipImageView.image = [self pngImageWithName:@"icon_zz_tj_tishi"];
}

- (UIImage *)pngImageWithName:(NSString *)name {
    NSString *imageName = [NSString stringWithFormat:@"%@@%ldx", name, (NSInteger)[UIScreen mainScreen].scale];
    return [UIImage imageWithContentsOfFile:[KDR_CURRENT_BUNDLE pathForResource:imageName ofType:@"png"]];
}

#pragma mark - api
+ (void)showStartDatePickerWithCurrentDate:(NSDate *)currentDate
                                   minDate:(NSDate *)minDate
                             pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                                setupBlock:(DRDatePickerSetupBlock)setupBlock {
    DRYMDPicker *pickerView = [DRYMDPicker pickerView];
    kDR_SAFE_BLOCK(setupBlock, pickerView);
    pickerView.titleLabel.text = @"开始日期";
    pickerView.currentDate = currentDate;
    pickerView.pickDoneBlock = pickDoneBlock;
    pickerView.pickerType = DRYMDPickerTypeStart;
    if (minDate) {
        pickerView.datePickerView.minimumDate = minDate;
    }
    [pickerView show];
}

+ (void)showEndDatePickerWithCurrentDate:(NSDate *)currentDate
                               startDate:(NSDate *)startDate
                           pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                              setupBlock:(DRDatePickerSetupBlock)setupBlock {
    DRYMDPicker *pickerView = [DRYMDPicker pickerView];
    kDR_SAFE_BLOCK(setupBlock, pickerView);
    [pickerView setupPlanEndPickerImages];
    pickerView.currentDate = currentDate;
    pickerView.startDate = startDate;
    pickerView.pickDoneBlock = pickDoneBlock;
    pickerView.pickerType = DRYMDPickerTypeEnd;
    if (startDate) {
        pickerView.datePickerView.minimumDate = startDate;
    }
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
    [pickerView dateLegalCheck];
    pickerView.datePickerView.minimumDate = pickerView.minDate;
    pickerView.datePickerView.maximumDate = pickerView.maxDate;
    pickerView.pickDoneBlock = pickDoneBlock;
    pickerView.pickerType = DRYMDPickerTypeDateOnly;
    [pickerView show];
}

#pragma mark - actions
- (void)onQuickButtonTapped:(JXButton *)button {
    self.selectedButton = button;
}

- (id)pickedObject {
    if (self.pickerType == DRYMDPickerTypeEnd) {
        if (self.quickDate) {
            return self.quickDate.endOfDate;
        } else if (self.forever) {
            return nil;
        } else {
            return self.datePickerView.date.endOfDate;
        }
    } else {
        return self.datePickerView.date.midnight;
    }
}

@end
