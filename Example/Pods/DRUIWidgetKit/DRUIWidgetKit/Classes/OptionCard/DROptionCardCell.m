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

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation DROptionCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.layer.borderWidth = 0.5;
    self.titleLabel.layer.cornerRadius = 6;
    self.titleLabel.layer.masksToBounds = YES;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    [self refresh];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self refresh];
}

- (void)setItemFace:(NSInteger)itemFace {
    _itemFace = itemFace;
    [self refresh];
}

- (void)setItemCornerRadius:(CGFloat)itemCornerRadius {
    _itemCornerRadius = itemCornerRadius;
    self.titleLabel.layer.cornerRadius = itemCornerRadius;
    [self refresh];
}

- (void)refresh {
    if (self.itemFace == 0) { // DROptionCardViewItemFaceBorder
        if (self.selected) {
            self.titleLabel.layer.borderColor = [DRUIWidgetUtil highlightColor].CGColor;
            self.titleLabel.textColor = [DRUIWidgetUtil highlightColor];
            self.titleLabel.font = [UIFont dr_PingFangSC_MediumWithSize:self.fontSize];
        } else {
            self.titleLabel.layer.borderColor = [DRUIWidgetUtil borderColor].CGColor;
            self.titleLabel.textColor = [DRUIWidgetUtil normalColor];
            self.titleLabel.font = [UIFont dr_PingFangSC_RegularWithSize:self.fontSize];
        }
    } else if (self.itemFace == 1) { // DROptionCardViewItemFaceGradient
        self.titleLabel.font = [UIFont dr_PingFangSC_RegularWithSize:self.fontSize];
        if (self.selected) {
            self.titleLabel.layer.borderColor = [UIColor clearColor].CGColor;
            self.titleLabel.textColor = [UIColor whiteColor];
            self.gradientLayer.hidden = NO;
        } else {
            self.titleLabel.layer.borderColor = [DRUIWidgetUtil borderColor].CGColor;
            self.titleLabel.textColor = [DRUIWidgetUtil descColor];
            self.gradientLayer.hidden = YES;
        }
        if (!self.gradientLayer.superlayer) {
            [self.layer insertSublayer:self.gradientLayer atIndex:0];
        }
        self.gradientLayer.frame = CGRectMake(0, 0, self.itemSize.width, self.itemSize.height);
        self.gradientLayer.cornerRadius = self.itemCornerRadius;
    }
    self.titleLabel.layer.cornerRadius = self.itemCornerRadius;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        CAGradientLayer *layer = [[CAGradientLayer alloc] init];
        layer.colors = @[(__bridge id)[DRUIWidgetUtil gradientLightColor].CGColor,
                         (__bridge id)[DRUIWidgetUtil gradientDarkColor].CGColor];
        layer.startPoint = CGPointMake(0, 0);
        layer.endPoint = CGPointMake(1, 1);
        _gradientLayer = layer;
    }
    return _gradientLayer;
}

@end
