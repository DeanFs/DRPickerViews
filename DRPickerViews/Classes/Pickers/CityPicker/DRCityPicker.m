//
//  DRCityPicker.m
//  DRPickerViews_Example
//
//  Created by 冯生伟 on 2019/10/11.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRCityPicker.h"
#import "DRCityPickerView.h"

@interface DRCityPicker ()

@property (weak, nonatomic) IBOutlet DRCityPickerView *cityPickerView;

@end

@implementation DRCityPicker

- (void)prepareToShow {
    DRPickerCityOption *opt = (DRPickerCityOption *)self.pickerOption;
    if (opt.cityCode == nil) {
        self.cityPickerView.cityCode = -1;
    } else {
        self.cityPickerView.cityCode = opt.cityCode.integerValue;
    }
}

- (id)pickedObject {
    DRPickerCityPickedObj *obj = [DRPickerCityPickedObj new];
    obj.cityCode = self.cityPickerView.cityCode;
    obj.province = self.cityPickerView.province;
    obj.city = self.cityPickerView.city;
    return obj;
}

- (Class)pickerOptionClass {
    return [DRPickerCityOption class];
}

@end
