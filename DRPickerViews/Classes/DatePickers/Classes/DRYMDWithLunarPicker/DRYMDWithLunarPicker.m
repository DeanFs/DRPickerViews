//
//  DRYMDWithLunarPicker.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/18.
//

#import "DRYMDWithLunarPicker.h"
#import "DRYMDWithLunarPickerMonthDayDataSource.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import "NSDate+DRExtension.h"

@interface DRYMDWithLunarPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *ignoreButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) DRYMDWithLunarPickerMonthDayDataSource *solarSource, *lunarSource, *solarMonthSource, *lunarMonthSource;
@property (nonatomic, strong) DRYMDWithLunarPickerMonthDayDataSource *dataSource;
@property (nonatomic, strong) NSDate *selectDate;

@end

@implementation DRYMDWithLunarPicker

+ (instancetype)loadPickerView {
    DRYMDWithLunarPicker *pickerView = [super pickerView];
    pickerView.pickerView.delegate = pickerView;
    pickerView.pickerView.dataSource = pickerView;
    pickerView.solarMonthSource = [DRYMDWithLunarPickerSolarDataSource new];
    pickerView.lunarMonthSource = [DRYMDWithLunarPickerLunarDataSource new];
    pickerView.solarSource = [DRYMDWithLunarPickerCanlendarSolarDataSource new];
    pickerView.lunarSource = [DRYMDWithLunarPickerCanlendarLunarDataSource new];

    return pickerView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (NSArray<DRYMDWithLunarPickerMonthDayDataSource *> *)dataSources {
    return @[self.solarMonthSource, self.lunarMonthSource, self.solarSource, self.lunarSource];
}

- (NSDate *)selectDate {
    if(_selectDate == nil) {
        _selectDate = [NSDate date];
    }
    
    return _selectDate;
}

- (DRYMDWithLunarPickerMonthDayDataSource *)dataSource {
    if(self.ignoreYear) {
        if(self.isLunar) {
            return self.lunarMonthSource;
        }else {
            return self.solarMonthSource;
        }
    }else {
        if(self.isLunar) {
            return self.lunarSource;
        }else {
            return self.solarSource;
        }
    }
}

/**
 生日时间设置选择器
 
 @param currentDate 反显当前日期，不忽略年份时的出生年月
 @param minDate 最小可选日期
 @param maxDate 最大可选日期
 @param month 忽略年份时的月
 @param day 忽略年份时的日
 @param ignoreYear 忽略年份
 @param isLunar 使用的是农历
 @param setupBlock 便于以后扩展参数的传入和初始化逻辑增加
 @param pickDoneBlock 选择完成回调
 */
+ (void)showWithCurrentDate:(NSDate *)currentDate
                    minDate:(NSDate *)minDate
                    maxDate:(NSDate *)maxDate
                      month:(NSInteger)month
                        day:(NSInteger)day
                 ignoreYear:(BOOL)ignoreYear
                    isLunar:(BOOL)isLunar
              pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                 setupBlock:(DRDatePickerSetupBlock)setupBlock {
    DRYMDWithLunarPicker *pickerView = [DRYMDWithLunarPicker loadPickerView];
    kDR_SAFE_BLOCK(setupBlock, pickerView);
    pickerView.pickDoneBlock = pickDoneBlock;
    [pickerView setupCurrentDate:currentDate minDate:minDate maxDate:maxDate];
    
    //显示选择的日期
    pickerView.segmentedControl.selectedSegmentIndex = isLunar ? 1 : 0;
    pickerView.ignoreButton.selected = ignoreYear;
    pickerView.selectDate = currentDate;
        
    if (ignoreYear) {
        pickerView.solarMonthSource.monthIndex = month - 1;
        pickerView.solarMonthSource.dayIndex = day - 1;
        pickerView.lunarMonthSource.monthIndex = month - 1;
        pickerView.lunarMonthSource.dayIndex = day - 1;
        [pickerView.solarMonthSource safeCheck];
        [pickerView.lunarMonthSource safeCheck];
    } else {
        [pickerView.dataSource resetIndexfromSolarDate:pickerView.selectDate];
        
        pickerView.solarMonthSource.monthIndex = pickerView.dataSource.monthIndex;
        pickerView.solarMonthSource.dayIndex = pickerView.dataSource.dayIndex;
        pickerView.lunarMonthSource.monthIndex = pickerView.dataSource.monthIndex;
        pickerView.lunarMonthSource.dayIndex = pickerView.dataSource.dayIndex;
    }
    
    [pickerView.solarMonthSource safeCheck];
    [pickerView.lunarMonthSource safeCheck];
    
    [pickerView selectedCurrentDateWithAnimated:false];
    
    [pickerView show];
}

/**
 限定公历时间范围选择时间，可选择农历，不可忽略年份
 由于农历数据限制，目前只支持1918-01-01 ~ 2099-12-31
 
 @param currentDate 当前公历日期
 @param minDate 最小可选日期
 @param maxDate 最大可选日期
 @param isLunar 是否反显农历
 @param pickDoneBlock 选择完成：selectedDate(公历日期) isLunar是否是农历
 @param setupBlock 便于以后扩展参数的传入和初始化逻辑增加
 */
+ (void)showWithCurrentDate:(NSDate *)currentDate
                    minDate:(NSDate *)minDate
                    maxDate:(NSDate *)maxDate
                    isLunar:(BOOL)isLunar
              pickDoneBlock:(DRDatePickerInnerDoneBlock)pickDoneBlock
                 setupBlock:(DRDatePickerSetupBlock)setupBlock {
    DRYMDWithLunarPicker *pickerView = [DRYMDWithLunarPicker loadPickerView];
    kDR_SAFE_BLOCK(setupBlock, pickerView);
    pickerView.pickDoneBlock = pickDoneBlock;
    [pickerView setupCurrentDate:currentDate minDate:minDate maxDate:maxDate];
    
    //显示选择的日期
    pickerView.segmentedControl.selectedSegmentIndex = isLunar ? 1 : 0;
    pickerView.ignoreButton.hidden = true;
    [pickerView.dataSource resetIndexfromSolarDate:pickerView.selectDate];
    
    pickerView.solarMonthSource.monthIndex = pickerView.dataSource.monthIndex;
    pickerView.solarMonthSource.dayIndex = pickerView.dataSource.dayIndex;
    pickerView.lunarMonthSource.monthIndex = pickerView.dataSource.monthIndex;
    pickerView.lunarMonthSource.dayIndex = pickerView.dataSource.dayIndex;
    
    [pickerView.solarMonthSource safeCheck];
    [pickerView.lunarMonthSource safeCheck];
    
    [pickerView selectedCurrentDateWithAnimated:false];
    
    [pickerView show];
}

- (void)setupCurrentDate:(NSDate *)currentDate
                 minDate:(NSDate *)minDate
                 maxDate:(NSDate *)maxDate {
    self.currentDate = currentDate;
    self.minDate = minDate;
    self.maxDate = maxDate;
    [self dateLegalCheck];
    
    self.selectDate = self.currentDate;
    for(DRYMDWithLunarPickerMonthDayDataSource *source in self.dataSources) {
        source.minDate = self.minDate;
        source.maxDate = self.maxDate;
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.dataSource.column;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataSource rowForComponent:component];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    return [self.dataSource titleForComponent:component row:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (!self.ignoreYear) {
        if (component == 0) {
            return 140.0;
        } else {
            return (kDRScreenWidth - 140.0) / 2 - 10;
        }
    } else {
        return 100.0;
    }
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(self.dataSource.ignoreYear) {
        switch (component) {
            case 0: {
                self.dataSource.monthIndex = row;
                self.solarMonthSource.monthIndex = row;
                self.lunarMonthSource.monthIndex = row;
                [self.solarMonthSource safeCheck];
                [self.lunarMonthSource safeCheck];
                [pickerView reloadComponent:1];
            }
                break;
            case 1: {
                self.dataSource.dayIndex = row;
                self.solarMonthSource.dayIndex = row;
                self.lunarMonthSource.dayIndex = row;
                [self.solarMonthSource safeCheck];
                [self.lunarMonthSource safeCheck];
            }
                break;
            default:
                break;
        }
    }else {
        switch (component) {
            case 0: {
                self.dataSource.yearIndex = row;
                [pickerView reloadComponent:1];
                [pickerView selectRow:self.dataSource.monthIndex inComponent:1 animated:NO];
                [pickerView reloadComponent:2];
                [pickerView selectRow:self.dataSource.dayIndex inComponent:2 animated:NO];
            }
                break;
            case 1: {
                self.dataSource.monthIndex = row;
                self.solarMonthSource.monthIndex = row;
                self.lunarMonthSource.monthIndex = row;
                [self.solarMonthSource safeCheck];
                [self.lunarMonthSource safeCheck];
                [pickerView reloadComponent:2];
                [pickerView selectRow:self.dataSource.dayIndex inComponent:2 animated:NO];
            }
                break;
            case 2: {
                self.dataSource.dayIndex = row;
                self.solarMonthSource.dayIndex = row;
                self.lunarMonthSource.dayIndex = row;
                [self.solarMonthSource safeCheck];
                [self.lunarMonthSource safeCheck];
            }
                break;
            default:
                break;
        }
        
        self.selectDate = self.dataSource.date;
    }
}

#pragma mark - Event Response
- (IBAction)ignoreYearAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if(!self.dataSource.ignoreYear) {
        [self.dataSource resetIndexfromSolarDate:self.selectDate];
    }
    
    [self.pickerView reloadAllComponents];
    [self selectedCurrentDateWithAnimated:NO];
}

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    [self.pickerView reloadAllComponents];
    
    if(!self.dataSource.ignoreYear) {
        [self.dataSource resetIndexfromSolarDate:self.selectDate];
        
        
        self.solarMonthSource.monthIndex = self.dataSource.monthIndex;
        self.solarMonthSource.dayIndex = self.dataSource.dayIndex;
        self.lunarMonthSource.monthIndex = self.dataSource.monthIndex;
        self.lunarMonthSource.dayIndex = self.dataSource.dayIndex;
        
        [self.solarMonthSource safeCheck];
        [self.lunarMonthSource safeCheck];
    }
    
    [self selectedCurrentDateWithAnimated:NO];
}

