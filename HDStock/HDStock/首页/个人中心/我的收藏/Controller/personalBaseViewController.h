//
//  personalBaseViewController.h
//  HDStock
//
//  Created by liyancheng on 16/11/28.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface personalBaseViewController : UIViewController

//设置标题
- (void)setHeader:(NSString *)titleStr;

//选择栏
- (void)initTopViewWithArray:(NSArray *)topViewArr;

//创建tableviews
-(void)setTableViewsWithCellKindsArray:(NSArray *)cellKinds;

- (void)initScrollView;
- (void)topButtonEvent:(UIButton *)sender;
@property (nonatomic,strong) UIScrollView *scrollView;

//tableViews
@property (nonatomic , strong) UITableView * tableView1;
@property (nonatomic , strong) UITableView * tableView2;
@property (nonatomic , strong) UITableView * tableView3;
@property (nonatomic,strong) UIView * backToView1;
@property (nonatomic,strong) UIView *backToView;
-(void)shareButtonClicked;
@end
