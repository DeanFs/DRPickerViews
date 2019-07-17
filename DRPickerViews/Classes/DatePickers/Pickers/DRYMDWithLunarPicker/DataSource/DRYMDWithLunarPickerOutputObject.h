//
//  DRYMDWithLunarPickerOutputObject.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRYMDWithLunarPickerOutputObject : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isLunar;
@property (nonatomic, assign) BOOL ignoreYear;

@end

NS_ASSUME_NONNULL_END
