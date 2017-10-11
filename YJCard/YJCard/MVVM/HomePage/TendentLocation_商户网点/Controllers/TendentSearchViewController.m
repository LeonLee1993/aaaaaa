//
//  TendentSearchViewController.m
//  YJCard
//
//  Created by paradise_ on 2017/8/16.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "TendentSearchViewController.h"
#import "RetailersModel.h"
#import "HistoryTableViewCell.h"
#import "TendentTableViewCell.h"
#import "TendentMessageViewController.h"

typedef NS_ENUM(NSInteger, LYCSearchState) {
    //历史记录
    LYCSearchStateHistory,
    //搜索
    LYCSearchStateSearching,
    //没有东西
    LYCSearchStateNone
};

@interface TendentSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, assign) NSInteger textLocation;//这里声明一个全局属性，用来记录
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextTF;
@property (weak, nonatomic) IBOutlet UITableView *searchingTableView;
@property (weak, nonatomic) IBOutlet UIView *nothingView;

@property (nonatomic,strong) UIView * searchView;
@property (nonatomic,assign) LYCSearchState nowSearchState;
@end
#define SearchHistory @"SearchHistory"
@implementation TendentSearchViewController{
    NSArray * searchHistoryArr;
    NSMutableArray * dataArr;
    NSInteger currentPage;
    NSInteger pageSize;
}

