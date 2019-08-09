//
//  DRBaseDatePicker.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/18.
//

#import "DRBaseAlertPicker.h"
#import "UITabBar+DRExtension.h"
#import "UIView+DRExtension.h"
#import "NSDate+DRExtension.h"
#import <DRMacroDefines/DRMacroDefines.h>

@interface DRBaseAlertPicker ()

// 时间选择器点击完成选择的回调
@property (nonatomic, copy) DRPickerInnerDoneBlock pickDoneBlock;

@end

@implementation DRBaseAlertPicker

#pragma mark - api
/**
 弹出选择器
 
 @param pickerOption 选择器参数
 @param setupBlock 额外初始化设置回调
 @param pickDoneBlock 选择完成回调
 */
+ (void)showPickerViewWithOption:(DRPickerOptionBase *)pickerOption
                      setupBlock:(DRPickerSetupBlock)setupBlock
                   pickDoneBlock:(DRPickerInnerDoneBlock)pickDoneBlock {
    DRBaseAlertPicker *pickerView = [self pickerView];
    kDR_SAFE_BLOCK(setupBlock, pickerView);
    pickerView.pickerOption = pickerOption;
    pickerView.pickDoneBlock = pickDoneBlock;
    [pickerView show];
}

/**
 动画隐藏选择器
 */
- (void)dismiss {
    [super dismiss];
    kDR_SAFE_BLOCK(self.pickerOption.dismissBlock);
}

#pragma mark - 子类中可能需要重写的方法
+ (instancetype)pickerView {
    return kDR_LOAD_XIB_NAMED(NSStringFromClass([self class]));
}

#pragma mark - 需要在子类中实现的抽象方法
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

/**
 需要的参数类，默认DRPickerOptionBase
 
 @return option 的类
 */
- (Class)pickerOptionClass {
    return [DRPickerOptionBase class];
}

#pragma mark - overwrite
- (UIView *)showInView {
    return self.pickerOption.showInView;
}

#pragma mark - private
/**
 动画显示选择器
 */
- (void)show {
    if (![self.pickerOption isKindOfClass:[self pickerOptionClass]]) {
        kDR_LOG(@"error: 请传入正确的参数类型【%@】", NSStringFromClass([self pickerOptionClass]));
        return;
    }
    
    kDRWeakSelf
    self.topBar.leftButtonActionBlock = ^(DRPickerTopBar *topBar, UIButton *tappedButton) {
        kDR_SAFE_BLOCK(weakSelf.pickerOption.cancelBlock);
        [weakSelf dismiss];
    };
    
    if (self.pickerOption.title.length) {
        self.topBar.centerButtonTitle = self.pickerOption.title;
    }
    
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
    [self prepareToShow];
    [self showFromPostion:self.pickerOption.showFromPosition];
}

@end
