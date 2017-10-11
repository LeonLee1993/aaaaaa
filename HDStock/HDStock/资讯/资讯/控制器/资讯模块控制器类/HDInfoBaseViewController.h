//
//  HDInfoBaseViewController.h
//  HDStock
//
//  Created by hd-app02 on 2016/11/24.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDStockBaseViewController.h"
@protocol HDPageViewControllerDelegate <NSObject>

- (void)scrollViewIsScrolling:(UIScrollView *)scrollView;

@end
@interface HDInfoBaseViewController : HDStockBaseViewController
// 代理
@property(weak, nonatomic)id<HDPageViewControllerDelegate> delegate;

@property (strong, nonatomic) UIScrollView * tempScrollView;


@end
