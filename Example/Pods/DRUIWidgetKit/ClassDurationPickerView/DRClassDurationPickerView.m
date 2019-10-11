//
//  DRClassDurationPickerView.m
//  BlocksKit
//
//  Created by 冯生伟 on 2019/10/11.
//

#import "DRClassDurationPickerView.h"
#import <Masonry/Masonry.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRCategories/UIFont+DRExtension.h>
#import "DRNormalDataPickerView.h"

@interface DRClassDurationPickerView ()

@property (weak, nonatomic) DRNormalDataPickerView *pickerView;
@property (nonatomic, strong) NSArray<NSString *> *classList;
@property (nonatomic, strong) NSArray<NSString *> *weekDayList;
@property (nonatomic, assign) BOOL didDrawRect;

@end

@implementation DRClassDurationPickerView

- (void)setupPickerView {
    NSString *currentWeekDay = self.weekDayList[self.weekDay-1];
    NSString *currentStartClass = self.classList[self.startClass-1];
    NSString *currentEndClass = self.classList[self.endClass-1];

    kDRWeakSelf
    self.pickerView.dataSource = @[self.weekDayList,
                                   self.classList,
                                   [self getEndClassList]];
    self.pickerView.currentSelectedStrings = @[currentWeekDay,
                                               currentStartClass,
                                               currentEndClass];
    self.pickerView.onSelectedChangeBlock = ^(NSInteger section, NSInteger index, NSString *selectedString) {
        if (section == 0) {
            weakSelf.weekDay = index + 1;
        } else if (section == 1) {
            weakSelf.startClass = index + 1;
            weakSelf.pickerView.dataSource = @[weakSelf.weekDayList,
                                               weakSelf.classList,
                                               [weakSelf getEndClassList]];
        } else {
            weakSelf.endClass = weakSelf.startClass + index;
        }
    };
    self.pickerView.getFontForSectionWithBlock = ^UIFont *(NSInteger section) {
        return [UIFont dr_PingFangSC_RegularWithSize:20];
    };
    self.pickerView.getSeparateTextBeforeSectionBlock = ^NSString *(NSInteger section) {
        if (section == 1) {
            return @"/";
        }
        return @"-";
    };
}

- (NSArray<NSString *> *)getEndClassList {
    NSInteger endLocation = self.startClass-1;
    NSInteger endLength = self.classList.count - self.startClass + 1;
    NSRange endRange = NSMakeRange(endLocation, endLength);
    return [self.classList subarrayWithRange:endRange];
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
        self.weekDayList = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
        NSMutableArray *classList = [NSMutableArray array];
        for (NSInteger i=1; i<18; i++) {
            [classList addObject:[NSString stringWithFormat:@"第%ld节", i]];
        }
        self.classList = classList;
        _startClass = 1;
        _endClass = 1;
        _weekDay = 1;

        DRNormalDataPickerView *picker = [[DRNormalDataPickerView alloc] init];
        [self addSubview:picker];
        [picker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_offset(0);
        }];
        self.pickerView = picker;
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

- (void)setStartClass:(NSInteger)startClass {
    if (![self isLegalClassIndex:startClass]) {
        return;
    }
    _startClass = startClass;

    if (self.didDrawRect) {
        [self setupPickerView];
    }
}

- (void)setEndClass:(NSInteger)endClass {
    if (![self isLegalClassIndex:endClass]) {
        return;
    }
    _endClass = endClass;

    if (self.didDrawRect) {
        [self setupPickerView];
    }
}

- (void)setWeekDay:(NSInteger)weekDay {
    if (![self isLegalWeekDay:weekDay]) {
        return;
    }
    _weekDay = weekDay;

    if (self.didDrawRect) {
        [self setupPickerView];
    }
}

- (BOOL)isLegalClassIndex:(NSInteger)class {
    return NSLocationInRange(class, NSMakeRange(1, self.classList.count+1));
}

- (BOOL)isLegalWeekDay:(NSInteger)weekDay {
    return NSLocationInRange(weekDay, NSMakeRange(1, self.weekDayList.count+1));
}

@end
