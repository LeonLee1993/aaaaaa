//
//  HDVideoDetailsViewController.m
//  HDStock
//
//  Created by hd-app02 on 2016/11/24.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDVideoDetailsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ZFPlayer.h"
#import "HDViedeoTitleViewCell.h"
#import "HDVideoListCell.h"
#import "HDNewsDetailsModel.h"
#import "HDNewsVideoRelatedModel.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import "HDShareCustom.h"

@interface HDVideoDetailsViewController ()<ZFPlayerDelegate, UITableViewDelegate, UITableViewDataSource, thyShareCustomDlegate>
@property (nonatomic,strong) HDShareCustom * customShare;

@property (strong, nonatomic) IBOutlet UIView *TopStatusView;
/** 播放器View的父视图*/
@property (strong, nonatomic) IBOutlet UIView *playerFatherView;
@property (strong, nonatomic) ZFPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIButton *praiseButton;

@property (strong, nonatomic) IBOutlet UIButton *collectionButton;
@property (strong, nonatomic) UIButton *shareButton;

@property (strong, nonatomic) NSMutableArray * relatedArray;

@property (assign, nonatomic) NSInteger favid;
@property (nonatomic, copy) NSString * token;

@property (nonatomic, assign) NSInteger clickedNum;

@end

@implementation HDVideoDetailsViewController{

    NSInteger page;
    NSInteger perpage;
    AppDelegate * appdelegate;
}


- (NSMutableArray *)relatedArray{

    if (!_relatedArray) {
        
        _relatedArray = [NSMutableArray array];
    }
    
    return _relatedArray;


}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
    NSDictionary *dicd = [[LYCUserManager informationDefaultUser] getUserInfoDic];
    self.token = dicd[@"token"];
    
    [self setCollectionedButtonsState];
    
    //appdelegate.allowRotation = 0;

}

- (void)setCollectionedButtonsState{

    NSMutableDictionary * dic = [ZHFactory readPlistWithPlistNameReturnMutableDictionary:self.token];
    NSString * favid = dic[[NSString stringWithFormat:@"%ld",(long)self.ItemAid]];
    NSString * isclicked = dic[[NSString stringWithFormat:@"isClicked%ld",(long)self.ItemAid]];
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
    [self.tabBarController.tabBar setHidden:NO];
    
    [self.navigationController.navigationBar setHidden:NO];

    
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self setUp];
    
    page = 1;
    
    perpage = 5;
    
    self.view.backgroundColor = COLOR(whiteColor);
    
    [self setUpTopPlayerView];
    
    [self setUpTableView];
    
    [self setUpButtons];
    
    [self requestData];
}

#pragma mark - 设置
- (void) setUp {
    
    NSString * urlString = [NSString stringWithFormat:@"http://gkc.cdtzb.com/web/video/videoList/%ld",(long)self.ItemAid];
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
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        if (platType == 2){//微博
            [shareParams SSDKSetupSinaWeiboShareParamsByText:strongSelf.summary
                                                       title:strongSelf.videoTitle
                                                       image:[NSURL URLWithString:strongSelf.picUrl]
                                                         url:[NSURL URLWithString:urlString]
                                                    latitude:0
                                                   longitude:0
                                                    objectID:nil
                                                        type:(SSDKContentTypeAuto)];
            [shareParams SSDKEnableUseClientShare];
            [strongSelf.customShare gotoShareWithContent:shareParams];
        }else if (platType == 0 || platType == 3) {//微信好友，QQ
            //1、创建分享参数
            NSArray* imageArray = @[[NSURL URLWithString:strongSelf.picUrl]];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:strongSelf.summary
                                                 images:imageArray
                                                    url:[NSURL URLWithString:urlString]
                                                  title:strongSelf.videoTitle
                                                   type:SSDKContentTypeAuto];
                [strongSelf.customShare gotoShareWithContent:shareParams];
            }
        }else if (platType == 1) {//微信朋友圈
            //1、创建分享参数
            NSArray* imageArray = @[[NSURL URLWithString:strongSelf.picUrl]];
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:strongSelf.summary
                                                 images:imageArray
                                                    url:[NSURL URLWithString:urlString]
                                                  title:strongSelf.videoTitle
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


- (void)setUpTableView{

    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.tableview.allowsSelection = YES;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"HDViedeoTitleViewCell" bundle:nil]forCellReuseIdentifier:@"HDViedeoTitleViewCell"];

    [self.tableview registerNib:[UINib nibWithNibName:@"HDVideoListCell" bundle:nil] forCellReuseIdentifier:@"HDVideoListCell"];
    
}

