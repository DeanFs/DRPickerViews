//
//  DRPickerTopBar.h
//  Pickers
//
//  Created by 冯生伟 on 2019/7/30.
//  Copyright © 2019 冯生伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRPickerTopBar;
typedef void (^DRPickerTopBarActionBlock)(DRPickerTopBar *topBar, UIButton *tappedButton);

IB_DESIGNABLE
@interface DRPickerTopBar : UIView

// default YES
@property (assign, nonatomic) IBInspectable BOOL showBottomLine;
@property (nonatomic, copy) IBInspectable NSString *leftButtonTitle;
@property (nonatomic, weak) IBInspectable UIImage *leftButtonImage;
@property (strong, nonatomic) IBInspectable UIColor *leftButtonTintColor;
@property (nonatomic, copy) IBInspectable NSString *centerButtonTitle;
@property (nonatomic, assign) BOOL rightButtonEnble;

// action callback
@property (nonatomic, copy) DRPickerTopBarActionBlock leftButtonActionBlock;
@property (nonatomic, copy) DRPickerTopBarActionBlock centerButtonActionBlock;
@property (nonatomic, copy) DRPickerTopBarActionBlock rightButtonActionBlock;

@end

