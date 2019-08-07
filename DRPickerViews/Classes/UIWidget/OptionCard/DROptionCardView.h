//
//  DROptionCardView.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/7/31.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DROptionCardView : UIView

@property (nonatomic, assign) IBInspectable NSInteger columnCount;      // default 3
@property (nonatomic, assign) IBInspectable CGFloat columnSpace;        // default 13
@property (nonatomic, assign) IBInspectable NSInteger lineCount;        // default 3
@property (nonatomic, assign) IBInspectable CGFloat lineHeight;         // default 32
@property (nonatomic, assign) IBInspectable CGFloat fontSize;           // default 13
@property (nonatomic, assign) IBInspectable CGFloat itemCornerRadius;   // default 6
@property (nonatomic, assign) IBInspectable BOOL mutableSelection;      // default NO
@property (nonatomic, assign) IBInspectable NSInteger maxSelectCount;   // default 3, effective when mutableSelection is YES
@property (nonatomic, copy) IBInspectable NSString *beyondMaxAlert;     // 多余最大限制的提示文案
@property (nonatomic, assign) IBInspectable NSInteger minSelectCount;   // default 1, effective when mutableSelection is YES
@property (nonatomic, assign) IBInspectable NSString *belowMinAlert;     // 低于最低限制的提示文案
@property (nonatomic, assign) IBInspectable BOOL showPageControl;      // 超过一页时，显示分页控制器 default NO
@property (nonatomic, assign) IBInspectable CGFloat pageControlHeight; // 分页控制器显示高度        default 30

@property (nonatomic, strong) NSArray<NSString *> *allOptions;
@property (nonatomic, strong) NSArray<NSString *> *selectedOptions;     // 反显
@property (nonatomic, strong) NSArray<NSNumber *> *selectedIndexs;

@property (nonatomic, copy) void (^onSelectionChangeBlock)(NSArray<NSString *> *selectedOptions, NSArray<NSNumber *> *selectedIndexs);

@end
