//
//  DRTimeConsumePickerView.h
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRTimeConsumePickerView : UIView

@property (nonatomic, assign) IBInspectable NSInteger timeScale; // 时间步长 分钟
@property (nonatomic, assign) IBInspectable int64_t minTimeConsume; // 最小时长 分钟
@property (nonatomic, assign) IBInspectable int64_t maxTimeConsume; // 最大时长 分钟
@property (nonatomic, assign) IBInspectable int64_t currentTimeConsume; // 当前返显时长，也可以通过该属性读取当前值
@property (nonatomic, assign, readonly) NSInteger day;
@property (nonatomic, assign, readonly) NSInteger hour;
@property (nonatomic, assign, readonly) NSInteger minute;
@property (nonatomic, copy) void (^onTimeConsumeChangeBlock) (int64_t timeConsume);

@end

NS_ASSUME_NONNULL_END
