//
//  HPTopView.h
//  YJCard
//
//  Created by paradise_ on 2017/6/29.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HPFunctionButton;
@class HPFunctionLitterButton;
typedef void(^tapToSearchBlock)() ;
@interface HPTopView : UIView


@property (weak, nonatomic) IBOutlet HPFunctionButton *queryCardButton;
@property (weak, nonatomic) IBOutlet HPFunctionButton *payMoneyCodeButton;
@property (weak, nonatomic) IBOutlet HPFunctionButton *scanButton;
@property (weak, nonatomic) IBOutlet HPFunctionButton *chargeButton;
@property (weak, nonatomic) IBOutlet HPFunctionLitterButton *quickBind;
@property (weak, nonatomic) IBOutlet HPFunctionLitterButton *saleRecord;
@property (weak, nonatomic) IBOutlet HPFunctionLitterButton *safeCenter;
@property (weak, nonatomic) IBOutlet HPFunctionLitterButton *offerHelp;
@property (weak, nonatomic) IBOutlet UIView *HPTopSearchView;

@property (nonatomic,copy) tapToSearchBlock tapToSearchBlock;

@end
