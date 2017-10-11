//
//  BuiedProductDetailViewController.m
//  HDStock
//
//  Created by liyancheng on 16/12/13.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "BuiedProductDetailViewController.h"
#import "BuiedPruductTableViewCell.h"//已购买列表页 头部
#import "buiedProductDetailSecondCell.h"//股票趋势  中部
#import "buiedProductDetailThirdCell.h"//底部
#import "buiedProductDetailForthCellTableViewCell.h"
#import "buiedProductDetailFifthCellTableViewCell.h"
#import "ProductDetailModel.h"
#import "fullPageFailLoadView.h"
#import "payAttentionButton.h"

@interface BuiedProductDetailViewController ()<UITableViewDataSource,UITableViewDelegate,fullPageFailLoadViewDelegate>
@property (nonatomic,strong) UITableView *tableView1;
@end

@implementation BuiedProductDetailViewController{
    NSInteger twoButtonFlag;//个股下面菜单栏状态切换  以前说是1-2个 现在变成1-3个
    NSInteger threeButtonFlag;//操盘动态 宏观分析  下面菜单栏切换
    NSMutableArray *dataArr;
    fullPageFailLoadView * fullFailLoad;
    payAttentionButton *payattentionbutton;
    BOOL isCollected;
    NSString *fid;
    BOOL isFirstLoadState;
}


#pragma mark ---initialViews---

- (void)setBottomAttentionButton{
    payattentionbutton = [[payAttentionButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44-64, SCREEN_WIDTH, 44)];
    [payattentionbutton addTarget:self action:@selector(addToMyAttention:) forControlEvents:UIControlEventTouchUpInside];
    payattentionbutton.hidden = YES;
    [self.view addSubview:payattentionbutton];
}




