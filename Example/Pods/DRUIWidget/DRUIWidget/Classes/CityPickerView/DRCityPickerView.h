//
//  DRCityPickerView.h
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRCityPickerView : UIView

@property (nonatomic, copy) IBInspectable NSString *province;
@property (nonatomic, copy) IBInspectable NSString *city;
@property (nonatomic, copy) void (^onSelectedChangeBlock) (NSString *province, NSString *city);


@end

NS_ASSUME_NONNULL_END
