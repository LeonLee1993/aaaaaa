//
//  HDSearchCenterViewController.m
//  HDStock
//
//  Created by hd-app02 on 16/11/14.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDSearchCenterViewController.h"
#import "HDMarketSearchTF.h"
#import "HDSearchTableViewCell.h"
#import "HDSearchViewModel.h"
#import "DeleteHistoryTableViewCell.h"
#import "HDMarketDetailViewController.h"
#import "fullPageFailLoadView.h"
#import "KeyBoardView.h"
#import "NoHistroyAndNoTextCell.h"
#import "randomStockModel.h"

#define realWidth [[UIScreen mainScreen] bounds].size.width
#define realHeight [[UIScreen mainScreen] bounds].size.height
@interface HDSearchCenterViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,fullPageFailLoadViewDelegate>
@property (nonatomic,strong)HDMarketSearchTF *HDsearchTextFd;
@property (nonatomic,strong)NSMutableArray *historyArr;//搜索历史数组 (用于得到沙盒数据)
@property (nonatomic,strong)NSMutableArray *realHistoryArr;//可变数组
@property (nonatomic,strong)NSMutableArray *archArr; //要存进沙盒的array
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray *searchResultArr;//从链接下载下来的数据
@property (nonatomic,strong)NSMutableArray *searchingArr;//与搜索框匹配的历史
@property (nonatomic,strong)NSMutableArray *tempArr;//与搜索框匹配的历史
@property (nonatomic,strong)KeyBoardView *keyBoardView;
@property (nonatomic,strong)MBProgressHUD *huded;


@end

@implementation HDSearchCenterViewController{
    UILabel *titleLable;
    fullPageFailLoadView * failLoadView;
    BOOL _changeFlag;
    NSInteger numOfsearchQueue;
    NSThread *nowSearchThread;
    BOOL isCanceled;
    MBProgressHUD *myHud;
    NSThread *threadOfCurren;
    NSMutableArray *randomStockArr;
}

-(NSMutableArray *)searchResultArr{
    if(!_searchResultArr){
        _searchResultArr = @[].mutableCopy;
    }
    return _searchResultArr;
}

-(KeyBoardView *)keyBoardView{
    if(!_keyBoardView){
        _keyBoardView = [KeyBoardView getKeyBoardView];
        _keyBoardView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*200);
        WEAK_SELF;
        _keyBoardView.block = ^(NSString * textStr){
            NSMutableString *str = [[NSMutableString alloc]initWithString:weakSelf.HDsearchTextFd.text];
            [str appendString:textStr];
            weakSelf.HDsearchTextFd.text = str;
            [weakSelf textField1TextChange:weakSelf.HDsearchTextFd];
        };
        
        _keyBoardView.actionBlock = ^(NSInteger flag){
            [weakSelf actionBlockWithFlag:flag];
        };
    }
    return _keyBoardView;
}

-(NSMutableArray *)tempArr{
    if(!_tempArr){
        _tempArr = @[].mutableCopy;
    }
    return _tempArr;
}

-(NSMutableArray *)searchingArr{
    if(!_searchingArr){
        _searchingArr = @[].mutableCopy;
    }
    return _searchingArr;
}

-(HDMarketSearchTF *)HDsearchTextFd{
    if(!_HDsearchTextFd){
        _HDsearchTextFd = [[HDMarketSearchTF alloc]initWithFrame:CGRectMake(15, 7,self.view.frame.size.width-70,30)];
        _HDsearchTextFd.placeholder = @"股票代码/全拼音/首字母";
        _HDsearchTextFd.delegate = self;
        _HDsearchTextFd.clearButtonMode = UITextFieldViewModeWhileEditing;
        _HDsearchTextFd.layer.cornerRadius=6;
        _HDsearchTextFd.layer.masksToBounds = YES;
        _HDsearchTextFd.keyboardType = UIKeyboardTypeWebSearch;
       _HDsearchTextFd.backgroundColor = BACKGROUNDCOKOR;
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sousuo"]];
        img.frame = CGRectMake(10, 0,13,14);
        _HDsearchTextFd.textColor = UICOLOR(153, 153, 153, 1);
        _HDsearchTextFd.leftView = img;
        _HDsearchTextFd.leftViewMode = UITextFieldViewModeAlways;
        _HDsearchTextFd.font = [UIFont fontWithName:@"Arial" size:13];
        _HDsearchTextFd.tintColor = [UIColor grayColor];
        _HDsearchTextFd.inputView = self.keyBoardView;
//        [_HDsearchTextFd addObserver:<#(nonnull NSObject *)#> forKeyPath:<#(nonnull NSString *)#> options:<#(NSKeyValueObservingOptions)#> context:<#(nullable void *)#>]
    }
    return _HDsearchTextFd;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTopView];
    [self setUpTableView];
    self.navigationController.navigationBar.hidden = YES;
    isCanceled = NO;
    failLoadView = [[fullPageFailLoadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:failLoadView];
    failLoadView.delegate = self;
    [failLoadView showWithAnimation];
    [self requestData];
}


