//
//  CityField.h
//  06-注册界面
//
//  Created by xiaomage on 15/9/6.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^selectedIndexBlock)(NSInteger);
typedef void (^setProvinceBlock)();
@interface CityField : UITextField
- (void)initialText;

@property (nonatomic,assign) NSInteger selProvinceIndex;

@property (nonatomic,copy) selectedIndexBlock indexSelectdBlock;

@property (nonatomic,copy) setProvinceBlock provinceSetBlock;

@property (nonatomic,assign) BOOL isCities;

- (void)resetCity;

- (void)resetIndex;

@property (nonatomic,strong) NSString * idStr;

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end
