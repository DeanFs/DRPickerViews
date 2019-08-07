//
//  DRBaseDatePicker.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/18.
//

#import "DRBaseDatePicker.h"
#import "UITabBar+DRExtension.h"
#import "UIView+DRExtension.h"
#import "NSDate+DRExtension.h"
#import <DRMacroDefines/DRMacroDefines.h>

@implementation DRBaseDatePicker

+ (instancetype)pickerView {
    return kDR_LOAD_XIB_NAMED(NSStringFromClass([self class]));
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    kDRWeakSelf
    self.topBar.leftButtonActionBlock = ^(DRPickerTopBar *topBar, UIButton *tappedButton) {
        kDR_SAFE_BLOCK(weakSelf.pickOption.cancelBlock);
        [weakSelf dismiss];
    };
    
    self.topBar.rightButtonActionBlock = ^(DRPickerTopBar *topBar, UIButton *tappedButton) {
        // 未停止滚动时，不执行完成回调
        if ([weakSelf anySubViewScrolling:weakSelf.picker]) {
            [weakSelf dismiss];
            return;
        }
        
        // 执行完成回调
        BOOL autoDismiss = YES;
        if (weakSelf.pickDoneBlock) {
            autoDismiss = self.pickDoneBlock(weakSelf, [self pickedObject]);
        }
        if (autoDismiss) {
            [weakSelf dismiss];
        }
    };
}

/**
 动画显示选择器
 */
- (void)show {
    [self prepareToShow];
    [self showFromPostion:DRPickerShowPositionBottom];
}

/**
 动画隐藏选择器
 */
- (void)dismiss {
    [super dismiss];
    kDR_SAFE_BLOCK(self.pickOption.dismissBlock);
}

- (NSDateComponents *)dateComponentsFromDate:(NSDate *)date {
    return [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                            fromDate:date];
}

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
                           setupBlock:(DRDatePickerSetupBlock)setupBlock {
    
}

/**
 构建选中的数据，抽象方法
 必须实现
 
 @return 选中的数据
 */
- (id)pickedObject {
    return nil;
}

/**
 准备显示，主要做一些反显操作
 可选实现，在show之前会自动调用
 */
- (void)prepareToShow {
    
}

#pragma mark - lazy load
- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

@end
