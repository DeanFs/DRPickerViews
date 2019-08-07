//
//  DROptionCardCell.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/7/31.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DROptionCardCell.h"
#import "DRUIWidgetUtil.h"
#import <DRCategories/UIFont+DRExtension.h>

@interface DROptionCardCell ()

@property (weak, nonatomic) IBOutlet UIButton *titleButton;


@end

@implementation DROptionCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleButton.layer.borderWidth = 0.5;
    self.titleButton.layer.cornerRadius = 6;
    self.titleButton.layer.masksToBounds = YES;
    _itemCornerRadius = 6;
    _fontSize = 13;
}

- (void)setFontSize:(CGFloat)fontSize {
    if (fontSize != _fontSize) {
        _fontSize = fontSize;
        self.titleButton.titleLabel.font = [UIFont dr_PingFangSC_RegularWithSize:fontSize];
    }
}

- (void)setItemCornerRadius:(CGFloat)itemCornerRadius {
    if (itemCornerRadius != _itemCornerRadius) {
        _itemCornerRadius = itemCornerRadius;
        self.titleButton.layer.cornerRadius = itemCornerRadius;
    }
}

- (void)setTitle:(NSString *)title {
    [UIView performWithoutAnimation:^{
        [self.titleButton setTitle:title forState:UIControlStateNormal];
    }];
    [self refresh];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self refresh];
}

- (void)refresh {
    [UIView performWithoutAnimation:^{
        self.titleButton.selected = self.selected;
        if (self.selected) {
            self.titleButton.layer.borderColor = [DRUIWidgetUtil highlightColor].CGColor;
        } else {
            self.titleButton.layer.borderColor = [DRUIWidgetUtil borderColor].CGColor;
        }
    }];
}

@end
