//
//  UITextView+JXLimitText.m
//  JXExtension
//
//  Created by Jeason on 27/6/2018.
//  Copyright © 2018年 Jeason.Lee. All rights reserved.
//

#import "UITextView+JXLimitText.h"

@implementation UITextView (JXLimitText)

- (UITextPosition *)jx_highlightPosition {
    UITextRange *highlightRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:highlightRange.start offset:0];
    return position;
}

- (void)jx_limitTextWithMaxLength:(NSUInteger)maxLength {
    NSString *text = self.text;
    NSString *language = [[UIApplication sharedApplication] textInputMode].primaryLanguage; //键盘输入模式
    if ([language isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，简体五笔，简体手写
        //获取高亮部分
        UITextPosition *position = [self jx_highlightPosition];
        if (!position) { //不是高亮，则对已输入的文字进行字数统计和限制
            if (text.length > maxLength) {
                self.text = [text substringToIndex:maxLength];
            }
        }
    } else {
        if (text.length > maxLength) {
            self.text = [text substringToIndex:maxLength];
        }
    }
}

@end
