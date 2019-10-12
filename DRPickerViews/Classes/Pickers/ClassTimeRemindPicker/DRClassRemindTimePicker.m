//
//  DRClassRemindTimePicker.m
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/11.
//

#import "DRClassRemindTimePicker.h"
#import <DRUIWidgetKit/DRClassRemindTimePickerView.h>

@interface DRClassRemindTimePicker ()

@property (weak, nonatomic) IBOutlet DRClassRemindTimePickerView *pickerView;

@end

@implementation DRClassRemindTimePicker

- (void)prepareToShow {
    DRPickerClassRemindTimeOption *opt = (DRPickerClassRemindTimeOption *)self.pickerOption;
    self.pickerView.isThisDay = opt.isThisDay;
    self.pickerView.hour = opt.hour;
    self.pickerView.minute = opt.minute;
    self.pickerView.timeScale = opt.timeScale;
}

- (id)pickedObject {
    DRPickerClassRemindTimePickedObj *obj = [DRPickerClassRemindTimePickedObj new];
    obj.isThisDay = self.pickerView.isThisDay;
    obj.hour = self.pickerView.hour;
    obj.minute = self.pickerView.minute;
    obj.hourMinute = [NSString stringWithFormat:@"%02ld%02ld", obj.hour, obj.minute];
    return obj;
}

- (Class)pickerOptionClass {
    return [DRPickerClassRemindTimeOption class];
}

@end
