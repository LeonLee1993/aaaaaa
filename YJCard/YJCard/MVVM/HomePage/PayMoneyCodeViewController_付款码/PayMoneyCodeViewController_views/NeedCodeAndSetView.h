//
//  NeedCodeAndSetView.h
//  YJCard
//
//  Created by paradise_ on 2017/8/7.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^setPasswordBlock)();
@interface NeedCodeAndSetView : UIView
//出现的地方以及出现的时候的中点
-(void)showWithCenterPoint:(UIView *)centerView;

@property (nonatomic,copy) setPasswordBlock setPasswordBlock;
- (void)remove;

@end
