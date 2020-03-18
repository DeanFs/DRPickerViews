//
//  DRDatePickerDataModels.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/6.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DRUIWidgetKit/DRPickerContainerView.h>

#pragma mark - 选择器类型定义
typedef NS_ENUM(NSInteger, DRPickerType) {
    // 入参：DRPickerDateOption
    // 出参(完成回调中的pickedObject，下同)：NSDate
    DRPickerTypeYMD,
    
    // 公历农历互切时间选择器
    // 入参：DRPickerWithLunarOption
    // 出参：DRPickerWithLunarPickedObj
    DRPickerTypeWithLunar,
    
    // 计划结束日期设置
    // 入参：DRPickerPlanEndOption
    // 出参：NSDate
    DRPickerTypePlanEnd,
    
    // 年月选择器
    // 入参：DRPickerDateOption
    // 出参：NSDate
    DRPickerTypeYearMoth,

    // 年月或者年选择器
    // 入参：DRPickerYearOrYearMonthOption
    // 出参：DRPickerYearOrYearMonthPickedObj
    DRPickerTypeYearOrYearMoth,
    
    // 年月选择器带筛选，月视图中使用
    // 入参：DRPickerYearMonthFilterOption
    // 出参：DRPickerYearMonthFilterPickedObj
    DRPickerTypeYearMothFileter,
    
    // 周选择器，周视图中使用
    // 入参：DRPickerDateOption
    // 出参：DRPickerOneWeekPickedObj
    DRPickerTypeOneWeek,
    
    // 传入date，修改其小时分钟
    // 入参：DRPickerHMForDateOption
    // 出参：NSDate
    DRPickerTypeHMForDate,
    
    // 入参：DRPickerHMOnlyOption
    // 出参：时间段时：DRPickerHMOnlyPickedObj  时间点时：NSString(HHmm)
    DRPickerTypeHMOnly,
    
    // 计划中，每周类型添加频次
    // 入参：DRPickerHMPlanWeekOption
    // 出参：DRPickerPlanWeekPickedObj
    DRPickerTypeHMPlanWeek,
    
    // 耗时0~9天，0~23小时，0~59分钟, 刻度为5分钟
    // 入参：DRPickerTimeConsumingOption
    // 出参：DRPickerTimeConsumingPickedObj
    DRPickerTypeTimeConsuming,
    
    // 提前提醒0~6,12,24,48小时，小时为0时，分5~55，否则分为0或30, 刻度为5分钟
    // 入参：DRPickerRemindAheadOption
    // 出参：NSNumber
    DRPickerTypeRemindAhead,
    
    // 数值带单位选择器，如xx天  xx岁
    // 入参：DRPickerValueSelectOption
    // 出参：NSNumber，选中的数值，如选择15天，则number为15
    DRPickerTypeValueSelect,
    
    // 简单字符串选项
    // 入参：DRPickerStringSelectOption
    // 出参：DRPickerStringSelectPickedObj
    DRPickerTypeStringSelect,
    
    // 选项卡选择器
    // 入参：DRPickerOptionCardOption
    // 出参：DRPickerOptionCardPickedObj
    DRPickerTypeOptionCard,

    // 城市选择
    // 入参：DRPickerCityOption
    // 出参：DRPickerCityPickedObj
    DRPickerTypeCity,

    // 课程表周数选择
    // 入参：DRPickerClassTableOption
    // 出参：DRPickerClassTablePickedObj
    DRPickerTypeClassTable,

    // 课程表周或学期选择
    // 入参：DRPickerClassTermOption
    // 出参：DRPickerClassTermPickedObj
    DRPickerTypeClassTerm,

    // 课程表课程时长选择
    // 入参：DRPickerClassDurationOption
    // 出参：DRPickerClassDurationPickedObj
    DRPickerTypeClassDuration,

    // 课程表上课提醒时间选择
    // 入参：DRPickerClassRemindTimeOption
    // 出参：DRPickerClassRemindTimePickedObj
    DRPickerTypeClassRemindTime,
    
    // 课程表上课提醒时间选择
    // 入参：DRPickerLinkageOption
    // 出参：DRPickerLinkagePickedObj
    DRPickerTypeLinkage,
    
    // 课程表上课提醒时间选择
    // 入参：DRPickerMultipleColumnOption
    // 出参：DRPickerMultipleColumnPickedObj
    DRPickerTypeMultipleColumn,
    
    // 时间选择“至今”
    // 入参：DRPickerDateOption
    // 出参：DRPickerDateToNowPickedObj
    DRPickerTypeDateToNow,
};

