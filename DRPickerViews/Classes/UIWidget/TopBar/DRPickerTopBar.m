//
//  DRPickerTopBar.m
//  Pickers
//
//  Created by 冯生伟 on 2019/7/30.
//  Copyright © 2019 冯生伟. All rights reserved.
//

#import "DRPickerTopBar.h"
#import <Masonry/Masonry.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import "DRUIWidgetUtil.h"
#import <JXExtension/NSString+JXSize.h>
#import <DRCategories/UIFont+DRExtension.h>

@interface DRPickerTopBar ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *centerButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightButtonWidth;

@end

@implementation DRPickerTopBar

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.containerView.backgroundColor = backgroundColor;
    self.leftButton.backgroundColor = backgroundColor;
    self.centerButton.backgroundColor = backgroundColor;
    self.rightButton.backgroundColor = backgroundColor;
}

- (void)setShowBottomLine:(BOOL)showBottomLine {
    self.bottomLine.hidden = !showBottomLine;
}

#pragma mark - left button
- (void)setLeftButtonTitle:(NSString *)leftButtonTitle {
    _leftButtonTitle = leftButtonTitle;
    [UIView performWithoutAnimation:^{
        [self.leftButton setTitle:leftButtonTitle forState:UIControlStateNormal];
        [self.leftButton layoutIfNeeded];
    }];
    if (leftButtonTitle.length > 0) {
        self.leftButtonImage = nil;
        CGFloat width = [leftButtonTitle jx_widthWithFont:[UIFont dr_PingFangSC_MediumWithSize:15]
                                      constrainedToHeight:16] + 20;
        if (width < 90) {
            width = 90;
        }
        self.leftButtonWidth.constant = width;
    } else {
        self.leftButtonWidth.constant = 90;
    }
}

- (void)setLeftButtonImage:(UIImage *)leftButtonImage {
    _leftButtonImage = leftButtonImage;
    [UIView performWithoutAnimation:^{
        [self.leftButton setImage:leftButtonImage forState:UIControlStateNormal];
        [self.leftButton layoutIfNeeded];
    }];
    if (leftButtonImage != nil) {
        self.leftButtonTitle = nil;
    }
}

- (void)setLeftButtonActionBlock:(DRPickerTopBarActionBlock)leftButtonActionBlock {
    _leftButtonActionBlock = leftButtonActionBlock;
    if (leftButtonActionBlock) {
        self.leftButton.hidden = NO;
    } else {
        self.leftButton.hidden = YES;
    }
}

- (void)setLeftButtonTintColor:(UIColor *)leftButtonTintColor {
    [self.leftButton setTitleColor:leftButtonTintColor
                          forState:UIControlStateNormal];
    [self.leftButton setTintColor:leftButtonTintColor];
}

#pragma mark - center button
- (void)setCenterButtonTitle:(NSString *)centerButtonTitle {
    _centerButtonTitle = centerButtonTitle;
    [UIView performWithoutAnimation:^{
        [self.centerButton setTitle:centerButtonTitle forState:UIControlStateNormal];
        [self.leftButton layoutIfNeeded];
    }];
    if (centerButtonTitle.length) {
        self.centerButton.hidden = NO;
    } else {
        self.centerButton.hidden = YES;
    }
}

- (void)setCenterButtonActionBlock:(DRPickerTopBarActionBlock)centerButtonActionBlock {
    _centerButtonActionBlock = centerButtonActionBlock;
    if (centerButtonActionBlock) {
        self.centerButton.enabled = YES;
    } else {
        self.centerButton.enabled = NO;
    }
}

#pragma mark - right button
- (BOOL)rightButtonEnble {
    return self.rightButton.enabled;
}

- (void)setRightButtonEnble:(BOOL)rightButtonEnble {
    self.rightButton.enabled = rightButtonEnble;
}

- (void)setRightButtonTitle:(NSString *)rightButtonTitle {
    [self.rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];
    if (rightButtonTitle.length > 0) {
        self.leftButtonImage = nil;
        CGFloat width = [rightButtonTitle jx_widthWithFont:[UIFont dr_PingFangSC_MediumWithSize:15]
                                      constrainedToHeight:16] + 20;
        if (width < 90) {
            width = 90;
        }
        self.rightButtonWidth.constant = width;
    } else {
        self.rightButtonWidth.constant = 90;
    }
}

#pragma mark - action
- (IBAction)leftButtonAction:(UIButton *)sender {
    kDR_SAFE_BLOCK(self.leftButtonActionBlock, self, sender);
}

- (IBAction)centerButtonAction:(UIButton *)sender {
    kDR_SAFE_BLOCK(self.centerButtonActionBlock, self, sender);
}

- (IBAction)rightButtonAction:(UIButton *)sender {
    kDR_SAFE_BLOCK(self.rightButtonActionBlock, self, sender);
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
        
        [self.leftButton setTitleColor:[DRUIWidgetUtil cancelColor]
                              forState:UIControlStateNormal];
        [self.leftButton setTintColor:[DRUIWidgetUtil cancelColor]];
        [self.leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        self.leftButton.hidden = YES;
        
        [self.centerButton setTitleColor:[DRUIWidgetUtil highlightColor]
                                forState:UIControlStateNormal];
        [self.centerButton setTitleColor:[DRUIWidgetUtil normalColor]
                                forState:UIControlStateDisabled];
        self.centerButton.hidden = YES;
        
        [self.rightButton setTitleColor:[DRUIWidgetUtil highlightColor]
                               forState:UIControlStateNormal];
        [self.rightButton setTitleColor:[DRUIWidgetUtil disableColor]
                               forState:UIControlStateDisabled];
        [self.rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
}

@end
