//
//  marketAddSelectedCell.h
//  HDStock
//
//  Created by liyancheng on 16/12/20.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^addSelectedBlock)();
@interface marketAddSelectedCell : UITableViewCell

@property (nonatomic,copy) addSelectedBlock block;

@end
