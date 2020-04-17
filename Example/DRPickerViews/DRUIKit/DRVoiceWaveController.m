//
//  DRVoiceWaveController.m
//  DRUIWidget_Example
//
//  Created by Cyfuer on 2019/10/8.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRVoiceWaveController.h"
#import <SCSiriWaveformView.h>

@interface DRVoiceWaveController ()
/**
    设置计时器
    */
@property (nonatomic, strong) dispatch_source_t timer;
@property (weak, nonatomic) IBOutlet SCSiriWaveformView *waveView;
@end

@implementation DRVoiceWaveController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTimers];
}
   
    

/**
 初始化计时器， 一般放到页面进入时 viewdidAppear
 */
- (void)initTimers {
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.03 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        [self.waveView updateWithLevel:arc4random()%30 * 0.002f+0.5];
    });
    dispatch_resume(timer);
    self.timer = timer;
}

/**
 使计时器失效， 需要在页面退出时，一般放到didDisappear中
 */
- (void)invalidateTimer {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

@end
