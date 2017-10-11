//
//  HDLeftMainViewController.m
//  HDStock
//
//  Created by liyancheng on 16/11/24.
//  Copyright © 2016年 hd-app02. All rights reserved.
//
//每次打开左视图 都要请求头像
#import "HDLeftMainViewController.h"
#import "AppDelegate.h"
#import "PersonalCenterFirstCell.h"
#import "PersonalCenterSecondCell.h"
#import "buttonOfFirstCell.h"
#import "ButtonOfPersonalTopView.h"
#import "SystemSettingViewController.h"//系统设置
#import "HDPersonInfoViewController.h"//个人信息
#import "guChiViewController.h"//我的股池
#import "MyCollectViewController.h"//我的收藏
#import "MyAskAndAnswerViewController.h"//我的问答
#import "MyCommentViewController.h"//我的评论
#import "MyAttentionViewController.h"//我的关注
#import "PersonalproductViewController.h"//产品
#import "PersonalJinnangViewController.h"//锦囊
#import "PCMyChatViewController.h"//我的聊天
#import "PCRegisterTelViewController.h"//注册电话号码界面
#import "PCSignInViewController.h"//登录界面
#import "PCMessageCenterViewController.h"//消息中心
#import "CycleScrollView.h"
#import "MyOrderViewController.h"//我的订单
#import "PCinviteMyFriendsViewController.h"//邀请好友
#import "PCMyPlanViewController.h"//我的计划
#import "NSTimer+Addition.h"
#import "MessageCenterModel.h"
#import "LXWaveProgressView.h"

@interface HDLeftMainViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic , strong) CycleScrollView *mainScorllView;
@property (nonatomic , strong) CycleScrollView *mainScorllView1;
@property (nonatomic , strong) UIView * messageView;
@property (nonatomic , strong) UIScrollView *strongScrollView;
@property (nonatomic , strong) NSMutableArray *scrollViewArr;
@end

@implementation HDLeftMainViewController{
    UILabel *numberLabel;
    UIButton * rightButton;
    UIButton * button2;
    UIButton * button1;
    NSDictionary * letfMainViewDic;
    
    LXWaveProgressView *progressView1;
    NSTimer *timer;
    NSMutableArray *messageSourceArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUNDCOKOR;
    UITableView *  tableview = [[UITableView alloc] init];
    self.tableview = tableview;
    tableview.frame = self.view.bounds;
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.bounces = NO;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableview registerNib:[UINib nibWithNibName:@"PersonalCenterFirstCell" bundle:nil] forCellReuseIdentifier:@"PersonalCenterFirstCell"];
    [tableview registerNib:[UINib nibWithNibName:@"PersonalCenterSecondCell" bundle:nil] forCellReuseIdentifier:@"PersonalCenterSecondCell"];
    [self.view addSubview:tableview];
    if(!_messageArr){
        _messageArr = @[].mutableCopy;
    }
    if(!messageSourceArr){
        messageSourceArr = @[].mutableCopy;
    }
    progressView1 = [[LXWaveProgressView alloc] initWithFrame:CGRectMake(0, 115, self.tableview.bounds.size.width, 100)];
    //    progressView1.center=CGPointMake(CGRectGetMidX(self.view.bounds), 270);
    progressView1.progress = 0.3;
    progressView1.waveHeight = 10;
    progressView1.speed = 4.5;
    progressView1.isShowSingleWave=NO;
}

-(NSMutableArray *)scrollViewArr{
    if(!_scrollViewArr){
        _scrollViewArr = @[].mutableCopy;
    }
    return _scrollViewArr;
}

//-(UIScrollView *)strongScrollView{
//    if(!_strongScrollView){
//        
//    }
//    return _strongScrollView;
//}