- (void)setTableView{
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.backgroundColor = BACKGROUNDCOKOR;
    [self.tableView1 registerNib:[UINib nibWithNibName:@"BuiedPruductTableViewCell" bundle:nil] forCellReuseIdentifier:@"BuiedPruductTableViewCel"];
    [self.tableView1 registerNib:[UINib nibWithNibName:@"buiedProductDetailSecondCell" bundle:nil] forCellReuseIdentifier:@"buiedProductDetailSecondCell"];
    [self.tableView1 registerNib:[UINib nibWithNibName:@"buiedProductDetailThirdCell" bundle:nil] forCellReuseIdentifier:@"buiedProductDetailThirdCell"];
     [self.tableView1 registerNib:[UINib nibWithNibName:@"buiedProductDetailForthCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"buiedProductDetailForthCellTableViewCell"];
    [self.tableView1 registerNib:[UINib nibWithNibName:@"buiedProductDetailFifthCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"buiedProductDetailFifthCellTableViewCell"];
    self.tableView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44);
    self.tableView1.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
    self.tableView1.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView1];
    WEAK_SELF;
    self.tableView1.mj_header = [PSYRefreshGifHeader headerWithRefreshingBlock:^{
        [dataArr removeAllObjects];
        [weakSelf loadDataOfProductDetail];
    }];
    
    self.tableView1.mj_footer = [PSYRefreshGifFooter footerWithRefreshingBlock:^{
        [dataArr removeAllObjects];
        [weakSelf loadDataOfProductDetail];
    }];
}




#pragma mark ---tableViewDelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(dataArr.count==0){
        return 0;
    }else{
        if(threeButtonFlag == 201){
            if(section == 3){
                if(dataArr.count==2){
                    if(twoButtonFlag==201){
                        ProductDetailModel *model = dataArr[0];
                        return model.operating_strategy.count;
                    }else{
                        ProductDetailModel *model = dataArr[1];
                        return model.operating_strategy.count;
                    }
                }else if(dataArr.count ==1){
                    ProductDetailModel *model = dataArr[0];
                    return model.operating_strategy.count;
                }
                return 5;
            }else{
                return 1;
            }
        }else{
            return 1;
        }
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            BuiedPruductTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"BuiedPruductTableViewCel"];
            
            if(dataArr.count ==2){
                if(twoButtonFlag== 201){
                    cell.model = dataArr[0];
                }else{
                    cell.model = dataArr[1];
                }
                NSString *tempStr = [cell.model.create_date substringFromIndex:5];
                NSArray *temparr = [tempStr componentsSeparatedByString:@"-"];
                
                
                if([_flagStr isEqualToString:@"1"]){
                    cell.title.text = [NSString stringWithFormat:@"《V6尊享版》之%@月%@日策略",temparr[0],temparr[1]];
                }else if ([_flagStr isEqualToString:@"2"]){
                    cell.title.text = [NSString stringWithFormat:@"《擒牛》之%@月%@日策略",temparr[0],temparr[1]];
                }else if ([_flagStr isEqualToString:@"3"]){
                    cell.title.text = [NSString stringWithFormat:@"《降龙》之%@月%@日策略",temparr[0],temparr[1]];
                }else if ([_flagStr isEqualToString:@"4"]){
                    cell.title.text = [NSString stringWithFormat:@"《捉妖》之%@月%@日策略",temparr[0],temparr[1]];
                }
            }else if (dataArr.count ==1){
            
                cell.model = dataArr[0];
                NSString *tempStr = [cell.model.create_date substringFromIndex:5];
                NSArray *temparr = [tempStr componentsSeparatedByString:@"-"];
                if([_flagStr isEqualToString:@"1"]){
                    cell.title.text = [NSString stringWithFormat:@"《V6尊享版》之%@月%@日策略",temparr[0],temparr[1]];
                }else if ([_flagStr isEqualToString:@"2"]){
                    cell.title.text = [NSString stringWithFormat:@"《擒牛》之%@月%@日策略",temparr[0],temparr[1]];
                }else if ([_flagStr isEqualToString:@"3"]){
                    cell.title.text = [NSString stringWithFormat:@"《降龙》之%@月%@日策略",temparr[0],temparr[1]];
                }else if ([_flagStr isEqualToString:@"4"]){
                    cell.title.text = [NSString stringWithFormat:@"《捉妖》之%@月%@日策略",temparr[0],temparr[1]];
                }
                
            }else if(dataArr.count ==2){
                if(twoButtonFlag== 201){
                    cell.model = dataArr[0];
                }else if(twoButtonFlag ==202){
                    cell.model = dataArr[1];
                }else{
                    cell.model = dataArr[2];
                }
                NSString *tempStr = [cell.model.create_date substringFromIndex:5];
                NSArray *temparr = [tempStr componentsSeparatedByString:@"-"];
                
                if([_flagStr isEqualToString:@"1"]){
                    cell.title.text = [NSString stringWithFormat:@"《V6尊享版》之%@月%@日策略",temparr[0],temparr[1]];
                }else if ([_flagStr isEqualToString:@"2"]){
                    cell.title.text = [NSString stringWithFormat:@"《擒牛》之%@月%@日策略",temparr[0],temparr[1]];
                }else if ([_flagStr isEqualToString:@"3"]){
                    cell.title.text = [NSString stringWithFormat:@"《降龙》之%@月%@日策略",temparr[0],temparr[1]];
                }else if ([_flagStr isEqualToString:@"4"]){
                    cell.title.text = [NSString stringWithFormat:@"《捉妖》之%@月%@日策略",temparr[0],temparr[1]];
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:
        {
            buiedProductDetailSecondCell *cell = [self.tableView1 dequeueReusableCellWithIdentifier:@"buiedProductDetailSecondCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(dataArr.count ==2){
                
                if(twoButtonFlag== 201){
                    cell.model = dataArr[0];
                }else{
                    cell.model = dataArr[1];
                }
                [cell setTwoButtonFrame];
                ProductDetailModel *model = dataArr[0];
                ProductDetailModel *model1 = dataArr[1];
                
                if(model.status == (NSNumber *)@(0)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.firstButton.stateLabel2.text = @"操盘中";
                    });
                }else if (model.status ==(NSNumber *)@(1)){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.firstButton.stateLabel2.text = @"止盈";
                    });
                }else if (model.status ==(NSNumber *)@(2)){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.firstButton.stateLabel2.text = @"止损";
                    });
                }
                
                if(model1.status == (NSNumber *)@(0)){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.secondButton.stateLabel2.text = @"操盘中";
                    });
                }else if (model1.status ==(NSNumber *)@(1)){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.secondButton.stateLabel2.text = @"止盈";
                    });
                }else if (model1.status ==(NSNumber *)@(2)){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.secondButton.stateLabel2.text = @"止损";
                    });
                }
                
                if(model.operation_period == (NSNumber *)@(0)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [cell.firstButton.stateLabel1 setText:@"短线"];
                    });
                    
                }else if (model.operation_period ==(NSNumber *)@(1)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.firstButton.stateLabel1.text = @"中线";
                    });
                    
                }else if (model.operation_period ==(NSNumber *)@(2)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.firstButton.stateLabel1.text = @"长线";
                    });
                    
                }
                
                
                
                if(model1.operation_period == (NSNumber *)@(0)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.secondButton.stateLabel1.text = @"短线";
                    });
                }else if (model1.operation_period ==(NSNumber *)@(1)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.secondButton.stateLabel1.text = @"中线";
                    });
                    
                }else if (model1.operation_period ==(NSNumber *)@(2)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.secondButton.stateLabel1.text = @"长线";
                    });
                    
                }
                
                [cell.secondButton setTitle:[NSString stringWithFormat:@"%@%@",model1.name,model1.code] forState:UIControlStateNormal];
                
                [cell.firstButton setTitle:[NSString stringWithFormat:@"%@%@",model.name,model.code] forState:UIControlStateNormal];
                if(cell.firstButton.selected == YES){
                    cell.firstButton.titleLabel.textColor = RGBCOLOR(153,153,153);
                }else{
                    cell.firstButton.titleLabel.textColor = RGBCOLOR(25,121,202);
                }
                
                cell.twoButtonBlock = ^(NSInteger tagIndex){
                    twoButtonFlag = tagIndex;
                    ProductDetailModel *model= dataArr[tagIndex-201];
                    fid = model.id.stringValue;
                    [self getAttentionState];
                    [self.tableView1 reloadData];
                };
            }else if (dataArr.count == 1){
                cell.model = dataArr[0];
                ProductDetailModel *model = dataArr[0];
                [cell setSelectedButtonFrame];
                
                CGRect secondButtonRect = cell.secondButton.frame;
                secondButtonRect.origin.x= self.view.frame.size.width;
                cell.secondButton.hidden = YES;
                
                if(model.status == (NSNumber *)@(0)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.firstButton.stateLabel2.text = @"操盘中";
                    });
                }else if (model.status ==(NSNumber *)@(1)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.firstButton.stateLabel2.text = @"止盈";
                    });
                }else if (model.status ==(NSNumber *)@(2)){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.firstButton.stateLabel2.text = @"止损";
                    });
                }
                
                if(model.operation_period == (NSNumber *)@(0)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [cell.firstButton.stateLabel1 setText:@"短线"];
                    });
                    
                }else if (model.operation_period ==(NSNumber *)@(1)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.firstButton.stateLabel1.text = @"中线";
                    });
                    
                }else if (model.operation_period ==(NSNumber *)@(2)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.firstButton.stateLabel1.text = @"长线";
                    });
                }
                
                [cell.firstButton setTitle:[NSString stringWithFormat:@"%@%@",model.name,model.code] forState:UIControlStateNormal];
                if(cell.firstButton.selected == YES){
                    cell.firstButton.titleLabel.textColor = RGBCOLOR(153,153,153);
                }else{
                    cell.firstButton.titleLabel.textColor = RGBCOLOR(25,121,202);
                }
                
                cell.twoButtonBlock = ^(NSInteger tagIndex){
                    twoButtonFlag = tagIndex;
                    [self.tableView1 reloadData];
                };
            }else if (dataArr.count ==3){
                
                [cell setThreeButtonFrame];
                
                if(twoButtonFlag== 201){
                    cell.model = dataArr[0];
                }else if(twoButtonFlag ==202){
                    cell.model = dataArr[1];
                }else if(twoButtonFlag ==202){
                    cell.model = dataArr[2];
                }
                ProductDetailModel *model = dataArr[0];
                ProductDetailModel *model1 = dataArr[1];
                ProductDetailModel *model2 = dataArr[2];
                
                if(model.status == (NSNumber *)@(0)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.firstButton.stateLabel2.text = @"操盘中";
                    });
                }else if (model.status ==(NSNumber *)@(1)){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.firstButton.stateLabel2.text = @"止盈";
                    });
                }else if (model.status ==(NSNumber *)@(2)){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.firstButton.stateLabel2.text = @"止损";
                    });
                }
                
                if(model1.status == (NSNumber *)@(0)){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.secondButton.stateLabel2.text = @"操盘中";
                    });
                }else if (model1.status ==(NSNumber *)@(1)){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.secondButton.stateLabel2.text = @"止盈";
                    });
                }else if (model1.status ==(NSNumber *)@(2)){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.secondButton.stateLabel2.text = @"止损";
                    });
                }
                
                if(model2.status == (NSNumber *)@(0)){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.thirdButton.stateLabel2.text = @"操盘中";
                    });
                }else if (model1.status ==(NSNumber *)@(1)){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.thirdButton.stateLabel2.text = @"止盈";
                    });
                }else if (model1.status ==(NSNumber *)@(2)){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.thirdButton.stateLabel2.text = @"止损";
                    });
                }
                
                if(model.operation_period == (NSNumber *)@(0)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [cell.firstButton.stateLabel1 setText:@"短线"];
                    });
                    
                }else if (model.operation_period ==(NSNumber *)@(1)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.firstButton.stateLabel1.text = @"中线";
                    });
                    
                }else if (model.operation_period ==(NSNumber *)@(2)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.firstButton.stateLabel1.text = @"长线";
                    });
                    
                }
                
                if(model2.operation_period == (NSNumber *)@(0)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [cell.thirdButton.stateLabel1 setText:@"短线"];
                    });
                    
                }else if (model2.operation_period ==(NSNumber *)@(1)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.thirdButton.stateLabel1.text = @"中线";
                    });
                    
                }else if (model2.operation_period ==(NSNumber *)@(2)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.thirdButton.stateLabel1.text = @"长线";
                    });
                }
                
                if(model1.operation_period == (NSNumber *)@(0)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.secondButton.stateLabel1.text = @"短线";
                    });
                }else if (model1.operation_period ==(NSNumber *)@(1)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.secondButton.stateLabel1.text = @"中线";
                    });
                    
                }else if (model1.operation_period ==(NSNumber *)@(2)){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.secondButton.stateLabel1.text = @"长线";
                    });
                    
                }
                
                
                
                
                [cell.secondButton setTitle:[NSString stringWithFormat:@"%@%@",model1.name,model1.code] forState:UIControlStateNormal];
                
                [cell.firstButton setTitle:[NSString stringWithFormat:@"%@%@",model.name,model.code] forState:UIControlStateNormal];
                
                [cell.thirdButton setTitle:[NSString stringWithFormat:@"%@%@",model2.name,model2.code] forState:UIControlStateNormal];
                
                
                
                if(cell.firstButton.selected == YES){
                    cell.firstButton.titleLabel.textColor = RGBCOLOR(153,153,153);
                }else{
                    cell.firstButton.titleLabel.textColor = RGBCOLOR(25,121,202);
                }
                
                cell.twoButtonBlock = ^(NSInteger tagIndex){
                    twoButtonFlag = tagIndex;
                    ProductDetailModel *model= dataArr[tagIndex-201];
                    fid = model.id.stringValue;
                    [self getAttentionState];
                    [self.tableView1 reloadData];
                };
            }
            return cell;
        }
            break;
        case 2:
        {
            buiedProductDetailThirdCell *cell=[self.tableView1 dequeueReusableCellWithIdentifier:@"buiedProductDetailThirdCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.threeButtonBlock = ^(NSInteger senderIndex){
                NSLog(@"%ld",(long)senderIndex);
                threeButtonFlag = senderIndex;
                [self.tableView1 reloadData];
            };
            
            return cell;
        }
            break;
        case 3:
        {
            if(threeButtonFlag == 201){//这里的下面三个按钮 第一个cell一种样式 二.三中是另一种样式
                buiedProductDetailForthCellTableViewCell *cell=[self.tableView1 dequeueReusableCellWithIdentifier:@"buiedProductDetailForthCellTableViewCell"];
                if(dataArr.count ==2){
                    
                    if(twoButtonFlag == 201){
                        ProductDetailModel *model = dataArr[0];
                        cell.model = model.operating_strategy[indexPath.row];
                        if(indexPath.row == model.operating_strategy.count-1){
                            cell.tagLabel.text = @" 推荐理由 ";
                        }
                    }else{
                        ProductDetailModel *model = dataArr[1];
                        cell.model = model.operating_strategy[indexPath.row];
                        if(indexPath.row == model.operating_strategy.count-1){
                            cell.tagLabel.text = @" 推荐理由 ";
                        }
                    }
                    
                }else if(dataArr.count ==1){
                    
                    ProductDetailModel *model = dataArr[0];
                    cell.model = model.operating_strategy[indexPath.row];
                    if(indexPath.row == model.operating_strategy.count-1){
                        cell.tagLabel.text = @" 推荐理由 ";
                    }
                    
                }else if (dataArr.count ==3){
                    
                    if(twoButtonFlag == 201){
                        ProductDetailModel *model = dataArr[0];
                        cell.model = model.operating_strategy[indexPath.row];
                        if(indexPath.row == model.operating_strategy.count-1){
                            cell.tagLabel.text = @" 推荐理由 ";
                        }
                    }else if(twoButtonFlag==202){
                        ProductDetailModel *model = dataArr[1];
                        cell.model = model.operating_strategy[indexPath.row];
                        if(indexPath.row == model.operating_strategy.count-1){
                            cell.tagLabel.text = @" 推荐理由 ";
                        }
                    }
                    else if(twoButtonFlag==203){
                        ProductDetailModel *model = dataArr[2];
                        cell.model = model.operating_strategy[indexPath.row];
                        if(indexPath.row == model.operating_strategy.count-1){
                            cell.tagLabel.text = @" 推荐理由 ";
                        }
                    }
                    
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                buiedProductDetailFifthCellTableViewCell *cell=[self.tableView1 dequeueReusableCellWithIdentifier:@"buiedProductDetailFifthCellTableViewCell"];
                if(twoButtonFlag == 201){
                    if(dataArr.count ==2){
                        cell.model = dataArr[0];
                    }else if(dataArr.count ==1){
                        cell.model = dataArr[0];
                    }
                    if(threeButtonFlag == 202){
                        NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
                        style1.headIndent = 0;
                        style1.firstLineHeadIndent = 0;
                        style1.lineSpacing = 3;
                        cell.descLabel.attributedText = [[NSAttributedString alloc]initWithString:cell.model.macro_analysis attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:style1}];
                    }else{
                        NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
                        style1.headIndent = 0;
                        style1.firstLineHeadIndent = 0;
                        style1.lineSpacing = 3;
                        cell.descLabel.attributedText = [[NSAttributedString alloc]initWithString:cell.model.industry_analysis attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:style1}];
                    }
                }else if(twoButtonFlag == 202){
                    if(dataArr.count >=2){
                        cell.model = dataArr[1];
                    }
                    if(threeButtonFlag == 202){
                        NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
                        style1.headIndent = 0;
                        style1.firstLineHeadIndent = 0;
                        style1.lineSpacing = 3;
                        if(![cell.model.macro_analysis isKindOfClass:[NSNull class]]){
                            cell.descLabel.attributedText = [[NSAttributedString alloc]initWithString:cell.model.macro_analysis attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:style1}];
                        }
                    }else{
                        NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
                        style1.headIndent = 0;
                        style1.firstLineHeadIndent = 0;
                        style1.lineSpacing = 3;
                        if(![cell.model.industry_analysis isKindOfClass:[NSNull class]]){
                            cell.descLabel.attributedText = [[NSAttributedString alloc]initWithString:cell.model.industry_analysis attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:style1}];
                        }
                    }
                }else{
                    if(dataArr.count ==3){
                        cell.model = dataArr[2];
                    }
                    if(threeButtonFlag == 202){
                        NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
                        style1.headIndent = 0;
                        style1.firstLineHeadIndent = 0;
                        style1.lineSpacing = 3;
                        if(![cell.model.macro_analysis isKindOfClass:[NSNull class]]){
                            cell.descLabel.attributedText = [[NSAttributedString alloc]initWithString:cell.model.macro_analysis attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:style1}];
                        }
                    }else{
                        NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
                        style1.headIndent = 0;
                        style1.firstLineHeadIndent = 0;
                        style1.lineSpacing = 3;
                        if(![cell.model.industry_analysis isKindOfClass:[NSNull class]]){
                            cell.descLabel.attributedText = [[NSAttributedString alloc]initWithString:cell.model.industry_analysis attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:style1}];
                        }
                    }
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
            break;
            
        default:
            break;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            CGSize secondDesc;
            if(dataArr.count==2){
                ProductDetailModel * model;
                if(twoButtonFlag ==201){
                    model = dataArr[0];
                }else{
                    model = dataArr[1];
                }
                NSString * tempStr = model.buy_reason;
                NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
                style1.headIndent = 0;
                style1.firstLineHeadIndent = 0;
                style1.lineSpacing = 9;
                secondDesc = [tempStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:style1} context:nil].size;
            }else if (dataArr.count == 1){
                ProductDetailModel * model = dataArr[0];
                NSString * tempStr = model.buy_reason;
                NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
                style1.headIndent = 0;
                style1.firstLineHeadIndent = 0;
                style1.lineSpacing = 9;
                secondDesc = [tempStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:style1} context:nil].size;
            }else if (dataArr.count == 3){
                ProductDetailModel * model;
                if(twoButtonFlag ==201){
                    model = dataArr[0];
                }else if(twoButtonFlag ==202){
                    model = dataArr[1];
                }else if(twoButtonFlag ==203){
                    model = dataArr[2];
                }
                NSString * tempStr = model.buy_reason;
                NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
                style1.headIndent = 0;
                style1.firstLineHeadIndent = 0;
                style1.lineSpacing = 9;
                secondDesc = [tempStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:style1} context:nil].size;
            }
            return 120+secondDesc.height-5;
        }
            break;
        case 1:
        {
            return 210;
        }
            break;
        case 2:
        {
            return 53;
        }
        case 3:
        {
            ProductDetailModel *model;
            if(dataArr.count == 2){
                if(twoButtonFlag == 201){
                    model = dataArr[0];
                }else{
                    model = dataArr[1];
                }
            }else if(dataArr.count ==1){
                model =dataArr[0];
            }
            if(threeButtonFlag==201){
                CGSize secondDesc;
                if(dataArr.count>0){
                    Operating_strategyModel *modeleded = model.operating_strategy[indexPath.row];
                    NSDictionary *dic =(NSDictionary *) modeleded;
                    NSString * tempStr = dic[@"content"];
                    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
                    style1.headIndent = 0;
                    style1.firstLineHeadIndent = 0;
                    style1.lineSpacing = 7;
                    secondDesc = [tempStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:style1} context:nil].size;
                }
                return 74+secondDesc.height-25;
            }else{
                
                NSString * tempStr;
                NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
                style1.headIndent = 0;
                style1.firstLineHeadIndent = 0;
                style1.lineSpacing = 7;
                
                if(threeButtonFlag == 202){
                    tempStr = model.macro_analysis;
                }else{
                    tempStr = model.industry_analysis;
                }
                CGSize secondDesc = [tempStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:style1} context:nil].size;
                return 40+secondDesc.height-15;
            }
        }
        
            break;
        default:
            break;
    }
    return 28;
}


