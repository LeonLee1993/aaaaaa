//
//  HDHeadLineDetailViewController.m
//  HDStock
//
//  Created by hd-app02 on 2017/1/10.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "HDHeadLineDetailViewController.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import "ZHFactory.h"
#import "HDShareCustom.h"

@interface HDHeadLineDetailViewController ()<thyShareCustomDlegate, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, HDFontChooseViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic,strong) UIView * shareBlakBgView;//分享时候的黑色遮罩视图
@property (nonatomic,strong) UIView * shareBgView;//分享背景视图
@property (nonatomic,copy) NSArray * shareTitleArr;//分享标题
@property (nonatomic,copy) NSArray * shareIconArr;//分享图片
@property (nonatomic,strong) HDShareCustom * customShare;

@property (strong, nonatomic) UIView * bottomView;
@property (strong, nonatomic) UIButton *collectionButton;
@property (strong, nonatomic) UIButton *praiseButton;
@property (assign, nonatomic) NSInteger favid;
@property (nonatomic, copy) NSString * token;

@property (nonatomic, strong) UITableView * tableview;
@property (nonatomic, strong) NSMutableArray * headLinedataArray;
@property (nonatomic, strong) NSMutableArray * relatedDataArray;
@property (nonatomic, strong) NSMutableDictionary * advertiseDic;
@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, strong) HDFontChooseView * fontChooseView;
@property (nonatomic, assign) NSInteger clickedNum;

@end

@implementation HDHeadLineDetailViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.title = self.controllerTitle;
    [self setUp];
    [self setNormalBackNav];
    [self setUpTextView];
    [self requestData];
    
    HDLeftPersonalViewController * leftVC = (HDLeftPersonalViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [leftVC setPanGesEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    NSDictionary *dicd = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    self.token = dicd[@"token"];
    NSMutableDictionary * dic = [ZHFactory readPlistWithPlistNameReturnMutableDictionary:self.token];
    NSString * favid = dic[[NSString stringWithFormat:@"%ld",(long)self.aid]];
    NSString * isclicked = dic[[NSString stringWithFormat:@"isClicked%ld",(long)self.aid]];
    if (favid) {
        
        self.collectionButton.selected = YES;
        
    }else{
        
        self.collectionButton.selected = NO;
        
    }
    if (isclicked) {
        
        self.praiseButton.enabled = NO;
        
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    HDLeftPersonalViewController * leftVC = (HDLeftPersonalViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [leftVC setPanGesEnabled:YES];
}

- (void)setUpTextView{
    
    self.fontChooseView = [[HDFontChooseView alloc]initWithFrame:CGRectZero];
    self.fontChooseView.delegate = self;
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - NAV_STATUS_HEIGHT - 50) style:UITableViewStylePlain];
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableview];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.scrollEnabled = NO;
    _webView.delegate = self;
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.right.left.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    self.collectionButton = [[UIButton alloc]init];
    [self.collectionButton setImage:imageNamed(@"zixun_detail_soucang_gray") forState:UIControlStateNormal];
    [self.collectionButton setImage:imageNamed(@"zixun_detail_soucang_red") forState:UIControlStateSelected];
    [self.collectionButton setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectionButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    self.collectionButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.collectionButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    [self.collectionButton setTitleEdgeInsets:UIEdgeInsetsMake(4, 0, 0, 0)];
    
    [self.bottomView addSubview:self.collectionButton];
    [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(105, 35));
        make.centerX.equalTo(self.bottomView.mas_right).with.offset(- SCREEN_WIDTH / 4.0f);
        make.centerY.equalTo(self.bottomView);
        
    }];
    
    self.praiseButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.praiseButton setImage:imageNamed(@"zixun_detail_dianzan_gray") forState:UIControlStateNormal];
    [self.praiseButton setImage:imageNamed(@"zixun_detail_dianzan_red") forState:UIControlStateDisabled];
    [self.praiseButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.clickedNum] forState:UIControlStateNormal];
    [self.praiseButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    self.praiseButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.praiseButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    [self.praiseButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    [self.bottomView addSubview:self.praiseButton];
    [self.praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(105, 35));
        make.centerY.equalTo(self.bottomView);
        make.centerX.equalTo(self.bottomView.mas_left).with.offset(SCREEN_WIDTH / 4.0f);
    }];
    
    [self.collectionButton addTarget:self action:@selector(collectionButtonOnTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.praiseButton addTarget:self action:@selector(praiseButtonOnTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setNavBarRightItemWithImage:imageNamed(@"zhuanti_share_icon")];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBegin)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
}

