//
//  DRBaseDatePicker.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/18.
//

#import "DRBaseAlertPicker.h"
#import <DRCategories/UITabBar+DRExtension.h>
#import <DRCategories/UIView+DRExtension.h>
#import <DRCategories/NSDate+DRExtension.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import "DRUIWidgetUtil.h"

@interface DRBaseAlertPicker ()

// 时间选择器点击完成选择的回调
@property (nonatomic, copy) DRPickerDoneBlock pickDoneBlock;

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
                   pickDoneBlock:(DRPickerDoneBlock)pickDoneBlock {
    DRBaseAlertPicker *pickerView = [self pickerView];
    kDR_SAFE_BLOCK(setupBlock, pickerView);
    pickerView.pickerOption = pickerOption;
    pickerView.pickDoneBlock = pickDoneBlock;
    [pickerView show];
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
- (BOOL)shouldDismissWhenTapSpaceArea {
    kDR_SAFE_BLOCK(self.pickerOption.tappedSpaceAreaBlock);
    return self.pickerOption.shouldDismissWhenTapSpaceArea;
}

- (void)viewDidShow {
    kDR_SAFE_BLOCK(self.pickerOption.didShowBlock);
}

- (void)viewDidDismiss {
    kDR_SAFE_BLOCK(self.pickerOption.dismissBlock);
}

- (void)dealloc {
    kDR_LOG(@"%@ dealloc", NSStringFromClass([self class]));
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
    if (self.pickerOption.title.length > 0) {
        self.topBar.centerButtonTitle = self.pickerOption.title;
    }
    if (self.pickerOption.cancelButtonTitle.length > 0) {
        self.topBar.leftButtonTitle = self.pickerOption.cancelButtonTitle;
    }
    
    kDRWeakSelf
    self.topBar.showBottomLine = NO;
    self.topBar.leftButtonActionBlock = ^(DRPickerTopBar *topBar, UIButton *tappedButton) {
        [weakSelf dismissComplete:^{
            kDR_SAFE_BLOCK(weakSelf.pickerOption.cancelBlock);
        }];
    };
    if (self.pickerOption.cancelBlock != nil) {
        self.topBar.leftButtonTintColor = [DRUIWidgetUtil highlightColor];
    }
    self.topBar.rightButtonActionBlock = ^(DRPickerTopBar *topBar, UIButton *tappedButton) {
        // 未停止滚动时，不执行完成回调
        if ([weakSelf anySubViewScrolling:weakSelf.picker]) {
            [weakSelf dismissComplete:nil];
            return;
        }
        if (weakSelf.pickerOption.autoDismissWhenPicked) {
            [weakSelf dismissComplete:^{
                kDR_SAFE_BLOCK(weakSelf.pickDoneBlock, weakSelf, [weakSelf pickedObject]);
            }];
        } else {
            kDR_SAFE_BLOCK(weakSelf.pickDoneBlock, weakSelf, [weakSelf pickedObject]);
        }
    };
    [self prepareToShow];
    [self showFromPostion:self.pickerOption.showFromPosition];
}

- (void)setPickerOption:(DRPickerOptionBase *)pickerOption {
    _pickerOption = pickerOption;
    pickerOption.pickerView = self;
}

#pragma mark - QCCardContentDelegate
- (void)setupCardContainerVc:(QCCardContainerController *)cardContainerVc {
    [super setupCardContainerVc:cardContainerVc];
    cardContainerVc.allowPanClose = NO;
    if (self.pickerOption.customBottomView != nil) {
        cardContainerVc.customBottomBar = self.pickerOption.customBottomView;
        self.pickerOption.customBottomView = nil;
    }
}

@end
