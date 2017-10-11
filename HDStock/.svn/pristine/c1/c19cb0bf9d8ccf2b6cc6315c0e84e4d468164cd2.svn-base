//
//  HDLiveLivingViewController.h
//  HDStock
//
//  直播－直播

//  Created by hd-app01 on 16/11/14.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDStockBaseViewController.h"
#import <WebKit/WebKit.h>

@protocol touchBeginDelegate <NSObject>

- (void) webViewTouchbegin;

@end

@interface HDLiveLivingViewController : HDStockBaseViewController

@property (nonatomic,weak) id <touchBeginDelegate> touchDelegate;

@property (nonatomic,strong) WKWebView * wkWeb;

@property (nonatomic,assign) CGRect frame;

@end
