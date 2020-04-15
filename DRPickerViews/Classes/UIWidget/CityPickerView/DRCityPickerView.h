//
//  DRCityPickerView.h
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRCityPickerView : UIView

@property (nonatomic, assign) IBInspectable NSInteger cityCode;
@property (nonatomic, copy, readonly) NSString *province;
@property (nonatomic, copy, readonly) NSString *city;
@property (nonatomic, copy) void (^onSelectedChangeBlock) (NSInteger cityCode, NSString *provice, NSString *city);

@end

NS_ASSUME_NONNULL_END