@class DRBaseAlertPicker;
#pragma mark - 选择器参数定义
#pragma mark 基类
@interface DRPickerOptionBase : NSObject
/**
 顶部标题
 */
@property (nonatomic, copy) NSString *title;

/// 取消文字颜色
@property (nonatomic, copy) NSString *cancelButtonTitle;

/// 点击空白区域是否隐藏选择器，默认YES
@property (nonatomic, assign) BOOL shouldDismissWhenTapSpaceArea;

/**
 指定在某个UI显示，默认显示到 keyWindow
 */
@property (nonatomic, weak) UIView *showInView;

/**
 选择器弹出的方向，默认：DRPickerShowPositionBottom
 */
@property (nonatomic, assign) DRPickerShowPosition showFromPosition;

/**
 是否在点击完成h时自动隐藏选择器，默认 YES
 如果设置为NO，在满足条件时在pickDoneBlock中调用[picker dismiss]进行隐藏
 */
@property (nonatomic, assign) BOOL autoDismissWhenPicked;

/**
 取消选择的回调
 */
@property (nonatomic, copy) dispatch_block_t cancelBlock;

/**
 显示动画执行完成的回调
 */
@property (nonatomic, copy) dispatch_block_t didShowBlock;

/**
 选择器隐藏时的回调
 */
@property (nonatomic, copy) dispatch_block_t dismissBlock;

/// 点击了空白区域的回调
@property (nonatomic, copy) dispatch_block_t tappedSpaceAreaBlock;

/// 具体的弹出Picker对象
@property (weak, nonatomic) DRBaseAlertPicker *pickerView;

/// 底部自定义视图
@property (strong, nonatomic) UIView *customBottomView;

+ (instancetype)optionWithTitle:(NSString *)title;

@end


#pragma mark - 选择器参数子类
@interface DRPickerDateOption : DRPickerOptionBase
/**
 当前日期，反显，默认：今天
 */
@property (nonatomic, strong) NSDate *currentDate;

/**
 最小可选日期，默认：NSDate扩展中的最小日期
 */
@property (nonatomic, strong) NSDate *minDate;

/**
 最大可选日期，默认：NSDate扩展中的最大日期
 */
@property (nonatomic, strong) NSDate *maxDate;

+ (instancetype)optionWithTitle:(NSString *)title
                    currentDate:(NSDate *)currentDate
                        minDate:(NSDate *)minDate
                        maxDate:(NSDate *)maxDate;

@end

@interface DRPickerYearOrYearMonthOption : DRPickerDateOption

@property (nonatomic, assign) BOOL isOnlyYear;

@end


typedef NS_ENUM(NSInteger, DRYMDWithLunarPickerType) {
    DRYMDWithLunarPickerTypeNormal,         // 年月日，不可忽略年份
    DRYMDWithLunarPickerTypeCanIngnoreYear, // 年月日，可忽略年份
    DRYMDWithLunarPickerTypeMonthDayOnly,   // 月日
};
@interface DRPickerWithLunarOption : DRPickerDateOption

/// 类型，默认：DRYMDWithLunarPickerTypeNormal
@property (nonatomic, assign) DRYMDWithLunarPickerType type;

/**
 年(公历/农历)
 忽略年份时，无效
 */
@property (nonatomic, assign) NSInteger year;

/**
 月份(公历/农历)
 */
@property (nonatomic, assign) NSInteger month;

/**
 日(公历/农历)
 */
@property (nonatomic, assign) NSInteger day;

/**
 是农历
 决定 year,month,day字段是否农历
 */
@property (nonatomic, assign) BOOL isLunar;

/**
 是闰月
 */
@property (nonatomic, assign) BOOL leapMonth;

/**
 忽略年份
 若为YES，则仅月日反显信息有效
 */
@property (nonatomic, assign) BOOL ignoreYear;

/// 开启 农历在底部显示公历，公历在底部显示农历
@property (nonatomic, assign) BOOL showDoubleCalendarTip;

+ (instancetype)optionWithTitle:(NSString *)title
                        minDate:(NSDate *)minDate
                        maxDate:(NSDate *)maxDate;

@end


@interface DRPickerPlanEndOption : DRPickerOptionBase
/**
 计划开始日期
 */
@property (nonatomic, strong) NSDate *startDate;

/**
 当前反显日期
 */
@property (nonatomic, strong) NSDate *currentDate;

/**
 最大可选日期
 */