- (void)setClickedNum:(NSInteger)clickedNum{

    _clickedNum = clickedNum;
    
    [self.praiseButton setTitle:[NSString stringWithFormat:@"%ld",clickedNum] forState:UIControlStateNormal];

}

#pragma mark == tablview相关

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 4;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            if (self.relatedDataArray.count <= 4) {
                
                return self.relatedDataArray.count;
                
            }else{
            
                return 4;
            
            }
            
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HDHeadLineModel * model = [self.headLinedataArray objectAtIndexCheck:indexPath.row];
    HDHeadLineModel * reModel = [self.relatedDataArray objectAtIndexCheck:indexPath.row];
    
    HDTextDetailCell * textCell = [[HDTextDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HDTextDetailCe1ll"];
    textCell.model = model;
    textCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [textCell.fontButton addTarget:self action:@selector(fontChooseButtonOntouched:) forControlEvents:UIControlEventTouchUpInside];
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"webCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    HDAdvertiseCell * adverCell = [[HDAdvertiseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HDAdvertiseCell"];
    adverCell.imageURL = [self.advertiseDic valueForKey:@"url"];
    adverCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    HDRelatedCell * relateCell = [[HDRelatedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"relateCell"];
    relateCell.model = reModel;
    relateCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {

        return textCell;
        
    }else if (indexPath.section == 1){
        
        [cell.contentView addSubview:_webView];
        
        return cell;
    
    }else if (indexPath.section == 2){
        
        return adverCell;
        
    }else{
    
        return relateCell;
    
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HDHeadLineModel * reModel = [self.relatedDataArray objectAtIndexCheck:indexPath.row];
    if (indexPath.section == 0) {
        
        return 108;

    }else if (indexPath.section == 1){
        
        if (self.webView.frame.size.height == 1) {
            
            return SCREEN_HEIGHT;
            
        }else{
            
            return self.webView.frame.size.height + 10.0f;
        
        }
        
    }else if (indexPath.section == 2){
        
        return 112 * FITHEIGHTBASEONIPHONEPLUS;
        
    }else{
        
        CGFloat screenW = [UIScreen mainScreen].bounds.size.width - 20;
        
        CGFloat contentW = [reModel.title sizeWithAttributes:@{NSFontAttributeName :[UIFont boldSystemFontOfSize:16]}].width;
    
        if (contentW > screenW) {
            
            if (kScreenIphone4 || kScreenIphone5) {
                
                return 80;
                
            }else{
                
                return 80 * FITHEIGHTBASEONIPHONEPLUS;
                
            }
        }else{
        
            if (kScreenIphone4 || kScreenIphone5) {
                
                return 60;
                
            }else{
                
                return 60 * FITHEIGHTBASEONIPHONEPLUS;
                
            }
        
        
        }
        
        
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UILabel * headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    
    headLabel.text = @"  相关观点";
    
    headLabel.font = [UIFont boldSystemFontOfSize:16];
    
    if (section == 3) {
        return headLabel;
    }

    return nil;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 3) {
        
        return 50;
        
    }else{
    
        return 0;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 2:
        {
            HDAdvertisementModel * model = [HDAdvertisementModel yy_modelWithDictionary:self.advertiseDic];
//            HDAdversementDetailViewController * adVC = [[HDAdversementDetailViewController alloc]init];
//            
//            adVC.tittle = [self.advertiseDic valueForKey:@"title"];
//            adVC.imageUrlStr = [self.advertiseDic valueForKey:@"url"];
//            adVC.url = [self.advertiseDic valueForKey:@"link"];
//            
//            [self.navigationController pushViewController:adVC animated:NO];
            [self turnToDetailViewController:model];
        }
            
            break;
        case 3:
        {
            HDHeadLineModel * model = [self.relatedDataArray objectAtIndexCheck:indexPath.row];
            
            NSString * tagName = model.tags_name.allValues[0];
            if ([tagName isEqualToString:@"专题"]) {
                
                HDSubjectViewController * vc = [[HDSubjectViewController alloc]init];
                
                vc.aid = model.aid;
                vc.uid = model.uid;
                vc.tittle = model.title;
                vc.imageUrlStr = model.pic;
                vc.controllerTitle = @"专题";
                [self.navigationController pushViewController:vc animated:NO];
                
            }else{
                HDHeadLineDetailViewController * headVC = [[HDHeadLineDetailViewController alloc]init];
                headVC.aid = model.aid;
                headVC.uid = model.uid;
                headVC.tittle = model.title;
                headVC.imageUrlStr = model.pic;
                
                if ([tagName isEqualToString:@"广告"]){
                    
                    headVC.controllerTitle = @"";
                    
                }else{
                    
                    headVC.controllerTitle = @"资讯";
                    
                }
                
                
                [self.navigationController pushViewController:headVC animated:NO];
            }
            
        }
            
            break;
            
        default:
            break;
    }

}

#pragma mark == scrollviewdelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [self fontChooseViewRemoveFromSuperView];
}

#pragma mark - 设置
- (void) setUp {
    
    //分享
    _customShare = [HDShareCustom new];
    _customShare.shareCustomDlegate = self;
    _customShare.comFromIndex = 0;
    WEAK_SELF;
    //判断是否安装了接受分享的设备
    _customShare.isInstalledAlertBlock = ^(NSString * isInstalledStr){
        STRONG_SELF;
        [strongSelf jugeWithStr:isInstalledStr];
    };
    //开始分享
    _customShare.sharePlatBlock = ^(NSInteger platType){
        STRONG_SELF;
        
        NSString * urlString = [NSString stringWithFormat:HeadLineNewsShareDetails,(long)strongSelf.aid,arc4random()%1000];
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        if (platType == 2){//微博
    
            [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",strongSelf.tittle,[NSURL URLWithString:urlString]]
                                                       title:@"股博士资讯"
                                                       image:[NSURL URLWithString:strongSelf.imageUrlStr]
                                                         url:[NSURL URLWithString:urlString]
                                                    latitude:0
                                                   longitude:0
                                                    objectID:nil
                                                        type:(SSDKContentTypeAuto)];
            [shareParams SSDKEnableUseClientShare];
            [strongSelf.customShare gotoShareWithContent:shareParams];
        }else if (platType == 0 || platType == 3) {//微信好友，QQ
            //1、创建分享参数
            NSArray* imageArray = @[[NSURL URLWithString:strongSelf.imageUrlStr]];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:strongSelf.tittle
                                                 images:imageArray
                                                    url:[NSURL URLWithString:urlString]
                                                  title:@"股博士资讯"
                                                   type:SSDKContentTypeAuto];
                [strongSelf.customShare gotoShareWithContent:shareParams];
            }
        }else if (platType == 1) {//微信朋友圈
            //1、创建分享参数
            NSArray* imageArray = @[[NSURL URLWithString:strongSelf.imageUrlStr]];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:strongSelf.tittle
                                                 images:imageArray
                                                    url:[NSURL URLWithString:urlString]
                                                  title:strongSelf.tittle
                                                   type:SSDKContentTypeAuto];
                [strongSelf.customShare gotoShareWithContent:shareParams];
            }
        }
        
    };
    
    //分享状态
    self.customShare.shareStatusBlock = ^(NSInteger shareState){
        STRONG_SELF;
        switch (shareState) {
            case SSDKResponseStateSuccess:
            {
                [MBProgressHUD showMessage:@"分享成功" ToView:strongSelf.view RemainTime:2];
            }
                break;
            case SSDKResponseStateFail:
            {
                [MBProgressHUD showMessage:@"分享失败" ToView:strongSelf.view RemainTime:2];
            }
                break;
            case SSDKResponseStateCancel:
            {
                [MBProgressHUD showMessage:@"取消分享" ToView:strongSelf.view RemainTime:2];
                
            }
                break;
            default:
                break;
        }
    };
    
}

