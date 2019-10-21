//
//  DRDatePickerFactory.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/15.
//

#import <Foundation/Foundation.h>
#import "DRBaseAlertPicker.h"

NS_ASSUME_NONNULL_BEGIN

/**
 时间选择器选择完成的回调
 
 @param picker 选择器对象，满足DRDatePickerProtocol协议
 @param pickedObject 选中的数据结构
 */
typedef void (^DRPickerDoneBlock)(DRBaseAlertPicker *picker, id pickedObject);


@interface DRPickerFactory : NSObject

/**
 显示Dialog
 
 @param type 选择器类型
 @param pickerOption 选择器参数
 @param pickDoneBlock 点击完成按钮确认选的回调
 */
+ (void)showPickerViewWithType:(DRPickerType)type
                  pickerOption:(DRPickerOptionBase *)pickerOption
                 pickDoneBlock:(DRPickerDoneBlock)pickDoneBlock;

@end

NS_ASSUME_NONNULL_END
