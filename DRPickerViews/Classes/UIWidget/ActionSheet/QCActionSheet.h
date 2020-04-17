//
//  QCActionSheet.h
//  Records
//
//  Created by 冯生伟 on 2020/4/9.
//  Copyright © 2020 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "QCCardContainerBaseService.h"

typedef NS_ENUM(NSInteger, QCActionSheetAlignment) {
    QCActionSheetAlignmentNone,     // 带图标则左对齐，否则居中对齐
    QCActionSheetAlignmentLeft,     // 左对齐
    QCActionSheetAlignmentCenter,   // 居中对齐
    QCActionSheetAlignmentRight     // 右对齐
};

typedef NS_ENUM(NSInteger, QCActionSheetRightIconType) {
    QCActionSheetRightIconTypeNone,         // 右侧无图标
    QCActionSheetRightIconTypeArrow,        // 右侧有向右箭头图标
    QCActionSheetRightIconTypeSelectMark    // 右侧有圆圈选中状态图标
};

typedef NS_ENUM(NSInteger, QCActionSheetBottomBarType) {
    QCActionSheetBottomBarTypeAuto,    // 自适应显示，有topBar则不显示BottomBar，否则显示不显示
    QCActionSheetBottomBarTypeShow,    // 强制显示底部栏，可以与顶部栏同时存在
    QCActionSheetBottomBarTypeHidden,  // 不显示底部栏，即使TopBar不存在也不显示底部栏
};

@interface QCActionSheetModel : NSObject

@property (assign, nonatomic) BOOL haveIcon;
@property (assign, nonatomic) BOOL allowsMultipleSelection;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) id icon;
@property (assign, nonatomic) QCActionSheetAlignment contentAlignment;
@property (assign, nonatomic) QCActionSheetRightIconType rightIconType;
@property (assign, nonatomic) BOOL selected;
@property (strong, nonatomic) id data;
@property (assign, nonatomic) NSInteger index;

@end

@interface QCActionSheetCell : UITableViewCell

@property (assign, nonatomic) BOOL showBottomLine; // default: NO
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *textFont;

- (void)refreshWithActionSheetModel:(QCActionSheetModel *)model;

@end

@interface QCActionSheet : QCCardContainerBaseService

#pragma mark - 功能，行为配置
/// 点击确定按钮，或者点击单选选项后自动退出页面，默认：YES
@property (assign, nonatomic) BOOL autoDismissWhenConfirm;

/// 允许下滑退出，默认NO，从底部弹出才有效
@property (assign, nonatomic) BOOL allowPanClose;

/// 使用自定义的Cell，完全自定义UI，默认：NO，置YES时，右上角显示确定按钮
@property (assign, nonatomic) BOOL isCustomCell;

/// 允许多选，不允许时，点击选项自动退出页面，默认：NO
@property (assign, nonatomic) BOOL allowsMultipleSelection;

/// 允许多选时，最少选中个数，默认：0
@property (assign, nonatomic) NSInteger minSelectCount;

/// 允许多选时，最多选中个数，默认：3
@property (assign, nonatomic) NSInteger maxSelectCount;

/// 选中数量超出最大，或者低于最少的回调
@property (copy, nonatomic) void(^selectBeyondLimitBlock)(NSInteger currentCount);

/// 返显当前选中的选项序号，0~...
@property (strong, nonatomic) NSArray<NSNumber *> *currentIndexs;

#pragma mark - 传入的选项卡为自定义Model时，需要设置以下回调
/// 获取自定义Model中用于显示选项的标题
@property (copy, nonatomic) NSString *(^getTitleBlock)(id customModel);

/// 获取自定义Model中用于显示选项的icon，可以是本地imageName，远程imageUrl，或者UIImage，无icon传入nil
@property (copy, nonatomic) id(^getIconBlock)(id customModel);

#pragma mark - 自定义Cell，不支持分组TableView
/// 注册自定义cell回调
@property (copy, nonatomic) void(^registerCells)(UITableView *tableView);

