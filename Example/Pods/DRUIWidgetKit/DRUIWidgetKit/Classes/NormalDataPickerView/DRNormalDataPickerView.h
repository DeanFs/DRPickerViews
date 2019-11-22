//
//  DRNormalDataPickerView.h
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/10.
//

#import <UIKit/UIKit.h>

@interface DRNormalDataPickerView : UIView

@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *dataSource;
@property (nonatomic, strong) NSArray<NSString *> *currentSelectedStrings;
@property (nonatomic, copy) CGFloat (^getWidthForSectionWithBlock)(NSInteger section); // 分割线宽：8
@property (nonatomic, copy) NSString * (^getSeparateTextBeforeSectionBlock)(NSInteger section); // 第section列之前的分割符
@property (nonatomic, copy) NSTextAlignment (^getTextAlignmentForSectionBlock)(NSInteger section);
@property (nonatomic, copy) UIFont * (^getFontForSectionWithBlock)(NSInteger section);
@property (nonatomic, copy) BOOL (^getIsLoopForSectionBlock)(NSInteger section);
@property (nonatomic, copy) UIView *(^getCustonCellViewBlock)(NSInteger section, NSInteger row, NSString *text, UIColor *textColor);
@property (nonatomic, copy) void (^onSelectedChangeBlock)(NSInteger section, NSInteger index, NSString *selectedString);

- (void)getSelectedValueForSection:(NSInteger)section
                         withBlock:(void (^)(NSInteger index, NSString *selectedString))block;

- (void)reloadData;

@end