@property (nonatomic, strong) NSDate *maxDate;

+ (instancetype)optionWithTitle:(NSString *)title
                    currentDate:(NSDate *)currentDate
                      startDate:(NSDate *)startDate
                        maxDate:(NSDate *)maxDate;

@end


@interface DRPickerYearMonthFilterOption : DRPickerDateOption
/**
 当前选中的筛选条件，反显
 */
@property (nonatomic, strong) NSArray<NSNumber *> *monthViewFilterIndexs;

/**
 筛选条件少于一项时的toas文案
 */
@property (nonatomic, copy) NSString *belowToast;

@end


@interface DRPickerHMBaseOption : DRPickerOptionBase

/**
 时间步长，默认5分钟
 */
@property (nonatomic, assign) NSInteger timeScale;

@end


@interface DRPickerHMForDateOption : DRPickerHMBaseOption
/**
 当前日期，需要被修改小时分钟的日期
 */
@property (nonatomic, strong) NSDate *currentDate;


+ (instancetype)optionWithTitle:(NSString *)title
                    currentDate:(NSDate *)currentDate;

@end


@interface DRPickerHMOnlyOption : DRPickerHMBaseOption
/**
 选则时间段
 */
@property (nonatomic, assign) BOOL forDuration;

/**
 在滚轮顶部显示持续时长、小于最小时长或跨天的错误提示，默认：YES
 */
@property (nonatomic, assign) BOOL showDurationTip;

/**
 允许跨天，默认：NO
 */
@property (nonatomic, assign) BOOL allowBeyondDay;

/**
 忽略错误，durationTip 不显示红色，不合法时隐藏tip
 */
@property (nonatomic, assign) BOOL ignoreError;

/**
 当前小时分钟，HHmm
 */
@property (nonatomic, copy) NSString *currentTime;

/**
 时间间隔，用于时间段选择，forDuration == YES
 单位：秒
 */
@property (nonatomic, assign) int64_t currentDuration;

/**
 最小时间间隔，用于时间段，单位分钟
 默认最小30分钟
 */
@property (nonatomic, assign) NSInteger minDuration;

/**
 是否可以清除时间
 */
@property (nonatomic, assign) BOOL canClean;

/**
 清除时间回调
 */
@property (nonatomic, copy) void (^onCleanTimeBlock)(id deletedObj);

@end


@interface DRPickerHMPlanWeekOption : DRPickerHMOnlyOption

/**
 当前选中的weekday
 */
@property (nonatomic, strong) NSArray<NSNumber *> *weekDays;

/**
 重复每周全天类型，仅选择周
 */
@property (nonatomic, assign) BOOL onlyWeekDay;

@end


@interface DRPickerTimeConsumingOption : DRPickerHMBaseOption
/**
 当前消耗时长，反显，单位：秒
 */
@property (nonatomic, assign) int64_t timeConsuming;

/// 最小时长，单位：分钟，默认：5
@property (nonatomic, assign) int64_t minTimeConsume;

/// 最大时长，单位：分钟，默认：10 * 24 * 60 - 1 = 14399
@property (nonatomic, assign) int64_t maxTimeConsume;

+ (instancetype)optionWithTitle:(NSString *)title
                  timeConsuming:(int64_t)timeConsuming;

@end


@interface DRPickerRemindAheadOption : DRPickerHMBaseOption

/// 最小提前提醒时间，单位：分钟，默认5
@property (assign, nonatomic) NSInteger minAheadTime;

@end


@interface DRPickerValueSelectOption : DRPickerOptionBase
/**
 滚动显示的最小值
 */
@property (nonatomic, assign) NSInteger minValue;

/**
 滚动显示的最大值
 */
@property (nonatomic, assign) NSInteger maxValue;

/**
 显示单位
 */
@property (nonatomic, copy) NSString *valueUnit;

/**
 前缀
 */
@property (nonatomic, copy) NSString *prefixUnit;

/// 提示语
@property (nonatomic, copy) NSString *tipText;

/**
 步长默认1.0
 */
@property (nonatomic, assign) CGFloat valueScale;

/**
 显示小数位数 默认0
 */
@property (nonatomic, assign) IBInspectable int digitCount;

/**
 是否强制显示指定小数位数 默认NO
 */
@property (nonatomic, assign) IBInspectable NSUInteger isForceDigit;

/**
 当前值
 */
@property (nonatomic, assign) NSInteger currentValue;

/**
 是否循环滚动 默认NO
 */
