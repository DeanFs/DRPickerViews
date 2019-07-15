//
//  DRMDWTPicker.m
//  Records
//
//  Created by Zube on 2018/3/24.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRMDWTPicker.h"
#import "DRBasicKitDefine.h"
#import "NSDate+DRExtension.h"
#import <JXExtension/JXExtension.h>
#import <YYText/YYText.h>
#import <HexColors/HexColors.h>

#define kYearRow 36500
#define kYearCenterRow 18250
#define kHourRow 24000
#define kHourCenterRow 12000
#define kMinuteRow 60000
#define kMinuteCenterRow 30000

@implementation DRMDWTPickerOutputObject

@end

@interface DRMDWTPicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet JXButton *cleanButton;

@property (nonatomic, strong) NSMutableDictionary *titleCacheDic; // 显示缓存
@property (nonatomic, assign) NSInteger offset; // 每次滚动结束时的偏移量累计值
@property (nonatomic, assign) NSInteger todayOffset; // 今天到currentDate之间的距离
@property (nonatomic, assign) NSInteger minDateOffset; // 最小日期currentDate之间的距离
@property (nonatomic, assign) NSInteger maxDateOffset; // 最大日期currentDate之间的距离

@end

@implementation DRMDWTPicker

+ (void)showPickerViewWithCurrentDate:(NSDate *)currentDate
                              minDate:(NSDate *)minDate
                              maxDate:(NSDate *)maxDate
                        pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                           setupBlock:(DRDatePickerSetupBlock)setupBlock {
    DRMDWTPicker*picker = [self pickerView];
    kDR_SAFE_BLOCK(setupBlock, picker);
    picker.currentDate = currentDate;
    picker.minDate = minDate;
    picker.maxDate = maxDate;
    picker.pickDoneBlock = pickDoneBlock;
    
    [picker show];
}

- (void)prepareToShow {
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.titleCacheDic = [NSMutableDictionary dictionary];
    
    if (self.pickOption.canClean) {
        self.cleanButton.hidden = NO;
        self.titleLabel.hidden = YES;
    }
    
    // 关键时间点设置
    [self dateLegalCheck];
    // 今天零点
    NSDate *today = [NSDate date].midnight; // 去除时分秒
    
    // 偏移量计算
    self.offset = 0;
    self.todayOffset = [self.currentDate.midnight numberOfDaysDifferenceWithDate:today];
    self.minDateOffset = [self.currentDate.midnight numberOfDaysDifferenceWithDate:self.minDate.midnight];
    self.maxDateOffset = [self.currentDate.midnight numberOfDaysDifferenceWithDate:self.maxDate.midnight];

    if (!self.pickTimeOnly) {
        [self.pickerView selectRow:kYearCenterRow inComponent:0 animated:NO];
    }
    [self.pickerView selectRow:kHourCenterRow + self.currentDate.hour inComponent:1 animated:NO];
    [self.pickerView selectRow:kMinuteCenterRow + self.currentDate.minute inComponent:2 animated:NO];
}

- (id)pickedObject {
    NSDateComponents *cmp = [self dateComponentsFromDate:self.currentDate];
    cmp.day += self.offset;
    cmp.hour = [self.pickerView selectedRowInComponent:1] % 24;
    cmp.minute = [self.pickerView selectedRowInComponent:2] % 60;
    NSDate *date = [self.calendar dateFromComponents:cmp];
    
    DRMDWTPickerOutputObject *obj = [DRMDWTPickerOutputObject new];
    obj.date = date;
    obj.timestamp = [date dateStringFromFormatterString:@"yyyyMMddHHmmss"].longLongValue;
    
    return obj;
}

#pragma mark - Actions
- (IBAction)cleanAction:(id)sender {
    kDR_SAFE_BLOCK(self.pickOption.cleanBlock, self.currentDate);
    [self dismiss];
}

#pragma mark - Private
// picker cell 显示格式
- (NSString *)monthDayStringForDate:(NSDate *)date withWeekday:(BOOL)withWeekday {
    if (withWeekday) {
        return [NSDate stringFromeDate:date formatterString:@"MM月dd日 E"];
    } else {
        return [NSDate stringFromeDate:date formatterString:@"MM月dd日"];
    }
}

