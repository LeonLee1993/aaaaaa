//
//  NeedCodeAndSetView.m
//  YJCard
//
//  Created by paradise_ on 2017/8/7.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "NeedCodeAndSetView.h"
#import "AppDelegate.h"

@implementation NeedCodeAndSetView

//-(void)awakeFromNib{
//    
//    [super awakeFromNib];
//}

-(void)showWithCenterPoint:(UIView *)centerView{
    
    self.frame = CGRectMake(0, 0, centerView.frame.size.width, centerView.frame.size.height);
    
    
//    UIImageView * imageView = [[UIImageView alloc]init];
//    imageView.image = [UIImage imageNamed:@"条码二维码"];
//    CGPoint point = self.center;
//    point.x -= 8 ;
//    point.y -= 8 ;
//    self.center = point;
    [centerView addSubview:self];
    /**  毛玻璃特效类型
     *  UIBlurEffectStyleExtraLight,
     *  UIBlurEffectStyleLight,
     *  UIBlurEffectStyleDark
     */
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    
//    //  毛玻璃视图
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    
//    //添加到要有毛玻璃特效的控件中
//    imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    [self insertSubview:imageView atIndex:0];
//    
//    //设置模糊透明度
//    effectView.alpha = 0.9f;
    
}

- (IBAction)setPWClicked:(id)sender {
    self.setPasswordBlock();
}

- (void)remove{
    [self removeFromSuperview];
}

@end
