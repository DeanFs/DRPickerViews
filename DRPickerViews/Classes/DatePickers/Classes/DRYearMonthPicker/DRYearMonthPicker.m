//
//  DRYearMonthPicker.m
//  Records
//
//  Created by 冯生伟 on 2018/12/12.
//  Copyright © 2018 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRYearMonthPicker.h"
#import "DRBasicKitDefine.h"
#import "NSDate+DRExtension.h"
#import <HexColors/HexColors.h>
#import <YYText/YYText.h>

#define kRowCount 100000   // 总行数，即可显示的总天数
#define kCentreRow 50000   // 中间行数，每次滚动结束时定位的位置

@interface DRYearMonthPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, assign) NSInteger minYearMonth;
@property (nonatomic, assign) NSInteger maxYearMonth;

@end

@implementation DRYearMonthPicker

+ (instancetype)pickerView {
    DRYearMonthPicker *picker = [super pickerView];
    picker.pickerView.delegate = picker;
    picker.pickerView.dataSource = picker;
    picker.minYearMonth = 190001;
    picker.maxYearMonth = ([NSDate date].year + 100)*100+12;
    return picker;
}

+ (void)showPickerViewWithCurrentDate:(NSDate *)currentDate
                              minDate:(NSDate *)minDate
                              maxDate:(NSDate *)maxDate
                        pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                           setupBlock:(DRDatePickerSetupBlock)setupBlock {
    DRYearMonthPicker *picker = [DRYearMonthPicker pickerView];
    kDR_SAFE_BLOCK(setupBlock, picker);
    picker.pickDoneBlock = pickDoneBlock;
    picker.currentDate = currentDate;
    picker.minDate = minDate;
    picker.maxDate = maxDate;
    [picker show];
}

- (void)prepareToShow {
    [self dateLegalCheck];
    
    self.minYearMonth = [self.minDate dateStringFromFormatterString:@"yyyyMM"].integerValue;
    self.maxYearMonth = [self.maxDate dateStringFromFormatterString:@"yyyyMM"].integerValue;
    
    [self.pickerView selectRow:self.currentDate.year inComponent:0 animated:NO];
    [self.pickerView selectRow:kCentreRow*12 + self.currentDate.month-1 inComponent:1 animated:NO];
}

#pragma mark - actions
- (id)pickedObject {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *cmp = [[NSDateComponents alloc] init];
    cmp.year = [self.pickerView selectedRowInComponent:0];
    cmp.month = [self.pickerView selectedRowInComponent:1] % 12+1;
    
    return [calendar dateFromComponents:cmp];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    for (UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"DDDDDD"];
        }
    }
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return kRowCount;
    }
    return kRowCount * 12;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 150;
    }
    return 100;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 38;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    UIColor *normalTextColor = [UIColor blackColor];
    UIColor *disableTextColor = [UIColor grayColor];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    attr.yy_font = [UIFont systemFontOfSize:21];
    attr.yy_color = normalTextColor;
    attr.yy_alignment = NSTextAlignmentCenter;
    
    if (component == 0) {
        [attr yy_appendString:[NSString stringWithFormat:@"%ld年", row]];
        if (row < self.minYearMonth / 100 || row > self.maxYearMonth / 100) {
            attr.yy_color = disableTextColor;
        }
    } else {
        NSInteger month = row % 12 + 1;
        NSInteger yearMonth = ([pickerView selectedRowInComponent:0] * 100) + month;
        
        [attr yy_appendString:[NSString stringWithFormat:@"%ld月", month]];
        if (yearMonth < self.minYearMonth || yearMonth > self.maxYearMonth) {
            attr.yy_color = disableTextColor;
        }
    }
    return attr;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger year = [pickerView selectedRowInComponent:0];
    NSInteger month = [pickerView selectedRowInComponent:1] % 12 + 1;
    NSInteger yearMonth = year * 100 + month;
        
    if (yearMonth < self.minYearMonth) {
        // 小于最小日期
        [pickerView selectRow:self.minYearMonth/100 inComponent:0 animated:YES];
        [pickerView selectRow:5000*12+self.minYearMonth%100-1 inComponent:1 animated:YES];
    } else if (yearMonth > self.maxYearMonth) {
        // 大于最大日期
        [pickerView selectRow:self.maxYearMonth/100 inComponent:0 animated:YES];
        [pickerView selectRow:5000*12+self.maxYearMonth%100-1 inComponent:1 animated:YES];
    } else {
        [pickerView selectRow:5000*12+month-1 inComponent:1 animated:NO];
    }
    [pickerView reloadAllComponents];
}

@end