- (void)tempModel{
    if(!_historyArr)
    {
        _realHistoryArr = [[NSMutableArray alloc]init];
        _historyArr = [[NSMutableArray alloc]init];
        _archArr = [[NSMutableArray alloc]init];
        [_realHistoryArr removeAllObjects];
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"historySearch"] isKindOfClass:[NSArray class]]){
            _historyArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"historySearch"];
            for (NSDictionary *dic in _historyArr) {
                HDSearchViewModel *model = [HDSearchViewModel yy_modelWithDictionary:dic];
                [_realHistoryArr addObject: model];
            }
        }else{
           [[NSUserDefaults standardUserDefaults] setObject:_historyArr forKey:@"historySearch"];
        }
    }else{
        [_realHistoryArr removeAllObjects];
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"historySearch"] isKindOfClass:[NSArray class]]){
            _historyArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"historySearch"];
            for (NSDictionary *dic in _historyArr) {
                HDSearchViewModel *model = [HDSearchViewModel yy_modelWithDictionary:dic];
                [_realHistoryArr addObject: model];
            }
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:_historyArr forKey:@"historySearch"];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField.text isEqualToString:@""]){
        return NO;
    }else{
        HDSearchViewModel *model = self.searchingArr[0];
        if([_realHistoryArr containsObject:model]){
            //包含时不添加
        }else{
            //不包含时添加
            if(model!=nil){
                [_realHistoryArr addObject:model];
            }
            [_archArr removeAllObjects];
            for (HDSearchViewModel *model in _realHistoryArr) {
                NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
                [dic setObject:model.Symbol forKey:@"Symbol"];
                [dic setObject:model.Name forKey:@"Name"];
                [_archArr addObject:dic];
            }
            [[NSUserDefaults standardUserDefaults] setObject:_archArr forKey:@"historySearch"];
        }
        HDMarketDetailViewController *detail = [[HDMarketDetailViewController alloc]init];
        detail.codeStr = model.Symbol;
        detail.title = model.Name;
        [self.navigationController pushViewController:detail animated:YES];
        return YES;
    }
}

-(void)setUpTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, realWidth, realHeight-64)];
    _tableView.backgroundColor = BACKGROUNDCOKOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"HDSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"HDSearchTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"DeleteHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"DeleteHistoryTableViewCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"NoHistroyAndNoTextCell" bundle:nil] forCellReuseIdentifier:@"NoHistroyAndNoTextCell"];
    [self.view addSubview:_tableView];
    [_tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.HDsearchTextFd.inputView = self.keyBoardView;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self tempModel];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [failLoadView hide];
}

- (void)setTopView{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, realWidth, 20)];
    [self.view addSubview:topView];
    topView.backgroundColor = MAIN_COLOR;
    UIView *topSearchView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, realWidth, 44)];
    [self.view addSubview:topSearchView];
    topSearchView.backgroundColor = MAIN_COLOR;
    [topSearchView addSubview:self.HDsearchTextFd];
    UIButton *cancelBRT = [[UIButton alloc]initWithFrame:CGRectMake(realWidth-45, 0, 38, 44)];
    [cancelBRT setTitle:@"取消" forState:UIControlStateNormal];
    cancelBRT.tintColor = [UIColor whiteColor];
    cancelBRT.titleLabel.textAlignment = NSTextAlignmentLeft;
    cancelBRT.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBRT addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    [topSearchView addSubview:cancelBRT];
    [self.HDsearchTextFd addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
}




