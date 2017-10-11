//
//  HDStartAdverImageView.m
//  HDStock
//
//  Created by hd-app02 on 2017/1/17.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "HDStartAdverImageView.h"
#import "HDAdvertisementModel.h"
@interface HDStartAdverImageView()

@property (nonatomic, strong) HDAdvertisementModel * selfModel;

@end

static NSString * const HasImageCache = @"ImageCache.plist";

@implementation HDStartAdverImageView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        [self requestNetImageData];
        
    }

    return self;

}

- (void)setButtonTimer{
    
    __block int timeout=5; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                [self.delegate passToAnotherController];
                
            });
            
        }else{
            
            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [self.passButton setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                
            });
            
            timeout--;
            
        }
        
    });
    
    dispatch_resume(_timer);
    
}

- (void)requestNetImageData{
    
    NSString * url = [NSString stringWithFormat:Advertisement,4,arc4random()%10000];
    //同步请求
    
    NSMutableURLRequest *request=[[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];

    [request willChangeValueForKey:@"timeoutInterval"];
    request.timeoutInterval = 3.f;
    [request didChangeValueForKey:@"timeoutInterval"];

    [requestOperation setResponseSerializer:responseSerializer];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    id json = [requestOperation responseObject];

    HDAdvertisementModel * model = [[HDAdvertisementModel alloc]init];
                
    NSDictionary * dataDic = json;
    
    if(json){
        
        NSArray * dataArray = dataDic[@"data"];
        
        int r = arc4random() % [dataArray count];
        
        model = [HDAdvertisementModel yy_modelWithDictionary:dataArray[r]];
                
//                if ([cache hasCacheForKey:HasImageCache]) {
//                    
//                    NSData * Object = [cache dataForKey:HasImageCache];
//                    
//                    if (![Object isEqual:json]) {
//                        
//                        NSData * jsoncache = [NSKeyedArchiver archivedDataWithRootObject:json];
//                        
//                        [cache setData:jsoncache forKey:HasImageCache];
//                        
//                        dataDic = json;
//                        
//                    }else{
//                    
//                        dataDic = [NSKeyedUnarchiver unarchiveObjectWithData:Object];
//                    }
//                    
//                    NSArray * dataArray = dataDic[@"data"];
//                    
//                    int r = arc4random() % [dataArray count];
//                    
//                    model = [HDAdvertisementModel yy_modelWithDictionary:dataArray[r]];
//                    
                    _selfModel = model;
    
                    [self sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"landingpage00"]];
        
        
                    
                    self.userInteractionEnabled = YES;
                    
                    self.passButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width - 70, 30.0f, 55, 23)];
                    [self.passButton setTitle:@"05" forState:UIControlStateNormal];
                    [self.passButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    self.passButton.titleLabel.font = [UIFont systemFontOfSize:14];
                    self.passButton.backgroundColor = [UIColor blackColor];
                    self.passButton.alpha = 0.25;
                    self.passButton.layer.masksToBounds = YES;
                    self.passButton.layer.cornerRadius = 5.0f;
                    [self.passButton addTarget:self action:@selector(buttonOnTouched:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self addSubview:self.passButton];
                    
                    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(turnToAdverDetail:)];
                    
                    tap.delegate = self;
                    
                    [self addGestureRecognizer:tap];
                    
                    [self setButtonTimer];
                    
                }
                
                
                //                NSDictionary * jsonDic = [NSKeyedUnarchiver unarchiveObjectWithData:Object];
//        
//                NSDictionary * jsonData = json;
                
                
        
//            } failure:^(NSError *error) {
//    
//            }];
//        
//        });
}

- (void)buttonOnTouched:(UIButton *)button{
    
    [self.delegate passToAnotherController];
    
}

- (void)turnToAdverDetail:(HDAdvertisementModel * )model{

    [self.delegate turnIntoDetail:_selfModel];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    if ([touch.view isKindOfClass:[UIButton class]]) {
        
        return NO;
        
    }
    
    return YES;

}

@end