- (void)loadDataOfPersonalCenter{
    [messageSourceArr removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    if(_messageArr.count==0){
            NSDictionary *userInfoDic = [[LYCUserManager informationDefaultUser]getUserInfoDic];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",@"http://gkc.cdtzb.com/api/order/order_expire/",userInfoDic[PCUserToken]];
            [[CDAFNetWork sharedMyManager]get:urlStr params:nil success:^(id json) {
                if([json[@"code"] isEqual:@(1)]){
                    if(((NSArray *)json[@"data"]).count>0){
                        for (NSDictionary *dic in json[@"data"]) {
                            [_messageArr addObject:dic[@"title"]];
                        }
                    }
                    if(messageSourceArr.count == 1){
                        [self.tableview reloadData];
                    }
                }else{
                    NSLog(@"获取失败");
                }
            } failure:^(NSError *error) {
                NSLog(@"请求数据出错");
            }];
        }
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *userInfoDic = [[LYCUserManager informationDefaultUser]getUserInfoDic];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@/type/0",@"http://gkc.cdtzb.com/api/message/count_by_type/token/",userInfoDic[PCUserToken]];
        [[CDAFNetWork sharedMyManager]get:urlStr params:nil success:^(id json) {
            if([json[@"code"] isEqual:@(1)]){
                for (NSDictionary *dic in json[@"data"]) {
                    MessageCenterModel * model = [MessageCenterModel yy_modelWithDictionary:dic];
                    [messageSourceArr addObject:model];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableview reloadData];
                    
                });
            
            }else{
                NSLog(@"获取失败");
            }
            
        } failure:^(NSError *error) {
            
        }];
    });
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *dic = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    letfMainViewDic = dic;
    [self loadDataOfPersonalCenter];
    [[LYCUserManager informationDefaultUser] getUserInformation];
    NSDictionary *dicd = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    if([dicd[PCUserState] isEqualToString:@"success"]){
        button1.hidden = YES;
        button2.hidden = YES;
        NSDictionary *dicdd = [[LYCUserManager informationDefaultUser] getUserInfoDic];
        dispatch_async(dispatch_get_main_queue(), ^{
            if([[LYCUserManager informationDefaultUser].defaultUser objectForKey:@"avatar"]){
                _imageView.image = [UIImage imageWithData:[[LYCUserManager informationDefaultUser].defaultUser objectForKey:@"avatar"]];
            }else{
                _imageView.image = [UIImage imageNamed:@"personcenter_default_bg"];
            }
            if(dicdd[PCUserName]){
                _nameLabel.text = dicdd[PCUserName];
            }
        });
    }else{
        button1.hidden = NO;
        button2.hidden = NO;
        _imageView.image = [UIImage imageNamed:@"personcenter_default_bg"];
    }
    [_tableview reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section ==0){
        return 1;
    }else
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        PersonalCenterFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalCenterFirstCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.buttonBlock = ^ (NSInteger index){
            [self handleFirstCellWithIndex:index];
        };
        
        return cell;
    }else if (indexPath.section ==1){
    PersonalCenterSecondCell *cell =[tableView dequeueReusableCellWithIdentifier:@"PersonalCenterSecondCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row == 0){
            cell.titleLabel.text = @"消息中心";
            NSDictionary *dic = [[LYCUserManager informationDefaultUser] getUserInfoDic];
            if([dic[PCUserState] isEqualToString:@"success"]){
                if(messageSourceArr.count>0){
                    MessageCenterModel *model = messageSourceArr[0];
                    if(![model.num isKindOfClass:[NSNull class]]){
                        if(![model.num isEqual:@(0)]){
                            cell.numLabel.text = [NSString stringWithFormat:@" %@ ",model.num];
                        }else{
                            cell.numLabel.text = @"";
                        }
                    }
                }
            }else{
                cell.numLabel.text = @"";
            }
            cell.leftImageView.image = [UIImage imageNamed:@"msg_icon"];
            cell.lineView.hidden = YES;
        }else if (indexPath.row == 1){
            cell.titleLabel.text = @"投顾计划";
            cell.leftImageView.image = [UIImage imageNamed:@"plan_icon"];
            cell.lineView.hidden = YES;
        }else if (indexPath.row == 2){
            cell.titleLabel.text = @"分享股博士";
            cell.leftImageView.image = [UIImage imageNamed:@"sharedocstock_icon"];
//            cell.bottomView.hidden = YES;
//            cell.ImageAlignment.constant = 0;
//            cell.lineViewBottomConstraint.constant = 0;
        }else if (indexPath.row == 3){
            cell.titleLabel.text = @"系统设置";
            cell.leftImageView.image = [UIImage imageNamed:@"setting_icon"];
//            cell.bottomView.hidden = YES;
//            cell.lineView.hidden = YES;
//            cell.ImageAlignment.constant = 0;
//            cell.lineViewBottomConstraint.constant = 0;
        }
        return cell;
    }
    else{
        return nil;
    }
}

