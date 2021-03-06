//
//  QCActionSheet.m
//  Records
//
//  Created by 冯生伟 on 2020/4/9.
//  Copyright © 2020 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "QCActionSheet.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <RegExCategories/RegExCategories.h>
#import <DRCategories/UITableView+DRExtension.h>
#import <DRCategories/UIFont+DRExtension.h>
#import <DRCategories/NSArray+DRExtension.h>
#import <Masonry/Masonry.h>
#import "DRUIWidgetUtil.h"

@implementation QCActionSheetModel

@end

@interface QCActionSheetCell ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIImageView *iconImageView;
@property (weak, nonatomic) UIImageView *rightImageView;
@property (weak, nonatomic) UIView *bottomLine;

@end

@implementation QCActionSheetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.showBottomLine = NO;
    }
    return self;
}

- (void)refreshWithActionSheetModel:(QCActionSheetModel *)model {
    if (self.titleLabel == nil) {
        [self setupViewWithModel:model];
    }
    self.titleLabel.text = model.title;
    if (model.icon != nil) {
        if ([model.icon isKindOfClass:[UIImage class]]) {
            self.iconImageView.image = (UIImage *)model.icon;
        } else if ([model.icon isKindOfClass:[NSString class]]) {
            if ([RX(@"^http") isMatch:(NSString *)model.icon]) {
                [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:(NSString *)model.icon]];
            } else {
                self.iconImageView.image = [UIImage imageNamed:(NSString *)model.icon];
            }
        }
    }
    if (model.rightIconType == QCActionSheetRightIconTypeSelectMark) {
        if (model.selected) {
            if (model.allowsMultipleSelection) {
                self.rightImageView.image = [self imageNamed:@"common_icon_chosen"];
            } else {
                self.rightImageView.image = [self imageNamed:@"common_icon_radio"];
            }
        } else {
            self.rightImageView.image = [self imageNamed:@"common_icon_unsel_black"];
        }
    }
}

- (void)setupViewWithModel:(QCActionSheetModel *)model {
    UIView *containerView = [[UIView alloc] init];
    [self.contentView addSubview:containerView];
    
    CGFloat horizontalPadding = 16;
    if (model.haveIcon) {
        horizontalPadding = 12;
    }
    if (model.contentAlignment == QCActionSheetAlignmentRight) {
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-horizontalPadding);
            make.top.bottom.mas_offset(0);
        }];
    } else if (model.contentAlignment == QCActionSheetAlignmentCenter) {
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_offset(0);
            make.top.bottom.mas_offset(0);
        }];
    } else {
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(horizontalPadding);
            make.top.bottom.mas_offset(0);
        }];
    }
    
    CGFloat titleLabelLeft = 0;
    CGFloat iconWidth = 24;
    if (model.haveIcon) {
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeCenter;
        iconView.clipsToBounds = YES;
        [containerView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(0);
            make.centerY.mas_offset(0);
            make.size.mas_equalTo(CGSizeMake(iconWidth, iconWidth));
        }];
        self.iconImageView = iconView;
        titleLabelLeft = iconWidth + 12;
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont dr_PingFangSC_MediumWithSize:15];
    titleLabel.textColor = [DRUIWidgetUtil normalColor];
    [containerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(titleLabelLeft);
        make.right.mas_offset(0);
        make.centerY.mas_offset(0);
    }];
    self.titleLabel = titleLabel;
    
    if (model.rightIconType != QCActionSheetRightIconTypeNone) {
        UIImageView *rightImageView = [[UIImageView alloc] init];
        rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        if (model.rightIconType == QCActionSheetRightIconTypeArrow) {
            rightImageView.image = [self imageNamed:@"common_icon_next_black"];
        }
        [self.contentView addSubview:rightImageView];
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-12);
            make.centerY.mas_offset(0);
            make.size.mas_equalTo(CGSizeMake(iconWidth, iconWidth));
        }];
        self.rightImageView = rightImageView;
    }
}

- (void)setShowBottomLine:(BOOL)showBottomLine {
    self.bottomLine.hidden = !showBottomLine;
}

- (void)setTextFont:(UIFont *)textFont {
    self.titleLabel.font = textFont;
}

