//
//  DRBaseDatePicker.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/18.
//

#import "DRPickerContainerView.h"
#import "DRPickerTopBar.h"
#import "DRDatePickerDataModels.h"

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

@interface DRBaseDatePicker : DRPickerContainerView

@property (weak, nonatomic) IBOutlet DRPickerTopBar *topBar;
@property (weak, nonatomic) IBOutlet UIView *picker;

// 时间选择器点击完成选择的回调
@property (nonatomic, copy) DRDatePickerInnerDoneBlock pickDoneBlock;

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;

@property (nonatomic, strong) DRPickerOption *pickOption;

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