-(void)textField1TextChange:(UITextField *)textField{
        _changeFlag = YES;
            if(numOfsearchQueue==self.searchResultArr.count){
                
                isCanceled = NO;
                WEAK_SELF;
                [myHud setHidden:YES];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.label.text = @"疯狂搜索中";
                myHud = hud;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self searchAction:textField.text];
                });
                
            }else{
                
                WEAK_SELF;
                isCanceled = YES;
                [myHud setHidden:YES];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.label.text = @"疯狂搜索中";
                myHud = hud;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    @synchronized (self) {
                        [self searchAction:textField.text];
                    }
                });
            }
    
       if(textField.text.length==0){
            isCanceled = YES;
            [myHud setHidden:YES];
            [self.tableView reloadData];
        }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.HDsearchTextFd.inputView = self.keyBoardView;
}

- (void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -----tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //搜索文字框有字的时候
    if(self.HDsearchTextFd.text.length>0){
        return self.searchingArr.count;
    }
    //历史记录的时候
    else{
        
        if(_realHistoryArr.count>0){
        
            if(section==0){
                return _realHistoryArr.count;
            }
            else if (section==1){
                return 1;
            }
            else{
                return 0;
            }
        }else{
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //搜索文字框有字的时候
    if(self.HDsearchTextFd.text.length>0){
        HDSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDSearchTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(self.searchingArr.count>0){
            if(self.searchingArr.count>indexPath.row){
                cell.model = self.searchingArr[indexPath.row];
            }
        }
        cell.addBlock = ^(NSString * symbol){
            NSMutableArray * mutArr ;
            if([[LYCUserManager informationDefaultUser].defaultUser objectForKey:MarketSearchDataKey]){
                mutArr = [NSMutableArray arrayWithArray:[[LYCUserManager informationDefaultUser].defaultUser objectForKey:MarketSearchDataKey]];
                if([mutArr containsObject:symbol]){
                    [self delectFromMyCollect:symbol];
                }else{
                    [self addToMyCollect:symbol];
                }
                [[LYCUserManager informationDefaultUser].defaultUser setObject:mutArr forKey:MarketSearchDataKey];
                [_tableView reloadData];
            }else{
                mutArr = @[].mutableCopy;
                [mutArr addObject:symbol];
                [[LYCUserManager informationDefaultUser].defaultUser setObject:mutArr forKey:MarketSearchDataKey];
                [_tableView reloadData];
            }
        };
        return cell;
    }
    //历史记录的时候
    else{
        if(_realHistoryArr.count>0){
            if(indexPath.section == 0){
                HDSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HDSearchTableViewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.model = _realHistoryArr[indexPath.row];
                cell.addBlock = ^(NSString *symbol){
                    NSMutableArray * mutArr ;
                    [self addToMyCollect:symbol];
                    if([[LYCUserManager informationDefaultUser].defaultUser objectForKey:MarketSearchDataKey]){
                        mutArr = [NSMutableArray arrayWithArray:[[LYCUserManager informationDefaultUser].defaultUser objectForKey:MarketSearchDataKey]];
                        if([mutArr containsObject:symbol]){
                            [self delectFromMyCollect:symbol];
                        }else{
                            [self addToMyCollect:symbol];
                        }
                        [[LYCUserManager informationDefaultUser].defaultUser setObject:mutArr forKey:MarketSearchDataKey];
                    }else{
                        mutArr = @[].mutableCopy;
                        [mutArr addObject:symbol];
                        [[LYCUserManager informationDefaultUser].defaultUser setObject:mutArr forKey:MarketSearchDataKey];
                    }
                };
                return cell;
            }else if (indexPath.section ==1){
                DeleteHistoryTableViewCell *deleteCell = [tableView dequeueReusableCellWithIdentifier:@"DeleteHistoryTableViewCell"];
                deleteCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return deleteCell;
            }else{
                return nil;
            }
        }else{//当在历史记录没得的时候显示推荐6条
            NoHistroyAndNoTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoHistroyAndNoTextCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.recommendArr = randomStockArr;
            WEAK_SELF;
            cell.buttonBlock = ^(NSInteger index){
                [weakSelf jumpToRecommedByIndex:index];
            };
            return cell;
        }
    }
}

- (void)jumpToRecommedByIndex:(NSInteger)index{
     HDMarketDetailViewController *detailVC = [[HDMarketDetailViewController alloc]init];
    randomStockModel * model = randomStockArr[index -200];
    detailVC.title = model.name;
    detailVC.codeStr = model.symbol;
    
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:model.name forKey:@"Name"];
    [dic setObject:model.symbol forKey:@"Symbol"];
    HDSearchViewModel * model1 = [HDSearchViewModel yy_modelWithDictionary:dic];
    
    if([_realHistoryArr containsObject:model1]){
        //包含时不添加
    }else{
        //不包含时添加
        if(model!=nil){
            [_realHistoryArr addObject:model1];
        }
        [_archArr removeAllObjects];
        for (HDSearchViewModel *model in _realHistoryArr) {
            NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
            [dic setObject:model.Symbol forKey:@"Symbol"];
            [dic setObject:model.Name forKey:@"Name"];
            [_archArr addObject:dic];
        }
        [[NSUserDefaults standardUserDefaults] setObject:_archArr forKey:@"historySearch"];
    }
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 43;
    }else{
        return 0;
    }
}

