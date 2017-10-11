//
//  KeyBoardView.h
//  HDStock
//
//  Created by liyancheng on 17/1/6.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^numberButtonBlock) (NSString *);
typedef void(^actionButtonBlock) (NSInteger);
@interface KeyBoardView : UIView
+ (instancetype)getKeyBoardView;

@property (nonatomic,copy) numberButtonBlock block;
@property (nonatomic,copy) actionButtonBlock actionBlock;
@end