#pragma mark ---networkRequest---

- (void)addToMyAttention:(UIButton *)sender{
    
    NSDictionary *userInfoDic = [[LYCUserManager informationDefaultUser]getUserInfoDic];
    NSString *urlStr ;
    if(payattentionbutton.selected){
        urlStr = [NSString stringWithFormat:@"http://gkc.cdtzb.com/api/king_favorite/del_favorite/fid/%@/token/%@",fid,userInfoDic[PCUserToken]];//删除的时候又要用什么产品id,添加删除的时候接口返回,不知道为什么这样弄
    }else{
        urlStr = [NSString stringWithFormat:@"http://gkc.cdtzb.com/api/king_favorite/add_favorite/kid/%@/token/%@/king_category/%@",fid,userInfoDic[PCUserToken],self.flagStr];
    }
    
    NSMutableDictionary * mutDic = @{}.mutableCopy;
    
    [[CDAFNetWork sharedMyManager]get:urlStr params:mutDic success:^(id json) {
        if([json[@"code"] isEqual:@(1)]){
            if(!payattentionbutton.selected){
                fid = json[@"data"][0][@"king_id"];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"加入关注成功";
                [hud hideAnimated:YES afterDelay: 1];
            }else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"取消关注成功";
                [hud hideAnimated:YES afterDelay: 1];
            }

            payattentionbutton.selected = !payattentionbutton.selected;
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = json[@"msg"];
            [hud hideAnimated:YES afterDelay: 1];
        }
    } failure:^(NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请求数据出错";
        [hud hideAnimated:YES afterDelay:2];
    }];
}

