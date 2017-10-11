//
//  TotalAssetViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/7/18.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "TotalAssetViewController.h"
#define totolAnimationTime 1.2
@interface TotalAssetViewController ()

@end

@implementation TotalAssetViewController{
    CGFloat UserTotalMoneyAmount;
    CGFloat UserTotalCashAmount;
    CGFloat UserTotalRebateAmount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getUsetAssetInfo];
    [self drawTopShape];//
    [self drawArcShape];//下面的绿色环
    [self setAnimationLayers];
}


- (void)getUsetAssetInfo{
    NSDictionary * infoDic = [[NSUserDefaults standardUserDefaults] objectForKey:UserAsset];
    
    UserTotalMoneyAmount =  [self floatWithRMBString:infoDic[UserTotalMoney]];//总金额
    UserTotalCashAmount = [self floatWithRMBString:infoDic[UserTotalCash]];//现金
    UserTotalRebateAmount = [self floatWithRMBString:infoDic[UserTotalRebate]];//积分
    
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",infoDic[UserTotalMoney]]];
    
    self.totalMoneyLabel1.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",infoDic[UserTotalMoney]]];
    
    self.totalCashLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",infoDic[UserTotalCash]]];
    
    self.cashLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",infoDic[UserTotalCash]]];
    
    self.rebateLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",infoDic[UserTotalRebate]]];
    
    self.rebateLabel1.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",infoDic[UserTotalRebate]]];
    
}

- (void)drawTopShape{
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(ScreenWidth, 0)];
    [path addLineToPoint:CGPointMake(ScreenWidth, ScreenWidth*175/360)];
    [path addLineToPoint:CGPointMake(0, ScreenWidth*220/360)];
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path.CGPath;
    [layer setFillColor:RGBColor(66, 189, 86).CGColor];
    [self.view.layer insertSublayer:layer atIndex:0];
}

- (void)drawArcShape{
    //下面的背景绿
    CGPoint point = CGPointZero;
    point.y = ScreenHeight * 367 / 640;
    point.x = ScreenWidth / 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:65.0 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path.CGPath;
    layer.lineWidth = 20;
    layer.strokeColor = MainColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.shadowRadius = 10;
    layer.shadowOpacity = 0.2;
    layer.shadowOffset = CGSizeMake(3, 3);
    layer.shadowColor = MainColor.CGColor;
    [self.view.layer insertSublayer:layer atIndex:0];
}

- (void)setAnimationLayers{
    
    CGPoint point = CGPointZero;
    point.y = ScreenHeight * 367 / 640;
    point.x = ScreenWidth / 2;
    
    CGFloat endAngle = UserTotalRebateAmount / UserTotalMoneyAmount * 2.00 * M_PI;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:65.0 startAngle:-M_PI_2 endAngle:-M_PI_2+(endAngle) clockwise:YES];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.path = path.CGPath;
    layer.lineWidth = 20;
    layer.strokeColor = RGBColor(255,152,0).CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    [self.view.layer insertSublayer:layer atIndex:1];
    
    CABasicAnimation * animation = [[CABasicAnimation alloc]init];
    animation.keyPath = @"strokeEnd";
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.duration = UserTotalRebateAmount*totolAnimationTime/UserTotalMoneyAmount;
    [layer addAnimation:animation forKey:@"first"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animation.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:point radius:65.0 startAngle:(endAngle) - M_PI_2 endAngle:M_PI *2 - M_PI_2 clockwise:YES];
        
        CAShapeLayer *layer1 = [[CAShapeLayer alloc]init];
        layer1.path = path1.CGPath;
        layer1.lineWidth = 20;
        layer1.strokeColor = RGBColor(255,235,56).CGColor;
        layer1.fillColor = [UIColor clearColor].CGColor;
        [self.view.layer insertSublayer:layer1 atIndex:1];
        
        CABasicAnimation * animation1 = [[CABasicAnimation alloc]init];
        animation1.keyPath = @"strokeEnd";
        animation1.fromValue = @(0);
        animation1.toValue = @(1);
        animation1.duration = (UserTotalCashAmount/UserTotalMoneyAmount)*totolAnimationTime;
        
        [layer1 addAnimation:animation1 forKey:@"seconde"];
        
    });
    
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)floatWithRMBString:(NSString *)rmbString{
    NSArray * tempArr = [rmbString componentsSeparatedByString:@"."];
    NSString *preStr = tempArr[0];
    NSArray * componentArr = [preStr componentsSeparatedByString:@","];
    NSMutableString * mutStr = [[NSMutableString alloc]init];
    for (NSString *str in componentArr) {
        [mutStr appendString:str];
    }
    return mutStr.floatValue;
}

@end
