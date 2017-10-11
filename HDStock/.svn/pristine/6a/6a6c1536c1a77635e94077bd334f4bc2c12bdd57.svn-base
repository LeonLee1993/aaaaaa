//
//  PSYSocketSingleton.h
//  HDStock
//
//  Created by hd-app02 on 2016/12/30.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GCDAsyncSocket.h>

@interface PSYSocketSingleton : NSObject<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket * socket;

@property (nonatomic, retain) NSTimer * heartTimer;

+ (PSYSocketSingleton *)sharedSocketServe;

- (void)startConnectSocket;

// 断开socket连接
-(void)cutOffSocket;

// 发送消息
- (void)sendMessage:(id)message;

@end
