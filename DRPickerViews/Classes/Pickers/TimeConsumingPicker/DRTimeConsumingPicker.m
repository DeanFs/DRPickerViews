//
//  DRTimeConsumingPicker.m
//  AFNetworking
//
//  Created by 冯生伟 on 2019/4/26.
//

#import "DRTimeConsumingPicker.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIView+DRExtension.h>
#import <DRCategories/UIFont+DRExtension.h>
#import <DRUIWidget/DRUIWidgetUtil.h>
#import <DRUIWidget/DRTimeConsumePickerView.h>

@interface DRTimeConsumingPicker ()

@property (weak, nonatomic) IBOutlet DRTimeConsumePickerView *pickerView;

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) BOOL haveShow;

@end

@implementation DRTimeConsumingPicker

- (void)prepareToShow {
    DRPickerTimeConsumingOption *option = (DRPickerTimeConsumingOption *)self.pickerOption;
    self.pickerView.timeScale = option.timeScale;
    self.pickerView.maxTimeConsume = option.maxTimeConsume;
    self.pickerView.currentTimeConsume = option.timeConsuming / 60;
}

- (Class)pickerOptionClass {
    return [DRPickerTimeConsumingOption class];
}

#pragma mark - actions
- (id)pickedObject {
    NSInteger day = self.pickerView.day;
    NSInteger hour = self.pickerView.hour;
    NSInteger minute = self.pickerView.minute;

    NSMutableString *timeString = [NSMutableString string];
    if (day > 0) {
        [timeString appendFormat:@"%ld天", day];
    }
    if (hour > 0) {
        [timeString appendFormat:@"%ld小时", hour];
    }
    if (minute > 0) {
        [timeString appendFormat:@"%ld分钟", minute];
    }
    if (timeString.length == 0) {
        [timeString appendFormat:@"0分钟"];
    }
    int64_t duration = day * 86400 + hour * 3600 + minute * 60;
    
    return [DRPickerTimeConsumingPickedObj objWithTimeConsuming:duration
                                                       timeDesc:timeString];
}

@end
