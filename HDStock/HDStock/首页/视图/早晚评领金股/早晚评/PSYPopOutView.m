//
//  PSYPopOutView.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/16.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PSYPopOutView.h"

@interface PSYPopOutView()<UIWebViewDelegate>

@property (nonatomic, strong) PSYProgresHUD * hud;

@property (nonatomic, strong) UIView * mainView;

@property (nonatomic, strong) UIImageView * topView;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIView * lineTop;

@property (nonatomic, strong) UIButton * sureButton;

@property (nonatomic, strong) UIView * lineBottom;

@property (nonatomic, strong) UITextView * textView;

@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, assign) CGFloat textHeight;

@property (nonatomic, strong) UIWebView * webview;

@end

@implementation PSYPopOutView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.mainView = [[UIView alloc]initWithFrame:CGRectZero];
        self.topView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.sureButton = [[UIButton alloc]initWithFrame:CGRectZero];
        //self.textView = [[UITextView alloc]initWithFrame:CGRectZero];
        self.lineTop = [[UIView alloc]initWithFrame:CGRectZero];
        self.lineBottom = [[UIView alloc]initWithFrame:CGRectZero];
        self.webview = [[UIWebView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.mainView];
        
        [self.topView addSubview:self.titleLabel];
        [self addSubview:self.topView];
        //[self.mainView addSubview:self.lineTop];
        [self.mainView addSubview:self.webview];
        //[self.mainView addSubview:self.lineBottom];
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
    
    
    
    self.topView.image = [UIImage imageWithColor:MAIN_COLOR];
    
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.lineTop.backgroundColor = [UIColor colorWithRed:238.0f/256.0f green:238.0f/256.0f blue:238.0f/256.0f alpha:1.0f];
    
//    self.textView.backgroundColor = [UIColor whiteColor];
//    self.textView.showsVerticalScrollIndicator = NO;
//    self.textView.editable = NO;
//    self.textView.font = [UIFont systemFontOfSize:14];
//    self.textView.textColor = [UIColor colorWithHexString:@"#666666"];
    self.webview.scrollView.bounces = NO;
    self.webview.delegate = self;
    
    
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
    
    self.mainView.frame = CGRectMake(25, 170, SCREEN_WIDTH-50, SCREEN_HEIGHT/2.0f);
    self.topView.frame = CGRectMake(25, 135, self.mainView.bounds.size.width, 40);
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.topView.layer.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5.0f, 5.0f)];
    CAShapeLayer * maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.topView.layer.bounds;
    maskLayer.path = maskPath.CGPath;
    self.topView.layer.mask = maskLayer;
    self.titleLabel.frame = CGRectMake(0, 0, self.mainView.bounds.size.width, 40);
    self.lineTop.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) - 1, self.mainView.bounds.size.width, 0.5);
    self.webview.frame = CGRectMake(5, 10, self.mainView.bounds.size.width - 10, SCREEN_HEIGHT/2.0f - 70.0f);
    self.lineBottom.frame = CGRectMake(0, 299, self.mainView.bounds.size.width, 1);
    self.sureButton.frame = CGRectMake((self.mainView.bounds.size.width - 130)/2.0f, SCREEN_HEIGHT/2.0f - 50.0f, 120, 36);
    
}

#pragma mark - 网络请求
- (void)requestData{
    [self.hud showAnimated:YES];
    NSString * url = [NSString stringWithFormat:MorningAndEvening,arc4random()%10000];
    
    WEAK_SELF;
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            
            
            NSArray * dataArr = json[@"data"];
            
            NSDictionary * dic = dataArr[0];
                
            self.titleLabel.text = dic[@"title"];
                
//            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//            
//            paragraphStyle.lineSpacing = 4;
//            
//            NSDictionary *attributes = @{
//                                         NSFontAttributeName:[UIFont systemFontOfSize:14],
//                                         NSParagraphStyleAttributeName:paragraphStyle
//                                         };
//            
//            self.textView.attributedText = [[NSAttributedString alloc] initWithString:dic[@"content"] attributes:attributes];
//            
            //self.textView.text = dic[@"content"];
            [self.webview loadHTMLString:dic[@"content"] baseURL:nil];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [strongSelf layoutIfNeeded];
                
            });
            
        } failure:^(NSError *error) {
            [self.hud hideAnimated:YES];
            [self.hud removeFromSuperViewOnHide];
            
        }];
        
    });
    
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    [self.hud hideAnimated:YES];

//    // 禁用用户选择
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
//    
//    // 禁用长按弹出框
//    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
//    NSString *injectionJSString = @"var script = document.createElement('meta');"
//    "script.name = 'viewport';"
//    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
//    "document.getElementsByTagName('head')[0].appendChild(script);";
//    [webView stringByEvaluatingJavaScriptFromString:injectionJSString];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    [self.hud hideAnimated:YES];

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