- (void)handleFirstCellWithIndex:(NSInteger)index{
    
    switch (index) {
        case 201:
        {
            
            [self presentTargetViewController:NSStringFromClass([PersonalproductViewController class])];
//            [self presentTargetViewController:NSStringFromClass([guChiViewController class])];
        }
            break;
            
        case 202://我的订单
        {
            if([letfMainViewDic[PCUserState] isEqualToString:@"success"]){
              [self presentTargetViewController:NSStringFromClass([MyOrderViewController class])];
            }else{
                [self presentTargetViewController:NSStringFromClass([PCSignInViewController class])];
            }
        }
            break;
            
        case 203:
        {
            
//            [self presentTargetViewController:NSStringFromClass([PCMyChatViewController class])];
            if([letfMainViewDic[PCUserState] isEqualToString:@"success"]){
                [self presentTargetViewController:NSStringFromClass([MyCollectViewController class])];
            }else{
                [self presentTargetViewController:NSStringFromClass([PCSignInViewController class])];
            }
            
        }
            break;
            
        case 204:
        {
            [self presentTargetViewController:NSStringFromClass([MyAttentionViewController class])];
            
        }
            break;
            
        case 205:
        {
            [self presentTargetViewController:NSStringFromClass([MyAskAndAnswerViewController class])];
        }
            break;
            
        case 206:
        {
            [self presentTargetViewController:NSStringFromClass([MyCommentViewController class])];
        }
            break;
            
        default:
            break;
    }
}

- (void)presentTargetViewController:(NSString *)classStr{
    [self.messageArr removeAllObjects];
    id targetVC = [[NSClassFromString(classStr) alloc] init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:targetVC];
    if([targetVC isKindOfClass:[PCinviteMyFriendsViewController class]]){
        PCinviteMyFriendsViewController *controller = targetVC;
        controller.titelStr = @"分享股博士";
        controller.urlStr =@"http://gk.cdtzb.com/api/download";
    }
    
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
    if([targetVC isKindOfClass:[PCSignInViewController class]]){
        PCSignInViewController *controller = targetVC;
        WEAK_SELF;
        controller.blockd = ^{//忘记密码修改的时候
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"修改密码成功";
            [hud hideAnimated:YES afterDelay: 1];
        };
    }
    
    if([targetVC isKindOfClass:[PCRegisterTelViewController class]]){
        PCRegisterTelViewController *controller = targetVC;
        controller.block = ^{
            [_messageArr removeAllObjects];
        };
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0){
        //我的产品 我的订单 我的收藏
    }else if (indexPath.section ==1){
        if(indexPath.row == 0){
            if([letfMainViewDic[PCUserState] isEqualToString:@"success"]){
                [self presentTargetViewController:NSStringFromClass([PCMessageCenterViewController class])];
            }else{
                [self presentTargetViewController:NSStringFromClass([PCSignInViewController class])];
            }
        }else if (indexPath.row == 3){
            SystemSettingViewController *setting = [[SystemSettingViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:setting];
            setting.hdLeft = self;
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }else if (indexPath.row == 2){
            
//            if([letfMainViewDic[PCUserState] isEqualToString:@"success"]){
                [self presentTargetViewController:NSStringFromClass([PCinviteMyFriendsViewController class])];
//            }else{
//                [self presentTargetViewController:NSStringFromClass([PCSignInViewController class])];
//            }
        }else if (indexPath.row == 1){//我的计划
            if([letfMainViewDic[PCUserState] isEqualToString:@"success"]){
                [self presentTargetViewController:NSStringFromClass([PCMyPlanViewController class])];
            }else{
                [self presentTargetViewController:NSStringFromClass([PCSignInViewController class])];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        NSDictionary * dic = [[LYCUserManager informationDefaultUser]getUserInfoDic];
        if([dic[PCUserState] isEqualToString:@"success"]){
            if(_messageArr.count==0){
                return 200;
            }else if (_messageArr.count ==1){
                return 250;
            }else{
                return 280;
            }
        }else{
            return 215;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary * dic = [[LYCUserManager informationDefaultUser]getUserInfoDic];
    UIView *view;
    UIImageView *backGroudImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 215)];
    
//    progressView1.firstWaveColor = [UIColor colorWithRed:134/255.0 green:116/255.0 blue:210/255.0 alpha:1];
//    progressView1.secondWaveColor = [UIColor colorWithRed:134/255.0 green:116/255.0 blue:210/255.0 alpha:0.5];
    [backGroudImage addSubview:progressView1];
    if([dic[PCUserState] isEqualToString:@"success"]){
        if(view==nil){
            if(_messageArr.count==0){
                view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 200)];
            }else if (_messageArr.count == 1){
                view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 250)];
            }else{
                view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 280)];
            }
            backGroudImage.frame = CGRectMake(0, 0, self.tableview.bounds.size.width, 200);
        }else{
            CGRect rect = view.frame;
            rect.size.width = 280;
            view.frame = rect;
        }
    }else{
        if(view==nil){
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 215)];
        }else{
            CGRect rect = view.frame;
            rect.size.width = 200;
            view.frame = rect;
        }
    }
    
    view.backgroundColor = RGBCOLOR(255, 255, 255);
    
    backGroudImage.userInteractionEnabled = YES;
    
    backGroudImage.image = [UIImage imageWithColor:MAIN_COLOR];
    //backGroudImage.image = [UIImage imageNamed:@"bigbg"];
    [view addSubview:backGroudImage];
    
    NSDictionary *infoDic = [[LYCUserManager informationDefaultUser]getUserInfoDic];
    
    NSDictionary *dicd = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    