- (void)loadDataOfProductDetail{
    NSString * url = [NSString stringWithFormat:PCProductDetailURL];
    NSMutableDictionary *mutDic = @{}.mutableCopy;
    [mutDic setObject:_createTimeStr forKey:@"create_date"];
    [mutDic setObject:_flagStr forKey:@"category"];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("lyc.dispathch.key.com", DISPATCH_QUEUE_SERIAL);
    
    dispatch_group_async(group, queue, ^{
        [[CDAFNetWork sharedMyManager]post:url params:mutDic success:^(id json) {
            if([json[@"data"] isKindOfClass:[NSNull class]]||[json[@"data"] isKindOfClass:[NSString class]]){
                [LYCFactory showLycHudToObject:self.view withTitil:@"没有更多数据了"];

            }else{
                NSInteger flagInt=0;
                for (NSDictionary *dic in json[@"data"]) {
                    ProductDetailModel * model = [ProductDetailModel yy_modelWithDictionary:dic];
                    if(flagInt == 0){
                        fid = model.id.stringValue;
                    }
                    flagInt++;
                    [dataArr addObject:model];
                }
            }
            [self getAttentionState];
        } failure:^(NSError *error) {
            [fullFailLoad showWithoutAnimation];
        }];
    });
}


- (void)getAttentionState{
    NSDictionary *userInfoDic = [[LYCUserManager informationDefaultUser]getUserInfoDic];
    NSString * attentionListUrl = [NSString stringWithFormat:@"http://gkc.cdtzb.com/api/king_favorite/is_fav_by_uid_kid/kid/%@/token/%@",fid,userInfoDic[PCUserToken]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[CDAFNetWork sharedMyManager]get:attentionListUrl params:nil success:^(id json) {
            if([json[@"code"] isEqual:@(1)]){
                if([json[@"data"][0][@"is_fav"] isEqual:@(1)]){
                    isCollected = YES;
                    
                        payattentionbutton.selected = YES;
                    
                    
                    fid = json[@"data"][0][@"favid"];
                }else{
                    
                    
                        payattentionbutton.selected = NO;
                    
            
                }
            }else{
                NSLog(@"请求错误");
            }
            
            [self.tableView1 reloadData];
            if(!isFirstLoadState){
                [self endRefresh];
                [fullFailLoad hide];
                payattentionbutton.hidden = NO;
            }
            isFirstLoadState = YES;
                
        } failure:^(NSError *error) {
            [fullFailLoad showWithoutAnimation];
        }];
    });
}


