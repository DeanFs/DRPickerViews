//
//  JXDirectionPanGestureRecognizer.m
//  JXExtension
//
//  Created by Jeason on 2018/5/30.
//  Copyright © 2018年 Jeason.Lee. All rights reserved.
//

#import "JXDirectionPanGestureRecognizer.h"

static const NSInteger JXDirectionPanThreshold = 5;

@implementation JXDirectionPanGestureRecognizer {
    int _moveX;
    int _moveY;
}

@synthesize direction = _direction;

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.direction != JXAnimatorDirectionNone) return;
    self.direction = [self determineDirectionIfNeeded:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    _moveX = 0;
    _moveY = 0;
}

//确定滑动的方向
- (JXAnimatorDirection)determineDirectionIfNeeded:(NSSet *)touches {
    if (self.direction == JXAnimatorDirectionNone) {
        CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
        BOOL inDisableScope = CGRectContainsPoint(self.disableScope, nowPoint);
        if (inDisableScope) {
            return JXAnimatorDirectionNone;
        } else {
            CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
            _moveX += prevPoint.x - nowPoint.x;
            _moveY += prevPoint.y - nowPoint.y;
            if (abs(_moveX) > JXDirectionPanThreshold) {
                if (_moveX > 0) { //向左滑动
                    return JXAnimatorDirectionLeft;
                } else { //向右滑动
                    return JXAnimatorDirectionRight;
                }
            } else if (abs(_moveY) > JXDirectionPanThreshold) {
                if (_moveY > 0) { //向上滑动
                    return JXAnimatorDirectionTop;
                } else { //向下滑动
                    return JXAnimatorDirectionBottom;
                }
            }
        }
    }
    return self.direction;
}

- (void)reset {
    [super reset];
    _moveX = 0;
    _moveY = 0;
}

@end
