//
//  HDLeftMainViewController.h
//  HDStock
//
//  Created by liyancheng on 16/11/24.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LeftViewControllerDelegate <NSObject>

- (void)showDetailWithStr:(NSString *)str;

@end

@interface HDLeftMainViewController : UIViewController

@property (nonatomic,assign)id <LeftViewControllerDelegate> delegate;

@property (nonatomic,assign) NSInteger numberOfTalking;

@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) NSMutableArray * messageArr;

@end
