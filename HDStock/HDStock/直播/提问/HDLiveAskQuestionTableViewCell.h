//
//  HDLiveAskQuestionTableViewCell.h
//  HDStock
//
//  Created by hd-app01 on 16/11/25.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDLiveAskQuestionTableViewCell : UITableViewCell
/** 提问标题*/
@property (weak, nonatomic) IBOutlet UILabel *questionTitleLab;
/** 回答状态*/
@property (weak, nonatomic) IBOutlet UILabel *answerStatusLabl;
/** 提问者*/
@property (weak, nonatomic) IBOutlet UILabel *askerLabl;

@end