@property (nonatomic, assign) IBInspectable BOOL isLoop;

+ (instancetype)optionWithTitle:(NSString *)title
                   currentValue:(NSInteger)currentValue
                       minValue:(NSInteger)minValue
                       maxValue:(NSInteger)maxValue
                      valueUnit:(NSString *)valueUnit;

@end


@interface DRPickerStringSelectOption : DRPickerOptionBase

@property (nonatomic, strong) NSArray<NSString *> *stringOptions;
@property (nonatomic, copy) NSString *currentStringOption;
@property (nonatomic, assign) NSInteger currentStringIndex;
@property (strong, nonatomic) UIFont *valueFont;
@property (strong, nonatomic) UIFont *unitFont;

/**
 显示单位
 */
@property (nonatomic, copy) NSString *valueUnit;

/**
 前缀
 */
@property (nonatomic, copy) NSString *prefixUnit;

/// 提示语
@property (nonatomic, copy) NSString *tipText;

+ (instancetype)optionWithTitle:(NSString *)title
                  stringOptions:(NSArray<NSString *> *)stringOptions;

@end


@interface DRPickerOptionCardOption : DRPickerOptionBase
/**
 显示在选项卡头部的书名问题，如果有则传入
 */
@property (nonatomic, copy) NSString *sectionTip;

/**
 传入需要显示的所有选项
 */
@property (nonatomic, strong) NSArray<NSString *> *allOptions;

/**
 传入当前已经选中的选项，用于反显，与selectedIndexs二选一
 */
@property (nonatomic, strong) NSArray<NSString *> *selectedOptions;

/**
 传入当前已经选中的选项下标，用于反显，与selectedOptions二选一
 */
@property (nonatomic, strong) NSArray<NSNumber *> *selectedIndexs;

/**
 显示多少列，默认 3
 */
@property (nonatomic, assign) NSInteger columnCount;

/**
 显示多少行, 默认 3
 */
@property (nonatomic, assign) NSInteger lineCount;

/**
 是否多选，默认 NO
 */
@property (nonatomic, assign) IBInspectable BOOL mutableSelection;

/**
 支持多选时，最多选择数量，默认 3
 */
@property (nonatomic, assign) IBInspectable NSInteger maxSelectCount;

/**
 支持多选时，选择多余最大限制的toast提示文案，默认：最多选择 xx 项
 */
@property (nonatomic, copy) IBInspectable NSString *beyondMaxAlert;

/**
 支持多选时，最少选择数量，默认 1
 */
@property (nonatomic, assign) IBInspectable NSInteger minSelectCount;

/**
 支持多选时，选择少于最小限制的toast提示文案，默认：最少选择 xx 项
 */
@property (nonatomic, assign) IBInspectable NSString *belowMinAlert;

/**
 每列间距，默认：13
 */
@property (nonatomic, assign) CGFloat columnSpace;

/**
 每行高度，默认：32
 */
@property (nonatomic, assign) IBInspectable CGFloat lineHeight;

/**
 item 字号(平方字体)，默认：13
 */
@property (nonatomic, assign) IBInspectable CGFloat fontSize;

/**
 item的圆角半径，默认6
 */
@property (nonatomic, assign) IBInspectable CGFloat itemCornerRadius;

/**
 超过一页时，是否显示分页控制器，默认 NO
 */
@property (nonatomic, assign) IBInspectable BOOL showPageControl;

/**
 显示分页控制器时，分页控制器显示高度，默认 30
 */
@property (nonatomic, assign) IBInspectable CGFloat pageControlHeight;

@end


@interface DRPickerCityOption : DRPickerOptionBase

/// 民政部指定code
@property (nonatomic, strong) NSNumber *cityCode;

+ (instancetype)optionWithTitle:(NSString *)title cityCode:(NSNumber *)cityCode;

@end


@interface DRPickerClassTableOption : DRPickerOptionBase

@property (nonatomic, assign) NSInteger wholeWeekCount; // 总周数，默认：25
@property (nonatomic, strong) NSArray<NSNumber *> *classWeeks;

@end


@interface DRPickerClassTermOption : DRPickerOptionBase

// 数据源控制
@property (nonatomic, strong) NSArray<NSArray *> *edudationSource;
@property (nonatomic, assign) NSInteger enterYear; // 入学年份
@property (nonatomic, assign) NSInteger education; // 学历 1：本科/大专  2：硕士
@property (nonatomic, assign) NSInteger termCount; // 学期数量，默认：3

