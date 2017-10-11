//
//  HDLiveSubmitOrderViewController.h
//  HDStock
//
//  Created by hd-app01 on 16/11/23.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDStockBaseViewController.h"
#import "PersonalproductViewController.h"

@protocol retrunToProductListVCRefreshUIDelegate <NSObject>

/**刷新产品购买状态buyState 1：成功，2：失败*/
- (void) retrunToProductListVCRefreshUI:(NSInteger)buyState;

@end

@interface HDLiveSubmitOrderViewController : HDStockBaseViewController


/** 支付类型Labl*/
@property (weak, nonatomic) IBOutlet UILabel *payFormLabl;
/** 支付金额Labl*/
@property (weak, nonatomic) IBOutlet UILabel *payAmountLabl;
/** 选择支付宝支付的对勾IMV*/
@property (weak, nonatomic) IBOutlet UIImageView *zhiFuBaoSelectedIMV;
/** 选择微信支付的对勾IMV*/
@property (weak, nonatomic) IBOutlet UIImageView *weiXinSelectedIMV;
/** 已经阅读了风险按钮*/
@property (weak, nonatomic) IBOutlet UIButton *fengXianBtn;
/** 风险说明的连接按钮*/
@property (weak, nonatomic) IBOutlet UIButton *linkToFengXianBtn;
/** 去支付按钮*/
@property (weak, nonatomic) IBOutlet UIButton *goToPayBtn;
/** 支付宝按钮*/
@property (weak, nonatomic) IBOutlet UIButton *zhiFuBaoBtn;
/** 微信按钮*/
@property (weak, nonatomic) IBOutlet UIButton *weiXinBtn;

@property (weak, nonatomic) IBOutlet UIView *weiXinBgView;

@property (weak, nonatomic) IBOutlet UIView *zhiFuBaoBgView;

@property (nonatomic,strong)NSString *needPayMoneyStr;
@property (nonatomic,strong)NSString *productId;

@property (nonatomic,weak) id<retrunToProductListVCRefreshUIDelegate>retrunRefreshBuyStateDelegate;

/**1:从个人中心进入产品详情页，2:从首页进入*/
@property (nonatomic,assign) NSInteger comfromIndex;

@end
