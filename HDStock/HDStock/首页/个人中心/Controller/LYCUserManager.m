//
//  LYCUserManager.m
//  meizai
//
//  Created by liyancheng on 16/5/9.
//  Copyright © 2016年 touzibao. All rights reserved.
//

#import "LYCUserManager.h"

#import "AppDelegate.h"
@implementation LYCUserManager{
    
}

+(instancetype)informationDefaultUser{
    static dispatch_once_t onceToken;
    static LYCUserManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[self alloc]initA];
    });
    return instance;
}

- (instancetype)initA{
    if(self =[super init]){
        _defaultUser = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (BOOL)isUserLogin {
    NSDictionary *dic =[_defaultUser objectForKey:PCUserKey];
    if ([dic[PCUserState] isEqualToString:@"success"]) {
        return YES;
    }
    return NO;
}

- (void)loginWithDictionary:(NSDictionary *)dic{
//    NSLog(@"%@",dic);
    [_defaultUser setObject:dic forKey:PCUserKey];
}


- (void)logOut {
    NSDictionary *dic =[_defaultUser objectForKey:PCUserKey];
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mutDic removeAllObjects];
    [_defaultUser setObject:mutDic forKey:PCUserKey];
}

-(NSDictionary *)getUserInfoDic{
    NSDictionary *dic;
    if(![[_defaultUser objectForKey:PCUserKey]isKindOfClass:[NSNull class]]){
        dic = [_defaultUser objectForKey:PCUserKey];
    }
    return dic;
}

-(void)autoLogin{
    [self signInAction];
}

- (void)signInAction{
    
    NSDictionary * infoDicd = [self getUserInfoDic];
    NSString *url = loginStr;
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    NSData *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
    if(!infoDicd[PCUserPassword]||!infoDicd[PCUserPhone]){
        NSLog(@"没得用户");
    }else{
        [mutDic setObject:infoDicd[PCUserPassword] forKey:@"password"];
        if([infoDicd[PCUserPhone] isKindOfClass:[NSNull class]]){
            [mutDic setObject:@"" forKey:@"username"];
        }else{
            [mutDic setObject:infoDicd[PCUserPhone] forKey:@"username"];
        }

        if(deviceToken !=nil){
            [mutDic setObject:deviceToken forKey:@"deviceToken"];
        }

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
        [manager POST:url parameters:mutDic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //NSLog(@"登录返回%@",responseObject);
            
            if([responseObject[@"code"] isEqual:@(1)]){
                NSMutableDictionary *infoDic = @{}.mutableCopy;
                if(infoDicd[PCUserPhone]&&infoDicd[PCUserPassword]){
                    [infoDic setObject:responseObject[@"msg"] forKey:PCUserState];
                    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    appDelegate.leftSideVc.leftVc.nameLabel.text = responseObject[@"data"][@"username"];
                    [infoDic setObject:responseObject[@"data"][@"token"] forKey:PCUserToken];
                    [infoDic setObject:responseObject[@"data"][@"username"] forKey:PCUserName];
                    [infoDic setObject:responseObject[@"data"][@"uid"] forKey:PCUserUid];
                    [infoDic setObject:infoDicd[PCUserPassword] forKey:PCUserPassword];
                    [infoDic setObject:infoDicd[PCUserPhone] forKey:PCUserPhone];
                    [_defaultUser setObject:infoDic forKey:PCUserKey];
                    [self getUserInformation];
                }
            }else{
                NSLog(@"登录失败");
            }
          
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
    
    NSDictionary *dic = [self getUserInfoDic];
    NSString *avatarStr = [NSString stringWithFormat:@"%@%@&%u",getAvatar,dic[PCUserToken],arc4random()%10000];
    if(dic[PCUserToken]){
        [mutDic setObject:dic[PCUserToken] forKey:@"token"];
        [[CDAFNetWork sharedMyManager] post:avatarStr params:nil success:^(id json) {
            NSString * avatarStr = [NSString stringWithFormat:@"http://%@",json[@"data"][@"header_img"]];
            NSDictionary *dic = [[LYCUserManager informationDefaultUser] getUserInfoDic];
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [mutDic setObject:avatarStr forKey:PCUserAvatar];
            [[LYCUserManager informationDefaultUser] loginWithDictionary:mutDic];
            [self setAvatar:avatarStr];
        } failure:^(NSError *error) {

        }];
    }
    
}

- (void)setAvatar:(NSString *)headStr{
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.leftSideVc.leftVc.imageView  sd_setImageWithURL:[NSURL URLWithString:headStr]  placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if([_defaultUser objectForKey:@"avatar"]){
            
        }else{
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            [_defaultUser setObject:data forKey:@"avatar"];
        }
    }];
}


#pragma mark --获得当前用户登录信息
- (void)getUserInformation{
    NSString *url = [NSString stringWithFormat:@"%@",getInformationStr];
    
    NSDictionary *infoDic = [LYCUserManager informationDefaultUser].getUserInfoDic;
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    if(infoDic[PCUserToken]){
        [mutDic setObject:infoDic[PCUserToken] forKey:@"token"];
    }
    [[CDAFNetWork sharedMyManager]post:url params:mutDic success:^(id json) {
        if([json[@"code"] isEqual:@(1)]&&![json[@"data"][@"header_img"] isEqualToString:@"http://gkp.cdtzb.com/"]){
            NSDictionary *dic = [self getUserInfoDic];
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    if(![_defaultUser objectForKey:@"avatar"]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [appDelegate.leftSideVc.leftVc.imageView sd_setImageWithURL:[NSURL URLWithString:json[@"data"][@"header_img"]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                NSData *data = UIImageJPEGRepresentation(appDelegate.leftSideVc.leftVc.imageView.image, 0.1);
                                if(data!=nil){
                                    [_defaultUser setObject:data forKey:@"avatar"];
                                }
                            }];
                        });
                    }else{
                        appDelegate.leftSideVc.leftVc.imageView.image = [UIImage imageWithData:[_defaultUser objectForKey:@"avatar"]];
                    }
            
            [self loginWithDictionary:mutDic];
        }else{
//            NSLog(@"用户没有头像");
        }
    } failure:^(NSError *error) {
        NSLog(@"error");
        NSLog(@"%@",error);
    }];
}

@end
