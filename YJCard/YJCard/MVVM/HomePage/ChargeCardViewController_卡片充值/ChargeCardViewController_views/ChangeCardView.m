//
//  ChangeCardView.m
//  YJCard
//
//  Created by paradise_ on 2017/7/3.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "ChangeCardView.h"
#import "ChangeCardHeadView.h"
#import "ChangeCardListTableViewCell.h"
#import "MemberPayCardsModel.h"

@interface ChangeCardView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ChangeCardView{
    ChangeCardHeadView *cardView;
}

+ (instancetype)initWithCards:(NSArray *)cardsArray{
    static ChangeCardView *cardView;
    cardView = [[self alloc]init];
    cardView.backgroundColor = RGBAColor(0, 0, 0, 0.7);
    cardView.frame = [UIScreen mainScreen].bounds;
    cardView.payCardsArr = cardsArray;
    return cardView;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [self setUpTableView];
}

-(void)didMoveToSuperview{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.lyc_y = self.frame.size.height/2;
        cardView.lyc_y = CGRectGetMinY(self.tableView.frame)-self.frame.size.width/360 * 116;
    }];
}

- (void)setUpTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.height/2)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cardView = [ChangeCardHeadView viewFromXib];
    __weak typeof (self)weakSelf = self;
    cardView.dissMissChangeCardViewBlock = ^{
        [weakSelf removeFromSuperview];
    };
    
    cardView.frame = CGRectMake(0, CGRectGetMinY(self.tableView.frame)-self.frame.size.width/360 * 116, self.frame.size.width, self.frame.size.width/360 * 116);
    [self.tableView registerNib:[UINib nibWithNibName:@"ChangeCardListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChangeCardListTableViewCell"];
    [self addSubview:cardView];
    [self addSubview:self.tableView];
    
    cardView.lyc_y = self.frame.size.height;
    self.tableView.lyc_y = cardView.lyc_y + self.frame.size.width/360 * 116;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.payCardsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChangeCardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChangeCardListTableViewCell"];
    MemberPayCardsModel * model = self.payCardsArr[indexPath.row];
    cell.payCardNO = model.cardNo;
    cell.leftMoneyLabel.text = [NSString stringWithFormat:@"账户余额: ¥%@",model.balance];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(point.y<cardView.lyc_y){
        [self removeFromSuperview];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenWidth/375*66;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MemberPayCardsModel * model = self.payCardsArr[indexPath.row];
    
    if([model.balance isEqualToString:@"0.00"]){
        [MBProgressHUD showWithText:@"该卡片无余额,不可选"];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:model.cardNo forKey:DefaultPayCard];
        [[NSUserDefaults standardUserDefaults]setObject:model.cardId forKey:DefaultPayCardID];
        [self.tableView reloadData];
        [self removeFromSuperview];
        self.resetPayNumBlock();
    }
    
    
}



-(void)dealloc{
    NSLog(@"delloo");
}



@end
