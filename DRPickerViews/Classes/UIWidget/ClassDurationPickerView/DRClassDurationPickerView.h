//
//  DRClassDurationPickerView.h
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRClassDurationPickerView : UIView

@property (nonatomic, assign) NSInteger weekDay;
@property (nonatomic, assign) NSInteger startClass;
@property (nonatomic, assign) NSInteger endClass;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
