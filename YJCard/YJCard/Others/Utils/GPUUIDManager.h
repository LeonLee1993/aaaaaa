//
//  MyUUIDManager.h
//  uuid
//
//  Created by macmini_01 on 16/6/15.
//  Copyright © 2016年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPUUIDManager : NSObject

+ (void) saveUUID: (NSString *) uuid;

+ (NSString *) getUUID;

+ (void) deleteUUID;

@end
