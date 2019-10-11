//
//  DRSectionTitleView.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/7/31.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRSectionTitleView.h"
#import <Masonry/Masonry.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import "DRUIWidgetUtil.h"

@interface DRSectionTitleView ()

@property (weak, nonatomic) UILabel *titleLabel;

@end

@implementation DRSectionTitleView

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setFontSize:(CGFloat)fontSize {
    self.titleLabel.font = [UIFont dr_PingFangSC_RegularWithSize:fontSize];
}

- (void)setTextColor:(UIColor *)textColor {
    self.titleLabel.textColor = textColor;
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
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [DRUIWidgetUtil descColor];
    label.font = [UIFont dr_PingFangSC_RegularWithSize:13];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(0);
        make.centerY.mas_offset(0);
    }];
    self.titleLabel = label;
}

@end
