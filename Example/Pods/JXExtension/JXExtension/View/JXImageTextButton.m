//
//  JXImageTextButton.m
//  JXExtension
//
//  Created by Jeason on 2017/8/21.
//  Copyright © 2017年 Jeason.Lee. All rights reserved.
//

#import "JXImageTextButton.h"
#import "UIView+JXFrame.h"

@interface JXImageTextButton ()

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation JXImageTextButton

@synthesize leftNormalStateImage = _leftNormalStateImage;
@synthesize leftHighlightedStateImage = _leftHighlightedStateImage;
@synthesize rightNormalStateImage = _rightNormalStateImage;
@synthesize rightHighlightedStateImage = _rightHighlightedStateImage;

#pragma mark - LifeCycle

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.leftImageView setJx_centerY:CGRectGetHeight(self.frame) / 2.0];
    [self addSubview:self.leftImageView];
    [self.rightImageView setJx_centerY:CGRectGetHeight(self.frame) / 2.0];
    [self addSubview:self.rightImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGRectGetWidth(self.titleLabel.frame) > ((CGRectGetWidth(self.frame) - CGRectGetWidth(self.leftImageView.frame) - CGRectGetWidth(self.rightImageView.frame) - self.space * 4))) {
        [self.titleLabel setJx_width:CGRectGetWidth(self.frame) - CGRectGetWidth(self.leftImageView.frame) - CGRectGetWidth(self.rightImageView.frame) - self.space * 4];
        [self.leftImageView setJx_x:self.space];
        [self.rightImageView setJx_x:CGRectGetWidth(self.frame) - CGRectGetWidth(self.rightImageView.frame) - self.space];
    } else {
        [self.leftImageView setJx_x:CGRectGetMinX(self.titleLabel.frame) - CGRectGetWidth(self.leftImageView.frame) - self.space];
        [self.rightImageView setJx_x:CGRectGetMaxX(self.titleLabel.frame) + self.space];
    }
    [self.titleLabel setJx_centerX:CGRectGetWidth(self.frame) / 2.0];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.leftImageView.highlighted = selected;
    self.rightImageView.highlighted = selected;
}

#pragma mark - Property method

- (UIImageView *)leftImageView {
    if (_leftImageView == nil) {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView {
    if (_rightImageView == nil) {
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}

- (UIImage *)leftNormalStateImage {
    return self.leftImageView.image;
}

- (void)setLeftNormalStateImage:(UIImage *)leftNormalStateImage {
    self.leftImageView.image = leftNormalStateImage;
    [self.leftImageView sizeToFit];
}

- (UIImage *)leftHighlightedStateImage {
    return self.leftImageView.highlightedImage;
}

- (void)setLeftHighlightedStateImage:(UIImage *)leftHighlightedStateImage {
    self.leftImageView.highlightedImage = leftHighlightedStateImage;
    [self.leftImageView sizeToFit];
}

- (UIImage *)rightNormalStateImage {
    return self.rightImageView.image;
}

- (void)setRightNormalStateImage:(UIImage *)rightNormalStateImage {
    self.rightImageView.image = rightNormalStateImage;
    [self.rightImageView sizeToFit];
}

- (UIImage *)rightHighlightedStateImage {
    return self.rightImageView.highlightedImage;
}

- (void)setRightHighlightedStateImage:(UIImage *)rightHighlightedStateImage {
    self.rightImageView.highlightedImage = rightHighlightedStateImage;
    [self.rightImageView sizeToFit];
}

@end
