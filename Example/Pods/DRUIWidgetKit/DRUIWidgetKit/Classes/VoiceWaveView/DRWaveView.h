//
//  DRWaveView.h
//  DRUIWidget_Example
//
//  Created by Cyfuer on 2019/10/9.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>

// 对SCSiriWaveFormView进行一次封装，精简使用流程

IB_DESIGNABLE
@interface DRWaveView : UIView

/*
 * 冲毁展示幅度，level越大展示波动也就越大，需要通过计时器来进行操作处理展示
 */
-(void)updateWithLevel:(CGFloat)level;

/*
 * 波的数量，默认17
 */
@property (nonatomic, assign) IBInspectable NSUInteger numberOfWaves;

/*
 * 波线条的颜色展示
 * Default: white
 */
@property (nonatomic, strong) IBInspectable UIColor *waveColor;
@end