#pragma mark == 分享代理
- (void) shareBlcakBgViewTaped{}
- (void) shareCustomShareBtnClicked{}
- (void) shareStatus:(NSInteger)shareStatusIndex{}

#pragma mark == 网络请求

- (void)requestData{
    
    WEAK_SELF;
    
    NSString * url = [NSString stringWithFormat:NewsDetails,self.aid,arc4random()%10000];
    
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            
            NSDictionary * dic = json[@"data"];
            HDHeadLineModel * headlinemodel = [HDHeadLineModel yy_modelWithDictionary:dic];
            self.clickedNum = headlinemodel.clicknum;
            self.tittle = headlinemodel.title;
            self.imageUrlStr = headlinemodel.pic;
            self.uid = headlinemodel.uid;
            NSString * webviewText = @"<style>body{margin:10;background-color:transparent;font:16px/30px Custom-Font-Name}</style>";
         NSString * htmlString = [webviewText stringByAppendingFormat:@
            "%@", headlinemodel.content];
            [_webView loadHTMLString:htmlString baseURL:nil];
             
            NSArray * relatedArray = dic[@"related"];
            
            for (NSDictionary * reDic in relatedArray) {
                
                HDHeadLineModel * reModel = [HDHeadLineModel yy_modelWithDictionary:reDic];
                
                [self.relatedDataArray addObject:reModel];
                
            }
            
            [strongSelf.headLinedataArray addObject:headlinemodel];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [strongSelf.tableview reloadData];
                
            });
            
        } failure:^(NSError *error) {
            

        }];
        
    });
    
    NSString * adverUrl = [NSString stringWithFormat:Advertisement,3,arc4random()%10000];
    
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:adverUrl params:nil success:^(id json) {
            
            NSArray * array = json[@"data"];;
            
            for (NSDictionary * reDic in array) {
                
                [self.advertiseDic setValuesForKeysWithDictionary:reDic];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [strongSelf.tableview reloadData];
                
            });
            
        } failure:^(NSError *error) {
            
        }];
        
    });

    
}

