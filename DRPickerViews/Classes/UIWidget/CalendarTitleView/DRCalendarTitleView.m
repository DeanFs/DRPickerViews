//
//  DRCalendarTitleView.m
//  DRUIWidgetLibrary_Example
//
//  Created by 冯生伟 on 2019/7/31.
//  Copyright © 2019 Dean_F. All rights reserved.
//

#import "DRCalendarTitleView.h"
#import <Masonry/Masonry.h>
#import <DRMacroDefines/DRMacroDefines.h>
#import "DRUIWidgetUtil.h"
#import <DRCategories/NSDate+DRExtension.h>
#import <BlocksKit/UIView+BlocksKit.h>
#import "DRYearMonthPicker.h"

@interface DRCalendarTitleView ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UIImageView *leftMarkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightMarkImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (nonatomic, strong) NSDate *minMonth;
@property (nonatomic, strong) NSDate *maxMonth;
@property (nonatomic, strong) NSCalendar *calendar;

@end

@implementation DRCalendarTitleView

- (void)setupWithCurrentMonth:(NSDate *)currentMonth
                     minMonth:(NSDate *)minMonth
                     maxMonth:(NSDate *)maxMonth {
    self.minMonth = minMonth.firstDayInThisMonth.midnight;
    self.maxMonth = maxMonth.lastDayInThisMonth.endOfDate;
    self.currentMonth = currentMonth;
}

- (void)setCurrentMonth:(NSDate *)currentMonth {
    _currentMonth = currentMonth;
    NSString *title;
    if (currentMonth.isThisYear) {
        title = [currentMonth dateStringFromFormatterString:@"MM"];
    } else {
        title = [currentMonth dateStringFromFormatterString:@"yyyy/MM"];
    }
    [UIView performWithoutAnimation:^{
        [self.titleButton setTitle:title
                          forState:UIControlStateNormal];
        [self.titleButton layoutIfNeeded];
    }];
    
    NSComparisonResult result = [self.calendar compareDate:currentMonth toDate:self.minMonth toUnitGranularity:NSCalendarUnitMonth];
    if (result == NSOrderedAscending || result == NSOrderedSame) {
        self.leftMarkImageView.hidden = YES;
    } else {
        self.leftMarkImageView.hidden = NO;
    }
    
    result = [self.calendar compareDate:currentMonth toDate:self.maxMonth toUnitGranularity:NSCalendarUnitMonth];
    if (result == NSOrderedDescending || result == NSOrderedSame) {
        self.rightMarkImageView.hidden = YES;
    } else {
        self.rightMarkImageView.hidden = NO;
    }
}

- (void)setFontSize:(CGFloat)fontSize {
    self.titleButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)setShowBottomLine:(BOOL)showBottomLine {
    self.bottomLine.hidden = !showBottomLine;
}

- (void)setWillShowYearMonthPickerBlock:(dispatch_block_t)willShowYearMonthPickerBlock {
    _willShowYearMonthPickerBlock = willShowYearMonthPickerBlock;
    if (willShowYearMonthPickerBlock) {
        self.titleButton.enabled = YES;
    }
}

- (void)setOnYearMonthChangeBlock:(void (^)(NSDate *))onYearMonthChangeBlock {
    _onYearMonthChangeBlock = onYearMonthChangeBlock;
    if (onYearMonthChangeBlock) {
        self.titleButton.enabled = YES;
    }
}

#pragma mark - actions
- (IBAction)onTitleButtonAction:(id)sender {
    kDRWeakSelf
    if (self.willShowYearMonthPickerBlock) {
        self.willShowYearMonthPickerBlock();
    } else {
        DRPickerDateOption *opt = [DRPickerDateOption optionWithTitle:@"选择日期" currentDate:self.currentMonth minDate:self.minMonth maxDate:self.maxMonth];
        [DRYearMonthPicker showPickerViewWithOption:opt setupBlock:nil pickDoneBlock:^BOOL(DRBaseAlertPicker *picker, id pickedObject) {
            weakSelf.currentMonth = (NSDate *)pickedObject;
            kDR_SAFE_BLOCK(weakSelf.onYearMonthChangeBlock, weakSelf.currentMonth);
            return YES;
        }];
    }
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
    if (!self.containerView) {
        self.containerView = kDR_LOAD_XIB_NAMED(NSStringFromClass([self class]));
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_offset(0);
        }];
        
        [self.titleButton setTitleColor:[DRUIWidgetUtil normalColor] forState:UIControlStateNormal];
        self.showBottomLine = YES;
        self.fontSize = 13;
        
        kDRWeakSelf
        [self.leftMarkImageView bk_whenTapped:^{
            weakSelf.currentMonth = weakSelf.currentMonth.lastMonth;
            kDR_SAFE_BLOCK(weakSelf.onYearMonthChangeBlock, weakSelf.currentMonth);
        }];
        
        [self.rightMarkImageView bk_whenTapped:^{
            weakSelf.currentMonth = weakSelf.currentMonth.nextMonth;
            kDR_SAFE_BLOCK(weakSelf.onYearMonthChangeBlock, weakSelf.currentMonth);
        }];
    }
}

#pragma mark - lazy load
- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        [_calendar setTimeZone:[NSTimeZone defaultTimeZone]];
    }
    return _calendar;
}

@end