- (id)pickedObject {
    DRYMDWithLunarPickerOutputObject *obj = [[DRYMDWithLunarPickerOutputObject alloc] init];
    obj.isLunar = [self isLunar];
    obj.ignoreYear = [self ignoreYear];
    
    if(self.dataSource.ignoreYear) {
        NSString *monthTitle = [self.dataSource titleForComponent:0 row:self.dataSource.monthIndex];
        NSString *dayTitle = [self.dataSource titleForComponent:1 row:self.dataSource.dayIndex];
        obj.month = [NSString stringWithFormat:@"%ld", self.dataSource.monthIndex + 1];
        obj.day = [NSString stringWithFormat:@"%ld", self.dataSource.dayIndex + 1];
        obj.title = [NSString stringWithFormat:@"%@%@", monthTitle, dayTitle];
        
    } else {
        obj.date = self.dataSource.date.midnight;
    }
    return obj;
}

#pragma mark - Private Method
- (void)selectedCurrentDateWithAnimated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pickerView reloadAllComponents];
        
        if (self.ignoreYear) {
            [self.pickerView selectRow:self.dataSource.monthIndex inComponent:0 animated:animated];
            [self.pickerView selectRow:self.dataSource.dayIndex inComponent:1 animated:animated];
        } else {
            [self.pickerView selectRow:self.dataSource.yearIndex inComponent:0 animated:animated];
            [self.pickerView selectRow:self.dataSource.monthIndex inComponent:1 animated:animated];
            [self.pickerView selectRow:self.dataSource.dayIndex inComponent:2 animated:animated];
        }
    });
}

#pragma mark - Property Method
- (BOOL)ignoreYear {
    return self.ignoreButton.selected;
}

- (BOOL)isLunar {
    return self.segmentedControl.selectedSegmentIndex == 1;
}

@end