- (void)collectionTheArticle{
    
    WEAK_SELF;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSString * url = [NSString stringWithFormat:CollectionTheArticle,(long)self.aid,(long)self.aid,self.token,arc4random()%1000];
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            
            NSArray * array = json[@"data"];
            
            NSMutableDictionary * faDic = [ZHFactory readPlistWithPlistNameReturnMutableDictionary:self.token];
            if (!faDic) {
                
                faDic = [NSMutableDictionary dictionary];
                
            }
            if (array.count != 0) {
                NSDictionary * dic = [array objectAtIndexCheck:0];
                NSString * favaid = dic[@"favid"];
                [faDic setValue:favaid forKey:[NSString stringWithFormat:@"%ld",(long)strongSelf.aid]];
            }
            
            NSString * code = json[@"code"];
            
            if (code.integerValue == 1) {
                [strongSelf plistHuanCunWithDic:faDic];
                
                [PSYProgressNormalHUD showHUDwithtext:@"收藏成功！" to:strongSelf];
                
            }else if (code.integerValue == 100){
                
                [PSYProgressNormalHUD showHUDwithtext:@"请勿重复收藏!" to:strongSelf];

            }
            
        } failure:^(NSError *error) {
            
            
        }];
        
    });
    
    
}

- (void)cancelCollection{
    
    NSMutableDictionary * dic = [ZHFactory readPlistWithPlistNameReturnMutableDictionary:self.token];
    NSString * favid = dic[[NSString stringWithFormat:@"%ld",(long)self.aid]];
    self.favid = favid.integerValue;
    WEAK_SELF;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSString * url = [NSString stringWithFormat:CancelCollection,(long)self.favid,self.token,arc4random()%1000];
    
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            NSString * code = json[@"code"];
            if (code.integerValue == 2) {
                [dic removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)strongSelf.aid]];
                [self plistHuanCunWithDic:dic];
                [PSYProgressNormalHUD showHUDwithtext:@"取消收藏!" to:strongSelf];
            }
            
        } failure:^(NSError *error) {
            
            
        }];
    });
}

