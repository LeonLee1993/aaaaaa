//
//  personalBaseViewController.m
//  HDStock
//
//  Created by liyancheng on 16/11/28.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "personalBaseViewController.h"

@interface personalBaseViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>


@end

@implementation personalBaseViewController{
    NSArray *topArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUNDCOKOR;
    topArray = @[].copy;
    [self panToPopView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)setHeader:(NSString *)titleStr{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    headView.backgroundColor = RGBCOLOR(212,45,73);
    [self.view addSubview:headView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 34, 200, 18)];
    [headView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = titleStr;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _backToView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 100, 44)];
    _backToView.backgroundColor = [UIColor clearColor];
    [headView addSubview:_backToView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToPresentView)];
    UIImageView * backImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 12, 19)];
    backImage.image = [UIImage imageNamed:@"back_icon"];
    [_backToView addSubview:backImage];
    [_backToView addGestureRecognizer:tap];
    
    
    
    _backToView1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 20, 100, 44)];
    _backToView1.backgroundColor = [UIColor clearColor];
    [headView addSubview:_backToView1];
    UIImageView * backImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(70, 13, 20, 19)];
    backImage1.image = [UIImage imageNamed:@"share_iconbig"];
    [_backToView1 addSubview:backImage1];
    _backToView1.hidden = YES;
}



- (void)initTopViewWithArray:(NSArray *)topViewArr
{
    topArray = topViewArr;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 41)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < topArray.count; i ++) {
        UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake(0 + i * (SCREEN_WIDTH / topArray.count), 0, SCREEN_WIDTH / topArray.count, 41)];
        [topButton setTitle:topArray[i] forState:UIControlStateNormal];
        topButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [topButton setTitleColor:RGBCOLOR(51, 51, 51) forState:UIControlStateNormal];
        [topButton setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
        if (i == 0) {
            topButton.selected = YES;
        }
        topButton.tag = 200 + i;
        [topButton addTarget:self action:@selector(topButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:topButton];
    }
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , 50, 3)];
    selectedView.center = CGPointMake(SCREEN_WIDTH/topArray.count/2, 40);
    selectedView.tag = 1000;
    selectedView.backgroundColor = MAIN_COLOR;
    [topView addSubview:selectedView];
    
    UIView * topBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), SCREEN_WIDTH, 1)];
    topBottomView.backgroundColor = RGBCOLOR(243, 243, 243);
    [self.view addSubview:topBottomView];
    [self initScrollView];
}

- (void)initScrollView
{
    NSInteger numberOfTableViews = topArray.count>0? topArray.count:1;
    _scrollView = [[UIScrollView alloc] init];
    [_scrollView setFrame:CGRectMake(0, 106, SCREEN_WIDTH, SCREEN_HEIGHT-105)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * numberOfTableViews, SCREEN_HEIGHT-105);
//    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = BACKGROUNDCOKOR;
    [self.view addSubview:_scrollView];
}

//顶部按钮点击事件
- (void)topButtonEvent:(UIButton *)sender{
    for (int i = 0; i < topArray.count; i++) {
        ((UIButton *)[self.view viewWithTag:200 + i]).selected = NO;
        if(sender.tag == 200 + i){
            [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*i, 0) animated:YES];
            [UIView animateWithDuration:0.3 animations:^{
                [[self.view viewWithTag:1000] setFrame:CGRectMake(SCREEN_WIDTH/topArray.count*(i+1)-SCREEN_WIDTH/topArray.count/2-25, 38, 50, 3)];
            }];
        }
    }
    sender.selected = YES;
}

- (void)backToPresentView{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark -- 设置tableView
-(void)setTableViewsWithCellKindsArray:(NSArray *)cellKinds{
    for (int i = 0; i < cellKinds.count ; i++) {
        if(i ==0){
            _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-106)];
            [_scrollView addSubview:_tableView1];
        }else if (i ==1){
            _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-106)];
            [_scrollView addSubview:_tableView2];
        }else if (i ==2){
            _tableView3 = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-106)];
            [_scrollView addSubview:_tableView3];
        }
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if(scrollView ==_scrollView){
//        CGFloat f = scrollView.contentOffset.x/SCREEN_WIDTH;
//        [[self.view viewWithTag:1000] setFrame:CGRectMake(SCREEN_WIDTH/topArray.count*(f+1)-SCREEN_WIDTH/topArray.count/2-25, 38, 50, 3)];
//        for (int i = 0; i < topArray.count; i++) {
//            ((UIButton *)[self.view viewWithTag:200 + i]).selected = NO;
//        }
//        ((UIButton *)[self.view viewWithTag:200 + f]).selected = YES;
//    }
}

- (void)panToPopView{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGPoint changedPoint;
        changedPoint = [pan translationInView:self.view];
        if((changedPoint.x)>60&&fabs(changedPoint.y)<10){
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    });
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


@end