-(UIView *)searchView{
    if(!_searchView){
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/375*35)];
        _searchView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth/375*35);
        __weak typeof (self)weakSelf = self;
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(14.5, 0, 120, ScreenWidth/375*35)];
        [_searchView addSubview:label];
        CGPoint point = label.center;
        point.y = _searchView.center.y;
        label.center = point;
        label.textColor = RGBColor(153, 153, 153);
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"搜索历史";
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-49, 0, 49, ScreenWidth/375*35)];
        [button setImage:[UIImage imageNamed:@"叉叉icon"] forState:UIControlStateNormal];
        [_searchView addSubview:button];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            NSArray * Arr = @[].copy;
            [[NSUserDefaults standardUserDefaults]setObject:Arr forKey:SearchHistory];
            searchHistoryArr = [[NSUserDefaults standardUserDefaults]objectForKey:SearchHistory];
            [weakSelf.tableView reloadData];
        }];
        UIView * buttonView = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_searchView.frame)-0.5, ScreenWidth-12, 0.5)];
        buttonView.backgroundColor = RGBColor(230, 230, 230);
        [_searchView addSubview:buttonView];
    }
    return _searchView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    currentPage = 0;
    pageSize = 20;
    dataArr = @[].mutableCopy;
    
    _searchTextTF.delegate = self;
    _searchTextTF.returnKeyType = UIReturnKeySearch;
    
    self.searchTextTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索icon2.png"]];
    
    self.searchTextTF.leftViewMode = UITextFieldViewModeAlways;
    
    searchHistoryArr = [[NSUserDefaults standardUserDefaults]objectForKey:SearchHistory];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"HistoryTableViewCell"];
    
    [self.searchingTableView registerNib:[UINib nibWithNibName:@"TendentTableViewCell" bundle:nil] forCellReuseIdentifier:@"TendentTableViewCelled"];
    
    self.tableView.tableHeaderView = self.searchView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _nowSearchState = LYCSearchStateHistory;
    __weak typeof (self)weakSelf = self;
    self.searchingTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getMoreTendentList1];
    }];
    
    self.searchTextTF.returnKeyType = UIReturnKeySearch;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_nowSearchState == LYCSearchStateHistory){
        return searchHistoryArr.count;
    }else if(_nowSearchState == LYCSearchStateSearching){
        return dataArr.count;
    }else if (_nowSearchState == LYCStateViewFail){
        return  0;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_nowSearchState == LYCSearchStateHistory){
        if(tableView == self.tableView){
            HistoryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCell"];
            cell.historyTitleLabel.text = searchHistoryArr[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if(_nowSearchState == LYCSearchStateSearching){
        if(tableView == self.searchingTableView){
            TendentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TendentTableViewCelled"];
            cell.model = dataArr[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
    }else if (_nowSearchState == LYCStateViewFail){
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_nowSearchState == LYCSearchStateHistory){
         return ScreenWidth/375*35;
    }else if(_nowSearchState == LYCSearchStateSearching){
        return ScreenWidth*128/375;
    }else if (_nowSearchState == LYCStateViewFail){
        return 0;
    }else{
        return 0;
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString *tempStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(tempStr.length>0){
        NSMutableArray * arr = [NSMutableArray arrayWithArray:searchHistoryArr];
        [self.searchTextTF resignFirstResponder];
        if([arr containsObject:tempStr]){
            //再次搜索相同内容的时候 搜索内容移动至第一位
            [arr removeObject:tempStr];
            [arr insertObject:tempStr atIndex:0];
            searchHistoryArr = arr;
            [[NSUserDefaults standardUserDefaults]setObject:arr forKey:SearchHistory];
            [self getMoreTendentList];
            currentPage = 0;
            
        }else{
//            [arr addObject:textField.text];
            [arr insertObject:tempStr atIndex:0];
            searchHistoryArr = arr;
            [[NSUserDefaults standardUserDefaults]setObject:arr forKey:SearchHistory];
            [self getMoreTendentList];
            currentPage = 0;
        }
    }else{
        if(textField.text.length>0){
            [MBProgressHUD showWithText:@"搜索内容不能全为空格"];
        }else{
            [MBProgressHUD showWithText:@"请输入搜索内容"];
        }
    }
    return YES;
}


- (void)getMoreTendentList{
    if(currentPage ==0){
        [dataArr removeAllObjects];
    }
    currentPage+=1;
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    [mutDic setObject:self.searchTextTF.text forKey:@"key"];//搜索词
    [mutDic setObject:@"0" forKey:@"categoryname"];//商户分类名称(默认0)
    [mutDic setObject:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:@"pageindex"];//第几页
    [mutDic setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"pagesize"];//每页大小
    [mutDic setObject:[NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.longitude] forKey:@"lng"];//当前经度
    [mutDic setObject:[NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.latitude] forKey:@"lat"];//当前纬度
    [mutDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefaultCityID]?[[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefaultCityID]:@"650100" forKey:@"city"];//城市id
    
    [mutDic setObject:@"0" forKey:@"ismap"];//0.列表 1.地图
    [mutDic setObject:@"2" forKey:@"version"];
    NSMutableDictionary * senderDic = @{}.mutableCopy;
    [senderDic setObject:mutDic forKey:@"SenderInfoKey"];
    // 发送请求
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Getretailers];
    
    self.mgr =[[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        
        if([json[@"code"] isEqual:@(100)]){
            for (NSDictionary *dic in json[@"data"][@"retailers"]) {
                RetailersModel * model = [RetailersModel yy_modelWithDictionary:dic];
                [dataArr addObject:model];
            }
//            [self.mainTableView reloadData];
            if(dataArr.count>0){
                self.tableView.hidden = YES;
                self.nothingView.hidden = YES;
                self.searchingTableView.hidden = NO;
                _nowSearchState = LYCSearchStateSearching;
                [self.searchingTableView reloadData];
            }else{
                _nowSearchState = LYCSearchStateNone;
                self.tableView.hidden = YES;
                self.retailerName = self.searchTextTF.text;
                self.nothingView.hidden = NO;
                self.searchingTableView.hidden = YES;
                [self.tableView reloadData];
            }
            
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
        if(((NSArray *)json[@"data"][@"retailers"]).count<20 || dataArr.count<20 ){
            
            [self.searchingTableView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            
            [self endRefresh];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self endRefresh];
        
    } andProgressView:self.view progressViewText:@"正在加载中" progressViewType:LYCStateViewLoad ViewController:self];
}

- (void)endRefreshWithNoMoreData{
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}


- (void)getMoreTendentList1{
    if(currentPage ==0){
        [dataArr removeAllObjects];
    }
    currentPage+=1;
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:UserInfoKey];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:[dic[@"memberId"] stringValue] forKey:@"memberid"];
    [mutDic setObject:dic[@"userToken"] forKey:@"usertoken"];
    [mutDic setObject:self.searchTextTF.text forKey:@"key"];//搜索词
    [mutDic setObject:@"0" forKey:@"categoryname"];//商户分类名称(默认0)
    [mutDic setObject:[NSString stringWithFormat:@"%ld",(long)currentPage] forKey:@"pageindex"];//第几页
    [mutDic setObject:[NSString stringWithFormat:@"%ld",(long)pageSize] forKey:@"pagesize"];//每页大小
    [mutDic setObject:[NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.longitude] forKey:@"lng"];//当前经度
    [mutDic setObject:[NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.latitude] forKey:@"lat"];//当前纬度
    [mutDic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefaultCityID]?[[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefaultCityID]:@"650100" forKey:@"city"];//城市id
    [mutDic setObject:@"0" forKey:@"ismap"];//0.列表 1.地图
    [mutDic setObject:@"2" forKey:@"version"];
    NSMutableDictionary * senderDic = @{}.mutableCopy;
    [senderDic setObject:mutDic forKey:@"SenderInfoKey"];
    // 发送请求
    NSString * requestStr = [NSString setUrlEncodeStringWithDic:mutDic];
    NSString *UrlStr =[NSString stringWithFormat:@"%@%@",GlobelHeader,Getretailers];
    
    self.mgr =[[LYCNetworkManager manager]LYC_Post:UrlStr params:requestStr success:^(id json) {
        
        if([json[@"code"] isEqual:@(100)]){
            for (NSDictionary *dic in json[@"data"][@"retailers"]) {
                RetailersModel * model = [RetailersModel yy_modelWithDictionary:dic];
                [dataArr addObject:model];
            }
            //[self.mainTableView reloadData];
            if(dataArr.count>0){
                self.tableView.hidden = YES;
                self.nothingView.hidden = YES;
                self.searchingTableView.hidden = NO;
                _nowSearchState = LYCSearchStateSearching;
                [self.searchingTableView reloadData];
            }else{
                _nowSearchState = LYCSearchStateNone;
                self.retailerName = self.searchTextTF.text;
                self.tableView.hidden = YES;
                self.nothingView.hidden = NO;
                self.searchingTableView.hidden = YES;
                [self.tableView reloadData];
            }
            
        }else{
            [MBProgressHUD showWithText:json[@"msg"]];
        }
        if(((NSArray *)json[@"data"][@"retailers"]).count<20 || dataArr.count<20 ){
            
            [self.searchingTableView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            
            [self endRefresh];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self endRefresh];
        
    } andProgressView:nil progressViewText:@"正在加载中" progressViewType:LYCStateViewLoad ViewController:self];
}

- (void)endRefresh{
//    [self.mainTableView.mj_footer endRefreshing];
    [self.searchingTableView.mj_footer endRefreshing];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView){
        HistoryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.searchTextTF.text = cell.historyTitleLabel.text;
        NSMutableArray * arr = [NSMutableArray arrayWithArray:searchHistoryArr];
        [self.searchTextTF resignFirstResponder];
        if([arr containsObject:self.searchTextTF.text]){
            //再次搜索相同内容的时候 搜索内容移动至第一位
            [arr removeObject:self.searchTextTF.text];
            [arr insertObject:self.searchTextTF.text atIndex:0];
            searchHistoryArr = arr;
            [[NSUserDefaults standardUserDefaults]setObject:arr forKey:SearchHistory];
            [self getMoreTendentList];
            currentPage = 0;
            
        }
        [self getMoreTendentList];
    }else{
        TendentMessageViewController * message = [[TendentMessageViewController alloc]init];
        message.langStr = [NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.longitude];
        message.lantitudeStr = [NSString stringWithFormat:@"%f",[LYCLocationSigleton LYCLocationManager].locService.userLocation.location.coordinate.latitude];
        message.model = dataArr[indexPath.row];
        [self.navigationController pushViewController:message animated:YES];
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setRetailerName:(NSString *)retailerName{
    
    NSString * attStr =[NSString stringWithFormat:@"抱歉，未能找到与“%@”匹配的内容",retailerName];
    
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"抱歉，未能找到与“%@”匹配的内容",retailerName]];
    [attribute addAttribute:NSForegroundColorAttributeName value:RGBColor(110, 110, 110) range:[attStr rangeOfString:retailerName]];
    [attribute addAttribute:NSForegroundColorAttributeName value:RGBColor(153, 153, 153) range:[attStr rangeOfString:@"抱歉，未能找到与“"]];
     [attribute addAttribute:NSForegroundColorAttributeName value:RGBColor(153, 153, 153) range:[attStr rangeOfString:@"”匹配的内容"]];
    
    self.messageLabel.attributedText = attribute;
    
}

#pragma mark-- UITextFieldDelegate
//在输入时，调用下面那个方法来判断输入的字符串是否含有表情
- (void)textFieldDidChanged:(UITextField *)textField
{
//    if (textField.text.length > 20) {
//        textField.text = [textField.text substringToIndex:20];
//        
//    }else {
//        if (self.textLocation == -1) {
//            NSLog(@"输入不含emoji表情");
//        }else {
//            NSLog(@"输入含emoji表情");
//            //截取emoji表情前
//            textField.text = [textField.text substringToIndex:self.textLocation];
//        }
//    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //禁止输入emoji表情
    if ([self stringContainsEmoji:string]) {
        self.textLocation = range.location;
        return NO;
    }else {
        self.textLocation = -1;
    }
    return YES;
}

- (BOOL)stringContainsEmoji:(NSString *)string
{
    NSUInteger len = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if (len < 3) { // 大于2个字符需要验证Emoji(有些Emoji仅三个字符)
        return NO;
    }
    
    // 仅考虑字节长度为3的字符,大于此范围的全部做Emoji处理
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    Byte *bts = (Byte *)[data bytes];
    Byte bt;
    short v;
    for (NSUInteger i = 0; i < len; i++) {
        bt = bts[i];
        
        if ((bt | 0x7F) == 0x7F) { // 0xxxxxxx ASIIC编码
            continue;
        }
        if ((bt | 0x1F) == 0xDF) { // 110xxxxx 两个字节的字符
            i += 1;
            continue;
        }
        if ((bt | 0x0F) == 0xEF) { // 1110xxxx 三个字节的字符(重点过滤项目)
            // 计算Unicode下标
            v = bt & 0x0F;
            v = v << 6;
            v |= bts[i + 1] & 0x3F;
            v = v << 6;
            v |= bts[i + 2] & 0x3F;
            
            // NSLog(@"%02X%02X", (Byte)(v >> 8), (Byte)(v & 0xFF));
            
            if ([self emojiInSoftBankUnicode:v] || [self emojiInUnicode:v]) {
                return YES;
            }
            
            i += 2;
            continue;
        }
        if ((bt | 0x3F) == 0xBF) { // 10xxxxxx 10开头,为数据字节,直接过滤
            continue;
        }
        
        return YES; // 不是以上情况的字符全部超过三个字节,做Emoji处理
    }
    return NO;
}

- (BOOL)emojiInSoftBankUnicode:(short)code
{
    return ((code >> 8) >= 0xE0 && (code >> 8) <= 0xE5 && (Byte)(code & 0xFF) < 0x60);
}

- (BOOL)emojiInUnicode:(short)code
{
    if (code == 0x0023
        || code == 0x002A
        || (code >= 0x0030 && code <= 0x0039)
        || code == 0x00A9
        || code == 0x00AE
        || code == 0x203C
        || code == 0x2049
        || code == 0x2122
        || code == 0x2139
        || (code >= 0x2194 && code <= 0x2199)
        || code == 0x21A9 || code == 0x21AA
        || code == 0x231A || code == 0x231B
        || code == 0x2328
        || code == 0x23CF
        || (code >= 0x23E9 && code <= 0x23F3)
        || (code >= 0x23F8 && code <= 0x23FA)
        || code == 0x24C2
        || code == 0x25AA || code == 0x25AB
        || code == 0x25B6
        || code == 0x25C0
        || (code >= 0x25FB && code <= 0x25FE)
        || (code >= 0x2600 && code <= 0x2604)
        || code == 0x260E
        || code == 0x2611
        || code == 0x2614 || code == 0x2615
        || code == 0x2618
        || code == 0x261D
        || code == 0x2620
        || code == 0x2622 || code == 0x2623
        || code == 0x2626
        || code == 0x262A
        || code == 0x262E || code == 0x262F
        || (code >= 0x2638 && code <= 0x263A)
        || (code >= 0x2648 && code <= 0x2653)
        || code == 0x2660
        || code == 0x2663
        || code == 0x2665 || code == 0x2666
        || code == 0x2668
        || code == 0x267B
        || code == 0x267F
        || (code >= 0x2692 && code <= 0x2694)
        || code == 0x2696 || code == 0x2697
        || code == 0x2699
        || code == 0x269B || code == 0x269C
        || code == 0x26A0 || code == 0x26A1
        || code == 0x26AA || code == 0x26AB
        || code == 0x26B0 || code == 0x26B1
        || code == 0x26BD || code == 0x26BE
        || code == 0x26C4 || code == 0x26C5
        || code == 0x26C8
        || code == 0x26CE
        || code == 0x26CF
        || code == 0x26D1
        || code == 0x26D3 || code == 0x26D4
        || code == 0x26E9 || code == 0x26EA
        || (code >= 0x26F0 && code <= 0x26F5)
        || (code >= 0x26F7 && code <= 0x26FA)
        || code == 0x26FD
        || code == 0x2702
        || code == 0x2705
        || (code >= 0x2708 && code <= 0x270D)
        || code == 0x270F
        || code == 0x2712
        || code == 0x2714
        || code == 0x2716
        || code == 0x271D
        || code == 0x2721
        || code == 0x2728
        || code == 0x2733 || code == 0x2734
        || code == 0x2744
        || code == 0x2747
        || code == 0x274C
        || code == 0x274E
        || (code >= 0x2753 && code <= 0x2755)
        || code == 0x2757
        || code == 0x2763 || code == 0x2764
        || (code >= 0x2795 && code <= 0x2797)
        || code == 0x27A1
        || code == 0x27B0
        || code == 0x27BF
        || code == 0x2934 || code == 0x2935
        || (code >= 0x2B05 && code <= 0x2B07)
        || code == 0x2B1B || code == 0x2B1C
        || code == 0x2B50
        || code == 0x2B55
        || code == 0x3030
        || code == 0x303D
        || code == 0x3297
        || code == 0x3299
        // 第二段
        || code == 0x23F0) {
        return YES;
    }
    return NO;
}

@end
