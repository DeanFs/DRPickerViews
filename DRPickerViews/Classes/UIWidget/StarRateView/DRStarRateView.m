
//
//  DRStarRateView.m
//  XHStarRateView
//
//  Created by Cyfuer on 2019/10/8.
//  Copyright © 2019 duorong. All rights reserved.
//

#import "DRStarRateView.h"


static NSString *const KForegroundStarImage = @"icon_star_yellow@2x.png";
static NSString *const KBackgroundStarImage = @"icon_star_gray@2x.png";

@interface DRStarRateView()

@property (nonatomic, strong) UIView *foregroundStarView;
@property (nonatomic, strong) UIView *backgroundStarView;
@property (nonatomic, assign) BOOL isAnimation;                 // 是否动画显示，默认 NO

@end

@implementation DRStarRateView

#pragma mark - Init Method

- (instancetype)init {
    if (self = [super init]) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    _numberOfStar       = 5;
    _rateStyle          = DRStarRateViewRateStyeHalfStar;
    _isAnimation        = YES;
    _editable           = YES;
    
    [self createStarView];
}


- (void)setupNumberOfStar:(NSInteger)numberOfStar currentrating:(CGFloat)currentRating completion:(DRStarRateViewRateCompletionBlock)completionBlock {
    _numberOfStar = numberOfStar;
    _currentRating = currentRating;
    self.completionBlock = completionBlock;
    [self createStarView];
}

- (void)dealloc {
    self.completionBlock = nil;
}

#pragma mark - 布局调整

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(self.backgroundStarView.frame, self.bounds)) {
        // 更新布局信息
        [self updateImageViewsLayout];
    }
    
    CGFloat animationDuration = (self.isAnimation ? 0.2 : 0);
    [UIView animateWithDuration:animationDuration animations:^{
        self.foregroundStarView.frame = CGRectMake(0, 0, self.bounds.size.width / self.numberOfStar * self.currentRating, self.bounds.size.height);
    }];
}


#pragma mark - Private Method

- (void)createStarView {
    if (self.foregroundStarView.superview) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.foregroundStarView = nil;
        self.backgroundStarView = nil;
    }
    
    self.foregroundStarView = [self createStarViewWithImage:self.highlightImage ?: [self bundleImageForName:KForegroundStarImage]];
    self.backgroundStarView = [self createStarViewWithImage:self.normalImage ?: [self bundleImageForName:KBackgroundStarImage]];
    
    NSAssert(_numberOfStar != 0, @"The Value Of Rate Star should not be Zero");
    self.foregroundStarView.frame = CGRectMake(0, 0, self.bounds.size.width * _currentRating / _numberOfStar, self.bounds.size.height);
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
}

/**
 获取bundle中的图片资源
 */
- (UIImage *)bundleImageForName:(NSString *)imageName {
    
    NSBundle *currentBundle = [NSBundle bundleForClass:self.class];
    NSString *path = [currentBundle pathForResource:imageName ofType:nil];  // 目录名称
    return [UIImage imageWithContentsOfFile:path];
}

/**
 资源创建
 */
- (UIView *)createStarViewWithImage:(UIImage *)image {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    
    NSAssert(_numberOfStar != 0, @"The Value Of Rate Star should not be Zero");

    @autoreleasepool {
        for (NSInteger i = 0; i < _numberOfStar; i ++) {
            @autoreleasepool {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                float starWidth = self.bounds.size.width / _numberOfStar;
                float starHeigh = self.bounds.size.height;
                imageView.frame = CGRectMake(i * starWidth, 0, starWidth, starHeigh);
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                [view addSubview:imageView];
            }
        }
    }
    
    return view;
}

#pragma mark - 更新UI信息
- (void)updateImageViewsLayout {
  
    self.foregroundStarView.frame = self.bounds;
    self.backgroundStarView.frame = self.bounds;
    
    for (int i = 0; i < self.backgroundStarView.subviews.count; i++) {
        UIView *subView = self.backgroundStarView.subviews[i];
        float starWidth = self.bounds.size.width / _numberOfStar;
        float starHeigh = self.bounds.size.height;
        subView.frame = CGRectMake(i * starWidth, 0, starWidth, starHeigh);
    }
    
    for (int i = 0; i < self.foregroundStarView.subviews.count; i++) {
           UIView *subView = self.foregroundStarView.subviews[i];
           float starWidth = self.bounds.size.width / _numberOfStar;
           float starHeigh = self.bounds.size.height;
           subView.frame = CGRectMake(i * starWidth, 0, starWidth, starHeigh);
    }
}

- (void)updateNormalImageViews {
    for (int i = 0; i < self.backgroundStarView.subviews.count; i++) {
          UIImageView *subView = self.backgroundStarView.subviews[i];
        if (![subView isKindOfClass:[UIImageView class]]) return;
        subView.image = self.normalImage;
    }
}

- (void)updateHighlightImageViews {
    for (int i = 0; i < self.foregroundStarView.subviews.count; i++) {
            UIImageView *subView = self.foregroundStarView.subviews[i];
          if (![subView isKindOfClass:[UIImageView class]]) return;
          subView.image = self.highlightImage;
    }
}


#pragma mark - 事件处理

- (void)userTapRateView:(UITapGestureRecognizer *)gesture {
    if (!self.editable) return; // 不允许更改的话
    
    CGPoint tapPoint = [gesture locationInView:self];
    CGFloat offset = tapPoint.x;
    CGFloat realRating = offset / (self.bounds.size.width / _numberOfStar);

    switch (_rateStyle) {
        case DRStarRateViewRateStyeFullStar: {
            self.currentRating = ceilf(realRating);
            break;
        }
        case DRStarRateViewRateStyeHalfStar: {
            float round = roundf(realRating);
            if (round == 0 && realRating < 0.2f && self.zeroRateEnable) {
                self.currentRating = 0.0;
            } else {
                self.currentRating = (round > realRating) ? round : (round + 0.5);
            }
            break;
        }
        case DRStarRateViewRateStyeIncompleteStar: {
            self.currentRating = realRating;
            break;
        }
    }
}


#pragma mark - setter & getter

- (void)setCurrentRating:(CGFloat)currentRating {
    if (_currentRating == currentRating) {
        return;
    }
    if (currentRating < 0) {
        _currentRating = 0;
    } else if (currentRating > _numberOfStar) {
        _currentRating = _numberOfStar;
    } else {
        _currentRating = currentRating;
    }
    
    if (self.completionBlock) {
        _completionBlock(_currentRating);
    }
    [self setNeedsLayout];
}


- (void)setNormalImage:(UIImage *)normalImage {
    _normalImage = normalImage;
    [self updateNormalImageViews];
}

- (void)setHighlightImage:(UIImage *)highlightImage {
    _highlightImage = highlightImage;
    [self updateHighlightImageViews];
}

- (void)setNumberOfStar:(NSUInteger)numberOfStar
{
    _numberOfStar = numberOfStar;
    [self createStarView];
}

@end
