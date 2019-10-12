//
//  DRClassDurationPicker.m
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/11.
//

#import "DRClassDurationPicker.h"
#import <DRUIWidgetKit/DRClassDurationPickerView.h>

@interface DRClassDurationPicker ()

@property (weak, nonatomic) IBOutlet DRClassDurationPickerView *pickerView;

@end

@implementation DRClassDurationPicker

- (void)prepareToShow {
    DRPickerClassDurationOption *opt = (DRPickerClassDurationOption *)self.pickerOption;
    self.pickerView.weekDay = opt.weekDay;
    self.pickerView.startClass = opt.startClass;
    self.pickerView.endClass = opt.endClass;
}

- (id)pickedObject {
    DRPickerClassDurationPickedObj *obj = [DRPickerClassDurationPickedObj new];
    obj.weekDay = self.pickerView.weekDay;
    obj.startClass = self.pickerView.startClass;
    obj.endClass = self.pickerView.endClass;
    return obj;
}

- (Class)pickerOptionClass {
    return [DRPickerClassDurationOption class];
}

@end
