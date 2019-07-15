//
//  DRTimeConsumingPicker.m
//  AFNetworking
//
//  Created by 冯生伟 on 2019/4/26.
//

#import "DRTimeConsumingPicker.h"
#import "DRBasicKitDefine.h"
#import <HexColors/HexColors.h>

@implementation DRTimeConsumingModel

+ (instancetype)modelWithDuration:(int64_t)duration timeString:(NSString *)timeString {
    DRTimeConsumingModel *model = [DRTimeConsumingModel new];
    model.timeString = timeString;
    model.duration = duration;
    return model;
}

@end

@interface DRTimeConsumingPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) BOOL haveShow;

@end

@implementation DRTimeConsumingPicker

+ (void)showPickerViewWithCurrentDate:(NSDate *)currentDate
                              minDate:(NSDate *)minDate
                              maxDate:(NSDate *)maxDate
                        pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                           setupBlock:(DRDatePickerSetupBlock)setupBlock {
    DRTimeConsumingPicker *picker = [DRTimeConsumingPicker pickerView];
    kDR_SAFE_BLOCK(setupBlock, picker);
    picker.pickDoneBlock = pickDoneBlock;
    picker.currentDate = currentDate;
    [picker show];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}

- (void)prepareToShow {
    NSInteger daySeconds = 24 * 60 *60;
    NSInteger hourSeconds = 60 * 60;
    int64_t allSeconds = self.pickOption.currentDuration;
    if (allSeconds >= daySeconds) {
        self.day = allSeconds / daySeconds;
        allSeconds = allSeconds % daySeconds;
    }
    if (allSeconds >= hourSeconds) {
        self.hour = allSeconds / hourSeconds;
        allSeconds = allSeconds % hourSeconds;
    }
    self.minute = allSeconds / 60;
    
    NSInteger minuteRow = self.minute / self.pickOption.timeScale + (self.minute % self.pickOption.timeScale > 0);
    if (self.day == 0 && self.hour == 0) {
        minuteRow --;
    }
    
    [self.pickerView selectRow:self.day inComponent:0 animated:NO];
    [self.pickerView selectRow:self.hour inComponent:2 animated:NO];
    [self.pickerView selectRow:minuteRow inComponent:4 animated:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.haveShow = YES;
        [self.pickerView reloadAllComponents];
    });
}

#pragma mark - actions
- (id)pickedObject {
    NSInteger day = [self.pickerView selectedRowInComponent:0];
    NSInteger hour = [self.pickerView selectedRowInComponent:2];
    NSInteger minute = [self.pickerView selectedRowInComponent:4] * self.pickOption.timeScale;
    if (day == 0 && hour == 0) {
        minute += self.pickOption.timeScale;
    }
    
    NSMutableString *timeString = [NSMutableString string];
    if (day > 0) {
        [timeString appendFormat:@"%ld天", day];
    }
    if (hour > 0) {
        [timeString appendFormat:@"%ld小时", hour];
    }
    if (minute > 0) {
        [timeString appendFormat:@"%ld分钟", minute];
    }
    if (timeString.length == 0) {
        [timeString appendFormat:@"0分钟"];
    }
    int64_t duration = day * 86400 + hour * 3600 + minute * 60;
    
    return [DRTimeConsumingModel modelWithDuration:duration
                                        timeString:timeString];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    for (UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"DDDDDD"];
        }
    }
    return 6;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (!self.haveShow) {
        return 100000;
    }
    if (component % 2) {
        return 1;
    }
    if (component == 0) {
        return 10;
    }
    if (component == 2) {
        return 24;
    }
    if (self.day == 0 &&
        self.hour == 0) {
        return 11;
    }
    return 12;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return (kDRScreenWidth-60)/6;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 34;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *text;
    if (component == 0) {
        text = [NSString stringWithFormat:@"%ld", row];
    }
    if (component == 1) {
        text = @"天";
    }
    if (component == 2) {
        text = [NSString stringWithFormat:@"%ld", row % 24];
    }
    if (component == 3) {
        text = @"小时";
    }
    if (component == 4) {
        NSInteger minute = row * self.pickOption.timeScale;
        if (self.day == 0 &&
            self.hour == 0) {
            minute += self.pickOption.timeScale;
        }
        text = [NSString stringWithFormat:@"%ld", minute];
    }
    if (component == 5) {
        text = @"分钟";
    }
    
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor hx_colorWithHexRGBAString:@"111111"];
        label.font = [UIFont systemFontOfSize:component%2?20:21];
    }
    label.text = text;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.day = row;
    }
    if (component == 2) {
        self.hour = row % 24;
    }
    [pickerView reloadAllComponents];
}

@end
