//
//  AutoMessageTableViewCell.h
//  YJCard
//
//  Created by paradise_ on 2017/8/11.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
//

@interface AutoMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IdLabel;
@property (weak, nonatomic) IBOutlet UILabel *ProvinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (nonatomic,strong) NSDictionary * infoDic;

@end
