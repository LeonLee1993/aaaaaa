//
//  HDInfoBaseViewController.m
//  HDStock
//
//  Created by hd-app02 on 2016/11/24.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDInfoBaseViewController.h"

@interface HDInfoBaseViewController ()<UIScrollViewDelegate>

@end

@implementation HDInfoBaseViewController

extern NSString *const ZJParentTableViewDidLeaveFromTopNotification;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    /// 利用通知可以同时修改所有的子控制器的scrollView的contentOffset为CGPointZero
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveFromTop) name:ZJParentTableViewDidLeaveFromTopNotification object:nil];
    
}

- (void)leaveFromTop {
    
    _tempScrollView.contentOffset = CGPointZero;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!_tempScrollView) {
        _tempScrollView = scrollView;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewIsScrolling:)]) {
        [self.delegate scrollViewIsScrolling:scrollView];
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



@end
