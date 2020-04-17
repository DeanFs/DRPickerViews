//
//  DRBaseDatePicker.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/18.
//

#import "DRPickerContainerView.h"
#import "DRPickerTopBar.h"
#import "DRDatePickerDataModels.h"

@class DRBaseAlertPicker;

/**
 时间选择器选择完成的回调
 
 @param picker 选择器对象，满足DRDatePickerProtocol协议
 @param pickedObject 选中的数据结构
 */
typedef void (^DRPickerDoneBlock)(DRBaseAlertPicker *picker, id pickedObject);

/**
 额外初始化回调
 
 @param picker 时间选择器
 */
typedef void (^DRPickerSetupBlock)(__kindof DRBaseAlertPicker *picker);

@interface DRBaseAlertPicker : DRPickerContainerView

@property (weak, nonatomic) IBOutlet DRPickerTopBar *topBar;
@property (weak, nonatomic) IBOutlet UIView *picker;

@property (nonatomic, strong) DRPickerOptionBase *pickerOption;

#pragma mark - api 直接调用该方法显示
/**
 弹出选择器
 
 @param pickerOption 选择器参数
 @param setupBlock 额外初始化设置回调
 @param pickDoneBlock 选择完成回调
 */
+ (void)showPickerViewWithOption:(DRPickerOptionBase *)pickerOption
                      setupBlock:(DRPickerSetupBlock)setupBlock
                   pickDoneBlock:(DRPickerDoneBlock)pickDoneBlock;

#pragma mark - 子类中可能需要重写的方法
/**
 加载同名xib
 子类有特殊的实例化方法时，子类中需要重写
 @return pickerView实例
 */
+ (instancetype)pickerView;

#pragma mark - 需要在子类中实现的抽象方法
/**
 准备显示，主要做一些反显操作
 可选实现，在show之前会自动调用
 */
- (void)prepareToShow;

/**
 构建选中的数据，抽象方法
 必须实现
 @return 选中的数据
 */
- (id)pickedObject;

/**
 需要的参数类，默认DRPickerOptionBase
 @return option 的类
 */
- (Class)pickerOptionClass;

@end
