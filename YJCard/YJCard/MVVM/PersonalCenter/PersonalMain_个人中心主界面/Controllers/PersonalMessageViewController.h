//
//  PersonalMessageViewController.h
//  YJCard
//
//  Created by paradise_ on 2017/8/16.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCBaseViewController.h"

@interface PersonalMessageViewController : LYCBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *birthDay;
@property (weak, nonatomic) IBOutlet UILabel *registTime;
@property (nonatomic,strong) NSDictionary * infoDic;
@end
