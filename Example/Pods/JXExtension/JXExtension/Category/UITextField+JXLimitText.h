//
//  UITextField+JXLimitText.h
//  JXExtension
//
//  Created by Jeason on 27/6/2018.
//  Copyright © 2018年 Jeason.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (JXLimitText)

/*输入高亮位置*/
- (UITextPosition *)jx_highlightPosition;

/*限制字数输入，在EditingChanged中调用*/
- (void)jx_limitTextWithMaxLength:(NSUInteger)maxLength;

@end
