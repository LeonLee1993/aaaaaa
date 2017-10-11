//
//  AffirmMoneySecondView.m
//  YJCard
//
//  Created by paradise_ on 2017/7/25.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "AffirmMoneySecondView.h"
#import "ChangeCardListTableViewCell.h"
#import "MemberPayCardsModel.h"
@interface AffirmMoneySecondView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *comeBackView;

@end

@implementation AffirmMoneySecondView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.tableView registerNib:[UINib nibWithNibName:@"ChangeCardListTableViewCell" bundle:nil] forCellReuseIdentifier:@"ChangeCardListTableViewCell"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.comeBackView addGestureRecognizer:tap];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cardsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChangeCardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChangeCardListTableViewCell"];
    MemberPayCardsModel * model = self.cardsArr[indexPath.row];
    cell.payCardNO = model.cardNo;
    cell.leftMoneyLabel.text = [NSString stringWithFormat:@"账户余额: ¥%@",model.balance];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MemberPayCardsModel * model = self.cardsArr[indexPath.row];
    [[NSUserDefaults standardUserDefaults]setObject:model.cardNo forKey:DefaultPayCard];
    [[NSUserDefaults standardUserDefaults]setObject:model.cardId forKey:DefaultPayCardID];
    [self.tableView reloadData];
    self.backBlock();
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenWidth/375*66;
}


- (void)tapAction{
    self.backBlock();
}


@end