// 反显
@property (nonatomic, assign) NSInteger currentYear;
@property (nonatomic, assign) NSInteger currentTerm;

@end


@interface DRPickerClassDurationOption : DRPickerOptionBase

@property (nonatomic, assign) NSInteger weekDay; // 1 ~ 7 对应：周一 ~ 周日
@property (nonatomic, assign) NSInteger startClass; // 开始节数 1~17
@property (nonatomic, assign) NSInteger endClass; // 节数结束

@end


@interface DRPickerClassRemindTimeOption : DRPickerHMBaseOption

@property (nonatomic, assign) BOOL isThisDay; // 是当天
@property (nonatomic, copy) NSString *hourMinute; // HHmm

// 通过hourMinute或者分别传入小时分钟
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;

@end


@interface DRPickerLinkageOption : DRPickerOptionBase

/// 单位数组
@property (strong, nonatomic) NSArray *unitArray;

/// 选项数组
@property (strong, nonatomic) NSArray <NSArray *>*valuesArray;

/// 选择单位
@property (strong, nonatomic) NSString *currentSelectUnit;

/// 选择值
@property (strong, nonatomic) NSString *currentSelectValue;

/// 提示语
@property (nonatomic, copy) NSString *tipText;

/// 左边一列影响右边一列，即unitArray在左边，optionArray在右边
@property (assign, nonatomic) BOOL leftToRith;

/// 主动列字体
@property (strong, nonatomic) UIFont *unitFont;

/// 被动影响数据源列字体
@property (strong, nonatomic) UIFont *valueFont;

/// 分隔符
@property (copy, nonatomic) NSString *separateText;

@end


@interface DRPickerMultipleColumnOption : DRPickerOptionBase

/// 选项数组
@property (strong, nonatomic) NSArray <NSArray<NSString *> *>*optionArray;

/// 选择值
@property (strong, nonatomic) NSArray <NSString *> *currentSelectedStrings;

/// 按顺序指定每一列的字体字号，默认平方常规20pt
@property (strong, nonatomic) NSArray<UIFont *> *columnsFont;

/// 按顺序设置列与列之间的分隔符，如“/”，“-”，默认@""空字符
@property (strong, nonatomic) NSArray<NSString *> *separateTexts;

/// 提示语
@property (nonatomic, copy) NSString *tipText;

@end


#pragma mark - 选择器选择完成回调返回数据结构定义
@interface DRPickerWithLunarPickedObj : NSObject
/**
 当前选中的日期(公历)
 */
@property (nonatomic, strong) NSDate *date;

/**
 年(公历/农历)
 */
@property (nonatomic, assign) NSInteger year;

/**
 月份(公历/农历)
 */
@property (nonatomic, assign) NSInteger month;

/**
 日(公历/农历)
 */
@property (nonatomic, assign) NSInteger day;

/**
 是农历
 决定 year,month,day字段是否农历
 */
@property (nonatomic, assign) BOOL isLunar;

/**
 是闰月
 */
@property (nonatomic, assign) BOOL leapMonth;

/**
 忽略年份
 若为YES，则仅月日反显信息有效
 */
@property (nonatomic, assign) BOOL ignoreYear;

@end


@interface DRPickerYearMonthFilterPickedObj : NSObject
/**
 选择的日期
 */
@property (nonatomic, strong) NSDate *date;

/**
 选择的筛选条件
 */
@property (nonatomic, strong) NSArray<NSNumber *> *filterOptionIndexs;

@end


@interface DRPickerOneWeekPickedObj : NSObject

@property (nonatomic, strong) NSDate *firstDateInWeek;
@property (nonatomic, strong) NSDate *lastDateInWeek;
@property (nonatomic, assign) int weekIndexInMonth; // 这个月的第几周
@property (nonatomic, strong) NSDate *month; // 当前所在月
@property (nonatomic, assign) BOOL lastWeekInMonth; // 这个月的最后一周，仅这周内包含下个月日期时标记
@property (copy, nonatomic) NSString *weekTitle; // 中文周次

@end


@interface DRPickerHMOnlyPickedObj : NSObject
/**
 当前选中的小时分钟，或者时间段的起点小时分钟，HHmm格式
 */
@property (nonatomic, copy) NSString *pickedTime; // HHmm

/**
 持续时长，单位：秒
 */
@property (nonatomic, assign) int64_t duration;

/**
 持续时长中文描述
 */
@property (nonatomic, copy) NSString *durationDesc;

/**
 结束时间的小时分钟 HHmm
 */
