//
//  JXInteractiveTransition.m
//  JXExtension
//
//  Created by Jeason on 2018/5/3.
//  Copyright © 2018年 Jeason.Lee. All rights reserved.
//

#import "JXInteractiveTransition.h"
#import "JXDirectionPanGestureRecognizer.h"
#import <objc/runtime.h>

static const CGFloat JXInteractiveTransitionMinPercent = 0.3;

typedef struct {
    unsigned int willBegin :      1;
    unsigned int isUpdating :     1;
    unsigned int willBeginTimer : 1;
    unsigned int willEnd :        1;
} JXDelegateFlag;

@interface JXInteractiveTransition ()

@property (nonatomic, assign, readwrite) BOOL isInteractive;
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) JXDirectionPanGestureRecognizer *panGesture;
@property (nonatomic, assign) JXInteractiveType type;
@property (nonatomic, assign) JXDelegateFlag delegateFlag;
@property (nonatomic, assign) CGFloat percent;
@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic, assign) CGFloat timeDis;

@end

@implementation JXInteractiveTransition

- (instancetype)initWithType:(JXInteractiveType)type {
    self = [super init];
    if (self) {
        _type = type;
        _minPersent = JXInteractiveTransitionMinPercent;
    }
    return self;
}

- (void)addPanGestureForView:(UIView *)view {
    self.panGesture = [[JXDirectionPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    self.panGesture.disableScope = self.disableScope;
    [view addGestureRecognizer:self.panGesture];
}

- (void)panGestureAction:(JXDirectionPanGestureRecognizer *)panGesture {
    JXAnimatorDirection toDirection = panGesture.direction;
    JXAnimatorDirection backDirection = [self _oppositeDirection:toDirection];
    if (!(self.enadleDirection & toDirection) || (toDirection == JXAnimatorDirectionNone)) {
        //不是设定的方向 或 滑动没有方向
        self.panGesture.direction = JXAnimatorDirectionNone;
        return;
    }
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan: {
            if (_delegateFlag.willBegin) {
                [_delegate jx_interactiveTransitionWillBegin:self];
            }
            _direction = [JXInteractiveDirection directionWithTo:toDirection back:backDirection];
            self.isInteractive = YES;
            self.configBlock ? self.configBlock(_direction) : nil;
            [self _jx_caculateMovePercentForGesture:panGesture];
        } break;
        case UIGestureRecognizerStateChanged: {
            [self _jx_caculateMovePercentForGesture:panGesture];
            [self _jx_updating];
        } break;
        case UIGestureRecognizerStateEnded: {
            //判断是否需要timer
            if (!_timerEable) {
                self.percent >= 0.5 ? [self _jx_finish] : [self _jx_cancle];
                return;
            }
            //判断此时是否已经转场完成，大于1或者小于0
            BOOL canEnd = [self _jx_canEndInteractiveTransitionWithPercent:self.percent];
            if (canEnd) return;
            //开启timer
            [self _jx_setEndAnimationTimerWithPercent:_percent];
        } break;
        default: break;
    }
}

#pragma mark - Private Method

- (void)_jx_caculateMovePercentForGesture:(JXDirectionPanGestureRecognizer *)panGesture {
    static CGFloat baseValue = 0.0f;
    if (self.panRatioBaseValue > 0) {
        baseValue = self.panRatioBaseValue;
    } else {
        CGSize viewSize = panGesture.view.frame.size;
        if (panGesture.direction == JXAnimatorDirectionBottom || panGesture.direction == JXAnimatorDirectionTop) {
            baseValue = viewSize.height;
        } else {
            baseValue = viewSize.width;
        }
    }
    CGPoint translation = [panGesture translationInView:panGesture.view];
    switch (panGesture.direction) {
        case JXAnimatorDirectionLeft:{
            self.percent += -translation.x / baseValue;
        } break;
        case JXAnimatorDirectionRight:{
            self.percent += translation.x / baseValue;
        } break;
        case JXAnimatorDirectionTop:{
            self.percent += -translation.y / baseValue;
        } break;
        case JXAnimatorDirectionBottom:{
            self.percent += translation.y / baseValue;
        } break;
        default: break;
    }
    [panGesture setTranslation:CGPointZero inView:panGesture.view];
}

- (BOOL)_jx_canEndInteractiveTransitionWithPercent:(CGFloat)percent {
    BOOL can = NO;
    if (percent >= 1) {
        [self _jx_finish];
        can = YES;
    }
    if (percent <= 0) {
        [self _jx_cancle];
        can = YES;
    }
    return can;
}

- (void)_jx_updating {
    CGFloat percent = _percent;
    if (percent < 0) {
        percent = 0;
    } else if (percent > 1) {
        percent = 1;
    }
    [self updateInteractiveTransition:percent < 0 ? CGFLOAT_MIN : percent];
    if (_delegateFlag.isUpdating) {
        [_delegate jx_interactiveTransition:self isUpdating:percent];
    }
}

- (void)_jx_finish {
    if (_delegateFlag.willEnd) {
        [_delegate jx_interactiveTransition:self willEndWithSuccessFlag:YES percent:_percent];
    }
    [self finishInteractiveTransition];
    self.percent = 0.0;
    self.isInteractive = NO;
    self.panGesture.direction = JXAnimatorDirectionNone;
}

- (void)_jx_cancle {
    if (_delegateFlag.willEnd) {
        [_delegate jx_interactiveTransition:self willEndWithSuccessFlag:NO percent:_percent];
    }
    [self cancelInteractiveTransition];
    self.percent = 0.0;
    self.isInteractive = NO;
    self.panGesture.direction = JXAnimatorDirectionNone;
}

//设置开启timer
- (void)_jx_setEndAnimationTimerWithPercent:(CGFloat)percent {
    _percent = percent;
    //根据失败还是成功设置刷新间隔
    if (percent > _minPersent) {
        _timeDis = (1 - percent) / ((1 - percent) * 30);
    } else {
        _timeDis = percent / (percent * 30);
    }
    if (_delegateFlag.willBeginTimer) {
        [_delegate jx_interactiveTransitionWillBeginTimerAnimation:self];
    }
    //开启timer
    [self _jx_startTimer];
}

- (void)_jx_startTimer {
    if (_timer) {
        return;
    }
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(_jx_timerEvent)];
    [_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)_jx_stopTimer {
    if (!_timer) {
        return;
    }
    [_timer invalidate];
    _timer = nil;
}

//timer事件
- (void)_jx_timerEvent {
    if (_percent > _minPersent) {
        _percent += _timeDis;
    }else{
        _percent -= _timeDis;
    }
    //通过timer不断刷新转场进度
    [self _jx_updating];
    BOOL canEnd = [self _jx_canEndInteractiveTransitionWithPercent:_percent];
    if (canEnd) {
        [self _jx_stopTimer];
    }
}

//反向手势
- (JXAnimatorDirection)_oppositeDirection:(JXAnimatorDirection)direction {
    switch (direction) {
        case JXAnimatorDirectionLeft:
            return JXAnimatorDirectionRight;
        case JXAnimatorDirectionRight:
            return JXAnimatorDirectionLeft;
        case JXAnimatorDirectionTop:
            return JXAnimatorDirectionBottom;
        case JXAnimatorDirectionBottom:
            return JXAnimatorDirectionTop;
        default:
            return JXAnimatorDirectionNone;
    }
}

#pragma mark - Property Method

- (void)setDelegate:(id<JXInteractiveTransitionDelegate>)delegate {
    _delegate = delegate;
    _delegateFlag.willBegin = delegate && [delegate respondsToSelector:@selector(jx_interactiveTransitionWillBegin:)];
    _delegateFlag.isUpdating = delegate && [delegate respondsToSelector:@selector(jx_interactiveTransition:isUpdating:)];
    _delegateFlag.willBeginTimer = delegate && [delegate respondsToSelector:@selector(jx_interactiveTransitionWillBeginTimerAnimation:)];
    _delegateFlag.willEnd = delegate && [delegate respondsToSelector:@selector(jx_interactiveTransition:willEndWithSuccessFlag:percent:)];
}

@end
