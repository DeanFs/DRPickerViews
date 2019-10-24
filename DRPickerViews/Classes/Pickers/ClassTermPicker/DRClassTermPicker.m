//
//  DRClassTermPicker.m
//  DRPickerViews_Example
//
//  Created by 冯生伟 on 2019/10/11.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRClassTermPicker.h"
#import <DRUIWidgetKit/DRClassTermPickerView.h>
#import <DRMacroDefines/DRMacroDefines.h>

@interface DRClassTermPicker ()

@property (weak, nonatomic) IBOutlet DRClassTermPickerView *pickerView;

@end

@implementation DRClassTermPicker

- (Class)pickerOptionClass {
    return [DRPickerClassTermOption class];
}

- (void)prepareToShow {
    DRPickerClassTermOption *opt = (DRPickerClassTermOption *)self.pickerOption;
    self.pickerView.enterYear = opt.enterYear;
    self.pickerView.education = opt.education;
    self.pickerView.termCount = opt.termCount;
    self.pickerView.currentYear = opt.currentYear;
    self.pickerView.currentTerm = opt.currentTerm;
    self.pickerView.edudationSource = opt.edudationSource;
}

- (id)pickedObject {
    DRPickerClassTermPickedObj *obj = [DRPickerClassTermPickedObj new];
    obj.currentYear = self.pickerView.currentYear;
    obj.currentTerm = self.pickerView.currentTerm;
    return obj;
}

@end
