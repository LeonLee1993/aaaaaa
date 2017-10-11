//
//  RedPacketView.m
//  redPacketView
//
//  Created by paradise_ on 2017/9/18.
//  Copyright © 2017年 YJGX. All rights reserved.
//

#import "RedPacketView.h"
#import "UIView+LYCViewExtension.h"
#import "TradeDetailViewController.h"
@implementation RedPacketView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    _openImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/375*89,ScreenWidth/375*88.5)];
    _openImageView.image = [[UIImage imageNamed:@"开"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.tempImageView addSubview:_openImageView];
    self.openImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(makeRotate)];
    [self.openImageView addGestureRecognizer:tap];
}

-(void)setReturnMoneyStr:(NSString *)returnMoneyStr{
    _returnMoneyStr = returnMoneyStr;
    NSString * monneyStr = [NSString stringWithFormat:@"%@元",self.returnMoneyStr];
    
    NSMutableAttributedString *mutAtr = [[NSMutableAttributedString alloc]initWithString:monneyStr];
    [mutAtr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]} range:[monneyStr rangeOfString:@"元"]];
    self.tradeMoney.attributedText = mutAtr;
    
    
}


- (IBAction)seeDetailButtonClick:(id)sender {
    [self removeFromSuperview];
    self.seeDetailBlock();
}
- (IBAction)remove:(id)sender {
    [self removeFromSuperview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
//    if([self.openForeImageVIew cgre])
    if(!CGRectContainsPoint(self.openForeImageVIew.frame, point)){
        [self removeFromSuperview];
    }
}

+(instancetype)installRedPacketView{
    RedPacketView * redPacket = [RedPacketView viewFromXib];
    return redPacket;
}


- (void)makeRotate{
    
    [UIView  animateWithDuration:1 animations:^{
        self.openImageView.layer.transform=CATransform3DMakeRotation(M_PI, 0, 1,0);
    } completion:^(BOOL finished) {
        [self.tempImageView removeFromSuperview];
        [self.openImageView removeFromSuperview];
        self.openForeImageVIew.image = [UIImage imageNamed:@"开后"];
        self.tradeMoney.hidden = NO;
        self.seeDetailButton.hidden = NO;
    }];
    
}
    
@end