- (void)clearSpearatorLineWithPickerView:(UIPickerView *)pickerView  {
    [pickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height < 1) {
            [obj setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"dddddd"]];
        }
    }];
}

#pragma mark - UIPickerViewDelegate & UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    [self clearSpearatorLineWithPickerView:pickerView];
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        if (self.pickTimeOnly) {
            return 1;
        }
        return kYearRow;
    } else if (component == 1) {
        return kHourRow;
    } else {
        return kMinuteRow;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return self.frame.size.width / 3 + 60;
    } {
        return self.frame.size.width / 4;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (kDRScreenWidth < 375) {
        return 35;
    }
    return 38;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    UIFont *textFont = [UIFont systemFontOfSize:21];
    if (kDRScreenWidth < 375) {
        textFont = [UIFont systemFontOfSize:18];
    }
    UIColor *normalTextColor = [UIColor blackColor];
    UIColor *disableTextColor = [UIColor grayColor];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    attr.yy_font = textFont;
    attr.yy_color = normalTextColor;
    
    if (component == 0) {
        NSInteger dayOffset = 0;
        if (!self.pickTimeOnly) {
            dayOffset = row - kYearCenterRow + self.offset;
        }
        NSString *offsetKey = [NSString stringWithFormat:@"%ld", dayOffset];
        NSString *title = [self.titleCacheDic objectForKey:offsetKey];
        if (!title) {
            NSDate *date = [self.currentDate nextDayWithCount:dayOffset];
            NSInteger todayOffset = dayOffset - self.todayOffset;
            if (labs(todayOffset) < 3) {
                if (todayOffset == -2) {
                    NSString *monthday = [self monthDayStringForDate:date withWeekday:NO];
                    title = [NSString stringWithFormat:@"%@ 前天", monthday];
                } else if (todayOffset == -1) {
                    NSString *monthday = [self monthDayStringForDate:date withWeekday:NO];
                    title = [NSString stringWithFormat:@"%@ 昨天", monthday];
                } else if (todayOffset == 0) {
                    title = @"今天";
                } else if (todayOffset == 1) {
                    NSString *monthday = [self monthDayStringForDate:date withWeekday:NO];
                    title = [NSString stringWithFormat:@"%@ 明天", monthday];
                } else if (todayOffset == 2) {
                    NSString *monthday = [self monthDayStringForDate:date withWeekday:NO];
                    title = [NSString stringWithFormat:@"%@ 后天", monthday];
                }
            } else {
                title = [self monthDayStringForDate:date withWeekday:YES];
            }
            [self.titleCacheDic setObject:title forKey:offsetKey];
        }
        [attr yy_appendString:title];
        
        if (!self.pickTimeOnly && (dayOffset < self.minDateOffset || dayOffset > self.maxDateOffset)) {
            attr.yy_color = disableTextColor;
        }
        
    } else if (component == 1) {
        [attr yy_appendString:[NSString stringWithFormat:@"%02ld", row%24]];
        attr.yy_alignment = NSTextAlignmentCenter;
    } else {
        [attr yy_appendString:[NSString stringWithFormat:@"%02ld", row%60]];
        attr.yy_alignment = NSTextAlignmentLeft;
    }
    return attr;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        if (!self.pickTimeOnly) {
            NSInteger currentOffset = row - kYearCenterRow; // 本次滚动距离
            NSInteger dayOffset = currentOffset + self.offset; // 日期天数偏移量
            BOOL animation = NO;
            
            self.offset += currentOffset;
            if (dayOffset < self.minDateOffset) { // 小于最小日期
                animation = YES;
                self.offset = self.minDateOffset;
            } else if (dayOffset > self.maxDateOffset) {
                animation = YES;
                self.offset = self.maxDateOffset;
            }
            
            [pickerView selectRow:kYearCenterRow inComponent:0 animated:animation];
            [pickerView reloadComponent:0];
        }
    } else if (component == 1) {
        [pickerView selectRow:kHourCenterRow + row % 24 inComponent:1 animated:NO];
    } else if (component == 2) {
        [pickerView selectRow:kMinuteCenterRow + row % 60 inComponent:2 animated:NO];
    }
}

@end

