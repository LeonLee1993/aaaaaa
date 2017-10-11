//
//  stockDetailView.h
//  HDStock
//
//  Created by hd-app02 on 2016/12/16.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockDetailView : UIView
@property (strong, nonatomic) IBOutlet UILabel *stockName;
@property (strong, nonatomic) IBOutlet UILabel *stockNumber;
@property (strong, nonatomic) IBOutlet UILabel *yuqishouyiNumber;
@property (strong, nonatomic) IBOutlet UILabel *diyimairuNumber;
@property (strong, nonatomic) IBOutlet UILabel *diyizhiyingNumber;
@property (strong, nonatomic) IBOutlet UILabel *diyizhisunNumber;
@property (strong, nonatomic) IBOutlet UILabel *diermairuNumber;
@property (strong, nonatomic) IBOutlet UILabel *dierzhiyingNumber;
@property (strong, nonatomic) IBOutlet UILabel *dierzhisunNumber;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *fengexianToLeft;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *fengexianToRight;
@property (strong, nonatomic) IBOutlet UITextView *textView;

+ (instancetype)stockDetailView;

@end