#pragma mark ---otherFunctions---

-(void)endRefresh{
    [self.tableView1.mj_header endRefreshing];
    [self.tableView1.mj_footer endRefreshing];
}

-(void)setFlagStr:(NSString *)flagStr{
    _flagStr = flagStr;
}



- (NSArray *) allPropertyNamesOfModelClass{
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList([ProductDetailModel class], &propertyCount);
    for (int i = 0; i < propertyCount; i ++) {
        objc_property_t property = propertys[i];
        const char * propertyName = property_getName(property);
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(propertys);
    return allNames;
}



-(void)popMenuDidClickRefresh:(fullPageFailLoadView *)popMenu{
    [popMenu.fullfailLoad hideTheSubViews];
    [self loadDataOfProductDetail];
}

#pragma mark ---View's life---

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [fullFailLoad hide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    twoButtonFlag = 201;
    threeButtonFlag = 201;
    isCollected = NO;
    isFirstLoadState = NO;
    if(!self.tableView1){
        self.tableView1 = [[UITableView alloc]init];
    }
    self.title = @"项目服务";
    if(!dataArr){
        dataArr = @[].mutableCopy;
    }
    [self setTableView];
    fullFailLoad = [[fullPageFailLoadView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];;
    [self.view addSubview:fullFailLoad];
    fullFailLoad.delegate = self;
    [fullFailLoad showWithAnimation];
    [self loadDataOfProductDetail];
    [self setBottomAttentionButton];
}
@end
