//
//  HDLiveHistoryDetailModel.h
//  HDStock
//
//  Created by hd-app01 on 16/11/30.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDBaseModel.h"

@interface HDLiveHistoryDetailModel : HDBaseModel

/**年月日*/
@property (copy, nonatomic) NSString *create_time;
/**时分标签*/
@property (copy, nonatomic) NSString *ctime;
/**内容标签*/
@property (copy, nonatomic) NSString *content;
/**100001所属房间编号*/
@property (copy, nonatomic) NSString *belong_room;
/**年*/
@property (copy, nonatomic) NSString *y;
/**月*/
@property (copy, nonatomic) NSString *m;
/**日*/
@property (copy, nonatomic) NSString *d;

/**行高*/
@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,assign) CGRect timeLablFrame;
@property (nonatomic,assign) CGRect sangleIMVFrame;
@property (nonatomic,assign) CGRect bgViewFrame;
@property (nonatomic,assign) CGRect titleLablFrame;

//
//@property (nonatomic,assign) CGFloat titleHeight;

-(instancetype)initWithDict:(NSDictionary *)dict;
- (void) setCellMaxHeight;

@end
