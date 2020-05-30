//
//  QCAppletModel.m
//  Records
//
//  Created by 冯生伟 on 2019/12/9.
//  Copyright © 2019 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "QCAppletModel.h"

DRNotificationName const DRNotificationNameAccountLoginSucess = @"DRNotificationNameAccountLoginSucess";//账号登录成功
DRNotificationName const DRNotificationNameDidChangeThemeNotification = @"DRNotificationNameDidChangeThemeNotification";
DRNotificationName const DRFastAppletUpdateNotification = @"DRFastAppletUpdateNotification";
NSString * const AFNetworkingReachabilityDidChangeNotification = @"com.alamofire.networking.reachability.change";

@implementation QCAppletModel


@end


@implementation QCThemeManager

+ (instancetype)manager {
    static QCThemeManager *manger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manger = [QCThemeManager new];
    });
    return manger;
}

- (BOOL)isWithTheme {
    return YES;
}

@end
