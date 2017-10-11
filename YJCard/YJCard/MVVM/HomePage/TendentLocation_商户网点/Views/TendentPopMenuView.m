//
//  TendentPopMenuView.m
//  YJCard
//
//  Created by paradise_ on 2017/8/8.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "TendentPopMenuView.h"
#import "TendentCategoryModel.h"
#import "TendentPopViewCell.h"
#import "TendentCityModel.h"

@interface TendentPopMenuView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) UIView *backgroudView;

@end

@implementation TendentPopMenuView{
    TendentPopViewCell * popCell;
}

- (id)initWithFrame:(CGRect )frame menuStartPoint:(CGPoint )startPoint menuItems:(NSArray *)items selectedAction:(void (^)(NSInteger index))action{
//    if(self == [super initWithFrame:frame]){
        TendentPopMenuView *popMenuView = [[TendentPopMenuView alloc]initWithFrame:frame];
        //背景色
        popMenuView.backgroudView = [[UIView alloc]initWithFrame:popMenuView.bounds];
        [popMenuView addSubview:popMenuView.backgroudView];
        popMenuView.backgroudView.backgroundColor = [UIColor blackColor];
        //列表视图
        popMenuView.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(popMenuView.frame)/2)];
        popMenuView.tableView.delegate = popMenuView;
        popMenuView.tableView.dataSource = popMenuView;
        popMenuView.tableView.layer.anchorPoint = CGPointMake(0, 0);
        [popMenuView addSubview:popMenuView.tableView];
        popMenuView.tableView.transform = CGAffineTransformMakeScale(1, 0.01);
        popMenuView.tableView.layer.position = CGPointMake(0, 0);
        [popMenuView.tableView registerNib:[UINib nibWithNibName:@"TendentPopViewCell" bundle:nil] forCellReuseIdentifier:@"TendentPopViewCell"];
        popMenuView.backgroudView.alpha = 0;
//    }
    return popMenuView;
}

- (void)showThePopMenu{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.backgroudView.alpha = 0.5;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)menuHide{
    [UIView animateWithDuration:5*0.05 animations:^{
        self.tableView.transform = CGAffineTransformMakeScale(1, 0.01);
        self.backgroudView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(point.y>self.tableView.frame.size.height){
        [self menuHide];
        self.dissappearBlock();
    }
}

-(void)setItemsArr:(NSArray *)itemsArr{
    _itemsArr = itemsArr;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TendentPopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TendentPopViewCell"];
    TendentCategoryModel * model = _itemsArr[indexPath.row];
    cell.titleLabel.text = model.name;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenWidth/375*35;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TendentPopViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.tableView reloadData];
    popCell.titleLabel.textColor = RGBColor(102, 102, 102);
    popCell = cell;
    cell.titleLabel.textColor = MainColor;
    TendentCityModel * model = _itemsArr[indexPath.row];
    self.selectedItemBlock(cell.titleLabel.text,[NSString stringWithFormat:@"%@",model.id]);
    [self menuHide];
    self.dissappearBlock();
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * defaultStr = [[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefault];
    TendentPopViewCell *popViewcell = (TendentPopViewCell *)cell;
    
    NSString * defaultStr1 = [[NSUserDefaults standardUserDefaults]objectForKey:TendentListDefaultCity];
    
    if([popViewcell.titleLabel.text isEqualToString:defaultStr]||[popViewcell.titleLabel.text isEqualToString:defaultStr1]){
        popViewcell.titleLabel.textColor = MainColor;
    }else{
        popViewcell.titleLabel.textColor = RGBColor(102, 102, 102);
    }
}

@end
