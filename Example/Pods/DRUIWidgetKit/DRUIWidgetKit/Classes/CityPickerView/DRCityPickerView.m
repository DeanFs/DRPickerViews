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

@property (nonatomic, copy) NSString *shengji;
@property (nonatomic, copy) NSString *diji;
@property (nonatomic, assign) NSInteger quHuaDaiMa;
@property (nonatomic, assign) NSInteger zoning_code; // 父级code
@property (nonatomic, strong) NSArray<DRCityPickerInfoModel *> *children;

@end

@implementation DRCityPickerInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children": [DRCityPickerInfoModel class]};
}

@end

@interface DRCityPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray<DRCityPickerInfoModel *> *provinceList;
@property (nonatomic, assign) BOOL didDrawRect;

@end

@implementation DRCityPickerView

- (void)setupPickerView {
    [self.pickerView reloadAllComponents];

    NSInteger provinceIndex = 0;
    NSInteger cityIndex = 0;
    BOOL find = NO;
    for (DRCityPickerInfoModel *province in self.provinceList) {
        cityIndex = 0;
        for (DRCityPickerInfoModel *city in province.children) {
            if (city.quHuaDaiMa == self.cityCode) {
                _province = city.shengji;
                _city = city.diji;
                find = YES;
                break;
            }
            cityIndex += 1;
        }
        if (find) {
            break;
        }
        provinceIndex += 1;
    }
    if (!find) {
        DRCityPickerInfoModel *city = self.provinceList.firstObject.children.firstObject;
        _province = city.shengji;
        _city = city.diji;
        _cityCode = city.quHuaDaiMa;
    }
    [self.pickerView selectRow:provinceIndex inComponent:0 animated:NO];
    [self.pickerView reloadComponent:1];
    [self.pickerView selectRow:cityIndex inComponent:1 animated:NO];

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
    return self.provinceList[[pickerView selectedRowInComponent:0]].children.count;
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
        text = self.provinceList[row].shengji;
    }
    if (component == 1) {
        text = self.provinceList[[pickerView selectedRowInComponent:0]].children[row].diji;
    }

    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont dr_PingFangSC_RegularWithSize:17];
    }
    label.textColor = [DRUIWidgetUtil pickerUnSelectColor];
    label.text = text;
    if (row == [pickerView selectedRowInComponent:component]) {
        label.textColor = [DRUIWidgetUtil normalColor];
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    DRCityPickerInfoModel *model = self.provinceList[[pickerView selectedRowInComponent:0]].children[[pickerView selectedRowInComponent:1]];
    _province = model.shengji;
    _city = model.diji;
    _cityCode = model.quHuaDaiMa;
    kDR_SAFE_BLOCK(self.onSelectedChangeBlock, model.quHuaDaiMa, model.shengji, model.diji);
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
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city_list" ofType:@"json"]];
        self.provinceList = [NSArray yy_modelArrayWithClass:[DRCityPickerInfoModel class] json:data];

        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.delegate = self;
        pickerView.dataSource = self;

        self.pickerView = pickerView;
        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_offset(0);
        }];
        _cityCode = -1;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if (CGRectIsEmpty(rect)) {
        return;
    }
    if (!self.didDrawRect) {
        self.didDrawRect = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupPickerView];
        });
    }
}

- (void)setCityCode:(NSInteger)cityCode {
    _cityCode = cityCode;

    if (self.didDrawRect) {
        [self setupPickerView];
    }
}

@end
