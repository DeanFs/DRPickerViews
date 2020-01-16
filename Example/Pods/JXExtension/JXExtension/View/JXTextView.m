//
//  JXTextView.m
//  JXExtension
//
//  Created by Jeason on 2017/6/15.
//  Copyright © 2017年 JeasonLee. All rights reserved.
//

#import "JXTextView.h"

@interface JXTextView()

@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) CGFloat currentHeight;

@end

@implementation JXTextView

@synthesize placeholder = _placeholder;
@synthesize placeholderColor = _placeholderColor;

#pragma mark - LifeCycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.text.length == 0 && self.placeholder.length > 0) {
        [self.placeHolderLabel setAlpha:1];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setup {
    self.enablesReturnKeyAutomatically = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

#pragma mark - Event Response

- (void)textChanged:(NSNotification *)notification {
    if (self.placeholder.length == 0) {
        return;
    }
    if (self.text.length == 0) {
        [self.placeHolderLabel setAlpha:1];
    } else {
        [self.placeHolderLabel setAlpha:0];
    }
    
    if (self.changeBlcok) {
        CGFloat height = ceil([self.text boundingRectWithSize:CGSizeMake(self.bounds.size.width - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.font} context:nil].size.height);
        height = height + self.textContainerInset.top + self.textContainerInset.bottom;
        if (self.currentHeight != height) {
            self.currentHeight = height;
            self.scrollEnabled = height > self.maxHeight && self.maxHeight > 0;
            if (!self.scrollEnabled) {
                self.changeBlcok(self.text, height);
            }
        }
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

#pragma mark - Property method

- (void)setMasksToBounds:(BOOL)masksToBounds {
    self.layer.masksToBounds = masksToBounds;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (NSString *)placeholder {
    return _placeholder;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder.copy;
    self.placeHolderLabel.text = placeholder;
}

- (UIColor *)placeholderColor {
    if (_placeholderColor == nil) {
        _placeholderColor = [UIColor lightGrayColor];
    }
    return _placeholderColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeHolderLabel.textColor = placeholderColor;
}

- (UILabel *)placeHolderLabel {
    UIEdgeInsets insets = self.textContainerInset;
    if (_placeHolderLabel == nil && self.placeholder.length > 0) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeHolderLabel.font = self.font;
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.textColor = self.placeholderColor;
        _placeHolderLabel.alpha = 0;
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_placeHolderLabel];
        [self sendSubviewToBack:_placeHolderLabel];
        CGFloat width = CGRectGetWidth(self.bounds) - (insets.left + insets.right + 10);
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:_placeHolderLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:insets.left + 5];
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_placeHolderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:insets.top];
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_placeHolderLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:width];
        NSArray *constraintArray = @[leftConstraint, topConstraint, widthConstraint];
        [self addConstraints:constraintArray];
    }
    return _placeHolderLabel;
}

- (void)setIsFixed:(BOOL)isFixed {
    _isFixed = isFixed;
    self.scrollEnabled = !isFixed;
    self.scrollsToTop = !isFixed;
    self.showsHorizontalScrollIndicator = !isFixed;
}

@end
