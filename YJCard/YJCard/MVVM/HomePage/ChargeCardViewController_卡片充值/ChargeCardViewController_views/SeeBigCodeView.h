//
//  SeeBigCodeView.h
//  YJCard
//
//  Created by paradise_ on 2017/7/3.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LYCSeeBigCodeType) {
    orginalCodeIsBite,//普通二维码
    originalCodeIsBar//条形码
};

@interface SeeBigCodeView : UIView

@property (nonatomic,strong) UIView * codeView;
@property (nonatomic,assign) CGRect codeViewFrame;
@property (nonatomic,strong) NSString *barCodeStr;
@property (nonatomic,assign) LYCSeeBigCodeType codeType;
+ (instancetype)initWithView:(UIView *)view andViewFrame:(CGRect )viewframe andCodeType:(LYCSeeBigCodeType ) type;
@end
