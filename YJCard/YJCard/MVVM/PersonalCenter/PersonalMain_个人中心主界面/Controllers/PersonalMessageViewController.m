//
//  PersonalMessageViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/8/16.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "PersonalMessageViewController.h"

@interface PersonalMessageViewController ()

@end

@implementation PersonalMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setInfoDic:self.infoDic];
}

-(void)setInfoDic:(NSDictionary *)infoDic{
    _infoDic = infoDic;
    NSString *name = infoDic[@"realName"];
    self.name.text = name.length>0?infoDic[@"realName"]:@"";
    self.gender.text = [infoDic[@"gender"] isEqual:@(1)]?@"男":@"女";
    self.registTime.text = infoDic[@"registerDate"];
    self.birthDay.text = [infoDic[@"birthDate"] isKindOfClass:[NSNull class]] ? @"":infoDic[@"birthDate"];
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}


@end
