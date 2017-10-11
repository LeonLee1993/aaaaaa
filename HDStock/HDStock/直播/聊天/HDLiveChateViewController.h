//
//  HDLiveChateViewController.h
//  HDStock
//
// 直播 － 聊天

//  Created by hd-app01 on 16/11/14.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDStockBaseViewController.h"
#import <WebKit/WebKit.h>

@interface HDLiveChateViewController : HDStockBaseViewController

@property (nonatomic,strong) WKWebView * wkWeb;

@end
