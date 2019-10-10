//
//  JXBordersView.m
//  JXBordersView
//
//  Created by Jeason on 16/7/19.
//  Copyright © 2016年 Jeason. All rights reserved.
//

#import "JXBordersView.h"

const JXRoundedCorner JXRoundedCornerAll = JXRoundedCornerTopLeft | JXRoundedCornerTopRight | JXRoundedCornerBottomRight | JXRoundedCornerBottomLeft;
const JXBorderSides JXBorderSidesAll = JXBorderSidesTop | JXBorderSidesLeft | JXBorderSidesBottom | JXBorderSidesRight;

@implementation JXBordersView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
    
    self.fillColor = [UIColor whiteColor];
    self.roundedCorners = JXRoundedCornerAll;
    self.borderSides = JXBorderSidesAll;
}

#pragma mark - Property method

- (void)setBorderSides:(JXBorderSides)borderSides {
    _borderSides = borderSides;
    [self setNeedsDisplay];
}

- (void)setRoundedCorners:(JXRoundedCorner)roundedCorners {
    _roundedCorners = roundedCorners;
    [self setNeedsDisplay];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [self setNeedsDisplay];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    [self setNeedsDisplay];
}

- (void)setDashBorder:(BOOL)dashBorder {
    _dashBorder = dashBorder;
    [self setNeedsDisplay];
}

- (void)setDashPhase:(NSInteger)dashPhase {
    _dashPhase = dashPhase;
    [self setNeedsDisplay];
}

- (void)setDashLength:(CGFloat)dashLength {
    _dashLength = dashLength;
    [self setNeedsDisplay];
}

- (void)setDashSpacing:(CGFloat)dashSpacing {
    _dashSpacing = dashSpacing;
    [self setNeedsDisplay];
}

- (void)setDashCount:(NSInteger)dashCount {
    _dashCount = dashCount;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    CGContextRef contenxt = UIGraphicsGetCurrentContext();
    
    CGFloat halfLineWidth = self.borderWidth / 2.0f;
    
    CGFloat topInsets = self.borderSides & JXBorderSidesTop ? halfLineWidth : -halfLineWidth;
    CGFloat leftInsets = self.borderSides & JXBorderSidesLeft ? halfLineWidth : -halfLineWidth;
    CGFloat rightInsets = self.borderSides & JXBorderSidesRight ? halfLineWidth : -halfLineWidth;
    CGFloat bottomInsets = self.borderSides & JXBorderSidesBottom ? halfLineWidth : -halfLineWidth;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(topInsets, leftInsets, bottomInsets, rightInsets);
    
    CGRect properRect = UIEdgeInsetsInsetRect(rect, insets);
    
    CGContextSetLineWidth(contenxt, 0.0f);
    //绘制背景
    [self addPathToContext:contenxt inRect:properRect respectBorders:NO];
    CGContextClosePath(contenxt);
    //设置背景颜色
    CGContextSetFillColorWithColor(contenxt, self.fillColor.CGColor);
    CGContextDrawPath(contenxt, kCGPathFill);
    //设置边框颜色与宽度
    CGContextSetStrokeColorWithColor(contenxt, self.borderColor.CGColor);
    CGContextSetLineWidth(contenxt, self.borderWidth);
    //设置画虚线
    if (self.dashBorder) {
        // dashLength是每节虚线长度 dashSpacing是间隔
        CGFloat lengths[] = {self.dashLength, self.dashSpacing};
        // lengths数组的长度
        NSInteger dashCount = self.dashCount ?: 2;
        CGContextSetLineDash(contenxt, self.dashPhase, lengths, dashCount);
    }
    //绘制边框
    [self addPathToContext:contenxt inRect:properRect respectBorders:YES];
    CGContextDrawPath(contenxt, kCGPathStroke);
}

#pragma mark - Private method

