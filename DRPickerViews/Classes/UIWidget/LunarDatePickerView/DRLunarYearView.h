//
//  DRLunarYearView.h
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/8/4.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRLunarYearView : UIView

@property (nonatomic, strong) UIColor *textColor;
/// 农历汉子字号
@property (strong, nonatomic) UIFont *lunarTextFont;
/// 数字年份字体
@property (strong, nonatomic) UIFont *yearTextFont;

- (void)setupName:(NSString *)name year:(NSInteger)year;

@end

NS_ASSUME_NONNULL_END
