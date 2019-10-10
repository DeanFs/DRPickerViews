//
//  UIScrollView+JXExtension.h
//  JXExtension
//
//  Created by Jeason on 2017/7/7.
//  Copyright © 2017年 Jeason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JXScrollDirection) {
    JXScrollDirectionUp,
    JXScrollDirectionDown,
    JXScrollDirectionLeft,
    JXScrollDirectionRight,
    JXScrollDirectionNone
};

@interface UIScrollView (JXExtension)

@property (nonatomic) CGFloat jx_contentWidth;
@property (nonatomic) CGFloat jx_contentHeight;
@property (nonatomic) CGFloat jx_contentOffsetX;
@property (nonatomic) CGFloat jx_contentOffsetY;

- (void)jx_setContentOffsetX:(CGFloat)x animated:(BOOL)animated;
- (void)jx_setContentOffsetY:(CGFloat)y animated:(BOOL)animated;

- (CGPoint)jx_topContentOffset;
- (CGPoint)jx_bottomContentOffset;
- (CGPoint)jx_leftContentOffset;
- (CGPoint)jx_rightContentOffset;

- (JXScrollDirection)jx_scrollDirection;

- (BOOL)jx_isScrolledToTop;
- (BOOL)jx_isScrolledToBottom;
- (BOOL)jx_isScrolledToLeft;
- (BOOL)jx_isScrolledToRight;
- (void)jx_scrollToTopAnimated:(BOOL)animated;
- (void)jx_scrollToBottomAnimated:(BOOL)animated;
- (void)jx_scrollToLeftAnimated:(BOOL)animated;
- (void)jx_scrollToRightAnimated:(BOOL)animated;
- (void)jx_stopScrolling;

- (NSUInteger)jx_verticalPageIndex;
- (NSUInteger)jx_horizontalPageIndex;

- (void)jx_scrollToVerticalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated;
- (void)jx_scrollToHorizontalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated;

@end