-(void)addToMyCollect:(NSString *)symbolStr{
    [self.huded setHidden:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    self.huded = hud;
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary *dic = [LYCUserManager informationDefaultUser].getUserInfoDic;
    [mutDic setObject:symbolStr forKey:@"symbol"];
    [mutDic setObject:(dic==nil)?@"":dic[PCUserToken] forKey:@"token"];
    [mutDic setObject:@"9135A5B6-6E45-46EE-B495-694D4E828AA7" forKey:@"device_number"];
    [[CDAFNetWork sharedMyManager] post:@"http://gk.cdtzb.com/api/product/addStock" params:mutDic success:^(id json) {
        if([json[@"code"] isEqual:@(1)]){
            [hud setHidden:YES];
            NSLog(@"关注成功");
            NSMutableArray * mutArr = [NSMutableArray arrayWithArray:[[LYCUserManager informationDefaultUser].defaultUser objectForKey:MarketSearchDataKey]];
            [mutArr addObject:symbolStr];
            [[LYCUserManager informationDefaultUser].defaultUser setObject:mutArr forKey:MarketSearchDataKey];
            [_tableView reloadData];
        }else{
            NSLog(@"关注失败");
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)delectFromMyCollect:(NSString *)symbolStr{
    [self.huded setHidden:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    self.huded = hud;
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [mutDic setObject:symbolStr forKey:@"symbol"];
    [mutDic setObject:@"9135A5B6-6E45-46EE-B495-694D4E828AA7" forKey:@"device_number"];
    [[CDAFNetWork sharedMyManager] post:@"http://gk.cdtzb.com/api/product/removeStock" params:mutDic success:^(id json) {
        if([json[@"code"] isEqual:@(1)]){
            [hud setHidden:YES];
            NSLog(@"删除成功");
            NSMutableArray * mutArr = [NSMutableArray arrayWithArray:[[LYCUserManager informationDefaultUser].defaultUser objectForKey:MarketSearchDataKey]];
            [mutArr removeObject:symbolStr];
            [[LYCUserManager informationDefaultUser].defaultUser setObject:mutArr forKey:MarketSearchDataKey];
            [_tableView reloadData];
        }else{
            NSLog(@"删除失败");
        }
    } failure:^(NSError *error) {
        
    }];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section == 0){
        UIView * tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, realWidth, 43)];
        tableHeadView.backgroundColor = BACKGROUNDCOKOR;
        titleLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 100, 13)];
        titleLable.textColor = UICOLOR(102, 102, 102, 1);
        titleLable.font = [UIFont systemFontOfSize:13];
        if(self.HDsearchTextFd.text.length>0){
            titleLable.text = @"搜索结果";
        }else{
            if(_realHistoryArr.count>0){
                titleLable.text = @"搜索历史";
            }else{
                titleLable.textColor = MAIN_COLOR;
                titleLable.text = @"热门推荐";
            }
        }
        titleLable.textAlignment = NSTextAlignmentLeft;
        [tableHeadView addSubview:titleLable];
        return tableHeadView;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_realHistoryArr.count>0){
        if(indexPath.section ==0){
            return 60;
        }
        else if (indexPath.section ==1){
            return 43;
        }
        else{
            return 0;
        }
    }else if (self.searchingArr.count>0){
        if(indexPath.section ==0){
            return 60;
        }
        else if (indexPath.section ==1){
            return 43;
        }
        else{
            return 0;
        }
    }
    
    else{
        return 300;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //搜索文字框有字的时候
    if(self.HDsearchTextFd.text.length>0){
        return 1;
    }
    //历史记录的时候
    else{
        
        if(_realHistoryArr.count>0){
            return 2;
        }else{
            return 1;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==0){
        
        if(_realHistoryArr.count>0||self.searchingArr.count>0){
            HDMarketDetailViewController *detailVC = [[HDMarketDetailViewController alloc]init];
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
            self.navigationItem.backBarButtonItem = barButtonItem;
            HDSearchViewModel * model;
            if(self.HDsearchTextFd.text.length>0){
                model = self.searchingArr[indexPath.row];
            }else{
                model = _realHistoryArr[indexPath.row];
            }
                
            if([_realHistoryArr containsObject:model]){
                //包含时不添加
            }else{
                //不包含时添加
                if(model!=nil){
                    [_realHistoryArr addObject:model];
                }
                [_archArr removeAllObjects];
                for (HDSearchViewModel *model in _realHistoryArr) {
                    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
                    [dic setObject:model.Symbol forKey:@"Symbol"];
                    [dic setObject:model.Name forKey:@"Name"];
                    [_archArr addObject:dic];
                }
                [[NSUserDefaults standardUserDefaults] setObject:_archArr forKey:@"historySearch"];
            }
            if(self.HDsearchTextFd.text.length>0){
                detailVC.title = model.Name;
                detailVC.codeStr = model.Symbol;
            }else{
                HDSearchViewModel *model = _realHistoryArr[indexPath.row];
                detailVC.title = model.Name;
                detailVC.codeStr = model.Symbol;
            }
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }else if (indexPath.section ==1){
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定清除所有历史记录?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_realHistoryArr removeAllObjects];
            [[NSUserDefaults standardUserDefaults] setObject:_realHistoryArr forKey:@"historySearch"];
            [_tableView reloadData];
        }];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}



- (void)searchAction:(NSString *) searchingStr{
    WEAK_SELF;
    numOfsearchQueue = 0;
    
    [self.searchingArr removeAllObjects];
    

    for (HDSearchViewModel *model in self.searchResultArr) {
        numOfsearchQueue++;
        if ([[(NSString *)model.Symbol lowercaseString] rangeOfString:[(NSString *)searchingStr lowercaseString]].location == NSNotFound) {
        } else {
            NSString *uniStr = [searchingStr substringToIndex:1];
            char c = *(char *)[uniStr UTF8String];
            if((c>'A'&&c<'Z')||(c>'a'&&c<'z')){
                NSInteger flag = 0;
                if( [[(NSString *)model.Symbol lowercaseString] rangeOfString:[(NSString *)searchingStr lowercaseString]].location == flag){
                    if(![self.searchingArr containsObject:model]){
                        if(model){
                            [self.searchingArr addObject:model];
                        }
                    }
                }
            }else{
                NSInteger flag = 2;//没有前缀的情况
                if( [[(NSString *)model.Symbol lowercaseString] rangeOfString:[(NSString *)searchingStr lowercaseString]].location == flag){
                    if(![self.searchingArr containsObject:model]){
                        [self.searchingArr addObject:model];
                    }
                }
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
            [myHud setHidden:YES];
            [weakSelf.tableView reloadData];
        });
}

#pragma mark - 网络请求
- (void)requestData{
    
    NSString * url = @"http://db2015.wstock.cn/wsDB_API/stock.php?return_t=0&r_type=2&u=cngywt&p=web8858";
    
    WEAK_SELF;
    NSTimeInterval cha=86401;
    if([[LYCUserManager informationDefaultUser].defaultUser objectForKey:@"searchArrDate"]){
        NSDate * d =[[LYCUserManager informationDefaultUser].defaultUser objectForKey:@"searchArrDate"];
        NSDate *nowDate = [NSDate date];
        NSTimeInterval late=[d timeIntervalSince1970];
        NSTimeInterval now= [nowDate timeIntervalSince1970];
        cha=now-late;
    }
    
    if(cha/86400<1){
        NSArray *arr = [[LYCUserManager informationDefaultUser].defaultUser objectForKey:@"searchArr"];
        for (NSDictionary * dic in arr) {
            HDSearchViewModel * model = [HDSearchViewModel yy_modelWithDictionary:dic];
            [self.searchResultArr addObject:model];
            if(randomStockArr.count>0){
                [failLoadView hide];
            }
        }
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
                
                if([json isKindOfClass:[NSArray class]]){
                    NSArray * dataArr = json;
                    if(dataArr.count>10){
                        if (self.searchResultArr.count != 0) {
                            [self.searchResultArr removeAllObjects];
                        }
                        
                        for (NSDictionary * dic in dataArr) {
                            HDSearchViewModel * model = [HDSearchViewModel yy_modelWithDictionary:dic];
                            [self.searchResultArr addObject:model];
                        }
                        [[LYCUserManager informationDefaultUser].defaultUser setObject:dataArr forKey:@"searchArr"];
                        NSDate *currentDate = [NSDate date];
                        [[LYCUserManager informationDefaultUser].defaultUser setObject:currentDate forKey:@"searchArrDate"];
                        numOfsearchQueue = self.searchResultArr.count;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.tableView reloadData];
                        });
                    }
                    [failLoadView hide];
                }else{
                    [weakSelf requestData];
                }
                
            } failure:^(NSError *error) {
                [weakSelf requestData];
            }];
        });
    }
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadRandomStock];
    });
}

