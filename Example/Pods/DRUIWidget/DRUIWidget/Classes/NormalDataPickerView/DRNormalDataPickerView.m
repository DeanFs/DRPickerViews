//
//  DRNormalDataPickerView.m
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/10.
//

#import "DRNormalDataPickerView.h"
#import <Masonry/Masonry.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import "DRUIWidgetUtil.h"

#define kLoopRowCount 10000   // 总行数，即可显示的总天数
#define kLoopCentreRow 5000   // 中间行数，每次滚动结束时定位的位置

@interface DRNormalDataPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) UIPickerView *pickerView;
@property (nonatomic, assign) BOOL didDrawRect;

@end

@implementation DRNormalDataPickerView

- (void)setupPickerView {
    [self.pickerView reloadAllComponents];

    NSMutableArray *arr = [NSMutableArray array];
    if (self.currentSelectedStrings.count > 0) {
        [arr addObjectsFromArray:self.currentSelectedStrings];
    }
    if (arr.count < self.dataSource.count) {
        for (NSInteger i=arr.count; i<self.dataSource.count; i++) {
            [arr addObject:self.dataSource[i][0]];
        }
    }
    for (NSInteger section=0; section<self.dataSource.count; section++) {
        NSArray *values = self.dataSource[section];
        NSString *aValue = arr[section];
        BOOL isLoop = NO;
        if (self.getIsLoopForSectionBlock) {
            isLoop = self.getIsLoopForSectionBlock(section);
        }
        for (NSInteger row=0; row<values.count; row++) {
            if ([aValue isEqualToString:values[row]]) {
                NSInteger component = section * 2;
                NSInteger index = row;
                if (isLoop) {
                    index += (kLoopCentreRow * values.count);
                }
                [self.pickerView selectRow:index inComponent:component animated:NO];
                break;
            }
        }
    }
    _currentSelectedStrings = arr;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pickerView reloadAllComponents];
    });
}

- (void)getSelectedValueForSection:(NSInteger)section
                         withBlock:(void (^)(NSInteger index, NSString *selectedString))block {
    NSArray *values = self.dataSource[section];
    NSInteger index = [self.pickerView selectedRowInComponent:section * 2];
    kDR_SAFE_BLOCK(block, index, values[index]);
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    [DRUIWidgetUtil hideSeparateLineForPickerView:pickerView];
    return self.dataSource.count * 2 - 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component % 2 > 0) {
        return 1;
    }
    BOOL isLoop = NO;
    if (self.getIsLoopForSectionBlock) {
        isLoop = self.getIsLoopForSectionBlock(component/2);
    }
    NSInteger count = self.dataSource[component/2].count;
    if (isLoop) {
        count *= kLoopRowCount;
    }
    return count;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component % 2 > 0) {
        return 8;
    }
    if (self.getWidthForSectionWithBlock) {
        return self.getWidthForSectionWithBlock(component/2);
    }
    CGFloat separateLineWidth = 0;
    if (self.dataSource.count > 1) {
        separateLineWidth = 8 * (self.dataSource.count - 1);
    }
    return (CGRectGetWidth(pickerView.frame)-separateLineWidth) / self.dataSource.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 34;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        if (component % 2 > 0) {
            label.font = [UIFont dr_PingFangSC_RegularWithSize:15];
            label.textAlignment = NSTextAlignmentCenter;
        } else {
            if (self.getFontForSectionWithBlock) {
                label.font = self.getFontForSectionWithBlock(component/2);
            } else {
                label.font = [UIFont dr_PingFangSC_MediumWithSize:17];
            }
            if (self.getTextAlignmentForSectionBlock) {
                label.textAlignment = self.getTextAlignmentForSectionBlock(component/2);
            } else {
                label.textAlignment = NSTextAlignmentCenter;
            }
        }
    }
    label.textColor = [DRUIWidgetUtil pickerUnSelectColor];
    if (component % 2 > 0) {
        if (self.getSeparateTextBeforeSectionBlock) {
            label.text = self.getSeparateTextBeforeSectionBlock((component+1)/2);
        } else {
            label.text = @"/";
        }
    } else {
        NSArray *sectionList = self.dataSource[component/2];
        label.text = sectionList[row%sectionList.count];
    }
    if (row == [pickerView selectedRowInComponent:component]) {
        label.textColor = [DRUIWidgetUtil normalColor];
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component % 2 > 0) {
        return;
    }
    NSInteger section = component / 2;
    NSArray *sectionList = self.dataSource[section];
    NSInteger index = row % sectionList.count;
    NSString *selectedString = sectionList[index];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.currentSelectedStrings];
    [arr replaceObjectAtIndex:section withObject:selectedString];
    _currentSelectedStrings = arr;
    kDR_SAFE_BLOCK(self.onSelectedChangeBlock, section, index, selectedString);

    BOOL isLoop = NO;
    if (self.getIsLoopForSectionBlock) {
        isLoop = self.getIsLoopForSectionBlock(section);
    }
    if (isLoop) {
        index += (kLoopCentreRow * sectionList.count);
        [self.pickerView selectRow:index inComponent:component animated:NO];
    }
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

- (void)setDataSource:(NSArray<NSArray<NSString *> *> *)dataSource {
    _dataSource = dataSource;

    if (self.didDrawRect) {
        [self setupPickerView];
    }
}

- (void)setCurrentSelectedStrings:(NSArray<NSString *> *)currentSelectedStrings {
    _currentSelectedStrings = currentSelectedStrings;

    if (self.didDrawRect) {
        [self setupPickerView];
    }
}

@end
