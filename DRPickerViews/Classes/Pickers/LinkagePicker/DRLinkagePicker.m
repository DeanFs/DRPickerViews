//
//  DRLinkagePicker.m
//  Records
//
//  Created by qing on 2019/11/20.
//  Copyright © 2019 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "DRLinkagePicker.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import <DRCategories/UIView+DRExtension.h>
#import <DRCategories/NSArray+DRExtension.h>
#import <DRUIWidgetKit/DRUIWidgetUtil.h>
#import <DRUIWidgetKit/DRSectionTitleView.h>
#import <DRUIWidgetKit/DRNormalDataPickerView.h>

@interface DRLinkagePicker ()

@property (weak, nonatomic) IBOutlet DRNormalDataPickerView *pickerView;
@property (weak, nonatomic) IBOutlet DRSectionTitleView *tipView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewTop;

@property (assign, nonatomic) NSUInteger currentUnitIndex;

@property (assign, nonatomic) NSUInteger currentValueIndex;

@end


@implementation DRLinkagePicker

- (CGFloat)pickerViewHeight {
    DRPickerLinkageOption *opt = (DRPickerLinkageOption *)self.pickerOption;
    if (opt.tipText.length > 0) {
        return 303;
    }
    self.tipViewTop.constant = 0;
    self.tipViewHeight.constant = 0;
    return [super pickerViewHeight];
}

- (void)prepareToShow {
    DRPickerLinkageOption *opt = (DRPickerLinkageOption *)self.pickerOption;
    if (opt.optionArray.count == 0) {
        return;
    }
    //数据构建
    self.currentUnitIndex = [opt.unitArray indexOfObject:opt.currentSelectUnit];
    
    NSArray *currentQuantityArray = [opt.optionArray safeGetObjectWithIndex:self.currentUnitIndex];
    self.pickerView.dataSource = @[currentQuantityArray,opt.unitArray];
    
    self.currentValueIndex = [currentQuantityArray indexOfObject:opt.currentSelectValue];
   
    self.pickerView.currentSelectedStrings = @[opt.currentSelectValue,opt.currentSelectUnit];
    self.pickerView.getSeparateTextBeforeSectionBlock = ^NSString *(NSInteger section) {
        return @"";
    };
    self.pickerView.getFontForSectionWithBlock = ^UIFont *(NSInteger section, NSInteger row) {
        return [UIFont dr_PingFangSC_RegularWithSize:20];
    };
    kDRWeakSelf
    self.pickerView.onSelectedChangeBlock = ^(NSInteger section, NSInteger index, NSString *selectedString) {
        if (section == 1) {
            if (index != weakSelf.currentUnitIndex) {
                weakSelf.currentUnitIndex = index;
                opt.currentSelectUnit = [opt.unitArray safeGetObjectWithIndex:weakSelf.currentUnitIndex];
                weakSelf.pickerView.dataSource = @[[opt.optionArray safeGetObjectWithIndex:index],opt.unitArray];
                [weakSelf.pickerView reloadData];
            }
        }else{
            opt.currentSelectValue = selectedString;
            weakSelf.currentValueIndex = index;
        }
    };
    self.pickerView.getWidthForSectionWithBlock = ^CGFloat(NSInteger section) {
        return 40;
    };
    self.pickerView.getTextAlignmentForSectionBlock = ^NSTextAlignment(NSInteger section) {
        return NSTextAlignmentCenter;
    };

    if (opt.tipText.length > 0) {
        self.tipView.title = opt.tipText;
    }
}

- (id)pickedObject {
    DRPickerLinkageOption *opt = (DRPickerLinkageOption *)self.pickerOption;
    DRPickerLinkagePickedObj *obj = [DRPickerLinkagePickedObj new];
    obj.currentSelectUnit = opt.currentSelectUnit;
    obj.selectUnitIndex = self.currentUnitIndex;
    obj.currentSelectValue = opt.currentSelectValue;
    obj.selectValueIndex = self.currentValueIndex;
    return obj;
}

- (Class)pickerOptionClass {
    return [DRPickerLinkageOption class];
}

@end
