//
//  QCAppletModel.h
//  Records
//
//  Created by 冯生伟 on 2019/12/9.
//  Copyright © 2019 DuoRong Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <DRPickerViews/DRUIWidgetUtil.h>
#import <JXExtension/JXExtension.h>
#import <Masonry/Masonry.h>
#import <DRCategories/DRCategories.h>
#import <BlocksKit/NSObject+BKAssociatedObjects.h>
#import <BlocksKit/NSObject+BKBlockObservation.h>

NS_ASSUME_NONNULL_BEGIN

#define DRADDNOTIFY(nameValue, methodValue) [[NSNotificationCenter defaultCenter] addObserver:self selector:methodValue name:nameValue object:nil];
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kWeakSelf __weak typeof(self) weakSelf = self;
#define DR_SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })

static const CGFloat DRGlobalAnimationDuration = 0.25;

typedef NSString * DRNotificationName NS_TYPED_ENUM;
UIKIT_EXTERN DRNotificationName const DRNotificationNameAccountLoginSucess;//账号登录成功
UIKIT_EXTERN DRNotificationName const DRNotificationNameDidChangeThemeNotification;
UIKIT_EXTERN DRNotificationName const DRFastAppletUpdateNotification; //课程课室
FOUNDATION_EXPORT NSString * const AFNetworkingReachabilityDidChangeNotification;

@interface QCAppletModel : NSObject

@property (assign, nonatomic) NSInteger appletId;
@property (copy, nonatomic) NSString *appletIcon;
@property (copy, nonatomic) NSString *appletFastIcon; // 快捷应用图标
@property (copy, nonatomic) NSString *appletName;
@property (copy, nonatomic) NSString *appletSubTitle;
@property (copy, nonatomic) NSString *appletType;
@property (copy, nonatomic) NSString *appletTypeName;
@property (assign, nonatomic) NSInteger subscribedSort;
@property (assign, nonatomic) NSInteger sort;
@property (copy, nonatomic) NSString *textColor; // 小程序名字颜色
@property (assign, nonatomic) BOOL defaulted;
@property (assign, nonatomic) BOOL subscribed;
@property (assign, nonatomic) BOOL state;
@property (copy, nonatomic) NSString *appletIntroduce;
@property (strong, nonatomic) NSArray *appletPreviewImgs;

@property (assign, nonatomic) BOOL unfold;
@property (assign, nonatomic) BOOL isDrag;//是否可以拖动
@property (assign, nonatomic) CGFloat cellHeight;//高度缓存
@property (assign, nonatomic) CGFloat imageHeight;//高度缓存
@property (strong, nonatomic) NSDictionary *widgetDetailData;

/**
 预览图
 */
@property (copy, nonatomic) NSString *appletFastPreviewImgs;

// 自定义属性
@property (assign, nonatomic) BOOL stateChanged;

@end


@interface QCThemeManager : NSObject

+ (instancetype)manager;
- (BOOL)isWithTheme;

@end

NS_ASSUME_NONNULL_END
