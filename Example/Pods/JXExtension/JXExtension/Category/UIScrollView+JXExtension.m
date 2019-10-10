//
//  UIScrollView+JXExtension.m
//  JXExtension
//
//  Created by Jeason on 2017/7/7.
//  Copyright © 2017年 Jeason. All rights reserved.
//

#import "UIScrollView+JXExtension.h"

@implementation UIScrollView (JXExtension)


- (CGFloat)jx_contentWidth {
    return self.contentSize.width;
}

- (void)setJx_contentWidth:(CGFloat)width {
    self.contentSize = CGSizeMake(width, self.frame.size.height);
}

- (CGFloat)jx_contentHeight {
    return self.contentSize.height;
}
- (void)setJx_contentHeight:(CGFloat)height {
    self.contentSize = CGSizeMake(self.frame.size.width, height);
}

- (CGFloat)jx_contentOffsetX {
    return self.contentOffset.x;
}

- (void)setJx_contentOffsetX:(CGFloat)x {
    self.contentOffset = CGPointMake(x, self.contentOffset.y);
}

- (CGFloat)jx_contentOffsetY {
    return self.contentOffset.y;
}

- (void)setJx_contentOffsetY:(CGFloat)y {
    self.contentOffset = CGPointMake(self.contentOffset.x, y);
}

- (void)jx_setContentOffsetX:(CGFloat)x animated:(BOOL)animated {
    [self setContentOffset:CGPointMake(x, self.contentOffset.y) animated:animated];
}

- (void)jx_setContentOffsetY:(CGFloat)y animated:(BOOL)animated {
    [self setContentOffset:CGPointMake(self.contentOffset.x, y) animated:animated];
}

- (CGPoint)jx_topContentOffset {
    return CGPointMake(self.contentOffset.x, -self.contentInset.top);
}

- (CGPoint)jx_bottomContentOffset {
    return CGPointMake(self.contentOffset.x, self.contentSize.height + self.contentInset.bottom - self.bounds.size.height);
}

- (CGPoint)jx_leftContentOffset {
    return CGPointMake(-self.contentInset.left, self.contentOffset.y);
}

- (CGPoint)jx_rightContentOffset {
    return CGPointMake(self.contentSize.width + self.contentInset.right - self.bounds.size.width, self.contentOffset.y);
}

- (JXScrollDirection)jx_scrollDirection {
    JXScrollDirection direction;
    if ([self.panGestureRecognizer translationInView:self.superview].y > 0.0f) {
        direction = JXScrollDirectionUp;
    } else if ([self.panGestureRecognizer translationInView:self.superview].y < 0.0f) {
        direction = JXScrollDirectionDown;
    } else if ([self.panGestureRecognizer translationInView:self].x < 0.0f) {
        direction = JXScrollDirectionLeft;
    } else if ([self.panGestureRecognizer translationInView:self].x > 0.0f) {
        direction = JXScrollDirectionRight;
    } else {
        direction = JXScrollDirectionNone;
    }
    return direction;
}

- (BOOL)jx_isScrolledToTop {
    return self.contentOffset.y <= [self jx_topContentOffset].y;
}

- (BOOL)jx_isScrolledToBottom {
    return self.contentOffset.y >= [self jx_bottomContentOffset].y;
}

- (BOOL)jx_isScrolledToLeft {
    return self.contentOffset.x <= [self jx_leftContentOffset].x;
}

- (BOOL)jx_isScrolledToRight {
    return self.contentOffset.x >= [self jx_rightContentOffset].x;
}

- (void)jx_scrollToTopAnimated:(BOOL)animated {
    [self setContentOffset:[self jx_topContentOffset] animated:animated];
}

- (void)jx_scrollToBottomAnimated:(BOOL)animated {
    [self setContentOffset:[self jx_bottomContentOffset] animated:animated];
}

- (void)jx_scrollToLeftAnimated:(BOOL)animated {
    [self setContentOffset:[self jx_leftContentOffset] animated:animated];
}

- (void)jx_scrollToRightAnimated:(BOOL)animated {
    [self setContentOffset:[self jx_rightContentOffset] animated:animated];
}

- (void)jx_stopScrolling {
    [self setContentOffset:CGPointMake(0, MIN(self.contentSize.height - CGRectGetHeight(self.frame), self.contentOffset.y)) animated:NO];
}

- (NSUInteger)jx_verticalPageIndex {
    return (self.contentOffset.y + (self.frame.size.height * 0.5f)) / self.frame.size.height;
}

- (NSUInteger)jx_horizontalPageIndex {
    return (self.contentOffset.x + (self.frame.size.width * 0.5f)) / self.frame.size.width;
}

- (void)jx_scrollToVerticalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated {
    [self setContentOffset:CGPointMake(0.0f, self.frame.size.height * pageIndex) animated:animated];
}

- (void)jx_scrollToHorizontalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated {
    [self setContentOffset:CGPointMake(self.frame.size.width * pageIndex, 0.0f) animated:animated];
}

@end
