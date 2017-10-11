//
//  TendentListViewModel.m
//  YJCard
//
//  Created by paradise_ on 2017/8/9.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "TendentListViewModel.h"

#import "RetailersModel.h"

@implementation TendentListViewModel{
    NSMutableArray * dataArr;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        [self setUp];
        dataArr = @[].mutableCopy;
    }
    return self;
    
}

- (void)setUp
{
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSDictionary * infoDic = input;
//        NSString * modelStr = input[@"modelName"];
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSString * requestStr = [NSString setUrlEncodeStringWithDic:infoDic[@"SenderInfoKey"]];
            NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Getretailers];
            
            [[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
                
                if([json[@"code"] isEqual:@(100)]){
                    for (NSDictionary *dic in json[@"data"][@"retailers"]) {
                        RetailersModel * model = [RetailersModel yy_modelWithDictionary:dic];
                        [dataArr addObject:model];
                    }
                }else{
                    [MBProgressHUD showWithText:json[@"msg"]];
                }
                [subscriber sendNext:dataArr];
                
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            } andProgressView:nil progressViewText:@"正在加载中" progressViewType:LYCStateViewLoad ViewController:nil];
            
            return nil;
            
        }];
        
        return signal;
    }];
    
    
}

@end
