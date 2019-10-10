//
//  JXBordersView.h
//  JXBordersView
//
//  Created by Jeason on 16/7/19.
//  Copyright © 2016年 Jeason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, JXRoundedCorner) {
    JXRoundedCornerNone        = 0,
    JXRoundedCornerTopLeft     = 1 << 0,
    JXRoundedCornerTopRight    = 1 << 1,
    JXRoundedCornerBottomRight = 1 << 2,
    JXRoundedCornerBottomLeft  = 1 << 3,
};

typedef NS_OPTIONS(NSUInteger, JXBorderSides) {
    JXBorderSidesNone   = 0,
    JXBorderSidesTop    = 1 << 0,
    JXBorderSidesLeft   = 1 << 1,
    JXBorderSidesBottom = 1 << 2,
    JXBorderSidesRight  = 1 << 3,
};

extern const JXRoundedCorner JXRoundedCornerAll;
extern const JXBorderSides JXBorderSidesAll;

@interface JXBordersView : UIView

@property (nonatomic, assign) JXBorderSides borderSides;

@property (nonatomic, assign) JXRoundedCorner roundedCorners;

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@property (nonatomic, strong) IBInspectable UIColor *fillColor;

@property (nonatomic, assign) IBInspectable BOOL dashBorder;

@property (nonatomic, assign) IBInspectable NSInteger dashPhase;

@property (nonatomic, assign) IBInspectable CGFloat dashLength;

@property (nonatomic, assign) IBInspectable CGFloat dashSpacing;

@property (nonatomic, assign) IBInspectable NSInteger dashCount;

@end
