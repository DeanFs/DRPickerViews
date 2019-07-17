//
//  DRBaseDatePicker.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/18.
//

#import <UIKit/UIKit.h>

@class DRBaseDatePicker;

/**
 时间选择器选择完成的回调
 
 @param picker 选择器对象，满足DRDatePickerProtocol协议
 @param pickedObject 选中的数据结构
 @return YES:自动隐藏pickerView, NO不自动隐藏
 */
typedef BOOL (^DRDatePickerInnerDoneBlock)(DRBaseDatePicker *picker, id pickedObject);

/**
 额外初始化回调

 @param picker 时间选择器
 */
typedef void (^DRDatePickerSetupBlock)(DRBaseDatePicker *picker);

/**
 清除时间回调

 @param deletedObj 被清除的时间
 */
typedef void (^DRDatePickerCleanBlock)(id deletedObj);


@interface DRDatePickerOption : NSObject

/**
 指定在某个UI显示，默认显示到 keyWindow
 */
@property (nonatomic, weak) UIView *showInView;

/**
 顶部标题
 */
@property (nonatomic, copy) NSString *title;

/**
 取消选择的回调
 */
@property (nonatomic, copy) dispatch_block_t cancelBlock;

/**
 选择器隐藏时的回调
 */
@property (nonatomic, copy) dispatch_block_t dismissBlock;

/**
 是否可以清除时间，即是否显示清除时间按钮，默认 NO
 支持type: DRDatePickerTypeMDWT, DRDatePickerTypeMDWTimeOnly, DRDatePickerTypeHM
          DRDatePickerTypeHMOnly, DRDatePickerTypeHMPlanWeek
 */
@property (nonatomic, assign) BOOL canClean;

/**
 清除时间的回调
 支持type: DRDatePickerTypeMDWT
 */
@property (nonatomic, copy) DRDatePickerCleanBlock cleanBlock;

/**
 是否在点击完成h时自动隐藏选择器，默认 YES
 如果设置为NO，在满足条件时在pickDoneBlock中调用[picker dismiss]进行隐藏
 */
@property (nonatomic, assign) BOOL autoDismissWhenPicked;


#pragma mark - DRYMDWithLunarPicker需要的参数
/**
 是农历
 */
@property (nonatomic, assign) BOOL isLunar;

/**
 忽略年份
 */
@property (nonatomic, assign) BOOL ignoreYear;

/**
 忽略年份时的月份
 */
@property (nonatomic, assign) NSInteger month;

/**
 忽略年份时的日
 */
@property (nonatomic, assign) NSInteger day;

#pragma mark - DRHourMinutePicker
/**
 仅小时分钟，返回 HHmm 格式字符串，默认NO
 适用于 DRDatePickerTypeHM
 */
@property (nonatomic, assign) BOOL hourMinuteOnly;

/**
 当前小时分钟，试用于 DRDatePickerTypeHMOnly, DRDatePickerTypeHMPlanWeek
 */
@property (nonatomic, copy) NSString *currentTime;

/**
 当前每周配置，适用于DRDatePickerTypeHMPlanWeek
 */
@property (nonatomic, strong) NSArray<NSNumber *> *weekDays;

/**
 重复每周全天类型，仅选择周
 */
@property (nonatomic, assign) BOOL onlyWeekDay;

/**
 时间步长，默认5
 */
@property (nonatomic, assign) NSInteger timeScale;

/**
 选则时间段
 */
@property (nonatomic, assign) BOOL forDuration;

/**
 最小时间间隔，用于时间段，单位分钟
 默认最小30分钟
 */
@property (nonatomic, assign) NSInteger minDuration;

/**
 时间间隔，用于时间段选择DRDatePickerTypeHMDuration
 单位：秒
 */
@property (nonatomic, assign) int64_t currentDuration;

+ (instancetype)optionWithTitle:(NSString *)title;

@end


@interface DRBaseDatePicker : UIView

@property (weak, nonatomic) IBOutlet UIView *safeBackView;
@property (weak, nonatomic) IBOutlet UIView *picker;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottom;

// 时间选择器点击完成选择的回调
@property (nonatomic, copy) DRDatePickerInnerDoneBlock pickDoneBlock;

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;

@property (nonatomic, strong) DRDatePickerOption *pickOption;

+ (instancetype)pickerView;

/**
 动画弹出时间选择器
 */
- (void)show;

/**
 动画隐藏时间选择器
 */
- (void)dismiss;

/**
 工具方法
 检查currentDate, minDate, maxDate设置的合理性，并进行修正
 子类中选择性调用该方法
 */
- (void)dateLegalCheck;

/**
 日期拆分出年月日

 @param date 日期
 @return 拆分结果
 */
- (NSDateComponents *)dateComponentsFromDate:(NSDate *)date;

#pragma mark - 需要在子类中实现的抽象方法

/**
 从底部弹出时间选择器

 @param currentDate 当前时间
 @param minDate 最小时间
 @param maxDate 最大时间
 @param pickDoneBlock 选择完成回调
 @param setupBlock 额为初始化设置回调
 */
+ (void)showPickerViewWithCurrentDate:(NSDate *)currentDate
                              minDate:(NSDate *)minDate
                              maxDate:(NSDate *)maxDate
                        pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                           setupBlock:(DRDatePickerSetupBlock)setupBlock;

/**
 构建选中的数据，抽象方法
 必须实现

 @return 选中的数据
 */
- (id)pickedObject;

/**
 准备显示，主要做一些反显操作
 可选实现，在show之前会自动调用
 */
- (void)prepareToShow;

@end
