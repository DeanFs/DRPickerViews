//
//  DRSegmentBar.h
//  Pickers
//
//  Created by 冯生伟 on 2019/7/30.
//  Copyright © 2019 冯生伟. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface DRSegmentBar : UIView

@property (nonatomic, assign) NSInteger selectedIndex; // 默认选中第一个
@property (nonatomic, copy) void (^onSelectChangeBlock) (NSInteger index);

- (void)setupWithAssociatedScrollView:(UIScrollView *)associatedScrollView
                               titles:(NSArray<NSString *> *)titles;

@end