- (void)setTextColor:(UIColor *)textColor {
    self.titleLabel.textColor = textColor;
}

- (UIImage *)imageNamed:(NSString *)imageName {
    return [DRUIWidgetUtil pngImageWithName:imageName
                                   inBundle:KDR_CURRENT_BUNDLE];
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [DRUIWidgetUtil borderColor];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        _bottomLine = line;
    }
    return _bottomLine;
}

@end

@interface QCActionSheet ()

@property (strong, nonatomic) NSMutableArray<QCActionSheetModel *> *dataSource;
@property (strong, nonatomic) NSMutableArray<QCActionSheetModel *> *selectedModels;
@property (copy, nonatomic) void(^selectionDoneBlock)(NSArray<NSNumber *> *indexs, NSArray<id> *options, QCActionSheet *theSheet);
@property (copy, nonatomic) void(^sheetCancelBlock) (BOOL isCancelButton);
@property (assign, nonatomic) BOOL showSeparatorLine;

@end

@implementation QCActionSheet

#pragma mark - API
/// 显示actionSheet，底部默认有取消按钮
/// @param options 选项标题集合数组
/// @param icons 选项图标集合数组，可以是本地imageName，远程imageUrl，或者UIImage，无icon传入nil
/// @param setupBlock 其他属性设置
/// @param selectedBlock 选择完成回调
/// @param cancelBlock 击取消回调，isCancelButton区分点击按钮还是空白区域
+ (void)showActionSheetWithOptions:(NSArray *)options
                             icons:(NSArray *)icons
                        setupBlock:(void(^)(QCActionSheet *actionSheet))setupBlock
                      selectAction:(void(^)(NSArray<NSNumber *> *indexs, NSArray<id> *options, QCActionSheet *theSheet))selectedBlock
                       cancelBlock:(void(^)(BOOL isCancelButton))cancelBlock {
    QCActionSheet *sheet = [QCActionSheet new];
    sheet.selectionDoneBlock = selectedBlock;
    sheet.sheetCancelBlock = cancelBlock;
    kDR_SAFE_BLOCK(setupBlock, sheet);
    [sheet setupWithOptions:options icons:icons];
    [QCCardContainerController showContainerWithService:sheet];
}

/// 退出sheet
/// @param complete 退出完成回调
- (void)dismissComplete:(dispatch_block_t)complete {
    [self.containerVc dismissComplete:complete];
}

/// 刷新数据
- (void)reloadData {
    [self.tableView reloadData];
}

/// 传入新的选项并刷新
- (void)reloadDataWithNewOptions:(NSArray *)newOptions
                        newIcons:(NSArray *)newIcons {
    [self setupWithOptions:newOptions icons:newIcons];
    [self.tableView reloadData];
}

#pragma mark - lifecycle
- (instancetype)init {
    self = [super init];
    if (self) {
        _dataSource = [NSMutableArray array];
        _autoDismissWhenConfirm = YES;
        _allowPanClose = NO;
        _isCustomCell = NO;
        _allowsMultipleSelection = NO;
        _minSelectCount = 0;
        _maxSelectCount = 3;
        _showCancelButton = YES;
        _bottomBarType = QCActionSheetBottomBarTypeAuto;
        _bottomBarTitle = @"取消";
        _bottomBarTintColor = [DRUIWidgetUtil cancelColor];
        _bottomBarTopSpace = 4;
        _alwaysShowConfirmButton = NO;
        _contentAlignment = QCActionSheetAlignmentNone;
        _textColor = [DRUIWidgetUtil normalColor];
        _textFont = [UIFont dr_PingFangSC_MediumWithSize:15];
        _rightIconType = QCActionSheetRightIconTypeNone;
        _showSeparatorLine = NO;
    }
    return self;
}

