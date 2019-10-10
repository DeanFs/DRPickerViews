//
//  JXAlertContainerView.h
//  JXExtension
//
//  Created by Jeason on 2017/8/2.
//  Copyright © 2017年 Jeason. All rights reserved.
//

#import "JXView.h"

@interface JXAlertContainerView : JXView

- (void)popToShow;
- (void)popToDismiss;
- (void)popToDismissWithRemove:(BOOL)remove;

@end
