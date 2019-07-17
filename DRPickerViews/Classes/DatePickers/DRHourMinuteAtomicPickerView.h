//
//  DRHourMinuteAtomicPickerView.h
//  AFNetworking
//
//  Created by 冯生伟 on 2019/4/16.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DRHourMinuteAtomicPickerViewType) {
    DRHourMinuteAtomicPickerViewTypeMoment, // 时间点
    DRHourMinuteAtomicPickerViewTypeDuration // 时间段
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

@class DRHourMinuteAtomicPickerView;
@protocol DRHourMinuteAtomicPickerViewDelegate <NSObject>

@optional
/**
 选择器停止滚动选中时对调

 @param hourMinutePickerView 当前选择器
 @param selectedValue 当前选中的值
 */
- (void)hourMinutePickerView:(DRHourMinuteAtomicPickerView *)hourMinutePickerView
             didSeletedValue:(DRHourMinutePickerValueModel *)selectedValue;

@end

IB_DESIGNABLE
@interface DRHourMinuteAtomicPickerView : UIView

/// DRHourMinuteAtomicPickerViewType
/// 类型：时间点，时间段(枚举类型并不支持IBInspectable，所以直接搞成NSInteger类型)
@property (nonatomic, assign) IBInspectable NSInteger type;

/// 字号, 默认22号系统字体
@property (nonatomic, assign) IBInspectable CGFloat pickerFontSize;

/// 时间段的至字文字大小，默认16号
@property (nonatomic, assign) IBInspectable CGFloat toLabelFontSize;

/// 选中颜色
@property (nonatomic, strong) IBInspectable UIColor *highlightColor;

/// 时间步长，1~59，默认1分钟
@property (nonatomic, assign) IBInspectable NSInteger timeScale;

/// 最小时间跨度，1~1439，时间段类型时可用，默认1分钟
@property (nonatomic, assign) IBInspectable NSInteger minDuration;

/// 滚轮行高，默认32
@property (nonatomic, assign) IBInspectable CGFloat rowHeight;

/// 代理
@property (nonatomic, weak) id<DRHourMinuteAtomicPickerViewDelegate> delegate;

/**
 实例化

 @param type 选择器类型
 @param delegate 代理
 @return 构建好的选择器
 */
+ (instancetype)hourMinutePickerViewWithType:(DRHourMinuteAtomicPickerViewType)type
                                    delegate:(id<DRHourMinuteAtomicPickerViewDelegate>)delegate;

/**
 设置反显当前时间
 适用于DRHourMinuteAtomicPickerViewTypeMoment类型

 @param hour 小时 0~23
 @param minute 分钟 0~59
 */
- (void)setCurrentHour:(NSInteger)hour
                minute:(NSInteger)minute;

/**
 设置反显当前时间
 适用于DRHourMinuteAtomicPickerViewTypeDuration类型
 
 @param startHour 小时 0~23
 @param startMinute 分钟 0~59
 @param duration 时间段时长，单位：秒
 */
- (void)setCurrentStartHour:(NSInteger)startHour
                startMimute:(NSInteger)startMinute
                   duration:(int64_t)duration;

/**
 获取当前选中的值

 @return 根据type不同返回不同数据模型
 */
- (DRHourMinutePickerValueModel *)currentSelectedValue;

@end