- (void)addPathToContext:(CGContextRef)contenxt inRect:(CGRect)rect respectBorders:(BOOL)respectBorders{
    
    CGFloat minx = CGRectGetMinX(rect);
    CGFloat midx = CGRectGetMidX(rect);
    CGFloat maxx = CGRectGetMaxX(rect);
    
    CGFloat miny = CGRectGetMinY(rect);
    CGFloat midy = CGRectGetMidY(rect);
    CGFloat maxy = CGRectGetMaxY(rect);
    
    CGContextMoveToPoint(contenxt, minx, midy);
    
    // 左上角
    if (self.roundedCorners & JXRoundedCornerTopLeft && self.borderSides & (JXBorderSidesTop | JXBorderSidesLeft)) {
        CGContextAddArcToPoint(contenxt, minx, miny, midx, miny, self.cornerRadius);
        CGContextAddLineToPoint(contenxt, midx, miny);
    } else {
      if (self.borderSides & JXBorderSidesLeft || !respectBorders) {
            CGContextAddLineToPoint(contenxt, minx, miny);
        } else {
            CGContextDrawPath(contenxt, kCGPathStroke);
            CGContextMoveToPoint(contenxt, minx, miny);
        }
        if (self.borderSides & JXBorderSidesTop || !respectBorders) {
            CGContextAddLineToPoint(contenxt, midx, miny);
        } else {
            CGContextDrawPath(contenxt, kCGPathStroke);
            CGContextMoveToPoint(contenxt, midx, miny);
        }
    }

    // 右上角
    if (self.roundedCorners & JXRoundedCornerTopRight && self.borderSides & (JXBorderSidesTop | JXBorderSidesRight)) {
        CGContextAddArcToPoint(contenxt, maxx, miny, maxx, midy, self.cornerRadius);
        CGContextAddLineToPoint(contenxt, maxx, midy);
    } else {
        if (self.borderSides & JXBorderSidesTop || !respectBorders) {
            CGContextAddLineToPoint(contenxt, maxx, miny);
        } else {
            CGContextDrawPath(contenxt, kCGPathStroke);
            CGContextMoveToPoint(contenxt, maxx, miny);
        }
        if (self.borderSides & JXBorderSidesRight || !respectBorders) {
            CGContextAddLineToPoint(contenxt, maxx, midy);
        } else{
            CGContextDrawPath(contenxt, kCGPathStroke);
            CGContextMoveToPoint(contenxt, maxx, midy);
        }
    }
    
    // 右下角
    if (self.roundedCorners & JXRoundedCornerBottomRight && self.borderSides & (JXBorderSidesBottom | JXBorderSidesRight)) {
        CGContextAddArcToPoint(contenxt, maxx, maxy, midx, maxy, self.cornerRadius);
        CGContextAddLineToPoint(contenxt, midx, maxy);
    } else {
        if (self.borderSides & JXBorderSidesRight || !respectBorders) {
            CGContextAddLineToPoint(contenxt, maxx, maxy);
        } else {
            CGContextDrawPath(contenxt, kCGPathStroke);
            CGContextMoveToPoint(contenxt, maxx, maxy);
        }
        if (self.borderSides & JXBorderSidesBottom || !respectBorders) {
            CGContextAddLineToPoint(contenxt, midx, maxy);
        }  else {
            CGContextDrawPath(contenxt, kCGPathStroke);
            CGContextMoveToPoint(contenxt, midx, maxy);
        }
    }
     // 左下角
    if (self.roundedCorners & JXRoundedCornerBottomLeft && self.borderSides & (JXBorderSidesBottom | JXBorderSidesLeft)) {
        CGContextAddArcToPoint(contenxt, minx, maxy, minx, midy, self.cornerRadius);
        CGContextAddLineToPoint(contenxt, minx, midy);
    } else {
        if (self.borderSides & JXBorderSidesBottom || !respectBorders) {
            CGContextAddLineToPoint(contenxt, minx, maxy);
        } else {
            CGContextDrawPath(contenxt, kCGPathStroke);
            CGContextMoveToPoint(contenxt, minx, maxy);
        }
        if (self.borderSides & JXBorderSidesLeft || !respectBorders) {
            CGContextAddLineToPoint(contenxt, minx, midy);
        } else{
            CGContextMoveToPoint(contenxt, minx, midy);
            CGContextDrawPath(contenxt, kCGPathStroke);
        }
    }
}

@end
