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


@end

@implementation DROptionCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.titleLabel.layer.borderWidth = 0.5;
        self.titleLabel.layer.cornerRadius = 6;
        self.titleLabel.layer.masksToBounds = YES;
    });
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    [self refresh];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self refresh];
}

- (void)refresh {
    if (self.selected) {
        self.titleLabel.layer.borderColor = [DRUIWidgetUtil highlightColor].CGColor;
        self.titleLabel.textColor = [DRUIWidgetUtil highlightColor];
        self.titleLabel.font = [UIFont dr_PingFangSC_MediumWithSize:self.fontSize];
    } else {
        self.titleLabel.layer.borderColor = [DRUIWidgetUtil borderColor].CGColor;
        self.titleLabel.textColor = [DRUIWidgetUtil normalColor];
        self.titleLabel.font = [UIFont dr_PingFangSC_RegularWithSize:self.fontSize];
    }
}

@end
