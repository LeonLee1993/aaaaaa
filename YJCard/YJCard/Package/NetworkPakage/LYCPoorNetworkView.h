//
//  LYCPoorNetworkView.h
//  YJCard
//
//  Created by paradise_ on 2017/8/22.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^reloadBlock)();
@interface LYCPoorNetworkView : UIView
- (void)show;
- (void)hid;

@property (nonatomic,copy) reloadBlock reloadBlock;
@end
