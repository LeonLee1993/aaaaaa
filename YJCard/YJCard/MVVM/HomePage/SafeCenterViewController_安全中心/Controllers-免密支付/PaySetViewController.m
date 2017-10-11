//
//  PaySetViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/8/4.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "PaySetViewController.h"
#import "IFPayWithCodeViewController.h"

@interface PaySetViewController ()
@property (weak, nonatomic) IBOutlet UIView *setNoPayCodeView;

@end

@implementation PaySetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToSet)];
    [self.setNoPayCodeView addGestureRecognizer:tap];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)goToSet{
    IFPayWithCodeViewController * ifNeed = [[IFPayWithCodeViewController alloc]init];
    [self.navigationController pushViewController:ifNeed animated:YES];
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
