//
//  DRValuePickerView.h
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRValuePickerView : UIView

/**
 滚动显示的最小值
 */
@property (nonatomic, assign) IBInspectable NSInteger minValue;

/**
 滚动显示的最大值
 */
@property (nonatomic, assign) IBInspectable NSInteger maxValue;

/**
 显示单位
 */
@property (nonatomic, copy) IBInspectable NSString *valueUnit;

/**
 前缀
 */
@property (nonatomic, copy) IBInspectable NSString *prefixUnit;

/**
 当前值
 */
@property (nonatomic, assign) IBInspectable NSInteger currentValue;

/**
 选择的值变化
 */
@property (nonatomic, copy) void (^onSelectedChangeBlock) (NSInteger value);

@end

NS_ASSUME_NONNULL_END
