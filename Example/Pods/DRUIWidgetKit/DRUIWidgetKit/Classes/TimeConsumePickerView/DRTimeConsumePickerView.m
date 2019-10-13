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

@property (nonatomic, assign) NSInteger componentCount;
@property (nonatomic, assign) NSInteger minDay;
@property (nonatomic, assign) NSInteger maxDay;
@property (nonatomic, assign) NSInteger minHour;
@property (nonatomic, assign) NSInteger maxHour;
@property (nonatomic, assign) NSInteger minMinute;
@property (nonatomic, assign) NSInteger maxMinute;

@end

@implementation DRTimeConsumePickerView

- (void)setupPickerView {
    [self initAll];
    if (self.minTimeConsume < self.timeScale) {
        _minTimeConsume = self.timeScale;
    }
    if (self.maxTimeConsume < self.timeScale) {
        _maxTimeConsume = self.timeScale;
    }
    if (self.minTimeConsume > self.maxTimeConsume) {
        _minTimeConsume = self.maxTimeConsume;
    }
    if (self.currentTimeConsume < self.timeScale || self.currentTimeConsume > self.maxTimeConsume) {
        _currentTimeConsume = self.minTimeConsume;
    }
    _minTimeConsume = (_minTimeConsume / self.timeScale + (_minTimeConsume % self.timeScale > 0)) * self.timeScale;

    // 最小时长解析
    int64_t minTimeConsume = self.minTimeConsume;
    if (minTimeConsume >= 1440) {
        _minDay = (NSInteger)(minTimeConsume / 1440);
        minTimeConsume %= 1440;
    }
    if (minTimeConsume >= 60) {
        _minHour = (NSInteger)(minTimeConsume / 60);
        minTimeConsume %= 60;
    }
    _minMinute = (NSInteger)minTimeConsume;

    // 最大时长解析
    int64_t maxTimeConsume = self.maxTimeConsume;
    if (maxTimeConsume >= 1440) {
        _componentCount = 6;
        _maxDay = (NSInteger)(maxTimeConsume / 1440);
        maxTimeConsume %= 1440;
        _maxHour = (NSInteger)(maxTimeConsume / 60);
        maxTimeConsume %= 60;
        _maxMinute = (NSInteger)maxTimeConsume;
    } else if (maxTimeConsume >= 60) {
        _componentCount = 4;
        _maxHour = (NSInteger)(maxTimeConsume / 60);
        maxTimeConsume %= 60;
        _maxMinute = (NSInteger)maxTimeConsume;
    } else {
        _componentCount = 2;
        _maxMinute = (NSInteger)maxTimeConsume;
    }
    [self.pickerView reloadAllComponents];

    [self renderTimeConsume];
}

- (void)renderTimeConsume {
    int64_t timeConsume = self.currentTimeConsume;
    if (timeConsume >= 1440) {
        _day = (NSInteger)(timeConsume / 1440);
        timeConsume = timeConsume % 1440;
    }
    if (timeConsume >= 60) {
        _hour = (NSInteger)(timeConsume / 60);
        timeConsume = timeConsume % 60;
    }
    _minute = (NSInteger)timeConsume;
    NSInteger minuteRow = self.minute / self.timeScale + (self.minute % self.timeScale > 0);

    if (self.componentCount == 6) {
        [self.pickerView selectRow:self.day inComponent:0 animated:NO];
        [self.pickerView selectRow:self.hour inComponent:2 animated:NO];
        [self.pickerView selectRow:minuteRow inComponent:4 animated:NO];
    } else if (self.componentCount == 4) {
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
    return self.componentCount;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component % 2) {
        return 1;
    }
    if (component == 0) {
        if (self.componentCount == 6) {
            return self.maxDay - self.minDay + 1;
        }
        if (self.componentCount == 4) {
            return 24;
        }
        return 12;
    }
    if (component == 2) {
        if (self.componentCount == 6) {
            return 24;
        } else {
            return 12;
        }
    }
    return 12;
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
        if (self.componentCount == 6) {
            text = [NSString stringWithFormat:@"%ld", self.minDay + row];
        } else if (self.componentCount == 4) {
            text = [NSString stringWithFormat:@"%ld", row];
        } else {
            text = [NSString stringWithFormat:@"%ld", row * self.timeScale];
        }
    }
    if (component == 1) {
        if (self.componentCount == 6) {
            text = @"天";
        } else if (self.componentCount == 4) {
            text = @"小时";
        } else {
            text = @"分钟";
        }
    }
    if (component == 2) {
        text = [NSString stringWithFormat:@"%ld", row];
        if (self.componentCount == 4) {
            text = [NSString stringWithFormat:@"%ld", row * self.timeScale];
        }
    }
    if (component == 3) {
        text = @"小时";
        if (self.componentCount == 4) {
            text = @"分钟";
        }
    }
    if (component == 4) {
        text = [NSString stringWithFormat:@"%ld", row * self.timeScale];
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
    if (component % 2 > 0) {
        return;
    }

    if (self.componentCount == 6) {
        _currentTimeConsume = [self dayLevelDidSelectRow:row inComponent:component];
    } else if (self.componentCount == 4) {
        _currentTimeConsume = [self hourLevelDidSelecRow:row inComponent:component];
    } else {
        _currentTimeConsume = [self minuteLevelDidSelectRow:row inComponent:component];
    }
    kDR_SAFE_BLOCK(self.onTimeConsumeChangeBlock, self.currentTimeConsume);
    [pickerView reloadAllComponents];
}