//    UIImageView* imageViewBack = [[UIImageView alloc]initWithFrame:CGRectMake(view.width/2-37, 60, 74, 74)];
//    imageViewBack.image = [UIImage imageNamed:@"touxiang_bg"];
//    [backGroudImage addSubview:imageViewBack];
    
    //头像
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(view.width/2-37, 67, 74, 74)];
    _imageView.layer.cornerRadius = 37;
    _imageView.layer.masksToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    
    NSDictionary *Infodic = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    if([Infodic[PCUserState] isEqualToString:@"success"]){
        if([[LYCUserManager informationDefaultUser].defaultUser objectForKey:@"avatar"]){
            _imageView.image = [UIImage imageWithData:[[LYCUserManager informationDefaultUser].defaultUser objectForKey:@"avatar"]];
        }else{
            _imageView.image = [UIImage imageNamed:@"personcenter_default_bg"];
        }
    }else{
        _imageView.image = [UIImage imageNamed:@"personcenter_default_bg"];
    }
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personalDetail)];
    [_imageView addGestureRecognizer:tap];
    [backGroudImage addSubview:_imageView];
    
    
    
    
    //登录
    button1 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(view.frame)-115, CGRectGetMaxY(_imageView.frame)+26, 90, 30)];
    [button1 setTitle:@"登录" forState:UIControlStateNormal];
    button1.tag = 201;
    [button1 setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    button1.backgroundColor = UICOLOR(255, 255, 255, 0.8);
    button1.cornerRadius = 3;
    button1.titleLabel.font = [UIFont systemFontOfSize:15];
    [button1 addTarget:self action:@selector(jumpToDetailByTag:) forControlEvents:UIControlEventTouchUpInside];
    
    //注册
    button2 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(view.frame)+25, CGRectGetMaxY(_imageView.frame)+26, 90, 30)];
    [button2 setTitle:@"注册" forState:UIControlStateNormal];
    [button2 setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    button2.backgroundColor = UICOLOR(255, 255, 255, 0.8);
    button2.cornerRadius = 3;
    button2.titleLabel.font = [UIFont systemFontOfSize:15];
    button2.tag = 202;
    [button2 addTarget:self action:@selector(jumpToDetailByTag:) forControlEvents:UIControlEventTouchUpInside];
    
    [backGroudImage addSubview:button1];
    [backGroudImage addSubview:button2];
    
    //名字
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(view.width/2-100, CGRectGetMaxY(_imageView.frame)+15, 200, 16)];
    [backGroudImage addSubview:_nameLabel];
    
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    
    if([infoDic[PCUserState] isEqualToString:@"success"]){
        _nameLabel.text = dicd[PCUserName];
        button1.hidden = YES;
        button2.hidden = YES;
    }else{
        _nameLabel.text = @"";
    }
    
    //头像下设置
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame)-18, CGRectGetMaxY(_imageView.frame)-20, 20, 20)];
    [backGroudImage addSubview:leftButton];
    leftButton.userInteractionEnabled = NO;
    [leftButton setImage:[UIImage imageNamed:@"settingifo_icon"] forState:UIControlStateNormal];
    
    if(_messageArr.count==0){
        [_messageView removeFromSuperview];
        for (UIView *view in _messageView.subviews) {
            [view removeFromSuperview];
        }
    }else if(_messageArr.count==1){
        [self setSingleMessage:_messageArr];
    }else{
        [self setMoreThanOneMessages:_messageArr];
    }
    
    if([dic[PCUserState] isEqualToString:@"success"]){
        if(_messageView){
            [view addSubview:_messageView];
        }
    }else{
        [_messageView removeFromSuperview];
    }
    
   
    
    return view;
}

