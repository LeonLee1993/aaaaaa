//
//  PCMCSecondViewController.m
//  HDStock
//
//  Created by liyancheng on 16/12/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "PCMCSecondViewController.h"
#import "PCMCSecondTableViewCell.h"
#import "fullPageFailLoadView.h"
#import "nothingContainView.h"//没得东西
#import "sortedModel.h"//  系统消息model 和排序model
#pragma mark ----- 系统消息

@interface PCMCSecondViewController ()<UITableViewDataSource,UITableViewDelegate,fullPageFailLoadViewDelegate>
@property (nonatomic,strong) UITableView * tableView1;
@property (nonatomic,strong) nothingContainView * nothingContain;
@end

@implementation PCMCSecondViewController{
    fullPageFailLoadView * failLoadView;
    NSMutableArray *dataArr;
    NSMutableArray * seperateByDayArr;
    NSMutableArray * orderArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.tableView1){
        self.tableView1 = [[UITableView alloc]init];
    }
//    [self setNavDicWithTitleFont:17 titleColor:[UIColor whiteColor] title:@"系统通知"];
    self.title = @"系统通知";
    if(!dataArr){
        dataArr = @[].mutableCopy;
    }
    
    if(!seperateByDayArr){
        seperateByDayArr = @[].mutableCopy;
    }
    
    if(!orderArr){
        orderArr = @[].mutableCopy;
    }
    
    [self setTableView];
    failLoadView = [[fullPageFailLoadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:failLoadView];
    failLoadView.delegate = self;
    [failLoadView showWithAnimation];
    [self loadDataOfPersonalCenter];
}

-(nothingContainView *)nothingContain{
    if(!_nothingContain){
        _nothingContain =[[nothingContainView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        [self.view addSubview:_nothingContain];
    }
    return _nothingContain;
}

- (void)setTableView{
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.backgroundColor = BACKGROUNDCOKOR;
    self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"PCMCSecondTableViewCell" bundle:nil] forCellReuseIdentifier:@"PCMCSecondTableViewCell"];
    self.tableView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:_tableView1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    sortedModel *model =seperateByDayArr[section];
    return model.systemMessageOrderArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return seperateByDayArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46)];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    headView.backgroundColor = RGBCOLOR(243, 243, 243);
    view.backgroundColor = RGBCOLOR(243, 243, 243);
    [view addSubview:headView];
    UILabel *timeLable = [[UILabel alloc]init];
    if(seperateByDayArr.count>0){
        sortedModel * model = seperateByDayArr[section];
        NSArray *timeStrArr = [model.timeStr componentsSeparatedByString:@" "];
        NSString *timeStr = timeStrArr[0];
        timeLable.text = timeStr;
        timeLable.font = [UIFont systemFontOfSize:11];
        timeLable.textColor = RGBCOLOR(153,153,153);
        [timeLable sizeToFit];
        timeLable.center = CGPointMake(SCREEN_WIDTH/2, 23);
        [view addSubview:timeLable];
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PCMCSecondTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"PCMCSecondTableViewCell"];
    if(seperateByDayArr.count>0){
        sortedModel *model = seperateByDayArr[indexPath.section];
        tableViewCell.model = model.systemMessageOrderArr[indexPath.row];
    }
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableViewCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    systemMessageModel * model;
    if(dataArr.count>0){
        model = dataArr[indexPath.row];
    }
    NSString * tempStr =model.content;
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    style1.headIndent = 0;
    style1.firstLineHeadIndent = 0;
    style1.lineSpacing = 10;
    CGSize secondDesc = [tempStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:style1} context:nil].size;
    CGFloat retureHeight =71+secondDesc.height-55;
    return retureHeight<70?70:retureHeight;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView1)
        
    {
        
        CGFloat sectionHeaderHeight = 46;
        
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            
        }
        
    }
    
}

- (void)loadDataOfPersonalCenter{
    [dataArr removeAllObjects];
    [seperateByDayArr removeAllObjects];
    NSDictionary *userInfoDic = [[LYCUserManager informationDefaultUser]getUserInfoDic];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@/type/2",@"http://gkc.cdtzb.com/api/message/fetch_all_by_uid_type/token/",userInfoDic[PCUserToken]];
    NSString *alreadyReadUrl = [NSString stringWithFormat:@"%@%@/type/2",@"http://gkc.cdtzb.com/api/message/look_at/token/",userInfoDic[PCUserToken]];
    [[CDAFNetWork sharedMyManager]get:urlStr params:nil success:^(id json) {
        if([json[@"code"] isEqual:@(1)]){
            for (NSDictionary *dic in json[@"data"]) {
                systemMessageModel *model = [systemMessageModel yy_modelWithDictionary:dic];
                [dataArr addObject:model];
            }
            [orderArr removeAllObjects];
            if(dataArr.count == ((NSArray *)json[@"data"]).count){
                [seperateByDayArr removeAllObjects];
                //排序
                    NSArray *sortArray = [dataArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                        
                        systemMessageModel *Model1 = obj1;
                        systemMessageModel *Model2 = obj2;
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        
                        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
                        
                        NSDate *date1= [dateFormatter dateFromString:Model1.time];
                        NSDate *date2= [dateFormatter dateFromString:Model2.time];
                        
                        if (date1 == [date1 earlierDate: date2]) { //不使用intValue比较无效
                            
                            return NSOrderedDescending;
                            
                        }else if (date1 == [date1 laterDate: date2]) {  
                            return NSOrderedAscending;
                            
                        }else{  
                            return NSOrderedSame;
                        }
                    }];
                //加进model模型
                
                
                    for (int i=0;i<sortArray.count;i++) {
                        
                        systemMessageModel *model = sortArray[i];
                        sortedModel * sortModel = [[sortedModel alloc]init];
                        sortModel.timeStr = ((NSArray *)[model.time componentsSeparatedByString:@" "])[0];
                        NSInteger flag=-1;
                        
                        sortedModel * nowModel;
                        for (sortedModel *model1 in seperateByDayArr) {
                            nowModel = model1;
                            NSArray * tempSepArr = [model.time componentsSeparatedByString:@" "];
                            NSString *nowTime = tempSepArr[0];
                            if(![model1.timeStr isEqualToString:nowTime]){
                                flag ++;
                            }else{
                                break;
                            }
                        }
                        
                        if(flag == seperateByDayArr.count-1){
                            [seperateByDayArr addObject:sortModel];
                            [sortModel.systemMessageOrderArr addObject:model];
                        }else{
                            [nowModel.systemMessageOrderArr addObject:model];
                        }
                }
                
            }
            
            
            if(seperateByDayArr.count>0){
                [self.tableView1 reloadData];
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self alreadyReadMessage:alreadyReadUrl];//已读  还要调一次接口 无语
                
            });
            
            

        }else{
            NSLog(@"获取失败");
        }
        if(dataArr.count ==0){
            [self.nothingContain show];
        }else{
            [self.nothingContain hide];
        }
        [failLoadView hide];
    } failure:^(NSError *error) {
        [failLoadView showWithoutAnimation];
    }];
}

- (void)alreadyReadMessage:(NSString *)url{
    [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)popMenuDidClickRefresh:(fullPageFailLoadView *)popMenu{
    [popMenu.fullfailLoad hideTheSubViews];
    [self loadDataOfPersonalCenter];
}

@end
