//
//  DRClassTermPickerView.h
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRClassTermPickerView : UIView

@property (nonatomic, assign) NSInteger maxWeek; // default 25
@property (nonatomic, assign) NSInteger minYear; // default 2014
@property (nonatomic, assign) NSInteger maxGrade; // 1 ~ 13
@property (nonatomic, assign) NSInteger maxTerm; // default 3

@property (nonatomic, assign) NSInteger startYear;
@property (nonatomic, assign) NSInteger grade;
@property (nonatomic, assign) NSInteger term;

@end

NS_ASSUME_NONNULL_END
