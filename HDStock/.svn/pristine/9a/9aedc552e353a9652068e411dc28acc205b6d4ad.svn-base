//
//  LYCUserManager.h
//  meizai
//
//  Created by liyancheng on 16/5/9.
//  Copyright © 2016年 touzibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYCUserManager : NSObject

- (BOOL)isUserLogin;

- (void)logOut;

+ (instancetype) informationDefaultUser;

- (void)loginWithDictionary:(NSDictionary *)dic;

- (NSDictionary *)getUserInfoDic;

- (void)autoLogin;

- (void)getUserInformation;

- (void)setAvatar:(NSString *)headStr;

@property (nonatomic, strong) NSUserDefaults *defaultUser;
@end
