//
//  DRValuePickerView.m
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/9.
//

#import "DRValuePickerView.h"
#import <Masonry/Masonry.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import "DRUIWidgetUtil.h"

@interface DRValuePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *prefixUnitLabel;

@property (nonatomic, assign) BOOL didDrawRect;

@end

@implementation DRValuePickerView

- (void)setupPickerView {
    if (self.currentValue < self.minValue || self.currentValue > self.maxValue) {
        self.currentValue = self.minValue;
        kDR_LOG(@"当前反显值不在设定范围内");
        return;
    }

    [self.pickerView reloadAllComponents];

    NSInteger row = self.currentValue - self.minValue;
    if (row > 0) {
        [self.pickerView selectRow:row inComponent:0 animated:NO];
    }
    self.valueLabel.text = [NSString stringWithFormat:@"%ld", self.maxValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pickerView reloadAllComponents];
    });
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    [DRUIWidgetUtil hideSeparateLineForPickerView:pickerView];
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.maxValue - self.minValue + 1;
}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:31];
    label.text = [NSString stringWithFormat:@"%ld", self.minValue + row];
    label.textColor = [DRUIWidgetUtil pickerUnSelectColor];
    if (row == [pickerView selectedRowInComponent:component] || component == 1) {
        label.textColor = [DRUIWidgetUtil normalColor];
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _currentValue = self.minValue + row;
    kDR_SAFE_BLOCK(self.onSelectedChangeBlock, _currentValue);
    [pickerView reloadComponent:component];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return CGRectGetWidth(pickerView.frame);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 34;
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
    if (!self.containerView) {
        self.containerView = kDR_LOAD_XIB_NAMED(NSStringFromClass([self class]));
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_offset(0);
        }];

        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.unitLabel.textColor = [DRUIWidgetUtil normalColor];
        self.prefixUnitLabel.textColor = [DRUIWidgetUtil normalColor];
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

- (void)setMinValue:(NSInteger)minValue {
    _minValue = minValue;

    if (self.didDrawRect) {
        [self setupPickerView];
    }
}

- (void)setMaxValue:(NSInteger)maxValue {
    _maxValue = maxValue;

    if (self.didDrawRect) {
        [self setupPickerView];
    }
}

- (void)setValueUnit:(NSString *)valueUnit {
    self.unitLabel.text = valueUnit;
}

- (void)setPrefixUnit:(NSString *)prefixUnit {
    self.prefixUnitLabel.text = prefixUnit;
}

- (void)setCurrentValue:(NSInteger)currentValue {
    _currentValue = currentValue;

    if (self.didDrawRect) {
        [self setupPickerView];
    }
}

@end
