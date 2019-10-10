//
//  JXDirectionPanGestureRecognizer.h
//  JXExtension
//
//  Created by Jeason on 2018/5/30.
//  Copyright © 2018年 Jeason.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "JXTransitionConstant.h"

@interface JXDirectionPanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, assign) JXAnimatorDirection direction; //手势滑动的方向
@property (nonatomic, assign) CGRect disableScope; //禁止响应区域

@end
