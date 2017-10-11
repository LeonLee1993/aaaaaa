//
//  MyUUIDManager.m
//  uuid
//
//  Created by macmini_01 on 16/6/15.
//  Copyright © 2016年 Jay. All rights reserved.
//

#import "GPUUIDManager.h"
#import "GPKeyChainManager.h"

static NSString *const KEY_IN_KEYCHAIN = @"com.myuuid.uuid";

@implementation GPUUIDManager

+ (void)saveUUID:(NSString *)uuid{
    if (uuid && uuid.length > 0) {
        [GPKeyChainManager save:KEY_IN_KEYCHAIN data:uuid];
    }
}

+(NSString *)getUUID{
    //先获取keychain里面的UUID字段，看是否存在
    NSString *uuid = (NSString *)[GPKeyChainManager load:KEY_IN_KEYCHAIN];
    
    //如果不存在则为首次获取UUID，所以获取保存。
    if (!uuid || uuid.length == 0) {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        uuid = [NSString stringWithFormat:@"%@", uuidString];
        [self saveUUID:uuid];
        CFRelease(puuid);
        CFRelease(uuidString);
    }
    return uuid;
}

+(void)deleteUUID{
    [GPKeyChainManager deletea:KEY_IN_KEYCHAIN];
}

@end
