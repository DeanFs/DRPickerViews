//
//  DRPickerContainerView.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/2.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRPickerContainerView.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UITabBar+DRExtension.h>
#import <BlocksKit/UIGestureRecognizer+BlocksKit.h>
#import <DRCategories/UIView+DRExtension.h>
#import <HexColors/HexColors.h>

@interface DRPickerContainerView () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *backCoverView;
@property (nonatomic, assign) DRPickerShowPosition position;

@end

@implementation DRPickerContainerView

#pragma mark - 子类中直接调用
- (void)showFromPostion:(DRPickerShowPosition)position {
    self.position = position;
    CGSize size = [self pickerViewSize];
    self.layer.cornerRadius = [self cornerRadius];
    self.layer.masksToBounds = YES;
    self.alpha= 0.0;
    [self.backCoverView addSubview:self];
    
    switch (self.position) {
        case DRPickerShowPositionBottom: {
            self.frame = CGRectMake([self xFromSize:size],
                                    kDRScreenHeight,
                                    size.width,
                                    size.height);
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:kDRAnimationDuration animations:^{
                    self.backCoverView.alpha = 1.0;
                    self.alpha = 1.0;
                    self.y = [self yFromSize:size];
                }];
            });
        } break;
            
        case DRPickerShowPositionTop: {
            self.frame = CGRectMake([self xFromSize:size],
                                    -size.height,
                                    size.width,
                                    size.height);
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:kDRAnimationDuration animations:^{
                    self.backCoverView.alpha = 1.0;
                    self.alpha = 1.0;
                    self.y = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + [self topPaddingFromStatusBar];
                }];
            });
        } break;
            
        case DRPickerShowPositionCenter: {
            self.frame = CGRectMake([self xFromSize:size], 0, size.width, size.height);
            self.centerY = self.backCoverView.centerY;
            self.transform = CGAffineTransformMakeScale(0.1, 0.1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:kDRAnimationDuration animations:^{
                    self.backCoverView.alpha = 1.0;
                    self.alpha = 1.0;
                    self.transform = CGAffineTransformIdentity;
                }];
            });
        }
        default:
            break;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDRAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.backCoverView bringSubviewToFront:self];
    });
}

- (void)dismiss {
    switch (self.position) {
        case DRPickerShowPositionBottom: {
            [UIView animateWithDuration:kDRAnimationDuration animations:^{
                self.backCoverView.alpha = 0.0;
                self.y = kDRScreenHeight;
            }];
        } break;
            
        case DRPickerShowPositionTop: {
            CGSize size = [self pickerViewSize];
            [UIView animateWithDuration:kDRAnimationDuration animations:^{
                self.backCoverView.alpha = 0.0;
                self.y = -size.height;
            }];
        } break;
            
        case DRPickerShowPositionCenter: {
            [UIView animateWithDuration:kDRAnimationDuration animations:^{
                self.backCoverView.alpha = 0.0;
                self.transform = CGAffineTransformMakeScale(0.1, 0.1);
            }];
        }
            
        default:
            break;
    }
}

- (void)pickerViewHeightChange:(CGFloat)newHeight {
    CGSize newSize = CGSizeMake([self pickerViewWidth], newHeight);
    [self pickerViewSizeChange:newSize];
}

#pragma mark - 子类根据需要重写
// 水平方向距离屏幕边缘距离，默认 16
- (CGFloat)horizontalPadding {
    return 16;
}

// 选择器高度 默认 260
- (CGFloat)picerViewHeight {
    return 260;
}

// 底部距离安全区域边缘距离 默认 16
- (CGFloat)bottomPaddingFromSafeArea {
    return 16;
}

// 顶部距离状态栏的距离 默认 16
- (CGFloat)topPaddingFromStatusBar {
    return 16;
}

// 圆角半径，默认 12
- (CGFloat)cornerRadius {
    return 12;
}

#pragma mark - private
- (CGFloat)pickerViewWidth {
    return kDRScreenWidth - 2 * [self horizontalPadding];
}

- (CGSize)pickerViewSize {
    return CGSizeMake([self pickerViewWidth],
                      [self picerViewHeight]);
}

- (CGFloat)xFromSize:(CGSize)size {
    return (kDRScreenWidth - size.width) / 2;
}

- (CGFloat)yFromSize:(CGSize)size {
    return kDRScreenHeight - size.height - [UITabBar safeHeight] - [self bottomPaddingFromSafeArea];
}

- (void)pickerViewSizeChange:(CGSize)newSize {
    switch (self.position) {
        case DRPickerShowPositionBottom: {
            [UIView animateWithDuration:kDRAnimationDuration animations:^{
                self.frame = CGRectMake([self xFromSize:newSize],
                                        [self yFromSize:newSize],
                                        newSize.width,
                                        newSize.height);
            }];
        } break;
            
        case DRPickerShowPositionTop: {
            [UIView animateWithDuration:kDRAnimationDuration animations:^{
                self.height = newSize.height;
            }];
        } break;
            
        case DRPickerShowPositionCenter: {
            [UIView animateWithDuration:kDRAnimationDuration animations:^{
                self.height = newSize.height;
                self.centerY = self.backCoverView.centerY;
            }];
        }
            
        default:
            break;
    }
}

#pragma mark - lazy load
- (UIView *)backCoverView {
    if (!_backCoverView) {
        kDRWeakSelf
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            if (state == UIGestureRecognizerStateEnded) {
                [weakSelf dismiss];
            }
        }];
        tap.delegate = self;
        
        UIView *view = [[UIView alloc] initWithFrame:kDRWindow.bounds];
        view.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"0B1222" alpha:0.4];
        view.alpha = 0.0;
        [view addGestureRecognizer:tap];
        [kDRWindow addSubview:view];
        _backCoverView = view;
    }
    return _backCoverView;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if([touch.view isDescendantOfView:self]) {
        return NO;
    }
    return YES;
}

@end