- (void)setUpTopPlayerView{

    self.TopStatusView.backgroundColor = MAIN_COLOR;
    self.playerView = [[ZFPlayerView alloc] init];
    
    [self.view addSubview:_TopStatusView];
    [self.view addSubview:self.playerFatherView];
    [self.playerFatherView addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
    [self.playerView playerControlView:controlView playerModel:self.playerModel];
    self.playerView.delegate = self;
    
    [self.playerView autoPlayTheVideo];

}

- (void)setUpButtons{
    
    [self.collectionButton addTarget:self action:@selector(collectionButtonOnTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.praiseButton addTarget:self action:@selector(praiseButtonOnTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.praiseButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.clickedNum] forState:UIControlStateNormal];
}

- (void)setClickedNum:(NSInteger)clickedNum{

    _clickedNum = clickedNum;
    
    [self.praiseButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.clickedNum] forState:UIControlStateNormal];

}


#pragma mark - ZFPlayerDelegate

- (void)zf_playerBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Getter

- (ZFPlayerModel *)playerModel
{
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.fatherView       = self.playerFatherView;
        _playerModel.videoURL         = [NSURL URLWithString:self.videoUrl];
        _playerModel.placeholderImageURLString = self.picUrl;
    }else{
        _playerModel.videoURL         = [NSURL URLWithString:self.videoUrl];
        _playerModel.placeholderImageURLString = self.picUrl;
    }
    return _playerModel;
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            if (self.relatedArray.count < 4) {
                return self.relatedArray.count;
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
    
    HDNewsVideoRelatedModel * model = [self.relatedArray objectAtIndexCheck:indexPath.row];
    
    HDVideoListCell * cellSingle = [tableView dequeueReusableCellWithIdentifier:@"HDVideoListCell"];
    cellSingle.model = model;
    cellSingle.selectionStyle = UITableViewCellSelectionStyleNone;

    HDViedeoTitleViewCell * titleCell = [tableView dequeueReusableCellWithIdentifier:@"HDViedeoTitleViewCell"];
    
    titleCell.titleLabel.text = self.videoTitle;
    
    titleCell.lookLabel.text = [NSString stringWithFormat:@"%ld",(long)self.videoLook];
    
    [titleCell.shareButton addTarget:self action:@selector(shareButtonOnTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.tagsname) {
        
        [titleCell.tagBGView setHidden:NO];
        [titleCell.tagLabel setHidden:NO];
        
        titleCell.tagLabel.text = self.tagsname;
        
    }else{
    
        [titleCell.tagBGView setHidden:YES];
        [titleCell.tagLabel setHidden:YES];
        
    }
    
    if (indexPath.section == 0) {
        return titleCell;
    }else{
        
        return cellSingle;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return  80;
    }else{
    return 115;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section != 0) {
        return 40;
    }
    return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 1;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 40)];
    label.backgroundColor = COLOR(whiteColor);
    if (section == 1) {
        
        label.text = @"  推荐";
        return label;
        
    }else{
    
        return nil;
    
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    
    view.backgroundColor = COLOR(whiteColor);
    
    return view;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.playerView removeFromSuperview];
    
    HDNewsVideoRelatedModel * model = [self.relatedArray objectAtIndexCheck:indexPath.row];
    
    self.videoTitle = model.title;
    //self.videoLook = model.aid;
    
    if (model.tags_name) {
        
        self.tagsname = model.tags_name.allValues[0];
    }
    
    self.picUrl = model.pic;
    
    self.videoUrl = model.fromurl;
    
    self.ItemAid = model.aid;
    
    self.ItemUid = model.uid;
    
    [self setUpTopPlayerView];
    
    [self requestData];
    
    [self setCollectionedButtonsState];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        
        return NO;
        
    }else{

    return YES;

    }
}


