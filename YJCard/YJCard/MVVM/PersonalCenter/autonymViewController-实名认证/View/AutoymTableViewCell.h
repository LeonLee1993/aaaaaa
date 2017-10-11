//
//  AutoymTableViewCell.h
//  YJCard
//
//  Created by paradise_ on 2017/7/20.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CityField;
@interface AutoymTableViewCell : UITableViewCell
//城市
@property (weak, nonatomic) IBOutlet CityField *secondCityField;
//省份
@property (weak, nonatomic) IBOutlet CityField *firstCityField;
//姓名 TF
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
//ID TF
@property (weak, nonatomic) IBOutlet UITextField *IdTF;

@property (nonatomic,strong) UIView * dissmissView;
@end
