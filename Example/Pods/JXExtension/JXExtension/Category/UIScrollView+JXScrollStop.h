//
//  UIScrollView+JXScrollStop.h
//  JXExtension
//
//  Created by Jeason on 12/7/2018.
//  Copyright © 2018年 Jeason.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JXScrollStopBlock)(void);

@interface UIScrollView (JXScrollStop)

//是否允许hook方法
@property (nonatomic, assign) BOOL jx_needHook;
//滑动停止回调
@property (nonatomic, copy) JXScrollStopBlock jx_scrollStopBlock;

@end
