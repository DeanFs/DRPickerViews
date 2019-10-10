//
//  DRStarRateView.h
//  XHStarRateView
//
//  Created by Cyfuer on 2019/10/8.
//  Copyright © 2019 duorong. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

/**
 点击评分的 block 回调

 @param currentScore 当前评论分数，CGFloat 类型
 */
typedef void(^DRStarRateViewRateCompletionBlock)(CGFloat currentScore);

/**
 星级评分样式

 - DRStarRateViewRateStyeFullStar:       整星评论，默认样式。
 - DRStarRateViewRateStyeHalfStar:       允许半星评论。
 - DRStarRateViewRateStyeIncompleteStar: 允许不完整星评论。
 */
typedef NS_ENUM(NSUInteger, DRStarRateViewRateStye) {
    DRStarRateViewRateStyeFullStar,
    DRStarRateViewRateStyeHalfStar,
    DRStarRateViewRateStyeIncompleteStar,
};


@interface DRStarRateView : UIView

/**
 普通图片展示
 */
@property (nonatomic, strong) IBInspectable UIImage *normalImage;
/**
 高亮图片展示
 */
@property (nonatomic, strong) IBInspectable UIImage *highlightImage;

/**
 评分填充样式，默认为最小展示一半 DRStarRateViewRateStyeHalfStar
 */
@property (nonatomic, assign) DRStarRateViewRateStye rateStyle;

/**
 星星数量，默认为5个
 */
@property (nonatomic, assign, readwrite) IBInspectable NSUInteger numberOfStar;
/**
 当前评分 默认为 0
 */
@property (nonatomic, assign) IBInspectable CGFloat currentRating;
/**
 是否可以调整评分，默认可以修改评分等级
 */
@property (nonatomic, assign) IBInspectable BOOL editable;
/**
 是否可以评0分，默认不可评0分
 */
@property (nonatomic, assign) IBInspectable BOOL zeroRateEnable;
/**
 更改评分等级的回调，返回数量，不过不可以调整评分等级，则不会触发回调
 */
@property (nonatomic, copy) DRStarRateViewRateCompletionBlock completionBlock;


/// 快速设置参数
/// @param numberOfStar 星星数量
/// @param currentRating 当前评分
/// @param completionBlock 完成回调
- (void)setupNumberOfStar:(NSInteger)numberOfStar
            currentrating:(CGFloat)currentRating
               completion:(DRStarRateViewRateCompletionBlock)completionBlock;

@end