- (void)praiseTheArticleToNet:(NSString *)str{
    
    WEAK_SELF;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSString * url = [NSString stringWithFormat:PraiseArticle,(long)self.aid,str,self.token,arc4random()%1000];
    
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            
            NSString * str = json[@"code"];
            
            if (str.integerValue == 1) {
                
                NSMutableDictionary * faDic = [ZHFactory readPlistWithPlistNameReturnMutableDictionary:self.token];
    
                if (!faDic) {
                    
                    faDic = [NSMutableDictionary dictionary];
                    
                }
                
                [faDic setValue:@"isclicked" forKey:[NSString stringWithFormat:@"isClicked%ld",(long)self.aid]];
                
                [self plistHuanCunWithDic:faDic];
                self.praiseButton.enabled = NO;
                self.clickedNum += 1;
                [PSYProgressNormalHUD showHUDwithtext:@"点赞成功!" to:strongSelf];
                
            }else if (str.integerValue == 405){
                
                [PSYProgressNormalHUD showHUDwithtext:@"您已点过赞!" to:strongSelf];
                self.praiseButton.enabled = NO;
                
            }
            
        } failure:^(NSError *error) {
            
            
        }];
    });
}

#pragma mark -- MD5加密
- (NSString *)stringToMD5:(NSString *)str{
    const char *fooData = [str UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    
    NSMutableString *saveResult = [NSMutableString string];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    return saveResult;
}

#pragma mark- plist缓存
- (void) plistHuanCunWithDic:(NSDictionary *) dic {
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:self.token];
    [dic writeToFile:plistPath atomically:YES];
}

//判断
- (void)jugeWithStr:(NSString *)alertStr {
    if (IOS8) {
        //执行操作
        WEAK_SELF;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:alertStr preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionContinue = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel  handler:nil];
        [alertController addAction:actionContinue];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:alertStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"", nil];
        [alter show];
    }
}

#pragma mark -- 懒加载
- (NSMutableArray *)headLinedataArray{
    
    if (!_headLinedataArray) {
        
        _headLinedataArray = [[NSMutableArray alloc]init];
    }
    
    return _headLinedataArray;
    
}

- (NSMutableArray *)relatedDataArray{
    
    if (!_relatedDataArray) {
        
        _relatedDataArray = [[NSMutableArray alloc]init];
    }
    
    return _relatedDataArray;
    
}

- (NSMutableDictionary *)advertiseDic{

    if (!_advertiseDic) {
        
        _advertiseDic = [[NSMutableDictionary alloc]init];
        
    }

    return _advertiseDic;

}

#pragma mark -- 网页代理

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '110%'";
    [_webView stringByEvaluatingJavaScriptFromString:str];
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    
    self.webView.frame = CGRectMake(0 , 0, SCREEN_WIDTH, height + 10.0f);

    [self.tableview reloadData];
}

#pragma mark == 点击事件
- (void)rightBarImageBtnClciked{
    
    [self.customShare createShareUI];
}

