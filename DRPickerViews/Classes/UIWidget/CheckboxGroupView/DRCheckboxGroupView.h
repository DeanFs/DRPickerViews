//
//  DRCheckboxGroupView.h
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRCheckboxGroupView : UIView

@property (nonatomic, assign) IBInspectable BOOL showBottomLine; // default NO
@property (nonatomic, assign) IBInspectable BOOL allowMultipleCheck; // 允许多选，default NO
@property (nonatomic, assign) IBInspectable BOOL singleCheck; // 单选，不可取消，default NO
@property (nonatomic, strong) NSArray<NSString *> *optionTitles;
@property (nonatomic, strong) NSArray<NSNumber *> *selectedIndexs;
@property (nonatomic, strong) NSArray<NSString *> *selectedOptions;

@property (nonatomic, copy) void (^onSelectedChangeBlock)(NSArray<NSNumber *> *selectedIndexs, NSArray<NSString *> *selectedOptions);

@end

NS_ASSUME_NONNULL_END