- (void)loadRandomStock{
    if(!randomStockArr){
        randomStockArr = @[].mutableCopy;
    }
    [randomStockArr removeAllObjects];
    [[CDAFNetWork sharedMyManager]post:@"http://gk.cdtzb.com/api/product/randomStock" params:nil success:^(id json) {
        if([json[@"code"] isEqual:@(1)]){
            for (id obj  in json[@"data"]) {
                randomStockModel *model = [randomStockModel yy_modelWithDictionary:obj];
                [randomStockArr addObject:model];
            }
            if(_realHistoryArr.count==0){
                [self.tableView reloadData];
            }
            if(self.searchResultArr.count>0){
                [failLoadView hide];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}


-(void)popMenuDidClickRefresh:(fullPageFailLoadView *)popMenu{
    [popMenu.fullfailLoad hideTheSubViews];
    [self requestData];
}

- (void)actionBlockWithFlag:(NSInteger )flag{
    switch (flag) {
        case 201:
        {
            WEAK_SELF;
            NSMutableString *str = [[NSMutableString alloc]initWithString:weakSelf.HDsearchTextFd.text];
            if(str.length>0){
                NSString * substr = [str substringToIndex:str.length-1];
                weakSelf.HDsearchTextFd.text = substr;
                [weakSelf textField1TextChange:weakSelf.HDsearchTextFd];
            }
        }
            break;
            
        case 202:
        {
            [self.HDsearchTextFd resignFirstResponder];
        }
            break;
            
        case 203:
        {
            [self.searchingArr removeAllObjects];
            self.HDsearchTextFd.text = @"";
            [self.tableView reloadData];
        }
            break;
            
        case 204:
        {
            if([self.HDsearchTextFd.text isEqualToString:@""]){
                return;
            }else{
                if(self.searchingArr.count>0){
                    HDSearchViewModel *model = self.searchingArr[0];
                    if([_realHistoryArr containsObject:model]){
                        //包含时不添加
                    }else{
                        //不包含时添加
                        if(model!=nil){
                            [_realHistoryArr addObject:model];
                        }
                        [_archArr removeAllObjects];
                        for (HDSearchViewModel *model in _realHistoryArr) {
                            NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
                            [dic setObject:model.Symbol forKey:@"Symbol"];
                            [dic setObject:model.Name forKey:@"Name"];
                            [_archArr addObject:dic];
                        }
                        [[NSUserDefaults standardUserDefaults] setObject:_archArr forKey:@"historySearch"];
                    }
                    HDMarketDetailViewController *detail = [[HDMarketDetailViewController alloc]init];
                    detail.codeStr = model.Symbol;
                    detail.title = model.Name;
                    [self.navigationController pushViewController:detail animated:YES];
                }else{
                    
                }
            }
        }
            break;
            
        case 205:
        {
            self.HDsearchTextFd.inputView = nil;
            self.HDsearchTextFd.keyboardType = UIKeyboardTypeASCIICapable;
            self.HDsearchTextFd.autocapitalizationType =UITextAutocapitalizationTypeNone;
            [self.HDsearchTextFd reloadInputViews];
        }
            break;
            
        case 206:
        {
            self.HDsearchTextFd.inputView = nil;
            self.HDsearchTextFd.keyboardType = UIKeyboardTypeDefault;
            self.HDsearchTextFd.autocapitalizationType =UITextAutocapitalizationTypeNone;
            [self.HDsearchTextFd reloadInputViews];
        }
            break;
            
        default:
            break;
    }
}




@end
