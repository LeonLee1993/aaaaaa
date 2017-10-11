//
//  ScanCodeTopView.h
//  YJCard
//
//  Created by paradise_ on 2017/7/4.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanCodeTopView : UIView
@property (weak, nonatomic) IBOutlet UIButton *goBack;
@property (weak, nonatomic) IBOutlet UIButton *helfButton;
-(void)closeTheLight;
@end
