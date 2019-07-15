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
#import "DRBasicKitDefine.h"

@implementation DRDatePickerOption

- (instancetype)init {
    self = [super init];
    if (self) {
        self.autoDismissWhenPicked = YES;
        self.timeScale = 5;
        self.minDuration = 30;
    }
    return self;
}

+ (instancetype)optionWithTitle:(NSString *)title {
    DRDatePickerOption *opt = [[DRDatePickerOption alloc] init];
    opt.title = title;
    return opt;
}

@end

@implementation DRBaseDatePicker

+ (instancetype)pickerView {
    return kDR_LOAD_XIB_NAMED(NSStringFromClass([self class]));
}

/**
 动画显示选择器
 */
- (void)show {
    [self prepareToShow];
    
    [UIView performWithoutAnimation:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.containerViewBottom.constant = - (self.containerViewHeight.constant + [UITabBar safeHeight]);
        [self layoutIfNeeded];
    }];
    
    [UIView animateWithDuration:kDRAnimationDuration animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.containerViewBottom.constant = 0;
        [self layoutIfNeeded];
    }];
}

/**
 动画隐藏选择器
 */
- (void)dismiss {
    [UIView animateWithDuration:kDRAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.containerViewBottom.constant = - (self.containerViewHeight.constant + [UITabBar safeHeight]);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    kDR_SAFE_BLOCK(self.pickOption.dismissBlock);
}

/**
 工具方法
 检查currentDate, minDate, maxDate设置的合理性，并进行修正
 子类中选择性调用该方法
 */
- (void)dateLegalCheck {
    // 当前时间默认今天
    if (!self.currentDate) {
        self.currentDate = [NSDate date];
    }
    
    // 最小日期默认0000-01-01 00:00:00
    if (!self.minDate) {
        self.minDate = [NSDate dateWithString:@"00000101" dateFormat:@"yyyyMMdd"];
    }
    
    // 当前时间不能比最小日期小
    if ([self.currentDate compare:self.minDate] == NSOrderedAscending) {
        if (self.maxDate && [self.minDate compare:self.maxDate] == NSOrderedDescending) {
            self.minDate = [NSDate dateWithString:@"19000101" dateFormat:@"yyyyMMdd"];
            self.maxDate = [self defaultMaxDate];
            return;
        } else {
            self.currentDate = self.minDate;
        }
    }
    
    // 最大日期默认y100年后最后一天最后一秒
    if (!self.maxDate || [self.minDate compare:self.maxDate] == NSOrderedDescending) {
        self.maxDate = [self defaultMaxDate];
        return;
    }
    
    if ([self.currentDate compare:self.maxDate] == NSOrderedDescending) {
        self.currentDate = self.maxDate;
    }
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

#pragma mark - actions
/**
 完成按钮点击响应

 @param button 完成按钮
 */
- (IBAction)confirmAction:(UIButton *)button {
    // 未停止滚动时，不执行完成回调
    if ([self anySubViewScrolling:self.picker]) {
        [self dismiss];
        return;
    }
    
    // 执行完成回调
    BOOL autoDismiss = YES;
    if (self.pickDoneBlock) {
        autoDismiss = self.pickDoneBlock(self, [self pickedObject]);
    }
    if (autoDismiss) {
        [self dismiss];
    }
}

/**
 取消按钮点击响应

 @param button 取消按钮
 */
- (IBAction)cancelAction:(UIButton *)button {
    kDR_SAFE_BLOCK(self.pickOption.cancelBlock);
    [self dismiss];
}

/**
 点击蒙板区域响应

 @param touches 点击区域信息
 @param event 事件
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self];
    if (!CGRectContainsPoint(self.safeBackView.frame, loc)) {
        [self dismiss];
    }
}

#pragma mark - private
- (NSDate *)defaultMaxDate {
    NSDateComponents *cmp = [self dateComponentsFromDate:self.currentDate];
    cmp.year += 2000;
    cmp.month = 12;
    cmp.day = 31;
    cmp.hour = 23;
    cmp.minute = 59;
    cmp.second = 59;
    return [[NSCalendar currentCalendar] dateFromComponents:cmp];
}

#pragma mark - lazy load
- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

@end
