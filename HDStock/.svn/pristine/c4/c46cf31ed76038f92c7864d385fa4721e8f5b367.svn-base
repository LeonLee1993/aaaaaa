//
//  PSYRefreshGifFooter.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/19.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PSYRefreshGifFooter.h"

@implementation PSYRefreshGifFooter

- (void)prepare{
    
    [super prepare];
    
    CGSize size = CGSizeMake(37, 37);
    
    self.gifView.image = [[UIImage sd_animatedGIFNamed:@"motion"]sd_animatedImageByScalingAndCroppingToSize:size];
    
//    UIImage * image1 = [imageNamed(@"logo_penqi_1")scaleToSize:size];
//    UIImage * image2 = [imageNamed(@"logo_penqi_2")scaleToSize:size];
//    UIImage * image3 = [imageNamed(@"logo_penqi_3")scaleToSize:size];
//    UIImage * image4 = [imageNamed(@"logo_penqi_4")scaleToSize:size];
//    UIImage * image5 = [imageNamed(@"logo_penqi_5")scaleToSize:size];
//    UIImage * image6 = [imageNamed(@"logo_penqi_6")scaleToSize:size];
//    UIImage * image7 = [imageNamed(@"logo_penqi_7")scaleToSize:size];
//    
//    NSArray * idleImages = @[image1,image2,image3,image4,image5,image6,image7];
//    
//    [self setImages:idleImages forState:MJRefreshStateIdle];
//    [self setImages:idleImages forState:MJRefreshStateRefreshing];
//    [self setImages:idleImages forState:MJRefreshStatePulling];
//    
//    [self setImages:idleImages duration:0.6f forState:MJRefreshStateIdle];
//    [self setImages:idleImages duration:0.6f forState:MJRefreshStateRefreshing];
//    [self setImages:idleImages duration:0.6f forState:MJRefreshStatePulling];
    
    //self.stateLabel.hidden = YES;
    self.stateLabel.textColor = RGBCOLOR(100, 100, 100);
    self.stateLabel.font = [UIFont systemFontOfSize:12];
    self.labelLeftInset = 0;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.gifView.constraints.count) return;
    
    self.gifView.frame = self.bounds;
    if (self.stateLabel.hidden) {
        self.gifView.contentMode = UIViewContentModeCenter;
    } else {
        self.gifView.contentMode = UIViewContentModeBottom;
        self.mj_h = 74;
        self.stateLabel.mj_h = 37.0f;
        self.stateLabel.mj_y = 37.0f;
        self.gifView.mj_w = self.mj_w * 0.5 - self.stateLabel.mj_textWith * 0.5 - self.labelLeftInset;
        self.gifView.mj_x = (self.mj_w - self.gifView.mj_w)/ 2.0f;
        self.gifView.mj_h = 37.0f;
        self.gifView.mj_y = 5.0f;
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    
    [super scrollViewPanStateDidChange:change];
    
    if([change[@"new"] isEqualToNumber:@1]){
        
        NSArray * titleArray = @[@"低开震荡并上扬，收盘多半是长阳", @"上下试盘震荡急，细查盘口拿主意", @"越过压力首回调，准是洗盘不要走", @"头次过顶会调整，三次过顶要升腾", @"顶底背离时不长，五天之内必转向", @"底背离时可介入，顶背离时要出局", @"低开上扬再回抽，主力洗盘为吸筹", @"高开走低要出局，难望主力再发力", @"直线走高到封停，次日必将还上行", @"三次冲顶不是顶，三次破底不是底", @"单阳过顶剑出鞘，故地重游一定要", @"绿柱将没见新低，红日东升欢迎你", @"近顶拉升要腾空，证明主力在称雄", @"指标低位多日磨，很快会有大突破", @"错过强势启动初，静等来日价回抽", @"牛股不下十日线，熊股围绕年线转", @"上升通道找拐点，买股安全又保险", @"买在低位不会套，卖在高点自然笑", @"轻信媒体乌鸦嘴，时间不长定后悔", @"掌握技术是根本，离开技术事难成", @"不怕买错就怕拖，最终割肉损失多", @"上涨严格挑毛病，下跌决不找理由"];
        
        int r = arc4random() % [titleArray count];
        
        NSString * title = titleArray[r];
        
        [self setTitle:title forState:MJRefreshStateIdle];
        [self setTitle:title forState:MJRefreshStateRefreshing];
        [self setTitle:title forState:MJRefreshStatePulling];
    }
}


@end