/// 返回自定义cell的数量，如果有传入options，则以options的数量为准，该回调可以不设置
@property (copy, nonatomic) NSInteger (^numbersOfRows)(UITableView *tableView, QCActionSheet *theSheet);

/// 返回自定义cell
@property (nonatomic, copy) UITableViewCell *(^cellForIndexPath)(UITableView *tableView, NSIndexPath *indexPath, id customModel, QCActionSheet *theSheet);

/// 返回cell的显示高度，不实现，默认：56pt
@property (copy, nonatomic) CGFloat (^heightForIndexPath)(UITableView *tableView, NSIndexPath *indexPath, QCActionSheet *theSheet);

/// 点击cell回调
@property (copy, nonatomic) void (^didSelectForIndexPath)(UITableView *tableView, NSIndexPath *indexPath, id customModel, QCActionSheet *theSheet);

#pragma mark - TopBar & BottomBar配置
/// 标题
@property (copy, nonatomic) NSString *title;
/// 左上角取消按钮标题，title不为空，或者allowsMultipleSelection=YES时有效，默认：YES
@property (assign, nonatomic) BOOL showCancelButton;
/// 底部栏行为描述，默认：QCActionSheetBottomBarTypeAuto
@property (assign, nonatomic) QCActionSheetBottomBarType bottomBarType;
/// 默认：取消
@property (copy, nonatomic) NSString *bottomBarTitle;
/// 默认：空
@property (strong, nonatomic) UIImage *bottomBarIcon;
/// 默认：#3C3C43,不透明85%
@property (strong, nonatomic) UIColor *bottomBarTintColor;
/// 默认：空
@property (copy, nonatomic) void (^onBottomBarTappedBlock)(QCActionSheet *theSheet);
/// 默认：4pt
@property (assign, nonatomic) CGFloat bottomBarTopSpace;
/// 自定义底部栏
@property (strong, nonatomic) UIView *customBottomBar;

#pragma mark - 选项显示样式配置
/// 选项内容对齐方式 默认QCActionSheetAlignmentNone
/// 若对齐方式为居中，且只显示标题，则会有分割线
@property (assign, nonatomic) QCActionSheetAlignment contentAlignment;

/// 文字颜色，默认：纯黑
@property (strong, nonatomic) UIColor *textColor;

/// 文字字体，默认：中黑15
@property (strong, nonatomic) UIFont *textFont;

/// 右侧图标类型，默认：QCActionSheetRightIconTypeNone
@property (assign, nonatomic) QCActionSheetRightIconType rightIconType;

#pragma mark - API
/// 显示actionSheet，底部默认有取消按钮
/// @param options 选项标题集合数组
/// @param icons 选项图标集合数组，可以是本地imageName，远程imageUrl，或者UIImage，无icon传入nil
/// @param setupBlock 其他属性设置
/// @param selectedBlock 选择完成回调
/// @param cancelBlock 击取消回调，isCancelButton区分点击按钮还是空白区域
+ (void)showActionSheetWithOptions:(NSArray *)options
                             icons:(NSArray *)icons
                        setupBlock:(void(^)(QCActionSheet *theSheet))setupBlock
                      selectAction:(void(^)(NSArray<NSNumber *> *indexs, NSArray<id> *options, QCActionSheet *theSheet))selectedBlock
                       cancelBlock:(void(^)(BOOL isCancelButton))cancelBlock;

/// 退出sheet
/// @param complete 退出完成回调
- (void)dismissComplete:(dispatch_block_t)complete;

/// 刷新数据
- (void)reloadData;

@end

