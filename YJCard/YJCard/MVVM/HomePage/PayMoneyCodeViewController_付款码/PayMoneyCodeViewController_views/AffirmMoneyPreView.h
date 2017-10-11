//
//  AffirmMoneyPreView.h
//  YJCard
//
//  Created by paradise_ on 2017/7/25.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectCardBlock)();

typedef void(^payMoneyBlock)();

typedef void(^selfDissMissBlock)();

@interface AffirmMoneyPreView : UIView

@property (nonatomic,copy) selectCardBlock selectcardBlock;

@property (nonatomic,copy) payMoneyBlock payMoneyBlock;

@property (nonatomic,copy) selfDissMissBlock selfDissMissBlock;

@property (weak, nonatomic) IBOutlet UILabel *RMBNumLabel;

@property (nonatomic,strong) NSString *RMBNumLabelText;
@property (weak, nonatomic) IBOutlet UILabel *payCardNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *payMoneyButton;

@end
