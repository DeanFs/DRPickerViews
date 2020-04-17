//
//  DRPageTemplateCell.m
//  DRUIWidget_Example
//
//  Created by Cyfuer on 2019/10/9.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRPageTemplateCell.h"

@interface DRPageTemplateCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation DRPageTemplateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}


- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}
@end