/*
 // 1. 作为普通的ActionSheet使用
 NSArrary *options = @[@"仅删除当天", @"删除今天及未来的重复", @"删除全部重复"];
 [QCActionSheet showActionSheetWithOptions:options icons:nil setupBlock:nil selectAction:^(NSArray<NSNumber *> *indexs, NSArray<id> *options) {
    NSInteger index = indexs.firstObject.integerValue; // 获取index
 
 } cancelBlock:^(BOOL isCancelButton) {
 
 }];
 
 // 2. 显示icon+标题，并在右侧显示向右箭头
 NSArray *titleArray = @[@"模板管理",@"提醒设置",@"自定义背景",@"分享"];
 NSArray *iconArray = @[@"health_icon_divide",@"health_icon_remind",@"health_icon_wallpaper",@"health_icon_share"];
 kWeakSelf
 [QCActionSheet showActionSheetWithOptions:titleArray icons:iconArray setupBlock:^(QCActionSheet *actionSheet) {
    actionSheet.rightIconType = QCActionSheetRightIconTypeArrow; // 在右侧显示向右箭头
 } selectAction:^(NSArray<NSNumber *> *indexs, NSArray<id> *options) {
    NSInteger index = indexs.firstObject.integerValue; // 获取index
 } cancelBlock:nil];
 
 // 3. 显示icon+标题，并在右侧显示选中圈，支持返显
 NSArray *titleArray = @[@"重要且紧急",@"重要不紧急",@"紧急不重要",@"不重要不紧急"];
 NSArray *iconArray = @[@"sx_add_xx_1",@"sx_add_xx_2",@"sx_add_xx_3",@"sx_add_xx_4"];
 [QCActionSheet showActionSheetWithOptions:titleArray icons:iconArray setupBlock:^(QCActionSheet *actionSheet) {
    actionSheet.rightIconType = QCActionSheetRightIconTypeSelectMark; // 在右侧显示选中圈
    actionSheet.currentIndexs = @[@(1)]; // 设置当前选中的值返显
 } selectAction:^(NSArray<NSNumber *> *indexs, NSArray<id> *options) {
    NSInteger index = indexs.firstObject.integerValue; // 获取index
 } cancelBlock:nil];
 
 // 4. options为自定义Model，且在右侧显示选中圈
 NSArray<QCAppletModel *> *models = allAppList;
 [QCActionSheet showActionSheetWithOptions:models icons:nil setupBlock:^(QCActionSheet *actionSheet) {
    actionSheet.rightIconType = QCActionSheetRightIconTypeSelectMark; // 在右侧显示选中圈
    actionSheet.title = @"选择小程序"; // 设置顶部标题
    actionSheet.getTitleBlock = ^NSString *(QCAppletModel *customModel) {
        return customModel.appletName;
    }; // 获取model中的标题字段
    actionSheet.getIconBlock = ^id(QCAppletModel *customModel) {
        return customModel.appletIcon;
    }; // 获取标题中的icon字段
 } selectAction:^(NSArray<NSNumber *> *indexs, NSArray<id> *options) {
    NSInteger index = indexs.firstObject.integerValue; // 获取index
 } cancelBlock:nil];
 
 // 5. 自定义Cell，并且options为自定义Model
 NSArray<QCAppletModel *> *models = allAppList;
 [QCActionSheet showActionSheetWithOptions:models icons:nil setupBlock:^(QCActionSheet *actionSheet) {
    actionSheet.isCustomCell = YES;
    actionSheet.registerCells = ^(UITableView *tableView) {
        [tableView registerClass:[DRSmallProgramBaseWidgetCell class] forCellReuseIdentifier:[DRSmallProgramBaseWidgetCell cellIdentifier]];
    }
    actionSheet.cellForIndexPath = ^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath, id customModel, QCActionSheet *theSheet) {
        DRSmallProgramBaseWidgetCell *cell = [DRSmallProgramBaseWidgetCell new];
        cell.appModel = appModel;
        return cell;
    };
    actionSheet.heightForIndexPath = ^CGFloat(UITableView *tableView, NSIndexPath *indexPath, QCActionSheet *theSheet) {
        return 100;
    };
    actionSheet.didSelectForIndexPath = ^(UITableView *tableView, NSIndexPath *indexPath, id customModel, QCActionSheet *theSheet) {
        [theSheet dismissComplete:nil];
    };
 } selectAction:nil cancelBlock:nil];
 */
