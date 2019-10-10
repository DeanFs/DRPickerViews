//
//  JXImageTextButton.h
//  JXExtension
//
//  Created by Jeason on 2017/8/21.
//  Copyright © 2017年 Jeason.Lee. All rights reserved.
//

#import "JXButton.h"

@interface JXImageTextButton : JXButton

@property (nonatomic) IBInspectable UIImage *leftNormalStateImage;
@property (nonatomic) IBInspectable UIImage *leftHighlightedStateImage;
@property (nonatomic) IBInspectable UIImage *rightNormalStateImage;
@property (nonatomic) IBInspectable UIImage *rightHighlightedStateImage;
@property (nonatomic) IBInspectable CGFloat space;

@end
