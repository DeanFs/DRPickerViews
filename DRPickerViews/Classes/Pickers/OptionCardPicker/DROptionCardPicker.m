//
//  DROptionCardPicker.m
//  DRPickerViews_Example
//
//  Created by 冯生伟 on 2019/8/11.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DROptionCardPicker.h"
#import <DRUIWidgetKit/DRSectionTitleView.h>
#import <DRUIWidgetKit/DROptionCardView.h>

@interface DROptionCardPicker ()

@property (weak, nonatomic) IBOutlet DRSectionTitleView *sectionView;
@property (weak, nonatomic) IBOutlet DROptionCardView *optionCardView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scectionViewBottom;

@property (nonatomic, weak) DRPickerOptionCardOption *cardOption;

@end

@implementation DROptionCardPicker

- (Class)pickerOptionClass {
    self.cardOption = (DRPickerOptionCardOption *)self.pickerOption;
    return [DRPickerOptionCardOption class];
}

- (CGFloat)pickerViewHeight {
    CGFloat height = 80;
    NSInteger itemCount = self.cardOption.allOptions.count;
    NSInteger columnCount = self.cardOption.columnCount;
    NSInteger lineCount = itemCount / columnCount + (itemCount % columnCount > 0);
    if (lineCount > self.cardOption.lineCount) {
        lineCount = self.cardOption.lineCount;
        if (self.cardOption.showPageControl) {
            height += self.cardOption.pageControlHeight;
        }
    }
    height += (lineCount * self.optionCardView.lineHeight + (lineCount - 1) * 24);
    if (self.cardOption.sectionTip.length) {
        height += 50;
    } else {
        height += 30;
        self.sectionView.hidden = YES;
        self.sectionViewHeight.constant = 0;
        self.scectionViewBottom.constant = 18;
    }
    return height;
}

- (void)prepareToShow {
    if (self.cardOption.sectionTip.length) {
        self.sectionView.title = self.cardOption.sectionTip;
    }
    
    self.optionCardView.allOptions = self.cardOption.allOptions;
    if (self.cardOption.selectedIndexs.count) {
        self.optionCardView.selectedIndexs = self.cardOption.selectedIndexs;
    }
    if (self.cardOption.selectedOptions.count) {
        self.optionCardView.selectedOptions = self.cardOption.selectedOptions;
    }
    self.optionCardView.columnCount = self.cardOption.columnCount;
    self.optionCardView.lineCount = self.cardOption.lineCount;
    self.optionCardView.mutableSelection = self.cardOption.mutableSelection;
    self.optionCardView.maxSelectCount = self.cardOption.maxSelectCount;
    self.optionCardView.beyondMaxAlert = self.cardOption.beyondMaxAlert;
    self.optionCardView.minSelectCount = self.cardOption.minSelectCount;
    self.optionCardView.belowMinAlert = self.cardOption.belowMinAlert;
    self.optionCardView.columnSpace = self.cardOption.columnSpace;
    self.optionCardView.lineHeight = self.cardOption.lineHeight;
    self.optionCardView.fontSize = self.cardOption.fontSize;
    self.optionCardView.itemCornerRadius = self.cardOption.itemCornerRadius;
    self.optionCardView.showPageControl = self.cardOption.showPageControl;
    self.optionCardView.pageControlHeight = self.cardOption.pageControlHeight;
}

- (id)pickedObject {
    DRPickerOptionCardPickedObj *obj = [DRPickerOptionCardPickedObj new];
    obj.selectedIndexs = self.optionCardView.selectedIndexs;
    obj.selectedOptions = self.optionCardView.selectedOptions;
    return obj;
}

@end
