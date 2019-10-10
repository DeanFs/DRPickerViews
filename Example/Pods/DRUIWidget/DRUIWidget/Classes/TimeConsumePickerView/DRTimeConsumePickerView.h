//
//  DRTimeConsumePickerView.h
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRTimeConsumePickerView : UIView

@property (nonatomic, assign) IBInspectable NSInteger timeScale; // 时间步长
@property (nonatomic, assign) IBInspectable NSInteger maxTimeConsume; // 最大时长
@property (nonatomic, assign) IBInspectable NSInteger currentTimeConsume; // 当前返显时长，也可以通过该属性读取当前值
@property (nonatomic, copy) void (^onTimeConsumeChangeBlock) (NSInteger timeConsume);

@end

NS_ASSUME_NONNULL_END
