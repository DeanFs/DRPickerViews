//
//  DRCityPickerView.m
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/10.
//

#import "DRCityPickerView.h"
#import <Masonry/Masonry.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import <YYModel/YYModel.h>
#import "DRUIWidgetUtil.h"

@interface DRCityPickerInfoModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSArray<DRCityPickerInfoModel *> *child;

@end

@implementation DRCityPickerInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"child": [DRCityPickerInfoModel class]};
}

@end

@interface DRCityPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray<DRCityPickerInfoModel *> *provinceList;
@property (nonatomic, assign) BOOL didDrawRect;

@end

@implementation DRCityPickerView

- (void)setupPickerView {
    for (DRCityPickerInfoModel *province in self.provinceList) {
        if ([province.name isEqualToString:self.province]) {
            [self.pickerView selectRow:province.code - 1 inComponent:0 animated:NO];
            [self.pickerView reloadComponent:1];
            for (DRCityPickerInfoModel *city in province.child) {
                if ([city.name isEqualToString:self.city]) {
                    [self.pickerView selectRow:city.code - 1 inComponent:1 animated:NO];
                    break;
                }
            }
            break;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pickerView reloadAllComponents];
    });
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    [DRUIWidgetUtil hideSeparateLineForPickerView:pickerView];
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceList.count;
    }
    return self.provinceList[[pickerView selectedRowInComponent:0]].child.count;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 100;
    }
    return 200;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 34;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *text;
    if (component == 0) {
        text = self.provinceList[row].name;
    }
    if (component == 1) {
        text = self.provinceList[[pickerView selectedRowInComponent:0]].child[row].name;
    }

    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont dr_PingFangSC_MediumWithSize:17];
    }
    label.textColor = [DRUIWidgetUtil pickerUnSelectColor];
    label.text = text;
    if (row == [pickerView selectedRowInComponent:component]) {
        label.textColor = [DRUIWidgetUtil normalColor];
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _province = self.provinceList[row].name;
    }
    if (component == 1) {
        _city = self.provinceList[[pickerView selectedRowInComponent:0]].child[row].name;
    }
    kDR_SAFE_BLOCK(self.onSelectedChangeBlock, self.province, self.city);
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
        NSData *data = [NSData dataWithContentsOfFile:[KDR_CURRENT_BUNDLE pathForResource:@"city_list" ofType:@"json"]];
        self.provinceList = [NSArray yy_modelArrayWithClass:[DRCityPickerInfoModel class] json:data];

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

- (void)setProvince:(NSString *)province {
    _province = province;

    if (self.didDrawRect) {
        [self setupPickerView];
    }
}

- (void)setCity:(NSString *)city {
    _city = city;

    if (self.didDrawRect) {
        [self setupPickerView];
    }
}

@end
