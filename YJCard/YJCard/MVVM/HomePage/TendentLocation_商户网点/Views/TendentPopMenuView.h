//
//  TendentPopMenuView.h
//  YJCard
//
//  Created by paradise_ on 2017/8/8.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^selectedItemBlock)(NSString *,NSString *);
typedef void (^dissappearBlock)();
@interface TendentPopMenuView : UIView

- (id)initWithFrame:(CGRect )frame menuStartPoint:(CGPoint )startPoint menuItems:(NSArray *)items selectedAction:(void (^)(NSInteger index))action;

@property (nonatomic,strong) NSArray *itemsArr;

@property (nonatomic,copy) selectedItemBlock selectedItemBlock;

@property (nonatomic,copy) dissappearBlock dissappearBlock;

- (void)showThePopMenu;

- (void)menuHide;



@end
