//
//  MyKeyChainManager.h
//  uuid
//
//  Created by macmini_01 on 16/6/15.
//  Copyright © 2016年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPKeyChainManager : NSObject

+ (NSMutableDictionary *) getKeyChainQuery:(NSString *) service;

+ (void) save:(NSString *) service data:(id) data;

+ (id) load:(NSString *) service;

+ (void) deletea:(NSString *) service;
@end
