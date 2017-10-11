//
//  MyKeyChainManager.m
//  uuid
//
//  Created by macmini_01 on 16/6/15.
//  Copyright © 2016年 Jay. All rights reserved.
//

#import "GPKeyChainManager.h"

@implementation GPKeyChainManager

+ (NSMutableDictionary *)getKeyChainQuery:(NSString *)service{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge_transfer id)kSecClassGenericPassword, (__bridge_transfer id)kSecClass,service,(__bridge_transfer id)kSecAttrService,service,(__bridge_transfer id)kSecAttrAccount,(__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible, nil];
    
    return [dic mutableCopy];
}

+(void)save:(NSString *)service data:(id)data{
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
}


+(id)load:(NSString *)service{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:service];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    return ret;
}

+(void)deletea:(NSString *)service{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:service];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}
@end
