//
//  SignalRViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/8/14.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "SignalRViewController.h"
#import <SignalR.h>

@interface SignalRViewController ()<SRConnectionDelegate>

@end

@implementation SignalRViewController{
    SRHubProxy *payHub ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    button.backgroundColor = [UIColor redColor];
//    [self.view addSubview:button];
//    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
    SRHubConnection *hubConnection = [SRHubConnection connectionWithURLString:@"https://ykt.szeltec.com/dev/ss/pay"];
    
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
    // Print the message when it comes in
//    [payHub invokeEvent:@"SendToMerchant" withArgs:@[@"420055471019561984",@"scan|420055471019561984|liyancheng|https://ss3.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/image/h%3D220/sign=85cae6132f1f95cab9f595b4f9167fc5/83025aafa40f4bfbe92d7d39094f78f0f63618d9.jpg"]];
}

- (void)sendToMember:(NSString *)sendToMember {
    NSLog(@"%@",sendToMember);
}

- (void)sendToMerchant:(NSString *)sendToMerchant {
    // Print the message when it comes in
   
}

- (void)SRConnectionDidOpen:(SRConnection *)connection
{
    [payHub invoke:@"JoinGroup" withArgs:@[@"410053272019575090",@"m"]];
    [payHub invoke:@"SendToMerchant" withArgs:@[@"420055471019561991",@"scan|420055471019561991|liyancheng|https://ss3.baidu.com/9fo3dSag_xI4khGko9WTAnF6hhy/image/h%3D220/sign=85cae6132f1f95cab9f595b4f9167fc5/83025aafa40f4bfbe92d7d39094f78f0f63618d9.jpg"]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [payHub invoke:@"SendToMerchant" withArgs:@[@"420055471019561991",@"msg|420055471019561991|￥10.00|PaySuccess"]];
    });
    
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
    NSLog(@"%@",data);
}

- (void)SRConnectionDidClose:(id <SRConnectionInterface>)connection{
    NSLog(@"did close");
}

@end
