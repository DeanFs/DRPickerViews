//
//  DRClassRemindTimePickerView.h
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRClassRemindTimePickerView : UIView

@property (nonatomic, assign) BOOL isThisDay;
@property (nonatomic, copy) NSString *hourMinute; // HHmm
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) NSInteger timeScale;

@end

NS_ASSUME_NONNULL_END
