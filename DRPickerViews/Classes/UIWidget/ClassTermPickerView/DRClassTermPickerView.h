//
//  DRClassTermPickerView.h
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRClassTermPickerView : UIView

// 数据源控制
@property (nonatomic, strong) NSArray<NSArray *> *edudationSource;
@property (nonatomic, assign) IBInspectable NSInteger termCount; // 学期数量，默认：3
@property (nonatomic, assign) IBInspectable NSInteger enterYear; // 入学年份
@property (nonatomic, assign) IBInspectable NSInteger education; // 学历 1：本科/大专  2：硕士

// 反显
@property (nonatomic, assign) IBInspectable NSInteger currentYear;
@property (nonatomic, assign) IBInspectable NSInteger currentTerm;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
