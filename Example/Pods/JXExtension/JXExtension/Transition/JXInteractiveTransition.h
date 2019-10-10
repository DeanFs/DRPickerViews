//
//  JXInteractiveTransition.h
//  JXExtension
//
//  Created by Jeason on 2018/5/3.
//  Copyright © 2018年 Jeason.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXInteractiveDirection.h"

@class JXInteractiveTransition, JXInteractiveDirection;

//手势控制转场方式
typedef NS_ENUM(NSUInteger, JXInteractiveType) {
    JXInteractiveTypePresent = 0,
    JXInteractiveTypeDismiss,
};

typedef void(^JXInteractiveGestureDirectionBlock)(JXInteractiveDirection *direction);

@protocol JXInteractiveTransitionDelegate <NSObject>
// 手势转场时的代理事件，animator默认为为其手势的代理，复写对应的代理事件可处理一些手势失败闪烁的情况
@optional
//手势转场即将开始时调用
- (void)jx_interactiveTransitionWillBegin:(JXInteractiveTransition *)interactiveTransition;
//手势转场中调用
- (void)jx_interactiveTransition:(JXInteractiveTransition *)interactiveTransition isUpdating:(CGFloat)percent;
//如果开始了转场手势timer，会在松开手指，timer开始的时候调用
- (void)jx_interactiveTransitionWillBeginTimerAnimation:(JXInteractiveTransition *)interactiveTransition;
//手势转场结束的时候调用
- (void)jx_interactiveTransition:(JXInteractiveTransition *)interactiveTransition willEndWithSuccessFlag:(BOOL)flag percent:(CGFloat)percent;

@end

@interface JXInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) CGRect disableScope; //禁止响应区域
@property (nonatomic, assign, readonly) BOOL isInteractive; //记录是否开始手势
@property (nonatomic, assign) CGFloat minPersent; //转场需要的最小百分比, 默认0.3
@property (nonatomic, assign) CGFloat panRatioBaseValue; //修改此值可改变滑动手势的速率
@property (nonatomic, assign) BOOL timerEable; //定时器开关，手势交互过程中松手增加定时器动画
@property (nonatomic, assign) JXAnimatorDirection enadleDirection; //允许手势交互方向
@property (nonatomic, strong, readonly)JXInteractiveDirection *direction; //手势方向
@property (nonatomic, copy) JXInteractiveGestureDirectionBlock configBlock; //过渡回调
@property (nonatomic, weak) id <JXInteractiveTransitionDelegate> delegate;

- (instancetype)initWithType:(JXInteractiveType)type;
- (void)addPanGestureForView:(UIView *)view;

@end
