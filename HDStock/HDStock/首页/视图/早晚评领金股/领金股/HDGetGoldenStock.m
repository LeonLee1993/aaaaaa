//
//  HDGetGoldenStock.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/16.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDGetGoldenStock.h"
#import "StockDetailView.h"

@interface HDGetGoldenStock()

@property (nonatomic, strong) PSYProgresHUD * hud;

@property (nonatomic, strong) UIView * mainView;

@property (nonatomic, strong) UIView * topView;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIImageView * imageview;

@property (nonatomic, strong) UIView * lineTop;

@property (nonatomic, strong) UIButton * sureButton;

@property (nonatomic, strong) UIView * lineBottom;

@property (nonatomic, strong) StockDetailView * stockDetailView;

@property (nonatomic, strong) UILabel * stockNameLabel;

@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, assign) CGFloat textHeight;

@end

@implementation HDGetGoldenStock

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.mainView = [[UIView alloc]initWithFrame:CGRectZero];
        self.topView = [[UIView alloc]initWithFrame:CGRectZero];
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.sureButton = [[UIButton alloc]initWithFrame:CGRectZero];
        self.stockDetailView = [StockDetailView stockDetailView];
        self.imageview = [[UIImageView alloc]initWithFrame:CGRectZero];
        
        //self.lineTop = [[UIView alloc]initWithFrame:CGRectZero];
        //self.lineBottom = [[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.mainView];
        [self.topView addSubview:self.titleLabel];
        [self.topView addSubview:self.imageview];
        [self.mainView addSubview:self.topView];
        [self.mainView addSubview:self.lineTop];
        [self.mainView addSubview:self.stockDetailView];
        [self.mainView addSubview:self.lineBottom];
        [self.mainView addSubview:self.sureButton];
        
        
        self.hud = [[PSYProgresHUD alloc]init];
        [self.mainView addSubview:self.hud];
        
        [self addPopAnimation];
        [self setUpSubViews];
    }
    
    return self;
    
}

- (void)setUpSubViews{
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    self.mainView.backgroundColor = [UIColor whiteColor];
    self.mainView.layer.borderWidth = 1.0f;
    self.mainView.layer.borderColor = MAIN_COLOR.CGColor;
    self.mainView.layer.masksToBounds = YES;
    self.mainView.layer.cornerRadius = 5.0f;
    
    self.topView.backgroundColor = MAIN_COLOR;
    
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"每日一股";
    
    self.imageview.image = [UIImage imageNamed:@"jingu_goldencow"];
    
    self.lineTop.backgroundColor = [UIColor colorWithRed:238.0f/256.0f green:238.0f/256.0f blue:238.0f/256.0f alpha:1.0f];
    
    self.lineBottom.backgroundColor = [UIColor colorWithRed:238.0f/256.0f green:238.0f/256.0f blue:238.0f/256.0f alpha:1.0f];
    
    [self.sureButton setTitle:@"已阅" forState:UIControlStateNormal];
    self.sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.sureButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [self.sureButton addTarget:self action:@selector(sureButtonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.sureButton.layer.borderWidth = 1.0f;
    self.sureButton.layer.borderColor = MAIN_COLOR.CGColor;
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = 18.0f;
    
}

- (void)sureButtonOnClicked:(UIButton *)button{
    
    [self removeFromSuperview];
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    [self requestData];
    self.mainView.frame = CGRectMake(25, 120, SCREEN_WIDTH-50, SCREEN_HEIGHT/2.0f + 50.0f);
    self.topView.frame = CGRectMake(0, 0, self.mainView.bounds.size.width, 40);
    self.titleLabel.frame = CGRectMake((self.mainView.bounds.size.width - 70.0f)/2.0f, 0, 70, 40);
    
    self.imageview.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame) - 38.0f, 0, 30.0f, 14.0f);
    self.imageview.centerY = self.titleLabel.centerY;
    //self.imageview.centerX = self.titleLabel.centerX/2.0f;
    //self.lineTop.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) - 1, self.mainView.bounds.size.width, 0.5);
    self.stockDetailView.frame = CGRectMake(0, 40, self.mainView.bounds.size.width, SCREEN_HEIGHT/2.0f - 50.0f);
    self.stockDetailView.fengexianToLeft.constant = self.stockDetailView.frame.size.width/3.0f;
    self.stockDetailView.fengexianToRight.constant = self.stockDetailView.frame.size.width/3.0f;
    //self.lineBottom.frame = CGRectMake(0, 299, self.mainView.bounds.size.width, 1);
    self.sureButton.frame = CGRectMake((self.mainView.bounds.size.width - 130)/2.0f, SCREEN_HEIGHT/2.0f - 10.0f, 120, 36);
}

#pragma mark - 网络请求
- (void)requestData{
    
    [self.hud showAnimated:YES];
    NSString * url = [NSString stringWithFormat:EveryDayOneStock];
    
    WEAK_SELF;
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            
            [self.hud hideAnimated:YES];
            NSArray * dataArr = json[@"data"];
            NSDictionary * dic = dataArr[0];
            self.stockDetailView.stockName.text = dic[@"name"];
            self.stockDetailView.stockNumber.text = dic[@"code"];
            
            NSString * yuqishouyi = [NSString stringWithFormat:@"%@",dic[@"expected_return"]];
            
            self.stockDetailView.yuqishouyiNumber.text = yuqishouyi;
            self.stockDetailView.diyimairuNumber.text = [NSString stringWithFormat:@"%.2f",[dic[@"first_price"] floatValue]];
            self.stockDetailView.diyizhiyingNumber.text = [NSString stringWithFormat:@"%.2f",[dic[@"first_win_price"] floatValue]];
            self.stockDetailView.diyizhisunNumber.text = [NSString stringWithFormat:@"%.2f",[dic[@"first_lose_price"] floatValue]];
            self.stockDetailView.diermairuNumber.text = [NSString stringWithFormat:@"%.2f",[dic[@"second_price"] floatValue]];
            self.stockDetailView.dierzhiyingNumber.text = [NSString stringWithFormat:@"%.2f",[dic[@"second_win_price"] floatValue]];
            self.stockDetailView.dierzhisunNumber.text = [NSString stringWithFormat:@"%.2f",[dic[@"second_lose_price"] floatValue]];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            
            paragraphStyle.lineSpacing = 4;
            
            NSDictionary *attributes = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:14],
                                         NSParagraphStyleAttributeName:paragraphStyle
                                         };
            
            if(dic[@"buy_reason"]){
            
                self.stockDetailView.textView.attributedText = [[NSAttributedString alloc] initWithString:dic[@"buy_reason"] attributes:attributes];
                self.stockDetailView.textView.textAlignment = NSTextAlignmentLeft;
            }else{
            
                self.stockDetailView.textView.textAlignment = NSTextAlignmentCenter;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [strongSelf layoutIfNeeded];
                
            });
            
        } failure:^(NSError *error) {
            
            [self.hud hideAnimated:YES];
            
            [self.hud removeFromSuperViewOnHide];
        
        }];
    });
}

- (void)addPopAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithDouble:0.f];
    animation.toValue   = [NSNumber numberWithDouble:1.f];
    animation.duration  = .25f;
    animation.fillMode  = kCAFillModeBackwards;
    [self.layer addAnimation:animation forKey:nil];
}

@end