#pragma mark - overwrite
- (void)setupCardContainerViwContoller {
    kDRWeakSelf
    // top bar
    self.containerVc.leftButtonAutoHighlight = NO;
    self.containerVc.allowPanClose = self.allowPanClose;
    self.containerVc.autoDismissWhenRightButtonAction = self.autoDismissWhenConfirm;
    self.containerVc.alwaysBounceVertical = self.allowPanClose;
    self.containerVc.dismissWhenTouchSpaceBlock = ^BOOL{
        kDR_SAFE_BLOCK(weakSelf.sheetCancelBlock, NO);
        return YES;
    };
    BOOL showTopBar = NO;
    if (self.title != nil) {
        self.containerVc.title = self.title;
        showTopBar = YES;
    }
    if (self.allowsMultipleSelection || self.alwaysShowConfirmButton) {
        self.containerVc.onRightButtonTapBlock = ^{
            [weakSelf onConfirmAction];
        };
        showTopBar = YES;
    }
    if (showTopBar) {
        if (self.showCancelButton) {
            self.containerVc.onLeftButtonTapBlock = ^{
                [weakSelf.containerVc dismissComplete:^{
                    kDR_SAFE_BLOCK(weakSelf.sheetCancelBlock, YES);
                }];
            };
        } else {
            self.containerVc.leftButtonTitle = @""; // 隐藏取消按钮
        }
        if (self.confirmButtonTitle.length > 0) {
            self.containerVc.rightButtonTitle = self.confirmButtonTitle;
        }
    }
    
    if (self.bottomBarType == QCActionSheetBottomBarTypeShow ||
        (self.bottomBarType == QCActionSheetBottomBarTypeAuto && !showTopBar)) {
        self.containerVc.customBottomBar = self.customBottomBar;
        if (self.customBottomBar == nil) {
            self.containerVc.showBottomBar = YES;
            self.containerVc.bottomBarIcon = self.bottomBarIcon;
            self.containerVc.bottomBarTitle = self.bottomBarTitle;
            self.containerVc.bottomBarTopSpace = self.bottomBarTopSpace;
            self.containerVc.bottomBarTintColor = self.bottomBarTintColor;
            self.containerVc.onBottomBarTappedBlock = ^{
                if (weakSelf.onBottomBarTappedBlock == nil) {
                    [weakSelf.containerVc dismissComplete:^{
                        kDR_SAFE_BLOCK(weakSelf.sheetCancelBlock, YES);
                    }];
                } else {
                    kDR_SAFE_BLOCK(weakSelf.onBottomBarTappedBlock, weakSelf);
                }
            };
        }
    }
}

- (void)registerTableViewCells {
    if (self.isCustomCell) {
#if DEBUG
        if (self.registerCells == nil) {
            NSAssert(NO, @"请先注册Cells");
        }
#endif
        kDR_SAFE_BLOCK(self.registerCells, self.tableView);
    } else {
        [self.tableView registerClass:[QCActionSheetCell class] forCellReuseIdentifier:[QCActionSheetCell cellIdentifier]];
    }
}