- (void)setSingleMessage:(NSArray *)_messageArr1{
    //提示消息view
    _messageView = [[UIView alloc]initWithFrame:CGRectMake(0, 200,self.tableview.bounds.size.width , 50)];
    UIImageView * tixingImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 14, 14)];
    tixingImage.image = [UIImage imageNamed:@"deadline_icon"];
    [_messageView addSubview:tixingImage];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(44, 10, 1, 30)];
    lineView.backgroundColor = RGBCOLOR(221,221,221);
    [_messageView addSubview:lineView];
    
    NSMutableArray *viewsArray = [@[] mutableCopy];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_messageArr1];
    [arr addObject:_messageArr1[0]];
    NSInteger scrolltime =0;
    for (int i = 0; i < arr.count; ++i) {
        for (NSString *s in arr) {
            UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width-60, 30)];
            tempLabel.text =  [NSString stringWithFormat:@"%@",s];
            tempLabel.font = [UIFont systemFontOfSize:13];
            tempLabel.numberOfLines = 0;
            [viewsArray addObject:tempLabel];
        if(tempLabel.size.width>self.tableview.bounds.size.width-60){
            dispatch_async(dispatch_get_main_queue(), ^{
                CGSize size = tempLabel.size;
                size.width = self.tableview.bounds.size.width-60;
                tempLabel.size = size;
            });
        }
        }
    }
//    timer = [NSTimer scheduledTimerWithTimeInterval:scrolltime
//                                                      target:self
//                                                    selector:@selector(animationTimerDidFired:)
//                                                    userInfo:nil
//                                                     repeats:YES];
    timer = nil;
    self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(60, 10, self.tableview.bounds.size.width-60, 30) animationDuration:scrolltime andTimer:timer];
    self.mainScorllView.backgroundColor = [UIColor whiteColor];
    self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    self.mainScorllView.totalPagesCount = ^NSInteger(void){
        return arr.count;
    };
    [self.scrollViewArr removeAllObjects];
    [self.scrollViewArr addObject:self.mainScorllView.scrollView];
    [_messageView addSubview:self.mainScorllView];
}

- (void)animationTimerDidFired:(NSTimer *)timer withScrollView:(UIScrollView *)scrollView
{
    CGPoint newOffset = CGPointMake(0,scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame));
    [scrollView setContentOffset:newOffset animated:YES];
}

- (void)setMoreThanOneMessages:(NSArray *)_messageArr1{
    //提示消息view
    _messageView = [[UIView alloc]initWithFrame:CGRectMake(0, 200,self.tableview.bounds.size.width , 80)];
    UIImageView * tixingImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 14, 14)];
    tixingImage.image = [UIImage imageNamed:@"deadline_icon"];
    [_messageView addSubview:tixingImage];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(44, 10, 1, 60)];
    lineView.backgroundColor = RGBCOLOR(221,221,221);
    [_messageView addSubview:lineView];
    
    NSMutableArray *viewsArray = [@[] mutableCopy];
    NSArray *arr = _messageArr1;
    NSInteger scrolltime;
    if(arr.count<=2){
        scrolltime =0;
    }else{
        scrolltime = 10;
    }
    
    NSMutableArray * secondArr = [NSMutableArray arrayWithArray:arr];
    NSString *tempStr = secondArr.firstObject;
    [secondArr removeFirstObject];
    [secondArr addObject:tempStr];
    if(secondArr.count<2){
        [secondArr removeAllObjects];
    }
    
    for (int i = 0; i < arr.count; ++i) {
        for (NSString *s in arr) {
            UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width-60, 35)];
            tempLabel.text =  [NSString stringWithFormat:@"%@",s];
            tempLabel.font = [UIFont systemFontOfSize:13];
            tempLabel.numberOfLines = 0;
            [viewsArray addObject:tempLabel];
        }
    }
    
    if(timer == nil){
        timer = [NSTimer scheduledTimerWithTimeInterval:scrolltime
                                                      target:self
                                                    selector:@selector(animationTimerDidFired:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    
    self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(60, 5, self.tableview.bounds.size.width-60, 35) animationDuration:scrolltime andTimer:timer];
    self.mainScorllView.backgroundColor = [UIColor whiteColor];
    self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    self.mainScorllView.totalPagesCount = ^NSInteger(void){
        return arr.count;
    };
    [_messageView addSubview:self.mainScorllView];
    
    
    NSMutableArray *viewsArray1 = [@[] mutableCopy];
    
    
    for (int i = 0; i < secondArr.count; ++i) {
        for (NSString *s in secondArr) {
            UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width-60, 35)];
            tempLabel.numberOfLines = 0;
            tempLabel.text =  [NSString stringWithFormat:@"%@",s];
            tempLabel.font = [UIFont systemFontOfSize:13];
            [viewsArray1 addObject:tempLabel];
        }
    }

    self.mainScorllView1 = [[CycleScrollView alloc] initWithFrame:CGRectMake(60, 40, self.tableview.bounds.size.width-60, 35) animationDuration:scrolltime andTimer:timer];
    self.mainScorllView1.backgroundColor = [UIColor whiteColor];
    
    self.mainScorllView1.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray1[pageIndex];
    };
    self.mainScorllView1.totalPagesCount = ^NSInteger(void){
        return secondArr.count;
    };
    
    [_messageView addSubview:self.mainScorllView1];
    
    [self.scrollViewArr removeAllObjects];
    [self.scrollViewArr addObject:self.mainScorllView.scrollView];
    [self.scrollViewArr addObject:self.mainScorllView1.scrollView];
    
}

