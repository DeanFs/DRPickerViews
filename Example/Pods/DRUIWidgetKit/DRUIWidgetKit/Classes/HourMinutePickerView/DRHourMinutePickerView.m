//
//  DRHourMinutePickerView.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/2.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRHourMinutePickerView.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import "UIView+DRExtension.h"
#import <Masonry/Masonry.h>
#import "DRUIWidgetUtil.h"
#import <DRCategories/UIFont+DRExtension.h>

@implementation DRHourMinutePickerValueModel

+ (instancetype)valueModelWithStartHour:(NSInteger)startHour
                            startMinute:(NSInteger)startMinute
                                endHour:(NSInteger)endHour
                              endMinute:(NSInteger)endMinute
                            minDuration:(NSInteger)minDuration {
    int64_t startMinuteStamp = startHour * 60 + startMinute;
    int64_t endMinuteStamp = endHour * 60 + endMinute;
    int64_t durationMinute = endMinuteStamp - startMinuteStamp;
    BOOL beyondOneDay = NO;
    if (durationMinute < 0) {
        durationMinute = 1440 - startMinuteStamp + endMinuteStamp;
        beyondOneDay = YES;
    }
    
    NSMutableString *text = [NSMutableString string];
    if (durationMinute > 59) {
        [text appendFormat:@"持续 %lli 小时", durationMinute/60];
        NSInteger minute = durationMinute % 60;
        if (minute > 0) {
            [text appendFormat:@" %ld 分钟", minute];
        }
    } else {
        [text appendFormat:@"持续 %lli 分钟", durationMinute];
    }
    
    DRHourMinutePickerValueModel *valueModel = [DRHourMinutePickerValueModel new];
    valueModel->_hour = startHour;
    valueModel->_minute = startMinute;
    valueModel->_endHour = endHour;
    valueModel->_endMinute = endMinute;
    valueModel->_duration = durationMinute * 60;
    valueModel->_durationDesc = text;
    valueModel->_enoughDuration = durationMinute >= minDuration;
    valueModel->_endHourMinute = [NSString stringWithFormat:@"%02ld%02ld", endHour, endMinute];
    valueModel->_beyondOneDay = beyondOneDay;
    return valueModel;
}

+ (instancetype)valueModelWithStartHour:(NSInteger)startHour
                            startMinute:(NSInteger)startMinute {
    DRHourMinutePickerValueModel *valueModel = [DRHourMinutePickerValueModel new];
    valueModel->_hour = startHour;
    valueModel->_minute = startMinute;
    return valueModel;
}

- (instancetype)init {
    if (self = [super init]) {
        _enoughDuration = YES;
        _beyondOneDay = NO;
        _durationDesc = @"";
    }
    return self;
}

@end

#define kHourRow 24000
#define kHourCenterRow 12000
#define kMinuteRow 60000
#define kMinuteCenterRow 30000

@interface DRHourMinutePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) UIPickerView *pickerView;

@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) int64_t duration;
@property (nonatomic, assign) BOOL setupWaiting;

@end

@implementation DRHourMinutePickerView

#pragma mark - api
/**
 实例化
 
 @param type 选择器类型
 @param delegate 代理
 @return 构建好的选择器
 */
+ (instancetype)hourMinutePickerViewWithType:(DRHourMinutePickerViewType)type
                                    delegate:(id<DRHourMinutePickerViewDelegate>)delegate {
    DRHourMinutePickerView *pickerView = [[DRHourMinutePickerView alloc] init];
    pickerView.type = type;
    pickerView.delegate = delegate;
    return pickerView;
}

/**
 获取当前选中的值
 
 @return 根据type不同返回不同数据模型
 */
- (DRHourMinutePickerValueModel *)currentSelectedValue {
    NSInteger startHour = [self.pickerView selectedRowInComponent:0] % 24;
    NSInteger startMinute = ([self.pickerView selectedRowInComponent:1] * self.timeScale) % 60;
    
    if (self.type == DRHourMinutePickerViewTypeMoment) {
        return [DRHourMinutePickerValueModel valueModelWithStartHour:startHour
                                                         startMinute:startMinute];
    }
    NSInteger endHour = [self.pickerView selectedRowInComponent:3] % 24;
    NSInteger endMinute = ([self.pickerView selectedRowInComponent:4] * self.timeScale) % 60;
    
    return [DRHourMinutePickerValueModel valueModelWithStartHour:startHour
                                                     startMinute:startMinute
                                                         endHour:endHour
                                                       endMinute:endMinute
                                                     minDuration:self.minDuration];
}

/**
 设置反显当前时间
 适用于DRHourMinutePickerViewTypeMoment类型
 调用该方法反显时，会强制将type设置为DRHourMinutePickerViewTypeMoment
 
 @param hour 小时
 @param minute 分钟
 */
- (void)setCurrentHour:(NSInteger)hour
                minute:(NSInteger)minute {
    self.hour = hour;
    self.minute = minute;
    [self setupToShow];
}

/**
 设置反显当前时间
 适用于DRHourMinutePickerViewTypeDuration类型
 调用该方法反显时，会强制将type设置为DRHourMinutePickerViewTypeDuration
 
 @param startHour 小时
 @param startMinute 分钟
 @param duration 时间段时长
 */
- (void)setCurrentStartHour:(NSInteger)startHour
                startMimute:(NSInteger)startMinute
                   duration:(int64_t)duration {
    self.hour = startHour;
    self.minute = startMinute;
    self.duration = duration;
    [self setupToShow];
}

- (void)setTypeXib:(NSInteger)typeXib {
    self.type = typeXib;
}

- (void)setType:(DRHourMinutePickerViewType)type {
    _type = type;
    [self setupToShow];
}