#pragma mark == 网络请求
- (void)requestData{
    NSString * url = [NSString stringWithFormat:NewsDetails,(long)self.ItemAid,arc4random()%1000];
    NSLog(@"视频%@",url);
    WEAK_SELF;
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //
    //    //2.把任务添加到队列中执行
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            
            NSDictionary * dataDic = json[@"data"];
            [self.relatedArray removeAllObjects];
            
            HDNewsDetailsModel * model = [HDNewsDetailsModel yy_modelWithDictionary:dataDic];
            
            self.clickedNum = model.clicknum;
            self.videoLook = model.viewnum + 478;
            self.videoTitle = model.title;
            //videoV.videoLook = model.aid;
            
            if (model.tags_name) {
                
                self.tagsname = model.tags_name.allValues[0];
            }
            
            self.picUrl = model.pic;
            
            self.videoUrl = model.fromurl;
            
            self.ItemAid = model.aid;
            
            self.ItemUid = model.uid;
            
            for (NSDictionary * dic in model.related) {
                
                HDNewsVideoRelatedModel * deModel = [HDNewsVideoRelatedModel yy_modelWithDictionary:dic];
                
                [strongSelf.relatedArray addObject:deModel];
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
    
    NSString * url = [NSString stringWithFormat:CollectionTheArticle,(long)self.ItemAid,(long)self.ItemAid,self.token,arc4random()%1000];
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
                [faDic setValue:favaid forKey:[NSString stringWithFormat:@"%ld",(long)self.ItemAid]];
            }
            
            NSString * code = json[@"code"];
            
            if (code.integerValue == 1) {
                [self plistHuanCunWithDic:faDic];
                [PSYProgressNormalHUD showHUDwithtext:@"收藏成功!" to:strongSelf];

            }else if (code.integerValue == 100){
                [PSYProgressNormalHUD showHUDwithtext:@"请勿重复收藏!" to:strongSelf];
            }
            
        } failure:^(NSError *error) {
            
            
        }];
        
    });
    
}
    
- (void)cancelCollection{
    
    NSMutableDictionary * dic = [ZHFactory readPlistWithPlistNameReturnMutableDictionary:self.token];
    NSString * favid = dic[[NSString stringWithFormat:@"%ld",(long)self.ItemAid]];
    self.favid = favid.integerValue;
    WEAK_SELF;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSString * url = [NSString stringWithFormat:CancelCollection,(long)self.favid,self.token,arc4random()%1000];
    
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            NSString * code = json[@"code"];
            if (code.integerValue == 2) {
                [dic removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)self.ItemAid]];
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
    
    NSString * url = [NSString stringWithFormat:PraiseArticle,(long)self.ItemAid,str,self.token,arc4random()%1000];
    
    dispatch_async(queue, ^{
        
        STRONG_SELF;
        
        [[CDAFNetWork sharedMyManager]get:url params:nil success:^(id json) {
            
            NSString * str = json[@"code"];
            if (str.integerValue == 1) {
                
                NSMutableDictionary * faDic = [ZHFactory readPlistWithPlistNameReturnMutableDictionary:self.token];
                if (!faDic) {
                    
                    faDic = [NSMutableDictionary dictionary];
                    
                }
                
                [faDic setValue:@"isclicked" forKey:[NSString stringWithFormat:@"isClicked%ld",(long)self.ItemAid]];
                
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


#pragma mark == 点击事件
- (void)collectionButtonOnTouched:(UIButton *)button{
    
    CAKeyframeAnimation * transition = [self beginTrasition];
    
    [button.imageView.layer addAnimation:transition forKey:@"animation"];
    
    if (self.token) {
        
        if (button.selected == NO) {
            
            [self collectionTheArticle];
            
        }else if(button.selected == YES){
            
            [self cancelCollection];
            
        }
        button.selected = !button.selected;
        
    }else{
        
        PCSignInViewController * signVC = [[PCSignInViewController alloc]init];
        
        [self presentViewController:signVC animated:YES completion:^{
            
            
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
        
        NSString * hashString = [NSString stringWithFormat:@"%ld%ld",(long)self.ItemUid,(long)self.ItemAid];
        
        NSString * hashedStr = [self stringToMD5:hashString];
        [self praiseTheArticleToNet:hashedStr];
    }
    
}

- (void)shareButtonOnTouched:(UIButton *)button{

    [self.customShare createShareUI];
    
}

#pragma mark == 分享代理
- (void) shareBlcakBgViewTaped{}
- (void) shareCustomShareBtnClicked{}
- (void) shareStatus:(NSInteger)shareStatusIndex{}

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
- (void)dealloc{

    [self.playerView removeFromSuperview];
    

}

- (CAKeyframeAnimation *)beginTrasition{

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(1),@(1.5),@(2)];
    animation.duration = 0.5;

    return animation;
}


@end