- (void)animationTimerDidFired:(NSTimer *)timer
{
    if([_messageView.subviews containsObject:self.mainScorllView]){
        if(self.scrollViewArr.count==2){
            for (int i=0; i<self.scrollViewArr.count; i++) {
                self.strongScrollView= self.scrollViewArr[i];
                CGPoint newOffset = CGPointMake(0,self.strongScrollView.contentOffset.y + 35);
                if(self.strongScrollView){
                    [self.strongScrollView setContentOffset:newOffset animated:YES];
                }
            }
        }else if (self.scrollViewArr.count ==1){
            self.strongScrollView= self.scrollViewArr[0];
            CGPoint newOffset = CGPointMake(0,self.strongScrollView.contentOffset.y + 35);
            if(self.strongScrollView){
                [self.strongScrollView setContentOffset:newOffset animated:YES];
            }
        }
    }
}

-(void)setNumberOfTalking:(NSInteger)numberOfTalking{
    _numberOfTalking = numberOfTalking;
    if(_numberOfTalking < 100){
        numberLabel.text = [NSString stringWithFormat:@" %ld ",(long)_numberOfTalking];
    }else{
        numberLabel.text = @" 99+ ";
    }
    [numberLabel sizeToFit];
    numberLabel.center = CGPointMake(CGRectGetWidth(rightButton.frame)*1.1, -CGRectGetHeight(numberLabel.frame)/2+6);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==0){
        return 90;
    }else{
    
        if (indexPath.row == 2) {
            return 44;
            
        }else if (indexPath.row == 3) {
            
            return 44;
        }else{
        
            return 44;
        }
    }
}

- (void)personalDetail{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if([letfMainViewDic[PCUserState] isEqualToString:@"success"]){
    
    HDPersonInfoViewController *personInfo = [[HDPersonInfoViewController alloc]init];
        WEAK_SELF;
    personInfo.block = ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"修改密码成功";
        [hud hideAnimated:YES afterDelay: 1];
    };
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:personInfo];
    
    [delegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
        
    }else{
        [self presentTargetViewController:NSStringFromClass([PCSignInViewController class])];
    }
}
#pragma mark ---跳转到登录 注册 
- (void)jumpToDetailByTag:(UIButton *)sender{
    switch (sender.tag) {
        case 201:
            [self presentTargetViewController:NSStringFromClass([PCSignInViewController class])];
            break;
        case 202:
            [self presentTargetViewController:NSStringFromClass([PCRegisterTelViewController class])];
            break;
        case 203:
            [self presentTargetViewController:NSStringFromClass([PCMessageCenterViewController class])];
            break;
        default:
            break;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [timer invalidate];
    timer = nil;
    [super viewWillDisappear:animated];
}

-(void)dealloc{
//    [super dealloc];
    [timer invalidate];
}



@end
