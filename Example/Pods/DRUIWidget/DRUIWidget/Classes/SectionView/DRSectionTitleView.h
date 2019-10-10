//
//  DRSectionTitleView.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/7/31.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface DRSectionTitleView : UIView

@property (nonatomic, copy) IBInspectable NSString *title;
@property (nonatomic, assign) IBInspectable CGFloat fontSize;   // default 13
@property (nonatomic, strong) IBInspectable UIColor *textColor; // default descColor

@end
