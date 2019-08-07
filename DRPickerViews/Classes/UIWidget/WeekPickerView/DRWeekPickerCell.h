//
//  DRWeekPickerCell.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/5.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRWeekPickerDateModel : NSObject <NSCopying>

@property (nonatomic, strong) NSMutableArray<NSString *> *daysList; // 01,02,....31
@property (nonatomic, strong) NSDate *firstDateInWeek;
@property (nonatomic, strong) NSDate *lastDateInWeek;
@property (nonatomic, strong) NSDate *month; // 当前所在月
@property (nonatomic, assign) int weekIndexInMonth; // 这个月的第几周
@property (nonatomic, assign) BOOL lastWeekInMonth; // 这个月的最后一周，仅这周内包含下个月日期时标记

// 与最大最小日期比较结果
@property (nonatomic, assign) BOOL disableSelect; // 不可选的周，超出了最大最小限制
@property (nonatomic, assign) NSInteger dayOffset; // 距离中心日期的偏移量，用于与最大最小日期比较
@property (nonatomic, assign) BOOL firstSelectableWeek; // 第一个可选周
@property (nonatomic, assign) int enableIndexFrom; // 第一个可选周，从第几天开始可选
@property (nonatomic, assign) BOOL lastSelectableWeek;
@property (nonatomic, assign) int enableIndexTo; // 最后一个可选周，最后一个可选天是第几天

@end

@interface DRWeekPickerCell : UIView

- (void)setupWeekCellWithModel:(DRWeekPickerDateModel *)weekModel selected:(BOOL)selected;

@end
