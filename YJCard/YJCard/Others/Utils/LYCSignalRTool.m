//
//  LYCSignalRTool.m
//  YJCard
//
//  Created by paradise_ on 2017/8/15.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "LYCSignalRTool.h"
#import <SignalR.h>

@interface LYCSignalRTool ()<SRConnectionDelegate>

@end

@implementation LYCSignalRTool{
    SRHubProxy *payHub ;
    NSString * requestStr;
}


+ (instancetype)LYCsignalRTool{
    
    static LYCSignalRTool *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        [instance viewDidLoad];
    });
    
    return instance;
}


- (void)viewDidLoad {
    
    SRHubConnection *hubConnection = [SRHubConnection connectionWithURLString:SignalRHeader];
    // Create a proxy to the chat service
    
    hubConnection.started = ^{
        NSLog(@"started");
    };
    
    hubConnection.received = ^(NSString * data) {
        NSLog(@"%@",data);
    };
    
    [hubConnection setDelegate:self];
    
    //创建一个代理到聊天服务
    
    //这个地方使用的时候要注意实体的使用chat.这个chat并不是固定的,是由后台人员给的.如果这个不对的话将会导致后面的回调方法不执行
    
    payHub = [hubConnection createHubProxy:@"PayHub"];
    
    //注册方法,addMessage:  后台人员一旦在后台调用了这个方法,只要移动端注册了这个方法就会立即执行
    [payHub on:@"JoinGroup" perform:self selector:@selector(joinGroup:)];
    
    [payHub on:@"LeaveGroup" perform:self selector:@selector(leaveGroup:)];
    
    [payHub on:@"SendToMember" perform:self selector:@selector(sendToMember:)];
    
    [payHub on:@"SendToMerchant" perform:self selector:@selector(sendToMerchant:)];
    
    
    [hubConnection setStarted:^{
        
        NSLog(@"Connection Started");
    }];
    
    [hubConnection setReceived:^(NSString *message) {
        
        NSLog(@"Connection Recieved Data: %@",message);
        
    }];
    
    [hubConnection setConnectionSlow:^{
        
        NSLog(@"Connection Slow");
        
    }];
    
    [hubConnection setReconnecting:^{
        
        NSLog(@"Connection Reconnecting");
        
    }];
    
    //连接成功
    
    [hubConnection setReconnected:^{
        
        NSLog(@"Connection Reconnected");
        
    }];
    
    //连接关闭
    
    [hubConnection setClosed:^{
        
        NSLog(@"Connection Closed");
        
    }];
    
    
    [hubConnection setError:^(NSError *error) {
        
        NSLog(@"Connection Error %@",error);
        
    }];
    
    // Start the connection
    //开始连接
    [hubConnection start];
    
}

- (void)joinGroup:(NSString *)joinGroup {
    // Print the message when it comes in
    NSLog(@"%@",joinGroup);
    
}

- (void)leaveGroup:(NSString *)leaveGroup {

}

- (void)sendToMember:(NSString *)sendToMember {

    
}

- (void)sendToMerchant:(NSString *)sendToMerchant {
    // Print the message when it comes in
    
}

- (void)SRConnectionDidOpen:(SRConnection *)connection
{

    
}


-(void)resicvechatMessage:(NSDictionary *)User andMessage:(NSDictionary *)Message

{
    
}

- (void)SRConnectionWillReconnect:(id <SRConnectionInterface>)connection{
    NSLog(@"will reconnect");
}

- (void)SRConnectionDidReconnect:(id <SRConnectionInterface>)connection{
    NSLog(@"did reconnect");
}

- (void)SRConnection:(id <SRConnectionInterface>)connection didReceiveData:(id)data{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getMessageFromMerchant" object:data userInfo:nil];
}

- (void)SRConnectionDidClose:(id <SRConnectionInterface>)connection{
    NSLog(@"did close");
}

- (void)sendMessageToCilentWithCodeString:(NSString *)codeString{
    
    [payHub invoke:@"JoinGroup" withArgs:@[codeString,@"m"]];
    
    NSDictionary *dic =[[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    
    [payHub invoke:@"SendToMerchant" withArgs:@[codeString,[NSString stringWithFormat:@"scan|%@|%@|%@",codeString,dic[UserName],dic[UserHeadImage]]]];
    
}

- (void)payCodeViewJoinTheCilentWithCodeString:(NSString *)codeString{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [payHub invoke:@"JoinGroup" withArgs:@[codeString,@"m"]];
    });
}
//用户扫商户成功
- (void)paySuccessMessageToCilentWithCodeString:(NSString *)codeString andMoneyCount:(NSString *)moneyCount{
    [payHub invoke:@"SendToMerchant" withArgs:@[codeString,[NSString stringWithFormat:@"msg|%@|￥%@|PaySuccess",codeString,moneyCount]]];
}

//商户扫用户成功
- (void)paySuccessMerchantToCilentWithCodeString:(NSString *)codeString andCaseID:(NSString *)caseID{
    [payHub invoke:@"SendToMerchant" withArgs:@[codeString,[NSString stringWithFormat:@"successtomerchant|%@|%@",codeString,caseID]]];
}

//- (void)payMoneyCodeMessageToCilentWithCodeString:(NSString *)codeString andStateStr:(NSString *)stateStr{
//    [payHub invoke:@"SendToMerchant" withArgs:@[codeString,[NSString stringWithFormat:@"successtomerchant|%@|%@",codeString,stateStr]]];
//}

- (void)userIsInputPassWordWithCodeString:(NSString *)string{
    [payHub invoke:@"SendToMerchant" withArgs:@[string,[NSString stringWithFormat:@"pwdinput|%@",string]]];
}

- (void)userCancelPayActionWithString:(NSString *)string{
    [payHub invoke:@"SendToMerchant" withArgs:@[string,[NSString stringWithFormat:@"usercancel|%@|0",string]]];
}

- (void)userDontHaveEnoughMoneyWithString:(NSString *)string{
    [payHub invoke:@"SendToMerchant" withArgs:@[string,[NSString stringWithFormat:@"notenoughformerchant|%@",string]]];
}
//用户正在付款中
- (void)userIsPayingActionWithString:(NSString *)codeString{
     [payHub invoke:@"SendToMerchant" withArgs:@[codeString,[NSString stringWithFormat:@"msg|%@|支付中...|null",codeString]]];
}



@end
