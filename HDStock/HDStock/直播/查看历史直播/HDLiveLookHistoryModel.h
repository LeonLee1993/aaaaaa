//
//  HDLiveLookHistoryModel.h
//  HDStock
//
//  Created by hd-app01 on 16/11/30.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDBaseModel.h"

@interface HDLiveLookHistoryModel : HDBaseModel

/**主题title*/
@property (copy, nonatomic) NSString *title;
/**参与人数*/
@property (copy, nonatomic) NSString *people_total;


@end
