//
//  UIButton+JXCountDown.h
//  JXExtension
//
//  Created by Jeason on 2017/8/5.
//  Copyright © 2017年 Jeason.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (JXCountDown)

#pragma mark - Normal

- (void)jx_normalTitleWithTitle:(NSString *)title
                      startTime:(NSInteger)timeout;

- (void)jx_normalTitleWithTitle:(NSString *)title
                      startTime:(NSInteger)timeout
                       canClick:(BOOL)canClick;

- (void)jx_normalTitleWithTitle:(NSString *)title
                      startTime:(NSInteger)timeout
                       complete:(void(^)(void))complete;

- (void)jx_normalTitleWithTitle:(NSString *)title
                      startTime:(NSInteger)timeout
                       canClick:(BOOL)canClick
                       complete:(void(^)(void))complete;

- (void)jx_normalTitleWithTitle:(NSString *)title
                      startTime:(NSInteger)timeout
                       progress:(void(^)(int seconds))progress
                       complete:(void(^)(void))complete;

- (void)jx_normalTitleWithTitle:(NSString *)title
                      startTime:(NSInteger)timeout
                       canClick:(BOOL)canClick
                       progress:(void(^)(int seconds))progress
                       complete:(void(^)(void))complete;

- (void)jx_normalTitleWithTitle:(NSString *)title
                      startTime:(NSInteger)timeout
                     waitPrefix:(NSString *)waitPrefix
                     waitSuffix:(NSString *)waitSuffix;

- (void)jx_normalTitleWithTitle:(NSString *)title
                      startTime:(NSInteger)timeout
                     waitPrefix:(NSString *)waitPrefix
                     waitSuffix:(NSString *)waitSuffix
                       canClick:(BOOL)canClick;

- (void)jx_normalTitleWithTitle:(NSString *)title
                      startTime:(NSInteger)timeout
                     waitPrefix:(NSString *)waitPrefix
                     waitSuffix:(NSString *)waitSuffix
                       complete:(void(^)(void))complete;

- (void)jx_normalTitleWithTitle:(NSString *)title
                      startTime:(NSInteger)timeout
                     waitPrefix:(NSString *)waitPrefix
                     waitSuffix:(NSString *)waitSuffix
                       canClick:(BOOL)canClick
                       complete:(void(^)(void))complete;

- (void)jx_normalTitleWithTitle:(NSString *)title
                      startTime:(NSInteger)timeout
                     waitPrefix:(NSString *)waitPrefix
                     waitSuffix:(NSString *)waitSuffix
                       canClick:(BOOL)canClick
                       progress:(void(^)(int seconds))progress
                       complete:(void(^)(void))complete;

#pragma mark - Selected

- (void)jx_selectedTitleWithTitle:(NSString *)title
                        startTime:(NSInteger)timeout;

- (void)jx_selectedTitleWithTitle:(NSString *)title
                        startTime:(NSInteger)timeout
                         canClick:(BOOL)canClick;

- (void)jx_selectedTitleWithTitle:(NSString *)title
                        startTime:(NSInteger)timeout
                         complete:(void(^)(void))complete;

- (void)jx_selectedTitleWithTitle:(NSString *)title
                        startTime:(NSInteger)timeout
                         canClick:(BOOL)canClick
                         complete:(void(^)(void))complete;

- (void)jx_selectedTitleWithTitle:(NSString *)title
                        startTime:(NSInteger)timeout
                         progress:(void(^)(int seconds))progress
                         complete:(void(^)(void))complete;

- (void)jx_selectedTitleWithTitle:(NSString *)title
                        startTime:(NSInteger)timeout
                         canClick:(BOOL)canClick
                         progress:(void(^)(int seconds))progress
                         complete:(void(^)(void))complete;

- (void)jx_selectedTitleWithTitle:(NSString *)title
                        startTime:(NSInteger)timeout
                       waitPrefix:(NSString *)waitPrefix
                       waitSuffix:(NSString *)waitSuffix;

- (void)jx_selectedTitleWithTitle:(NSString *)title
                        startTime:(NSInteger)timeout
                       waitPrefix:(NSString *)waitPrefix
                       waitSuffix:(NSString *)waitSuffix
                         canClick:(BOOL)canClick;

- (void)jx_selectedTitleWithTitle:(NSString *)title
                        startTime:(NSInteger)timeout
                       waitPrefix:(NSString *)waitPrefix
                       waitSuffix:(NSString *)waitSuffix
                         complete:(void(^)(void))complete;

- (void)jx_selectedTitleWithTitle:(NSString *)title
                        startTime:(NSInteger)timeout
                       waitPrefix:(NSString *)waitPrefix
                       waitSuffix:(NSString *)waitSuffix
                         canClick:(BOOL)canClick
                         complete:(void(^)(void))complete;

- (void)jx_selectedTitleWithTitle:(NSString *)title
                        startTime:(NSInteger)timeout
                       waitPrefix:(NSString *)waitPrefix
                       waitSuffix:(NSString *)waitSuffix
                         canClick:(BOOL)canClick
                         progress:(void(^)(int seconds))progress
                         complete:(void(^)(void))complete;

@end
