//
//  RedPacketView.h
//  redPacketView
//
//  Created by paradise_ on 2017/9/18.
//  Copyright © 2017年 YJGX. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^seeDetailBlock)();
@interface RedPacketView : UIView
@property (strong, nonatomic)  UIImageView * openImageView;
    @property (weak, nonatomic) IBOutlet UIImageView *openForeImageVIew;
@property (weak, nonatomic) IBOutlet UIButton *seeDetailButton;
@property (weak, nonatomic) IBOutlet UILabel *tradeMoney;
    
@property (weak, nonatomic) IBOutlet UIImageView *tempImageView;

+ (instancetype)installRedPacketView;

@property (nonatomic,strong) NSString * returnMoneyStr;

@property (nonatomic,copy) seeDetailBlock seeDetailBlock;

@end
