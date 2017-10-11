//
//  MyPersonalCommentCell.m
//  HDStock
//
//  Created by liyancheng on 16/11/29.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "MyPersonalCommentCell.h"

@implementation MyPersonalCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setShowDetailView:(UIView *)showDetailView{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToSeeSomeThing)];
    [showDetailView addGestureRecognizer:tap];
}

-(void)tapToSeeSomeThing{
    NSLog(@"showDetail");
}
- (IBAction)buttonClicked:(id)sender {
    NSLog(@"doSomeThing");
}

@end
