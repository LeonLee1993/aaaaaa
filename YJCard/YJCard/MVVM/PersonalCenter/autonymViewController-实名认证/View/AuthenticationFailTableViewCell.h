//
//  AuthenticationFailTableViewCell.h
//  YJCard
//
//  Created by paradise_ on 2017/8/11.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^resetBlock)();
@interface AuthenticationFailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageLable;

@property (nonatomic,copy)resetBlock resetBlock;

@end
