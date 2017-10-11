//
//  PSYSocketSingleton.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/30.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PSYSocketSingleton.h"

@interface PSYSocketSingleton ()
@end

#define HOST @""

#define PORT 8080

#define TIME_OUT 20

//设置写入超时 -1 表示不会使用超时
#define WRITE_TIME_OUT -1

//设置读取超时 -1 表示不会使用超时
#define READ_TIME_OUT -1
#define MAX_BUFFER 1024

@implementation PSYSocketSingleton

static PSYSocketSingleton * socketSingleton = nil;

+ (PSYSocketSingleton *)sharedSocketServe{

    @synchronized (self) {
        
        if (socketSingleton == nil) {
            
            socketSingleton = [[[self class]alloc]init];
        }
    }

    return socketSingleton;


}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{

    @synchronized (self) {
        
        if (socketSingleton == nil) {
            
            socketSingleton = [super allocWithZone:zone];
            return socketSingleton;
        }
        
    }

    return nil;

}

- (void)startConnectSocket{

    self.socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    if (![self socketOpen:HOST port:PORT]) {
        
        
    }

}

- (NSInteger)socketOpen:(NSString *)address port:(NSInteger)port{

    if (![self.socket isConnected]) {
        
        NSError * error = nil;
        
        [self.socket connectToHost:address onPort:port withTimeout:TIME_OUT error:&error];
        
    }

    return 0;

}

-(void)cutOffSocket
{
    //self.socket.userData = SocketOfflineByUser;
    [self.socket disconnect];
}

- (void)onSocket:(GCDAsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@" willDisconnectWithError %@   err = %@",sock.userData,[err description]);
    if (err.code == 57) {
        //self.socket.userData = SocketOfflineByWifiCut;
    }
    //    NSData * unreadData = [sock unreadData]; // ** This gets the current buffer
    //    if(unreadData.length > 0) {
    //        [self onSocket:sock didReadData:unreadData withTag:0]; // ** Return as much data that could be collected
    //    } else {
    //        NSLog(@" willDisconnectWithError %@   err = %@",sock.userData,[err description]);
    //        if (err.code == 57) {
    //            self.socket.userData = SocketOfflineByWifiCut;
    //        }
    //    }
}

- (void)onSocketDidDisconnect:(GCDAsyncSocket *)sock
{
    NSLog(@"7878 sorry the connect is failure %@",sock.userData);
//    if (sock.userData == SocketOfflineByServer) {
//        // 服务器掉线，重连
//        [self startConnectSocket];
//    }
//    else if (sock.userData == SocketOfflineByUser) {
//        // 如果由用户断开，不进行重连
//        return;
//    }else if (sock.userData == SocketOfflineByWifiCut) {
//        // wifi断开，不进行重连
//        return;
//    }
}

//发送消息成功之后回调
- (void)onSocket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    //读取消息
    [self.socket readDataWithTimeout:-1 buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
}
//接受消息成功之后回调
- (void)onSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    //服务端返回消息数据量比较大时，可能分多次返回。所以在读取消息的时候，设置MAX_BUFFER表示每次最多读取多少，当data.length < MAX_BUFFER我们认为有可能是接受完一个完整的消息，然后才解析
    if( data.length < MAX_BUFFER )
    {
        //收到结果解析...
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",dic);
        //解析出来的消息，可以通过通知、代理、block等传出去
    }
    
    [self.socket readDataWithTimeout:READ_TIME_OUT buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
}

- (void)sendMessage:(id)message
{
    //像服务器发送数据
    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:cmdData withTimeout:WRITE_TIME_OUT tag:1];
}

#pragma mark == GCDAsyncSocketDelegate
- (void)onSocket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    //这是异步返回的连接成功，
    NSLog(@"didConnectToHost");
    
    //通过定时器不断发送消息，来检测长连接
    self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkLongConnectByServe) userInfo:nil repeats:YES];
    [self.heartTimer fire];
}

// 心跳连接
-(void)checkLongConnectByServe{
    // 向服务器发送固定可是的消息，来检测长连接
    NSString *longConnect = @"connect is here";
    NSData   *data  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:1 tag:1];
}
@end
