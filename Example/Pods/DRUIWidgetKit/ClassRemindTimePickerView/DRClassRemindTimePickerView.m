//
//  DRClassRemindTimePickerView.m
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/11.
//

#import "DRClassRemindTimePickerView.h"
#import <Masonry/Masonry.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import "DRNormalDataPickerView.h"

@interface DRClassRemindTimePickerView ()

@property (weak, nonatomic) DRNormalDataPickerView *pickerView;
@property (nonatomic, assign) BOOL didDrawRect;

@end

@implementation DRClassRemindTimePickerView

- (void)setupPickerView {
    NSArray *dayList = @[@"前一天",@"当天"];
    NSMutableArray *hourList = [NSMutableArray array];
    for (NSInteger i=0; i<24; i++) {
        [hourList addObject:[NSString stringWithFormat:@"%02ld", i]];
    }
    NSMutableArray *minuteList = [NSMutableArray array];
    for (NSInteger i=0; i<60; i+=self.timeScale) {
        [minuteList addObject:[NSString stringWithFormat:@"%02ld", i]];
    }

    NSString *dayString = dayList[(NSInteger)self.isThisDay];
    NSString *hourString = [NSString stringWithFormat:@"%02ld", self.hour];
    NSString *minuteString = [NSString stringWithFormat:@"%02ld", self.minute];

    self.pickerView.dataSource = @[dayList, @[@""], hourList, minuteList];
    self.pickerView.currentSelectedStrings = @[dayString, @"", hourString, minuteString];

    kDRWeakSelf
    self.pickerView.onSelectedChangeBlock = ^(NSInteger section, NSInteger index, NSString *selectedString) {
        if (section == 0) {
            weakSelf.isThisDay = (BOOL)index;
        } else if (section == 2) {
            weakSelf.hour = index;
        } else if (section == 3) {
            weakSelf.minute = index * weakSelf.timeScale;
        }
    };
    self.pickerView.getFontForSectionWithBlock = ^UIFont *(NSInteger section) {
        if (section == 0) {
            return [UIFont dr_PingFangSC_MediumWithSize:17];
        }
        if (section == 1) {
            return [UIFont systemFontOfSize:6];
        }
        return [UIFont dr_PingFangSC_RegularWithSize:26];
    };
    self.pickerView.getWidthForSectionWithBlock = ^CGFloat(NSInteger section) {
        if (section == 0) {
            return 100;
        }
        if (section == 1) {
            return 14;
        }
        return 60;
    };
    self.pickerView.getTextAlignmentForSectionBlock = ^NSTextAlignment(NSInteger section) {
        if (section == 0) {
            return NSTextAlignmentRight;
        }
        if (section == 2) {
            return NSTextAlignmentRight;
        }
        return NSTextAlignmentLeft;
    };
    self.pickerView.getSeparateTextBeforeSectionBlock = ^NSString *(NSInteger section) {
        if (section == 2) {
            return @"/";
        }
        return @"";
    };
    self.pickerView.getIsLoopForSectionBlock = ^BOOL(NSInteger section) {
        if (section == 0 || section == 1) {
            return NO;
        }
        return YES;
    };
}

#pragma mark - setup xib
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    if (!self.pickerView) {
        DRNormalDataPickerView *picker = [[DRNormalDataPickerView alloc] init];
        [self addSubview:picker];
        [picker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_offset(0);
        }];
        self.pickerView = picker;
        self.isThisDay = NO;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if (CGRectEqualToRect(rect, CGRectZero)) {
        return;
    }
    if (!self.didDrawRect) {
        self.didDrawRect = YES;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupPickerView];
        });
    }
}

@end
