//
//  UIScrollView+JXScrollStop.m
//  JXExtension
//
//  Created by Jeason on 12/7/2018.
//  Copyright © 2018年 Jeason.Lee. All rights reserved.
//
//  参考：https://www.jianshu.com/p/13d49a364357

#import "UIScrollView+JXScrollStop.h"
#import <objc/runtime.h>

static void *kJXScrollStopNeedHookKey;
static void *kJXScrollStopBlockKey;

@implementation UIScrollView (JXScrollStop)

+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod([UIScrollView class], @selector(setDelegate:));
        Method replaceMethod = class_getInstanceMethod([UIScrollView class], @selector(jx_hook_setDelegate:));
        method_exchangeImplementations(originalMethod, replaceMethod);
    });
}

- (void)jx_hook_setDelegate:(id<UIScrollViewDelegate>)delegate {
    [self jx_hook_setDelegate:delegate];
    if (self.jx_needHook && ([self isMemberOfClass:[UIScrollView class]] || [self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]])) {
        //Hook (scrollViewDidEndDecelerating:) 方法
        JXHookMethod([delegate class], @selector(scrollViewDidEndDecelerating:), [self class], @selector(jx_scrollViewDidEndDecelerating:), @selector(jx_add_scrollViewDidEndDecelerating:));
        //Hook (scrollViewDidEndDragging:willDecelerate:) 方法
        JXHookMethod([delegate class], @selector(scrollViewDidEndDragging:willDecelerate:), [self class], @selector(jx_scrollViewDidEndDragging:willDecelerate:), @selector(jx_add_scrollViewDidEndDragging:willDecelerate:));
        //Hook (scrollViewDidEndScrollingAnimation:) 方法
        JXHookMethod([delegate class], @selector(scrollViewDidEndScrollingAnimation:), [self class], @selector(jx_scrollViewDidEndScrollingAnimation:), @selector(jx_add_scrollViewDidEndScrollingAnimation:));
    } else {
        //        NSLog(@"⚠️不是指定类型，不需要hook方法⚠️");
    }
}

#pragma mark - Replace Method

- (void)jx_scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self jx_scrollViewDidEndDecelerating:scrollView];
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [scrollView jx_scrollStop:scrollView];
    }
}

- (void)jx_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self jx_scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if (!decelerate) {
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            [scrollView jx_scrollStop:scrollView];
        }
    }
}

- (void)jx_scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self jx_scrollViewDidEndScrollingAnimation:scrollView];
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [scrollView jx_scrollStop:scrollView];
    }
}

#pragma mark - Add Method

- (void)jx_add_scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [scrollView jx_scrollStop:scrollView];
    }
}

- (void)jx_add_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            [scrollView jx_scrollStop:scrollView];
        }
    }
}

- (void)jx_add_scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [scrollView jx_scrollStop:scrollView];
    }
}

#pragma mark - Private Method

static void JXHookMethod(Class originalClass, SEL originalSel, Class replacedClass, SEL replacedSel, SEL noneSel) {
    // 原实例方法
    Method originalMethod = class_getInstanceMethod(originalClass, originalSel);
    // 替换的实例方法
    Method replaceMethod = class_getInstanceMethod(replacedClass, replacedSel);
    // 如果没有实现 delegate 方法，则手动动态添加
    if (!originalMethod) {
        Method noneMethod = class_getInstanceMethod(replacedClass, noneSel);
        BOOL addNoneMethod = class_addMethod(originalClass, originalSel, method_getImplementation(noneMethod), method_getTypeEncoding(noneMethod));
        if (addNoneMethod) {
            //            NSLog(@"⚠️没有实现 (%@) 方法，手动添加成功！！⚠️",NSStringFromSelector(originalSel));
        }
        return;
    }
    // 向实现 delegate 的类中添加新的方法
    // 这里是向 originalClass 的 replaceSel（@selector(p_scrollViewDidEndDecelerating:)） 添加 replaceMethod
    BOOL addMethod = class_addMethod(originalClass, replacedSel, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod));
    if (addMethod) {
        // 添加成功
        //        NSLog(@"⚠️实现了 (%@) 方法并成功 Hook 为 --> (%@)⚠️", NSStringFromSelector(originalSel), NSStringFromSelector(replacedSel));
        // 重新拿到添加被添加的 method,这里是关键(注意这里 originalClass, 不 replacedClass), 因为替换的方法已经添加到原类中了, 应该交换原类中的两个方法
        Method newMethod = class_getInstanceMethod(originalClass, replacedSel);
        // 实现交换
        method_exchangeImplementations(originalMethod, newMethod);
    } else {
        // 添加失败，则说明已经 hook 过该类的 delegate 方法，防止多次交换。
        //        NSLog(@"⚠️已替换过，避免多次替换 --> (%@)⚠️",NSStringFromClass(originalClass));
    }
}

- (void)jx_scrollStop:(UIScrollView *)scrollView {
    self.jx_scrollStopBlock ? self.jx_scrollStopBlock() : nil;
}

#pragma mark - Property Method

- (BOOL)jx_needHook {
    return [objc_getAssociatedObject(self, &kJXScrollStopNeedHookKey) boolValue];
}

- (void)setJx_needHook:(BOOL)jx_needHook {
    objc_setAssociatedObject(self, &kJXScrollStopNeedHookKey, [NSNumber numberWithBool:jx_needHook], OBJC_ASSOCIATION_ASSIGN);
}

- (JXScrollStopBlock)jx_scrollStopBlock {
    return objc_getAssociatedObject(self, &kJXScrollStopBlockKey);
}

- (void)setJx_scrollStopBlock:(JXScrollStopBlock)jx_scrollStopBlock {
    objc_setAssociatedObject(self, &kJXScrollStopBlockKey, jx_scrollStopBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
