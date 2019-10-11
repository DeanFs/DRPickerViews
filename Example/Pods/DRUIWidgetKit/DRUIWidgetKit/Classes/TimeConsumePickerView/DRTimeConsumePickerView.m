//
//  DRTimeConsumePickerView.m
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/9.
//

#import "DRTimeConsumePickerView.h"
#import <Masonry/Masonry.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import "DRUIWidgetUtil.h"

@interface DRTimeConsumePickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) UIPickerView *pickerView;
@property (nonatomic, assign) BOOL didDrawRect;

@property (nonatomic, assign) NSInteger maxDayRow;
@property (nonatomic, assign) NSInteger maxHourRow;
@property (nonatomic, assign) NSInteger maxMinuteRow;

@end

@implementation DRTimeConsumePickerView

- (void)setupPickerView {
    [self initAll];
    if (self.currentTimeConsume < self.timeScale) {
        _currentTimeConsume = self.timeScale;
    }
    if (self.maxTimeConsume < self.timeScale) {
        _maxTimeConsume = self.timeScale;
    }

    if (self.maxTimeConsume < self.timeScale) {
        kDR_LOG(@"最大时长不能小于步长");
        return;
    }
    if (self.currentTimeConsume > self.maxTimeConsume) {
        kDR_LOG(@"当前返现时长不在限定范围内");
        return;
    }

    NSInteger dayMinute = 24 * 60;
    if (self.maxTimeConsume >= dayMinute) {
        self.maxDayRow = self.maxTimeConsume / dayMinute + 1;
    } else if (self.maxTimeConsume >= 60) {
        self.maxHourRow = self.maxTimeConsume / 60 + 1;
    } else {
        self.maxMinuteRow = self.maxTimeConsume / self.timeScale + (self.maxTimeConsume % self.timeScale > 0);
    }
    [self.pickerView reloadAllComponents];

    [self renderTimeConsume];
}

