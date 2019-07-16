//
//  DRYMDWithTodayPicker.m
//  Records
//
//  Created by 冯生伟 on 2019/1/28.
//  Copyright © 2019 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRYMDWithTodayPicker.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import "NSDate+DRExtension.h"
#import <HexColors/HexColors.h>
#import <YYText/YYText.h>

#define kRowCount 36500   // 总行数，即可显示的总天数
#define kCenterRow 18250  // 中间行数，每次滚动结束时定位的位置

@interface DRYMDWithTodayPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableDictionary *titleCacheDic; // 显示缓存
@property (nonatomic, assign) NSInteger offset; // 每次滚动结束时的偏移量累计值
@property (nonatomic, assign) NSInteger thisYearStartOffset; // 今年第一天到currentDate之间的距离
@property (nonatomic, assign) NSInteger thisYearEndOffset; // 今年最后天到currentDate之间的距离
@property (nonatomic, assign) NSInteger todayOffset; // 今天到currentDate之间的距离
@property (nonatomic, assign) NSInteger minDateOffset; // 最小日期currentDate之间的距离
@property (nonatomic, assign) NSInteger maxDateOffset; // 最大日期currentDate之间的距离

@end

@implementation DRYMDWithTodayPicker

+ (void)showDatePickerViewWithCurrentDate:(NSDate *)currentDate
                                  minDate:(NSDate *)minDate
                                  maxDate:(NSDate *)maxDate
                            pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                               setupBlock:(DRDatePickerSetupBlock)setupBlock {
    DRYMDWithTodayPicker *pickerView = [DRYMDWithTodayPicker pickerView];
    kDR_SAFE_BLOCK(setupBlock, pickerView);
    pickerView.currentDate = currentDate;
    pickerView.minDate = minDate;
    pickerView.maxDate = maxDate;
    pickerView.pickDoneBlock = pickDoneBlock;
    [pickerView show];
}

- (void)prepareToShow {
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.titleCacheDic = [NSMutableDictionary dictionary];
    
    // 关键时间点设置
    // 今天
    NSDateComponents *cmp = [self dateComponentsFromDate:[NSDate date]];
    NSDate *today = [self.calendar dateFromComponents:cmp]; // 去除时分秒
    
    // 今年第一天
    cmp.month = 1;
    cmp.day = 1;
    NSDate *thisYearFirstDay = [self.calendar dateFromComponents:cmp];
    
    // 今年最后一天
    cmp.month = 12;
    cmp.day = 31;
    NSDate *thisYearLastDay = [self.calendar dateFromComponents:cmp];
    
    [self dateLegalCheck];
    self.currentDate = self.currentDate.midnight;
    
    // 偏移量计算
    self.offset = 0;
    self.thisYearStartOffset = [self.currentDate numberOfDaysDifferenceWithDate:thisYearFirstDay];
    self.thisYearEndOffset = [self.currentDate numberOfDaysDifferenceWithDate:thisYearLastDay];
    self.todayOffset = [self.currentDate numberOfDaysDifferenceWithDate:today];
    self.minDateOffset = [self.currentDate numberOfDaysDifferenceWithDate:self.minDate.midnight];
    self.maxDateOffset = [self.currentDate numberOfDaysDifferenceWithDate:self.maxDate.midnight];
    
    // 开始选中中间位置
    [self.pickerView selectRow:kCenterRow inComponent:0 animated:NO];
}

#pragma mark - actions
- (id)pickedObject {
    return [self.currentDate nextDayWithCount:self.offset];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    for (UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"DDDDDD"];
        }
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return kRowCount;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (kDRScreenWidth < 375) {
        return 35;
    }
    return 38;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
             attributedTitleForRow:(NSInteger)row
                      forComponent:(NSInteger)component {
    UIColor *normalTextColor = [UIColor blackColor];
    UIColor *disableTextColor = [UIColor grayColor];
    UIFont *textFont = [UIFont systemFontOfSize:21];
    if (kDRScreenWidth < 375) {
        textFont = [UIFont systemFontOfSize:18];
    }
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    attr.yy_font = textFont;
    
    NSInteger dayOffset = row - kCenterRow + self.offset;
    NSString *offsetKey = [NSString stringWithFormat:@"%ld", dayOffset];
    NSString *title = [self.titleCacheDic objectForKey:offsetKey];
    if (!title) {
        if (dayOffset == self.todayOffset) {
            title = @"今天";
        } else {
            NSDate *date = [self.currentDate nextDayWithCount:dayOffset];
            if (dayOffset >= self.thisYearStartOffset && dayOffset <= self.thisYearEndOffset) {
                // 在今年范围内
                title = [NSDate stringFromeDate:date formatterString:@"M月d日"];
            } else {
                title = [NSDate stringFromeDate:date formatterString:@"yyyy年M月d日"];
            }
        }
        [self.titleCacheDic setObject:title forKey:offsetKey];
    }
    [attr yy_appendString:title];
    
    attr.yy_color = normalTextColor;
    if (dayOffset < self.minDateOffset || dayOffset > self.maxDateOffset) {
        attr.yy_color = disableTextColor;
    }
    
    return attr;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger currentOffset = row - kCenterRow; // 本次滚动距离
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
    
    [pickerView selectRow:kCenterRow inComponent:0 animated:animation];
    [pickerView reloadComponent:0];
}

@end
