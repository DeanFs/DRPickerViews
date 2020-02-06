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
#import <DRCategories/NSArray+DRExtension.h>
#import "DRUIWidgetUtil.h"

#define kLoopRowCount 10000   // 总行数，即可显示的总天数
#define kLoopCentreRow 5000   // 中间行数，每次滚动结束时定位的位置

@interface DRNormalDataPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) UIPickerView *pickerView;
@property (nonatomic, assign) BOOL didDrawRect;
@property (nonatomic, assign) BOOL didChangeSelect;
@property (assign, nonatomic) BOOL reloading; // 用于避免死循环

@end

@implementation DRNormalDataPickerView

- (void)getSelectedValueForSection:(NSInteger)section
                         withBlock:(void (^)(NSInteger index, NSString *selectedString))block {
    NSArray *values = self.dataSource[section];
    NSInteger index = [self.pickerView selectedRowInComponent:section * 2];
    kDR_SAFE_BLOCK(block, index, values[index]);
}

- (void)reloadData {
    self.reloading = YES;
    if (self.didDrawRect) {
        if (self.didChangeSelect) {
            [self setupPickerView];
        } else {
            [self.pickerView reloadAllComponents];
            for (NSInteger i=0; i<self.dataSource.count; i++) {
                NSArray *arr = self.dataSource[i];
                if (![arr isKindOfClass:[NSArray class]]) {
                    kDR_LOG(@"传入数据有误");
                    return;
                }
                NSInteger row = [self.pickerView selectedRowInComponent:i*2];
                NSInteger maxIndex = arr.count - 1;
                if (row > maxIndex) {
                    row = maxIndex;
                }
                if (row < 0) {
                    row = 0;
                }
                [self.pickerView selectRow:row inComponent:i*2 animated:NO];
                [self pickerView:self.pickerView didSelectRow:row inComponent:i*2];
            }
            [self.pickerView reloadAllComponents];
        }
    }
    self.reloading = NO;
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
    if (self.getIsLoopForSectionBlock != nil) {
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
    if (self.getWidthForSectionWithBlock != nil) {
        return self.getWidthForSectionWithBlock(component/2);
    }
    CGFloat separateLineWidth = 0;
    if (self.dataSource.count > 1) {
        separateLineWidth = 18 * (self.dataSource.count - 1) + 40 * kDRScreenWidth / 414;
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
            if (self.getFontForSectionWithBlock != nil) {
                label.font = self.getFontForSectionWithBlock(component/2, row);
            } else {
                label.font = [UIFont dr_PingFangSC_RegularWithSize:17];
            }
            if (self.getTextAlignmentForSectionBlock != nil) {
                label.textAlignment = self.getTextAlignmentForSectionBlock(component/2);
            } else {
                label.textAlignment = NSTextAlignmentCenter;
            }
        }
    }
    
    label.textColor = [DRUIWidgetUtil pickerUnSelectColor];
    if (row == [pickerView selectedRowInComponent:component]) {
        label.textColor = [DRUIWidgetUtil normalColor];
    }
    
    if (component % 2 > 0) {
        if (self.getSeparateTextBeforeSectionBlock != nil) {
            label.text = self.getSeparateTextBeforeSectionBlock((component+1)/2);
        } else {
            label.text = @"/";
        }
    } else {
        NSArray *sectionList = self.dataSource[component/2];
        NSString *text = sectionList[row%sectionList.count];
        if (self.getCustonCellViewBlock != nil) {
            UIView *customView = self.getCustonCellViewBlock(component/2, row, text, label.textColor);
            if (customView) {
                return customView;
            }
        }
        label.text = text;
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component % 2 > 0) {
        return;
    }
    NSInteger section = component / 2;
    NSArray *sectionList = self.dataSource[section];
    NSString *selectedString = @"";
    NSInteger index = -1;
    if (sectionList.count > 0) {
        index = row % sectionList.count;
        selectedString = sectionList[index];
        if (selectedString == nil) {
            selectedString = @"";
        }
    }
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.currentSelectedStrings];
    [arr replaceObjectAtIndex:section withObject:selectedString];
    _currentSelectedStrings = arr;
    if (!self.reloading) {
        if (index < 0) {
            index = 0;
        }
        kDR_SAFE_BLOCK(self.onSelectedChangeBlock, section, index, selectedString);
    }
    
    BOOL isLoop = NO;
    if (self.getIsLoopForSectionBlock != nil) {
        isLoop = self.getIsLoopForSectionBlock(section);
    }
    if (isLoop && index >= 0) {
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

#pragma mark - private
- (void)setup {
    if (!self.pickerView) {
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.backgroundColor = [UIColor whiteColor];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        
        self.pickerView = pickerView;
        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_offset(0);
        }];
    }
}

- (void)setupPickerView {
    if (![self.dataSource isKindOfClass:[NSArray class]] || self.dataSource.count == 0) {
        kDR_LOG(@"传入数据有误");
        return;
    }
    
    NSMutableArray<NSString *> *currentSelectedStrings = [NSMutableArray array];
    NSMutableArray<NSNumber *> *rows = [NSMutableArray array];
    for (NSInteger i=0; i<self.dataSource.count; i++) {
        NSArray *arr = self.dataSource[i];
        if (![arr isKindOfClass:[NSArray class]]) {
            kDR_LOG(@"传入数据有误");
            return;
        }
        
        NSString *current = [self.currentSelectedStrings safeGetObjectWithIndex:i];
        if (![current isKindOfClass:[NSString class]] || current.length == 0) {
            [currentSelectedStrings addObject:arr.firstObject];
            [rows addObject:@(0)];
            continue;
        }
        
        BOOL find = NO;
        for (NSInteger j=0; j<arr.count; j++) {
            NSString *string = arr[j];
            if (![string isKindOfClass:[NSString class]]) {
                kDR_LOG(@"传入数据有误");
                return;
            }
            if ([string isEqualToString:current]) {
                find = YES;
                [currentSelectedStrings addObject:string];
                [rows addObject:@(j)];
            }
        }
        if (!find) {
            [currentSelectedStrings addObject:arr.firstObject];
            [rows addObject:@(0)];
        }
    }
    _currentSelectedStrings = currentSelectedStrings;
    [self.pickerView reloadAllComponents];
    
    for (NSInteger i=0; i<rows.count; i++) {
        NSInteger index = rows[i].integerValue;
        [self.pickerView selectRow:index inComponent:i*2 animated:NO];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pickerView reloadAllComponents];
    });
    self.didChangeSelect = NO;
}

- (void)setCurrentSelectedStrings:(NSArray<NSString *> *)currentSelectedStrings {
    _currentSelectedStrings = currentSelectedStrings;
    
    if (self.didDrawRect) {
        self.didChangeSelect = YES;
    }
}

@end
