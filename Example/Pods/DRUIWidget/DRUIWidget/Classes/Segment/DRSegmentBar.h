//
//  DRSegmentBar.h
//  Pickers
//
//  Created by 冯生伟 on 2019/7/30.
//  Copyright © 2019 冯生伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DRSegmentBarShowType) {
    DRSegmentBarShowTypeNormal = 0,         // 普通样式
    DRSegmentBarShowTypeLineStick,          // 线紧挨着标题
    DRSegmentBarShowTypeLineImg,            // 使用图片在底部展示
};


IB_DESIGNABLE
@interface DRSegmentBar : UIView

@property (weak, nonatomic) IBOutlet UIView *sepratorLine;

/**
 配置不同的样式类型, 使用枚举没法展示出来，所以使用整型
 默认是普通样式
 */
@property (nonatomic, assign) IBInspectable NSUInteger showType;

/**
 如果使用第三种样式，使用图片
 */
@property (nonatomic, strong) IBInspectable UIImage * flagImage;
/**
 偏移位置，标签图片底部展示偏移
 */
@property (nonatomic, assign) CGFloat flagImageOffsetBottom;

/**
 字体大小，如果不设置使用13
 */
@property (nonatomic, assign)IBInspectable CGFloat titleFontSize;

/**
 选中字体颜色, 默认为主题色
 */
@property (nonatomic, strong)IBInspectable UIColor * selectColor;


/**
 未选中字体颜色, 默认为黑色
 */
@property (nonatomic, strong)IBInspectable UIColor * normalColor;


@property (nonatomic, assign) NSInteger selectedIndex; // 默认选中第一个
@property (nonatomic, copy) void (^onSelectChangeBlock) (NSInteger index);

- (void)setupWithAssociatedScrollView:(UIScrollView *)associatedScrollView
                               titles:(NSArray<NSString *> *)titles;

@end