@property (nonatomic, copy) NSString *endHourMinute;

/**
 时长不小于最小时长
 */
@property (nonatomic, assign) BOOL enoughDuration;

/**
 持续时长跨天标志
 */
@property (nonatomic, assign) BOOL beyondOneDay;

- (void)setupWithPickedTime:(NSString *)pickedTime
                   duration:(NSInteger)duration
               durationDesc:(NSString *)durationDesc
              endHourMinute:(NSString *)endHourMinute
              enoughDuation:(BOOL)enoughDuration
               beyondOneDay:(BOOL)beyondOneDay;

@end


@interface DRPickerPlanWeekPickedObj : DRPickerHMOnlyPickedObj
/**
 当前选中的周
 */
@property (nonatomic, copy) NSArray<NSNumber *> *weekDays;

- (void)setupWeekDays:(NSArray<NSNumber *> *)weekDays
           pickedTime:(NSString *)pickedTime;

- (void)setupWeekDays:(NSArray<NSNumber *> *)weekDays
           pickedTime:(NSString *)pickedTime
             duration:(NSInteger)duration
         durationDesc:(NSString *)durationDesc
        endHourMinute:(NSString *)endHourMinute
       enoughDuration:(BOOL)enoughDuration
         beyondOneDay:(BOOL)beyondOneDay;

@end


@interface DRPickerTimeConsumingPickedObj : NSObject
/**
 耗时时长，单位：秒
 */
@property (nonatomic, assign) int64_t timeConsuming;

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;

/**
 xx天xx小时xx分钟
 */
@property (nonatomic, copy) NSString *timeDesc;

+ (instancetype)objWithTimeConsuming:(int64_t)timeConsuming
                            timeDesc:(NSString *)timeDesc;

@end


@interface DRPickerStringSelectPickedObj : NSObject

@property (nonatomic, copy) NSString *selectedOption;
@property (nonatomic, assign) NSInteger selectedIndex;

+ (instancetype)objWithSelectedOption:(NSString *)option
                        selectedIndex:(NSInteger)index;

@end


@interface DRPickerOptionCardPickedObj : NSObject
/**
 当前已经选中的选项
 */
@property (nonatomic, strong) NSArray<NSString *> *selectedOptions;

/**
 当前已经选中的选项下标
 */
@property (nonatomic, strong) NSArray<NSNumber *> *selectedIndexs;

@end

@interface DRPickerYearOrYearMonthPickedObj : NSObject

@property (nonatomic, assign) BOOL isOnlyYear;
@property (nonatomic, strong) NSDate *yearMonth;

@end

@interface DRPickerCityPickedObj : NSObject

@property (nonatomic, assign) NSInteger cityCode;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;

@end


@interface DRPickerClassTablePickedObj : NSObject

@property (nonatomic, strong) NSArray<NSNumber *> *classWeeks;

@end


@interface DRPickerClassTermPickedObj : NSObject

@property (nonatomic, assign) NSInteger currentYear;
@property (nonatomic, assign) NSInteger currentTerm;

@end


@interface DRPickerClassDurationPickedObj : NSObject

@property (nonatomic, assign) NSInteger weekDay; // 1 ~ 7 对应：周一 ~ 周日
@property (nonatomic, assign) NSInteger startClass; // 开始节数 1~17
@property (nonatomic, assign) NSInteger endClass; // 节数结束

@end


@interface DRPickerClassRemindTimePickedObj : NSObject

@property (nonatomic, assign) BOOL isThisDay; // 是当天
@property (nonatomic, copy) NSString *hourMinute; // HHmm
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;

@end


@interface DRPickerLinkagePickedObj : NSObject

/// 选择单位
@property (strong, nonatomic) NSString *currentSelectUnit;

/// 选中下标
@property (assign, nonatomic) NSUInteger selectUnitIndex;

/// 选择值
@property (strong, nonatomic) NSString *currentSelectValue;

/// 选中下标
@property (assign, nonatomic) NSUInteger selectValueIndex;

@end


@interface DRPickerMultipleColumnPickedObj : NSObject

/// 选择值
@property (strong, nonatomic) NSArray <NSString *> *selectedStrings;

/// 选择DRPickerViews
@property (strong, nonatomic) NSArray <NSNumber *> *selectedIndexs;

@end


@interface DRPickerDateToNowPickedObj : NSObject

/// 选择日期
@property (strong, nonatomic) NSDate *date;
/// 至今
@property (assign, nonatomic) BOOL isToNow;

@end
