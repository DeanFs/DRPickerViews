
//
//  DRWaveView.m
//  DRUIWidget_Example
//
//  Created by Cyfuer on 2019/10/9.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRWaveView.h"
#import "SCSiriWaveformView.h"
#import <Masonry/Masonry.h>

@interface DRWaveView ()
/**
 波视图
 */
@property (nonatomic, strong) SCSiriWaveformView * waveView;
@end

@implementation DRWaveView

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
    self.waveView.backgroundColor = [UIColor clearColor];
    self.waveView.numberOfWaves = 17;
    self.waveView.waveColor = [UIColor whiteColor];
    self.waveView.primaryWaveLineWidth = 1;
    self.waveView.frequency = 1;
    
    [self addSubview:self.waveView];
    [self.waveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)updateWithLevel:(CGFloat)level {
    [self.waveView updateWithLevel:level];
}

- (void)setWaveColor:(UIColor *)waveColor {
    _waveColor = waveColor;
    self.waveView.waveColor = _waveColor;
}
- (void)setNumberOfWaves:(NSUInteger)numberOfWaves {
    _numberOfWaves = numberOfWaves;
    self.waveView.numberOfWaves = _numberOfWaves;
}


- (SCSiriWaveformView *)waveView {
    if (!_waveView) {
        _waveView = [[SCSiriWaveformView alloc] init];
    }
    return _waveView;
}

@end
