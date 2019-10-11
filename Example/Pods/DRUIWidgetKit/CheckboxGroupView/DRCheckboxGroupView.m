//
//  DRCheckboxGroupView.m
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/11.
//

#import "DRCheckboxGroupView.h"
#import <Masonry/Masonry.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import <HexColors/HexColors.h>
#import "DRUIWidgetUtil.h"

@interface DRCheckboxGroupView ()

@property (weak, nonatomic) UIStackView *stackView;
@property (nonatomic, weak) UIView *bottomLine;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSString *> *selectMap;
@property (nonatomic, strong) NSMutableArray<UIButton *> *checkButtons;
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, weak) UIButton *currentButton;

@end

@implementation DRCheckboxGroupView

- (void)setupPickerView {
    if (self.checkButtons.count == 0) {
        return;
    }
    for (UIButton *button in self.checkButtons) {
        if (self.selectMap[@(button.tag)] == nil) {
            button.selected = NO;
        } else {
            button.selected = YES;
            if (!self.allowMultipleCheck) {
                self.currentButton = button;
            }
        }
    }
}

- (void)onCheckButtonTapped:(UIButton *)button {
    if (button.selected) {
        if (self.singleCheck) {
            return;
        }
        button.selected = NO;
        [self.selectMap removeObjectForKey:@(button.tag)];
    } else {
        if (!self.allowMultipleCheck) {
            self.currentButton.selected = NO;
            [self.selectMap removeObjectForKey:@(self.currentButton.tag)];
            self.currentButton = button;
        }
        button.selected = YES;
        [self.selectMap setObject:self.optionTitles[button.tag] forKey:@(button.tag)];
    }
    kDR_SAFE_BLOCK(self.onSelectedChangeBlock, self.selectMap.allKeys, self.selectMap.allValues);
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
    if (!self.stackView) {
        UIStackView *stackView = [[UIStackView alloc] init];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.distribution = UIStackViewDistributionFillEqually;
        stackView.spacing = 0;
        self.stackView = stackView;

        self.normalImage = [DRUIWidgetUtil pngImageWithName:@"class_icon_ring_30px_def"
                                                   inBundle:KDR_CURRENT_BUNDLE];
        self.selectedImage = [DRUIWidgetUtil pngImageWithName:@"class_icon_ring_30px_sel"
                                                     inBundle:KDR_CURRENT_BUNDLE];
        self.selectedImage = [self.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

        [self addSubview:self.stackView];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            make.left.mas_offset(16);
            make.right.mas_offset(-16);
        }];
        self.showBottomLine = YES;
    }
}

- (void)setShowBottomLine:(BOOL)showBottomLine {
    self.bottomLine.hidden = !showBottomLine;
}

- (void)setOptionTitles:(NSArray<NSString *> *)optionTitles {
    _optionTitles = optionTitles;

    if (self.checkButtons.count > 0) {
        for (UIButton *button in self.checkButtons) {
            [button removeFromSuperview];
            [self.stackView removeArrangedSubview:button];
        }
        [self.checkButtons removeAllObjects];
        [self.selectMap removeAllObjects];
        _selectedIndexs = @[];
        _selectedOptions = @[];
    }

    if (optionTitles.count > 0) {
        for (NSInteger i=0; i<self.optionTitles.count; i++) {
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:self.optionTitles[i] forState:UIControlStateNormal];
            [button setTitleColor:[DRUIWidgetUtil normalColor] forState:UIControlStateNormal];
            [button setTitleColor:[DRUIWidgetUtil highlightColor] forState:UIControlStateSelected];
            [button setImage:self.normalImage forState:UIControlStateNormal];
            [button setImage:self.selectedImage forState:UIControlStateSelected];
            [button addTarget:self action:@selector(onCheckButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, -3);
            button.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 3);
            button.titleLabel.font = [UIFont dr_PingFangSC_RegularWithSize:13];
            button.tintColor = [DRUIWidgetUtil highlightColor];
            button.tag = i;
            if (self.selectMap[@(i)] != nil) {
                button.selected = YES;
            }
            [self.stackView addArrangedSubview:button];
            [self.checkButtons addObject:button];
        }
        [self setupPickerView];
    }
}

- (void)setSelectedOptions:(NSArray<NSString *> *)selectedOptions {
    _selectedOptions = selectedOptions;

    [self.selectMap removeAllObjects];
    NSMutableArray *indexs = [NSMutableArray array];
    for (NSString *option in selectedOptions) {
        for (NSInteger i=0; i<self.optionTitles.count; i++) {
            if ([option isEqualToString:self.optionTitles[i]]) {
                if (!self.selectMap[@(i)]) {
                    self.selectMap[@(i)] = option;
                    [indexs addObject:@(i)];
                    break;
                }
            }
        }
    }
    _selectedIndexs = indexs;
    [self setupPickerView];
}

- (void)setSelectedIndexs:(NSArray<NSNumber *> *)selectedIndexs {
    _selectedIndexs = selectedIndexs;

    [self.selectMap removeAllObjects];
    NSMutableArray *options = [NSMutableArray array];
    for (NSNumber *number in selectedIndexs) {
        NSString *option = self.optionTitles[number.integerValue];
        if (option.length > 0) {
            [options addObject:option];
        }
        self.selectMap[number] = option;
    }
    _selectedOptions = options;
    [self setupPickerView];
}

- (void)setAllowMultipleCheck:(BOOL)allowMultipleCheck{
    _allowMultipleCheck = allowMultipleCheck;
    if (allowMultipleCheck) {
        _singleCheck = NO;
    }
}

- (void)setSingleCheck:(BOOL)singleCheck {
    _singleCheck = singleCheck;

    if (singleCheck) {
        _allowMultipleCheck = NO;
    }
}

- (NSMutableDictionary<NSNumber *, NSString *> *)selectMap {
    if (!_selectMap) {
        _selectMap = [NSMutableDictionary dictionary];
    }
    return _selectMap;
}

- (NSMutableArray<UIButton *> *)checkButtons {
    if (!_checkButtons) {
        _checkButtons = [NSMutableArray array];
    }
    return _checkButtons;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"E5E5F0"];
        [self addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(0);
            make.height.mas_equalTo(0.5);
            make.left.mas_offset(16);
            make.right.mas_offset(-16);
        }];
        _bottomLine = bottomLine;
    }
    return _bottomLine;
}

@end
