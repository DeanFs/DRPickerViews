//
//  DRLunarYearView.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/4.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRLunarYearView.h"

@interface DRLunarYearView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@end

@implementation DRLunarYearView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setupName:(NSString *)name year:(NSInteger)year {
    self.nameLabel.text = name;
    self.yearLabel.text = [NSString stringWithFormat:@"%ld", year];
}

- (void)setTextColor:(UIColor *)textColor {
    self.nameLabel.textColor = textColor;
    self.yearLabel.textColor = textColor;
}

- (void)setLunarTextFont:(UIFont *)lunarTextFont {
    _lunarTextFont = lunarTextFont;
    self.nameLabel.font = lunarTextFont;
}

- (void)setYearTextFont:(UIFont *)yearTextFont {
    _yearTextFont = yearTextFont;
    self.yearLabel.font = yearTextFont;
}

@end
