//
//  DRHourMinuteAtomicPickerView.m
//  AFNetworking
//
//  Created by 冯生伟 on 2019/4/16.
//

#import "DRHourMinuteAtomicPickerView.h"
#import "DRBasicKitDefine.h"
#import <HexColors/HexColors.h>
#import <YYText/YYText.h>
#import <Masonry/Masonry.h>
#import "UIView+DRExtension.h"
#import "DRBundleManager.h"

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

@interface DRHourMinuteAtomicPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>


@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1Center;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2Center;

@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) int64_t duration;
@property (nonatomic, assign) BOOL setupWaiting;

@end

@implementation DRHourMinuteAtomicPickerView

#pragma mark - api
/**
 实例化
 
 @param type 选择器类型
 @param delegate 代理
 @return 构建好的选择器
 */
+ (instancetype)hourMinutePickerViewWithType:(DRHourMinuteAtomicPickerViewType)type
                                    delegate:(id<DRHourMinuteAtomicPickerViewDelegate>)delegate {
    DRHourMinuteAtomicPickerView *pickerView = [[DRHourMinuteAtomicPickerView alloc] init];
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
    
    if (self.type == DRHourMinuteAtomicPickerViewTypeMoment) {
        return [DRHourMinutePickerValueModel valueModelWithStartHour:startHour
                                                         startMinute:startMinute];
    }
    NSInteger endHour = [self.pickerView selectedRowInComponent:2] % 24;
    NSInteger endMinute = ([self.pickerView selectedRowInComponent:3] * self.timeScale) % 60;
    
    return [DRHourMinutePickerValueModel valueModelWithStartHour:startHour
                                                     startMinute:startMinute
                                                         endHour:endHour
                                                       endMinute:endMinute
                                                     minDuration:self.minDuration];
}

/**
 设置反显当前时间
 适用于DRHourMinuteAtomicPickerViewTypeMoment类型
 调用该方法反显时，会强制将type设置为DRHourMinuteAtomicPickerViewTypeMoment
 
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
 适用于DRHourMinuteAtomicPickerViewTypeDuration类型
 调用该方法反显时，会强制将type设置为DRHourMinuteAtomicPickerViewTypeDuration
 
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

- (void)setType:(NSInteger)type {
    _type = type;
    [self setupToShow];
}

- (void)setTimeScale:(NSInteger)timeScale {
    _timeScale = timeScale;
    [self setupToShow];
}

- (void)setHighlightColor:(UIColor *)highlightColor {
    _highlightColor = highlightColor;
    self.toLabel.textColor = highlightColor;
}

- (void)setToLabelFontSize:(CGFloat)toLabelFontSize {
    self.toLabel.font = [UIFont systemFontOfSize:toLabelFontSize];
}

- (void)setRowHeight:(CGFloat)rowHeight {
    _rowHeight = rowHeight;
    self.line1Center.constant = -rowHeight/2;
    self.line2Center.constant = rowHeight/2;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.containerView.backgroundColor = backgroundColor;
    self.pickerView.backgroundColor = backgroundColor;
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
    if (!self.containerView) {
        self.containerView = kDR_LOAD_XIB_NAMED(NSStringFromClass([self class]));
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_offset(0);
        }];
        
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerFontSize = 22;
        self.toLabelFontSize = 16;
        self.highlightColor = [UIColor hx_colorWithHexRGBAString:@"111111"];
        self.timeScale = 1;
        self.minDuration = 1;
        self.rowHeight = 32;
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
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
        self.toLabel.hidden = YES;
        [self.pickerView selectRow:kHourCenterRow + self.hour
                       inComponent:0
                          animated:NO];
        [self.pickerView selectRow:kMinuteCenterRow + (self.minute / self.timeScale + (self.minute % self.timeScale > 0))
                       inComponent:1
                          animated:NO];
        if (self.type == DRHourMinuteAtomicPickerViewTypeDuration) {
            NSAssert(self.minDuration >= self.timeScale && self.minDuration <= 1440, @"最小时间间隔不能小于时间步长，且不能超过24小时(1440分钟)");
            NSAssert(self.duration <= 86400, @"时间跨度不能超过一天");
            self.toLabel.hidden = NO;
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
                           inComponent:2
                              animated:NO];
            [self.pickerView selectRow:kMinuteCenterRow + endMinuteRow
                           inComponent:3
                              animated:NO];
        }
        [self.pickerView reloadAllComponents];
        self.setupWaiting = NO;
        
        if ([self.delegate respondsToSelector:@selector(hourMinutePickerView:didSeletedValue:)]) {
            DRHourMinutePickerValueModel *value = [self currentSelectedValue];
            [self.delegate hourMinutePickerView:self
                                didSeletedValue:value];
        }
    });
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    for (UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = [UIColor clearColor];
        }
    }
    if (self.type == DRHourMinuteAtomicPickerViewTypeDuration) {
        return 4;
    }
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component % 2 == 0) {
        return kHourRow;
    } else {
        return kMinuteRow;
    }
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.type == DRHourMinuteAtomicPickerViewTypeMoment) {
        return 80;
    }
    return (self.width-40) / 4;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return self.rowHeight;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *text;
    if (component % 2 == 0) {
        text = [NSString stringWithFormat:@"%02ld", row % 24];
    } else {
        text = [NSString stringWithFormat:@"%02ld", (row * self.timeScale) % 60];
    }
    NSInteger selectedRow = [pickerView selectedRowInComponent:component];
    
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
    }
    label.text = text;
    label.textColor = [UIColor hx_colorWithHexRGBAString:@"111111"];
    label.font = [UIFont systemFontOfSize:self.pickerFontSize];
    label.textAlignment = NSTextAlignmentCenter;
    
    if (row == selectedRow) {
        label.textColor = self.highlightColor;
    }
    if (self.type == DRHourMinuteAtomicPickerViewTypeDuration) {
        if (component == 1) {
            label.textAlignment = NSTextAlignmentLeft;
        } else if (component == 2) {
            label.textAlignment = NSTextAlignmentRight;
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

@end
