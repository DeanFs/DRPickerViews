//
//  DRHourMinutePickerView.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/2.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DRHourMinutePickerViewType) {
    DRHourMinutePickerViewTypeMoment, // 时间点
    DRHourMinutePickerViewTypeDuration // 时间段
};

@interface DRHourMinutePickerValueModel : NSObject

@property (nonatomic, assign, readonly) NSInteger hour;
@property (nonatomic, assign, readonly) NSInteger minute;
@property (nonatomic, assign, readonly) NSInteger endHour;
@property (nonatomic, assign, readonly) NSInteger endMinute;

// 持续分钟数，时间段类型时有值，时间点类型为0，单位：秒
@property (nonatomic, assign, readonly) int64_t duration;
// 持续时长中文描述
@property (nonatomic, copy, readonly) NSString *durationDesc;
// 结束时间的小时分钟 HHmm
@property (nonatomic, copy, readonly) NSString *endHourMinute;
// 时间段类型时，标记时间段有效（duration > minDuration）
@property (nonatomic, assign, readonly) BOOL enoughDuration;
// 时间段跨天
@property (nonatomic, assign, readonly) BOOL beyondOneDay;

@end

@class DRHourMinutePickerView;
@protocol DRHourMinutePickerViewDelegate <NSObject>

@optional
/**
 选择器停止滚动选中时对调
 
 @param hourMinutePickerView 当前选择器
 @param selectedValue 当前选中的值
 */
- (void)hourMinutePickerView:(DRHourMinutePickerView *)hourMinutePickerView
             didSeletedValue:(DRHourMinutePickerValueModel *)selectedValue;

@end

IB_DESIGNABLE
@interface DRHourMinutePickerView : UIView

/// DRHourMinutePickerViewType
/// 类型：时间点，时间段
@property (nonatomic, assign) DRHourMinutePickerViewType type;
@property (nonatomic, assign) IBInspectable NSInteger typeXib; // 在xib中指定type时使用

/// 时间步长，1~59，默认1分钟
@property (nonatomic, assign) IBInspectable NSInteger timeScale;

/// 最小时间跨度，1~1439，时间段类型时可用，默认1分钟
@property (nonatomic, assign) IBInspectable NSInteger minDuration;

/// 代理
@property (nonatomic, weak) id<DRHourMinutePickerViewDelegate> delegate;

/**
 实例化
 
 @param type 选择器类型
 @param delegate 代理
 @return 构建好的选择器
 */
+ (instancetype)hourMinutePickerViewWithType:(DRHourMinutePickerViewType)type
                                    delegate:(id<DRHourMinutePickerViewDelegate>)delegate;

/**
 获取当前选中的值
 
 @return 根据type不同返回不同数据模型
 */
- (DRHourMinutePickerValueModel *)currentSelectedValue;

/**
 设置反显当前时间
 适用于DRHourMinutePickerViewTypeMoment类型
 
 @param hour 小时 0~23
 @param minute 分钟 0~59
 */
- (void)setCurrentHour:(NSInteger)hour
                minute:(NSInteger)minute;

/**
 设置反显当前时间
 适用于DRHourMinutePickerViewTypeDuration类型
 
 @param startHour 小时 0~23
 @param startMinute 分钟 0~59
 @param duration 时间段时长，单位：秒
 */
- (void)setCurrentStartHour:(NSInteger)startHour
                startMimute:(NSInteger)startMinute
                   duration:(int64_t)duration;

@end