- (void)collectionButtonOnTouched:(UIButton *)button{
    
    CAKeyframeAnimation * transition = [self beginTrasition];
    
    [button.imageView.layer addAnimation:transition forKey:@"transition"];
    
    if (self.token) {
        if (button.selected == NO) {
            
            [self collectionTheArticle];
            
        }else if(button.selected == YES){
            
            [self cancelCollection];
            
        }
        button.selected = !button.selected;
    }else{
        
        PCSignInViewController * signVC = [[PCSignInViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:signVC];
        [self presentViewController:nav animated:YES completion:^{
            
            
        }];
    }
    
}


- (void)praiseButtonOnTouched:(UIButton * )button{
    
    CAKeyframeAnimation * transition = [self beginTrasition];
    
    [button.imageView.layer addAnimation:transition forKey:@"transition"];
    
    if (!self.token) {
        
        PCSignInViewController * signVC = [[PCSignInViewController alloc]init];
        
        [self presentViewController:signVC animated:YES completion:^{
            
            
        }];
        
    }else{
        
        NSString * hashString = [NSString stringWithFormat:@"%ld%ld",(long)self.uid,(long)self.aid];
        
        NSString * hashedStr = [self stringToMD5:hashString];
        
        [self praiseTheArticleToNet:hashedStr];
    }
    
}

- (void)fontChooseButtonOntouched:(UIButton *)button{

    if (button.selected == NO) {
        
        CGRect frame=[self.tableview convertRect:button.frame toView:self.view];
        self.fontChooseView.layer.anchorPoint = CGPointMake(1, 0);
        self.fontChooseView.frame = CGRectMake(frame.origin.x - (90 - frame.size.width), frame.origin.y + frame.size.height, 90, 28);
        
        self.fontChooseView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
        [self.view addSubview:self.fontChooseView];
        
        [UIView animateWithDuration:0.5f animations:^{
        
            self.fontChooseView.transform = CGAffineTransformMakeScale(1, 1);
            
        }completion:^(BOOL finish){
            
            
        }];
        
    }else{
    
        [self fontChooseViewRemoveFromSuperView];

    }
    
    button.selected = !button.selected;
}

- (void)chooseButtonOntouched:(UIButton *)button{
    
        NSInteger num;
    
        if (button.tag == 1200) {
    
            num = 100;
            
        }else if (button.tag == 1201){
    
            num = 110;
    
        }else if(button.tag == 1202){
    
            num = 120;
    
        }
    
    [self translateTheWebView:num];
    [self fontChooseViewRemoveFromSuperView];

}

- (void)fontChooseViewRemoveFromSuperView{

    [self.fontChooseView removeFromSuperview];

}

- (void)translateTheWebView:(NSInteger)num{

    NSString *str = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'",num];
    [_webView stringByEvaluatingJavaScriptFromString:str];
    
    CGRect frame = _webView.frame;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = 1;
    _webView.frame = frame;
    frame.size.height = _webView.scrollView.contentSize.height;
    _webView.frame = frame;
    
    [self.tableview reloadData];
}

#pragma mark -- 手势
- (void)tapBegin{

    [self fontChooseViewRemoveFromSuperView];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    CGRect rect1 = [self.tableview rectForSection:2];
    CGRect rect2 = [self.tableview rectForSection:3];
    CGPoint point = [touch locationInView:self.tableview];
    
    if ((CGRectContainsPoint(rect1, point) && [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])|| (CGRectContainsPoint(rect2, point) &&[gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) || [touch.view isKindOfClass:[UIButton class]]) {
        
        return NO;
    }

    return YES;

}

- (CAKeyframeAnimation *)beginTrasition{
    
    //关键帧动画
    //用动画完成放大的效果
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    //需要给他设置一个关键帧的值,这个值就是变化过程
    //values是一个数组
    animation.values = @[@(1),@(1.5),@(2)];
    //设置动画的时长
    animation.duration = 0.5;
    
    return animation;
}
@end
