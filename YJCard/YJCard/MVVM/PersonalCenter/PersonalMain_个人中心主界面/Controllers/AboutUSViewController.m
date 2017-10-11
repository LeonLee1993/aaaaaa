//
//  AboutUSViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/8/15.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//
#import <StoreKit/StoreKit.h>
#import "AboutUSViewController.h"

@interface AboutUSViewController () <SKStoreProductViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UIView *versionView;
@property (weak, nonatomic) IBOutlet UILabel *versionNumLabel;

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToScore)];
    [self.scoreView addGestureRecognizer:tap];
    self.versionNumLabel.text = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSLog(@"%@",[NSBundle mainBundle].infoDictionary);
}

- (void)goToScore{
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1280253603&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
}

- (void)openAppWithIdentifier:(NSString *)appId {
    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
    storeProductVC.delegate = self;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
    [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
        if (result) {
            [self presentViewController:storeProductVC animated:YES completion:nil];
        }
    }];
    
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
