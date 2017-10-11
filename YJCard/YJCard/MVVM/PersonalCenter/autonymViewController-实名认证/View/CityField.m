//
//  CityField.m
//  06-注册界面
//
//  Created by xiaomage on 15/9/6.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//


//#import "Province.h"
#import "CityField.h"
#import "AutomyCityProvenModel.h"
@interface CityField () <UIPickerViewDataSource,UIPickerViewDelegate>

//@property (nonatomic, strong) NSMutableArray *provinces;

@property (nonatomic,strong) NSMutableArray * ZoneIDArr;

@property (nonatomic, weak) UIPickerView *pickerView;

@property (nonatomic,strong) NSMutableArray * provinceArr;

@end

@implementation CityField

// 初始化文字的方法
- (void)initialText
{
    [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
    
}

-(NSMutableArray *)ZoneIDArr{
    if(!_ZoneIDArr){
        _ZoneIDArr = @[].mutableCopy;
        NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"PandCity.plist" ofType:nil];
        // 2.根据filePath创建JSON数据
        NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:filePath1];
        NSArray * arr = dic[@"areas"];
        for (NSDictionary * diced  in arr) {
            AutomyCityProvenModel * model = [AutomyCityProvenModel yy_modelWithDictionary:diced];
            [_ZoneIDArr addObject:model];
        }
    }
    return _ZoneIDArr;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

//-(instancetype)initWithCoder:(NSCoder *)aDecoder{
//    if(self = [super initWithCoder:aDecoder]){
//        [self setUp];
//    }
//    return self;
//}

// 初始化
- (void)setUp
{
    self.tintColor = [UIColor blackColor];
    // 创建pickerView
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    
    _pickerView = pickerView;
    
    pickerView.dataSource = self;
    
    pickerView.delegate = self;
    
    pickerView.backgroundColor = [UIColor clearColor];
    // 自定义文本框键盘
    self.inputView = pickerView;
    
    _provinceArr = @[].mutableCopy;
    
    [self setProVinceAndCitys];
    
}


- (void)setProVinceAndCitys{
    for (AutomyCityProvenModel * model in self.ZoneIDArr) {
        if([model.ParentId isEqual:@(0)]){
            [_provinceArr addObject:model];
        }
    }
    
    for (AutomyCityProvenModel * Lmodel in _provinceArr) {
        NSMutableArray * citysArr = @[].mutableCopy;
        [self.ZoneIDArr enumerateObjectsUsingBlock:^(AutomyCityProvenModel  * model, NSUInteger idx, BOOL * _Nonnull stop) {
            if(model.ParentId == Lmodel.Id){
                [citysArr addObject:model];
            }
        }];
        Lmodel.citys = citysArr;
    }
    
    NSLog(@"%@",((AutomyCityProvenModel *)_provinceArr[0]).AreaName);
}


#pragma mark - 数据源方法
// PickerView 1列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(self.isCities){
        AutomyCityProvenModel *p =  self.provinceArr[_selProvinceIndex];
        return p.citys.count;
    }else{
        return self.provinceArr.count;
    }
}

// 返回每一行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
        if(self.isCities){
            AutomyCityProvenModel * p =  self.provinceArr[_selProvinceIndex];
            return ((AutomyCityProvenModel *)(p.citys[row])).AreaName;
        }else{
            AutomyCityProvenModel *p = self.provinceArr[row];
            return p.AreaName;
        }
}

// 选中某一行的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.isCities) { // 滚动的是城市
        // 获取选中的省
        AutomyCityProvenModel *p = self.provinceArr[_selProvinceIndex];
        // 获取选中的城市
        NSArray *cities = p.citys;
        // 获取第1列选中的行
        NSInteger cityIndex = [pickerView selectedRowInComponent:1];
        // 获取选中的城市
        NSString *cityName = ((AutomyCityProvenModel *)cities[cityIndex]).AreaName;
        // 给文本框赋值
        self.text = [NSString stringWithFormat:@"%@",cityName];
        
        if(_selProvinceIndex==0){//省份的那栏没有选择的时候在选择城市的时候给它赋值
            if(self.provinceSetBlock){
                self.provinceSetBlock();
            }
        }
        
        for (AutomyCityProvenModel *model in self.ZoneIDArr) {
            if([model.AreaName isEqualToString:cityName]){
                self.idStr = model.Id.stringValue;
                NSLog(@"%@",self.idStr);
            }
        }
        
    }else{
        
        AutomyCityProvenModel *p = self.provinceArr[row];
        for (AutomyCityProvenModel *model in self.ZoneIDArr) {
            if([model.AreaName isEqualToString:p.AreaName]){
                self.idStr = model.Id.stringValue;
            }
        }
        self.text = p.AreaName;
        
    }

    if(self.indexSelectdBlock){
        self.indexSelectdBlock(row);
    }
    
}

- (void)resetCity{
    // 获取选中的省
    AutomyCityProvenModel *p = self.provinceArr[_selProvinceIndex];
    // 获取选中的城市
    NSArray *cities = p.citys;
    // 获取选中的城市
    NSString *cityName = ((AutomyCityProvenModel *)cities[0]).AreaName;
    // 给文本框赋值
    self.text = [NSString stringWithFormat:@"%@",cityName];
    
    for (AutomyCityProvenModel *model in self.ZoneIDArr) {
        if([model.AreaName isEqualToString:cityName]){
            self.idStr = model.Id.stringValue;
        }
    }
}

- (void)resetIndex{
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        //设置为不可用
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