- (void)setTimeScale:(NSInteger)timeScale {
    _timeScale = timeScale;
    [self setupToShow];
}

#pragma mark - private
// 反显
- (void)setupToShow {
    if (self.setupWaiting) {
        return;
    }
    self.setupWaiting = YES;
    
    // 由于drawRect不稳定，且耗性能，此处使用延时0.2秒，充当drawRect方法来用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 修正小时分钟值
        NSInteger hour = self.hour;
        if (self.minute % self.timeScale > 0) {
            self.minute = (self.minute / self.timeScale + 1) * self.timeScale;
        }
        if (self.minute > 59) {
            hour += self.minute / 60;
            self.minute = self.minute % 60;
        }
        if (hour > 23) {
            hour = hour % 24;
        }
        self.hour = hour;
        
        // 反显
        NSAssert(self.timeScale > 0 && self.timeScale < 60, @"时间步长需要在1~59之间");
        [self.pickerView selectRow:kHourCenterRow + self.hour
                       inComponent:0
                          animated:NO];
        [self.pickerView selectRow:kMinuteCenterRow + (self.minute / self.timeScale + (self.minute % self.timeScale > 0))
                       inComponent:1
                          animated:NO];
        if (self.type == DRHourMinutePickerViewTypeDuration) {
            NSAssert(self.minDuration >= self.timeScale && self.minDuration <= 1440, @"最小时间间隔不能小于时间步长，且不能超过24小时(1440分钟)");
            NSAssert(self.duration <= 86400, @"时间跨度不能超过一天");
            if (self.duration <= 0) {
                self.duration = self.minDuration*60;
            }
            // 计算结束时间row
            NSInteger endHour = self.hour;
            NSInteger endMinute = self.minute + self.duration / 60;
            if (endMinute % self.timeScale > 0) {
                endMinute = (endMinute / self.timeScale + 1) * self.timeScale;
            }
            if (endMinute > 59) {
                endHour += endMinute / 60;
                endMinute = endMinute % 60;
            }
            if (endHour > 23) {
                endHour = endHour % 24;
            }
            NSInteger endMinuteRow = endMinute / self.timeScale + (endMinute % self.timeScale > 0);
            
            [self.pickerView selectRow:kHourCenterRow + endHour
                           inComponent:3
                              animated:NO];
            [self.pickerView selectRow:kMinuteCenterRow + endMinuteRow
                           inComponent:4
                              animated:NO];
        }
        [self.pickerView reloadAllComponents];
        self.setupWaiting = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(hourMinutePickerView:didSeletedValue:)]) {
                DRHourMinutePickerValueModel *value = [self currentSelectedValue];
                [self.delegate hourMinutePickerView:self
                                    didSeletedValue:value];
            }
        });
        
    });
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    [DRUIWidgetUtil hideSeparateLineForPickerView:pickerView];
    if (self.type == DRHourMinutePickerViewTypeDuration) {
        return 5;
    }
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 2) {
        return 1;
    }
    if (component == 0 || component == 3) {
        return kHourRow;
    } else {
        return kMinuteRow;
    }
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.type == DRHourMinutePickerViewTypeMoment) {
        return 70;
    }
    if (component == 2) {
        return 8;
    }
    return (self.width-58) / 4;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (self.type == DRHourMinutePickerViewTypeMoment) {
        return 40;
    }
    return 34;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *text;
    if (component == 2) {
        text = @"-";
    } else if (component == 0 || component == 3) {
        text = [NSString stringWithFormat:@"%02ld", row % 24];
    } else {
        text = [NSString stringWithFormat:@"%02ld", (row * self.timeScale) % 60];
    }
    
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.textColor = [DRUIWidgetUtil pickerUnSelectColor];
        label.font = [UIFont systemFontOfSize:31];
        if (self.type == DRHourMinutePickerViewTypeDuration) {
            label.font = [UIFont systemFontOfSize:26];
            if (component == 2) {
                label.textColor = [DRUIWidgetUtil normalColor];
                label.font = [UIFont dr_PingFangSC_RegularWithSize:15];
            }
        }
        label.textAlignment = NSTextAlignmentCenter;
    }
    label.text = text;
    
    NSInteger selectedRow = [pickerView selectedRowInComponent:component];
    if (row == selectedRow) {
        label.textColor = [DRUIWidgetUtil normalColor];
    }
    
    if (self.type == DRHourMinutePickerViewTypeDuration) {
        if (component == 0) {
            label.textAlignment = NSTextAlignmentRight;
        } else if (component == 4) {
            label.textAlignment = NSTextAlignmentLeft;
        }
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // 代理回调
    if ([self.delegate respondsToSelector:@selector(hourMinutePickerView:didSeletedValue:)]) {
        DRHourMinutePickerValueModel *value = [self currentSelectedValue];
        [self.delegate hourMinutePickerView:self
                            didSeletedValue:value];
    }
    
    // 回滚设置，无限滚动支持
    if (component % 2 == 0) {
        [pickerView selectRow:kHourCenterRow + row % 24 inComponent:component animated:NO];
    } else {
        NSInteger minuteRow = ((row * self.timeScale) % 60) / self.timeScale;
        [pickerView selectRow:kMinuteCenterRow + minuteRow inComponent:component animated:NO];
    }
    
    // 用于富文本设置
    [pickerView reloadComponent:component];
}

#pragma mark - lifecycle
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
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.backgroundColor = [UIColor whiteColor];
    picker.delegate = self;
    picker.dataSource = self;
    [self addSubview:picker];
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_offset(0);
    }];
    self.pickerView = picker;
    
    self.timeScale = 1;
    self.minDuration = 1;
    self.backgroundColor = [UIColor whiteColor];
}

@end