- (int64_t)dayLevelDidSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _day = self.minDay + row;
    } else if (component == 2) {
        _hour = row;
    } else {
        _minute = row * self.timeScale;
    }
    int64_t currentMinuts = self.day * 1440 + self.hour * 60 + self.minute;
    if (currentMinuts < self.minTimeConsume) {
        currentMinuts = self.minTimeConsume;
        _hour = self.minHour;
        _minute = self.minMinute;
        [self.pickerView selectRow:self.hour inComponent:2 animated:YES];
        [self.pickerView selectRow:self.minute / self.timeScale inComponent:4 animated:YES];
    } else if (currentMinuts > self.maxTimeConsume) {
        currentMinuts = self.maxTimeConsume / self.timeScale * self.timeScale;
        _hour = self.maxHour;
        _minute = self.maxMinute;
        [self.pickerView selectRow:self.hour inComponent:2 animated:YES];
        [self.pickerView selectRow:self.minute / self.timeScale inComponent:4 animated:YES];
    }
    return currentMinuts;
}

- (int64_t)hourLevelDidSelecRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _hour = row;
    } else {
        _minute = row * self.timeScale;
    }
    int64_t currentMinuts = self.hour * 60 + self.minute;
    if (currentMinuts < self.minTimeConsume) {
        currentMinuts = self.minTimeConsume;
        _hour = self.minHour;
        _minute = self.minMinute;
        [self.pickerView selectRow:self.hour inComponent:0 animated:YES];
        [self.pickerView selectRow:self.minute / self.timeScale inComponent:2 animated:YES];
    } else if (currentMinuts > self.maxTimeConsume) {
        currentMinuts = self.maxTimeConsume / self.timeScale * self.timeScale;
        _hour = self.maxHour;
        _minute = self.maxMinute;
        [self.pickerView selectRow:self.hour inComponent:0 animated:YES];
        [self.pickerView selectRow:self.minute / self.timeScale inComponent:2 animated:YES];
    }
    return currentMinuts;
}

- (int64_t)minuteLevelDidSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _minute = row * self.timeScale;
    int64_t currentMinuts = self.minute;
    if (currentMinuts < self.minTimeConsume) {
        currentMinuts = self.minTimeConsume;
        _minute = self.minMinute;
        [self.pickerView selectRow:self.minute / self.timeScale inComponent:0 animated:YES];
    } else if (currentMinuts > self.maxTimeConsume) {
        currentMinuts = self.maxTimeConsume / self.timeScale * self.timeScale;
        _minute = self.maxMinute;
        [self.pickerView selectRow:self.minute / self.timeScale inComponent:0 animated:YES];
    }
    return currentMinuts;
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
    _componentCount = 0;
    _minDay = 0;
    _maxDay = 0;
    _minHour = 0;
    _maxHour = 0;
    _minMinute = 0;
    _maxMinute = 0;
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

- (void)setMinTimeConsume:(int64_t)minTimeConsume {
    _minTimeConsume = minTimeConsume;

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