- (void)renderTimeConsume {
    NSInteger dayMinute = 24 * 60;
    NSInteger timeConsume = self.currentTimeConsume;
    if (timeConsume >= dayMinute) {
        _day = timeConsume / dayMinute;
        timeConsume = timeConsume % dayMinute;
    }
    if (timeConsume >= 60) {
        _hour = timeConsume / 60;
        timeConsume = timeConsume % 60;
    }
    _minute = timeConsume;

    NSInteger minuteRow = self.minute / self.timeScale + (self.minute % self.timeScale > 0);
    if (self.day == 0 && self.hour == 0 && minuteRow > 0) {
        minuteRow --;
    }

    if (self.maxDayRow > 0) {
        [self.pickerView selectRow:self.day inComponent:0 animated:NO];
        [self.pickerView selectRow:self.hour inComponent:2 animated:NO];
        [self.pickerView selectRow:minuteRow inComponent:4 animated:NO];
    } else if (self.maxHourRow > 0) {
        [self.pickerView selectRow:self.hour inComponent:0 animated:NO];
        [self.pickerView selectRow:minuteRow inComponent:2 animated:NO];
    } else {
        [self.pickerView selectRow:minuteRow inComponent:0 animated:NO];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pickerView reloadAllComponents];
    });
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    [DRUIWidgetUtil hideSeparateLineForPickerView:pickerView];
    if (self.maxDayRow > 0) {
        return 6;
    }
    if (self.maxHourRow > 0) {
        return 4;
    }
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component % 2) {
        return 1;
    }
    if (component == 0) {
        if (self.maxDayRow > 0) {
            return self.maxDayRow;
        }
        if (self.maxHourRow > 0) {
            return self.maxHourRow;
        }
        return self.maxMinuteRow;
    }
    NSInteger rowCount;
    if (component == 2) {
        if (self.maxDayRow > 0) {
            if (self.maxDayRow - 1 == [self.pickerView selectedRowInComponent:0]) {
                rowCount = (self.maxTimeConsume % 1440) / 60 + 1;
            } else {
                rowCount = 24;
            }
        } else {
            NSInteger maxMinute = 60;
            if (self.hour == 0) {
                rowCount = maxMinute / self.timeScale - 1;
            } else {
                if (self.maxHourRow - 1 == [self.pickerView selectedRowInComponent:0]) {
                    maxMinute = self.maxTimeConsume % 60;
                    maxMinute = (maxMinute / self.timeScale + (maxMinute % self.timeScale > 0)) * self.timeScale;
                }
                rowCount = maxMinute / self.timeScale;
            }
        }
    } else { // component == 4
        NSInteger maxMinute = 60;
        if (self.day == 0 &&
            self.hour == 0) {
            rowCount = maxMinute / self.timeScale - 1;
        } else {
            if (self.maxDayRow - 1 == [self.pickerView selectedRowInComponent:0]) {
                NSInteger maxHour = self.maxTimeConsume % 1440 / 60;
                if (maxHour == [self.pickerView selectedRowInComponent:2]) {
                    maxMinute = self.maxTimeConsume % 1440 % 60;
                    maxMinute = (maxMinute / self.timeScale + (maxMinute % self.timeScale > 0)) * self.timeScale;
                }
            }
            rowCount = maxMinute / self.timeScale;
        }
    }
    if ([pickerView selectedRowInComponent:component] >= rowCount) {
        [pickerView selectRow:rowCount-1 inComponent:component animated:YES];
    }
    return rowCount;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component % 2 == 0) {
        return 70;
    }
    return 32;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 34;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *text;
    if (component == 0) {
        // 天或者小时
        text = [NSString stringWithFormat:@"%ld", row];
        if (self.maxMinuteRow > 0) { // 仅可选分钟
            text = [NSString stringWithFormat:@"%ld", (row + 1) * self.timeScale];
        }
    }
    if (component == 1) {
        if (self.maxDayRow > 0) {
            text = @"天";
        } else if (self.maxHourRow > 0) {
            text = @"小时";
        } else {
            text = @"分钟";
        }
    }
    if (component == 2) {
        text = [NSString stringWithFormat:@"%ld", row];
        if (self.maxHourRow > 0) {
            NSInteger minute = (row + (self.hour == 0)) * self.timeScale;
            text = [NSString stringWithFormat:@"%ld", minute];
        }
    }
    if (component == 3) {
        text = @"小时";
        if (self.maxHourRow > 0) {
            text = @"分钟";
        }
    }
    if (component == 4) {
        NSInteger minute = row * self.timeScale;
        if (self.day == 0 &&
            self.hour == 0) {
            minute += self.timeScale;
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
    }
    label.textColor = [DRUIWidgetUtil pickerUnSelectColor];
    label.text = text;
    if (row == [pickerView selectedRowInComponent:component]) {
        label.textColor = [DRUIWidgetUtil normalColor];
    }
    if (component % 2 == 0) {
        label.font = [UIFont systemFontOfSize:26];
    } else {
        label.font = [UIFont dr_PingFangSC_RegularWithSize:15];
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        if (self.maxDayRow > 0) {
            _day = row;
        } else if (self.maxHourRow > 0) {
            _hour = row;
        } else {
            _minute = (row + 1) * self.timeScale;
        }
    }
    if (component == 2) {
        if (self.maxDayRow > 0) {
            _hour = row;
        } else {
            _minute = (row + (self.hour == 0)) * self.timeScale;
        }
    }
    if (component == 4) {
        _minute = (row + (self.day == 0 && self.hour == 0)) * self.timeScale;
    }
    _currentTimeConsume = self.day * 24 * 60 + self.hour * 60 + self.minute;
    kDR_SAFE_BLOCK(self.onTimeConsumeChangeBlock, self.currentTimeConsume);
    [pickerView reloadAllComponents];
}

#pragma mark - setup xib
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    if (!self.pickerView) {
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.delegate = self;
        pickerView.dataSource = self;

        self.pickerView = pickerView;
        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_offset(0);
        }];
    }
}

- (void)initAll {
    _didDrawRect = NO;
    _maxDayRow = 0;
    _maxHourRow = 0;
    _maxMinuteRow = 0;
    [self initDayTime];
}

- (void)initDayTime {
    _day = 0;
    _hour = 0;
    _minute = 0;
}

- (void)setCurrentTimeConsume:(int64_t)currentTimeConsume {
    _currentTimeConsume = currentTimeConsume;

    if (self.didDrawRect) {
        [self initDayTime];
        [self renderTimeConsume];
    }
}

- (void)setTimeScale:(NSInteger)timeScale {
    _timeScale = timeScale;

    if (self.didDrawRect) {
        [self setupPickerView];
    }
}

- (void)setMaxTimeConsume:(int64_t)maxTimeConsume {
    _maxTimeConsume = maxTimeConsume;

    if (self.didDrawRect) {
        [self setupPickerView];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if (CGRectEqualToRect(rect, CGRectZero)) {
        return;
    }
    if (!self.didDrawRect) {
        self.didDrawRect = YES;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupPickerView];
        });
    }
}

@end