- (BOOL)dismissWhenTouchSpace {
    kDR_SAFE_BLOCK(self.sheetCancelBlock, NO);
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isCustomCell) {
        if (self.numbersOfRows != nil) {
            return self.numbersOfRows(tableView, self);
        } else {
#if DEBUG
            NSAssert(NO, @"自定义cell未设置numbersOfRows回调");
#endif
            return 0;
        }
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isCustomCell) {
        UITableViewCell *cell = nil;
        if (self.cellForIndexPath != nil) {
            cell = self.cellForIndexPath(tableView, indexPath, self.dataSource[indexPath.row].data, self);
        } else {
#if DEBUG
            NSAssert(NO, @"自定义cell未设置cellForIndexPath回调");
#endif
        }
        if (cell != nil) {
            return cell;
        }
    }
    QCActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:[QCActionSheetCell cellIdentifier]];
    [cell refreshWithActionSheetModel:self.dataSource[indexPath.row]];
    cell.textColor = self.textColor;
    cell.textFont = self.textFont;
    cell.showBottomLine = (self.showSeparatorLine && indexPath.row < self.dataSource.count - 1);
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isCustomCell) {
        if (self.didSelectForIndexPath != nil) {
            self.didSelectForIndexPath(tableView, indexPath, self.dataSource[indexPath.row].data, self);
            return;
        }
    }
    QCActionSheetModel *model = self.dataSource[indexPath.row];
    kDRWeakSelf
    if (self.allowsMultipleSelection) {
        if (model.selected) { // 取消选中
            if (self.selectedModels.count > self.minSelectCount) {
                model.selected = NO;
                [self.selectedModels removeObject:model];
            } else {
                kDR_SAFE_BLOCK(self.selectBeyondLimitBlock, self.selectedModels.count);
            }
        } else { // 选中
            if (self.selectedModels.count < self.maxSelectCount) {
                model.selected = YES;
                [self.selectedModels addObject:model];
            } else {
                kDR_SAFE_BLOCK(self.selectBeyondLimitBlock, self.selectedModels.count);
            }
        }
        [tableView reloadData];
    } else {
        if (self.alwaysShowConfirmButton) {
            self.selectedModels.firstObject.selected = NO;
            [self.selectedModels removeAllObjects];
            [self.selectedModels addObject:model];
            model.selected = YES;
            [tableView reloadData];
        } else {
            if (self.autoDismissWhenConfirm) {
                [self.containerVc dismissComplete:^{
                    kDR_SAFE_BLOCK(weakSelf.selectionDoneBlock, @[@(indexPath.row)], @[model.data], weakSelf);
                }];
            } else {
                kDR_SAFE_BLOCK(self.selectionDoneBlock, @[@(indexPath.row)], @[model.data], self);
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isCustomCell) {
        if (self.heightForIndexPath != nil) {
            return self.heightForIndexPath(tableView, indexPath, self);
        }
    }
    return 56;
}

#pragma mark - private
- (void)setupWithOptions:(NSArray *)options
                   icons:(NSArray *)icons {
    [self.dataSource removeAllObjects];
    if (options.count == 0) {
        if (self.isCustomCell && self.numbersOfRows != nil) {
            NSInteger rows = self.numbersOfRows(self.tableView, self);
            if (rows > 0) {
                for (NSInteger i=0; i<rows; i++) {
                    [self.dataSource addObject:[QCActionSheetModel new]];
                }
                return;
            }
        }
#if DEBUG
        NSAssert(NO, @"可选项不能为空");
#endif
        return;
    }
    
    if (self.allowsMultipleSelection) {
        self.selectedModels = [NSMutableArray array];
    }
    
    NSMutableDictionary *selectedMap = [NSMutableDictionary dictionary];
    for (NSNumber *index in self.currentIndexs) {
        [selectedMap setObject:index forKey:index];
    }
    QCActionSheetAlignment alignment = self.contentAlignment;
    BOOL haveIcon = NO;
    if (alignment == QCActionSheetAlignmentNone) {
        alignment = QCActionSheetAlignmentCenter;
        if (icons.count > 0 || self.getIconBlock != nil) {
            haveIcon = YES;
            alignment = QCActionSheetAlignmentLeft;
        }
    }
    if (alignment == QCActionSheetAlignmentCenter &&
        self.contentAlignment == QCActionSheetAlignmentNone) {
        self.showSeparatorLine = YES;
    }
    
    for (NSInteger i=0; i<options.count; i++) {
        NSString *option = options[i];
        QCActionSheetModel *model = [QCActionSheetModel new];
        model.index = i;
        model.data = option;
        model.contentAlignment = alignment;
        model.rightIconType = self.rightIconType;
        model.haveIcon = haveIcon;
        model.icon = [icons safeGetObjectWithIndex:i];
        model.selected = ([selectedMap objectForKey:@(i)] != nil);
        model.allowsMultipleSelection = self.allowsMultipleSelection;
        if ([option isKindOfClass:[NSString class]]) {
            model.title = option;
        } else {
            if (self.getTitleBlock != nil) {
                model.title = self.getTitleBlock(option);
            }
            if (self.getIconBlock != nil) {
                id icon = self.getIconBlock(option);
                if (icon != nil) {
                    model.icon = icon;
                }
            }
        }
        if (model.selected) {
            [self.selectedModels addObject:model];
        }
        [self.dataSource addObject:model];
    }
}

- (void)onConfirmAction {
    NSMutableArray *indexs = [NSMutableArray array];
    NSMutableArray *options = [NSMutableArray array];
    for (QCActionSheetModel *model in self.selectedModels) {
        [indexs addObject:@(model.index)];
        [options addObject:model.data];
    }
    kDR_SAFE_BLOCK(self.selectionDoneBlock, indexs, options, self);
}

@end
