//
//  HDLiveTableViewCell.h
//  HDStock
//
//  Created by hd-app01 on 16/11/17.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDLiveListModel.h"


@interface HDLiveTableViewCell : UITableViewCell

/** cell上的背景view*/
@property (weak, nonatomic) IBOutlet UIView *bgView;
/** 头像*/
@property (weak, nonatomic) IBOutlet UIImageView *headPicIMV;
/** 直播室*/
@property (weak, nonatomic) IBOutlet UILabel *LiveRoomLab;
/** 直播状态*/
@property (weak, nonatomic) IBOutlet UILabel *LiveStatusLal;
/** 主题*/
@property (weak, nonatomic) IBOutlet UILabel *themeLab;
/** 参与人数数字*/
@property (weak, nonatomic) IBOutlet UILabel *joinPersonNumLab;
/**关注*/
@property (weak, nonatomic) IBOutlet UIButton *careBtn;

//******  中间的椭圆标签 ******* /
 
/** 第一个:短线 */
@property (weak, nonatomic) IBOutlet UILabel *firstCirlLab;
/** 第二个：互动多*/
@property (weak, nonatomic) IBOutlet UILabel *secondCirlLab;
/** 第三个：计算机*/
@property (weak, nonatomic) IBOutlet UILabel *thirdCirlLab;



- (void) configUIWithModel:(HDLiveListModel*)model;

@end
