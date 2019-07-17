//
//  DRTimeConsumingPicker.h
//  AFNetworking
//
//  Created by 冯生伟 on 2019/4/26.
//

#import "DRBaseDatePicker.h"

@interface DRTimeConsumingModel : NSObject

// 时长秒数，单位：秒
@property (nonatomic, assign) int64_t duration;
// xx天xx小时xx分钟
@property (nonatomic, copy) NSString *timeString;

@end

@interface DRTimeConsumingPicker : DRBaseDatePicker

@end
