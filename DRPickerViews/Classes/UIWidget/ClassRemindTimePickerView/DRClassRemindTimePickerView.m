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
    if (self.hourMinute.length == 4) {
        hourString = [self.hourMinute substringToIndex:2];
        minuteString = [self.hourMinute substringFromIndex:2];
    }

    self.pickerView.dataSource = @[dayList, @[@""], hourList, minuteList];
    self.pickerView.currentSelectedStrings = @[dayString, @"", hourString, minuteString];
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
        kDRWeakSelf
        DRNormalDataPickerView *pickerView = [[DRNormalDataPickerView alloc] init];
        pickerView.onSelectedChangeBlock = ^(NSInteger section, NSInteger index, NSString *selectedString) {
            if (section == 0) {
                weakSelf.isThisDay = (BOOL)index;
            } else if (section == 2) {
                weakSelf.hour = index;
            } else if (section == 3) {
                weakSelf.minute = index * weakSelf.timeScale;
            }
        };
        pickerView.getFontForSectionWithBlock = ^UIFont *(NSInteger section, NSInteger row) {
            if (section == 0) {
                return [UIFont dr_PingFangSC_RegularWithSize:17];
            }
            if (section == 1) {
                return [UIFont systemFontOfSize:6];
            }
            return [UIFont dr_PingFangSC_RegularWithSize:26];
        };
        pickerView.getWidthForSectionWithBlock = ^CGFloat(NSInteger section) {
            if (section == 1) {
                return 14;
            }
            return 60;
        };
        pickerView.getTextAlignmentForSectionBlock = ^NSTextAlignment(NSInteger section) {
            if (section == 0) {
                return NSTextAlignmentRight;
            }
            if (section == 2) {
                return NSTextAlignmentRight;
            }
            return NSTextAlignmentLeft;
        };
        pickerView.getSeparateTextBeforeSectionBlock = ^NSString *(NSInteger section) {
            if (section == 2) {
                return @"/";
            }
            return @"";
        };
        pickerView.getIsLoopForSectionBlock = ^BOOL(NSInteger section) {
            if (section == 0 || section == 1) {
                return NO;
            }
            return YES;
        };
        self.pickerView = pickerView;
        self.isThisDay = NO;

        [self addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_offset(0);
        }];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if (CGRectIsEmpty(rect)) {
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
