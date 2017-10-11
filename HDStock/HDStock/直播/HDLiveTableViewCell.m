//
//  HDLiveTableViewCell.m
//  HDStock
//
//  Created by hd-app01 on 16/11/17.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLiveTableViewCell.h"

@implementation HDLiveTableViewCell


- (void) configUIWithModel:(HDLiveListModel*)model {
    //头像
    [self.headPicIMV sd_setImageWithURL:[NSURL URLWithString:model.header] placeholderImage:imageNamed(@"weidenglu") options:(SDWebImageProgressiveDownload)];
    //直播室名
    self.LiveRoomLab.text = model.name;
    //主题
    self.themeLab.text = model.title;
    //已参与人数
    self.joinPersonNumLab.text = model.people_total;
    //直播状态
    self.LiveStatusLal.textAlignment = NSTextAlignmentLeft;
    //直播状态有3个：视屏直播中，直播中（文字直播），未直播
    if ([model.status isEqualToString:@"2"]) {
        self.LiveStatusLal.text = @"  视频直播中  ";
    }else if ([model.status isEqualToString:@"1"]) {
        self.LiveStatusLal.text = @"  直播中  ";
    }else if ([model.status isEqualToString:@"0"]) {
        self.LiveStatusLal.text = @"  未直播  ";
        self.LiveStatusLal.backgroundColor = UICOLOR(221, 221, 221, 1);
        self.LiveStatusLal.textColor = TEXT_COLOR;
    }

    //关注状态
    if ([model.is_attention isEqualToString:@"0"]) {//(未)关注
        [self setNotCareStatus];
    }else if ([model.is_attention isEqualToString:@"1"]) {//已关注
        [self setAlwaysCareStatus];
    }
    
    //标签
    NSArray * tagLablArr = @[self.firstCirlLab,self.secondCirlLab,self.thirdCirlLab];
    if (model.tag.count <= 3) {
        for (int i = 0; i < model.tag.count; i++) {
            UILabel * tempTagLabl = (UILabel*)tagLablArr[i];
            tempTagLabl.text = [[NSString alloc] initWithFormat:@"  %@  ",model.tag[i]];
            tempTagLabl.textAlignment = NSTextAlignmentLeft;
        }
    }
    for (int i = (int)model.tag.count; i < tagLablArr.count; i++) {
        UILabel * tempL = tagLablArr[i];
        [tempL removeFromSuperview];
    }
    
    
}

- (void) createTagLablsWithModel:(HDLiveListModel*)model {
    //标签
    [self.firstCirlLab removeFromSuperview];
    [self.secondCirlLab removeFromSuperview];
    [self.thirdCirlLab removeFromSuperview];
    
    if ([model.tag isKindOfClass:[NSArray class]] && (model.tag.count>0)) {
        CGFloat space = 5;
        CGFloat verSpace = 9;
        for (int i = 0; i < model.tag.count; i++) {
            CGSize tempSize = [model.tag[i] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
            UILabel * tempTagLabl = [ZHFactory createLabelWithFrame:CGRM((CGMIN_X(self.LiveRoomLab.frame)+space)*i, CGMAX_Y(self.LiveRoomLab.frame)+verSpace, tempSize.width+4, 17) andFont:[UIFont systemFontOfSize:11] andTitleColor:[UIColor colorWithHexString:@"#999999"] title:model.tag[i]];
            tempTagLabl.textAlignment = NSTextAlignmentCenter;
            tempTagLabl.layer.cornerRadius = 8;
            tempTagLabl.layer.masksToBounds = YES;
            tempTagLabl.layer.borderWidth = 1;
            tempTagLabl.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
            if (CGMAX_X(tempTagLabl.frame) <= self.bgView.width-10) {//不能超过边距10
                [self.bgView addSubview:tempTagLabl];
            }else {
                return;
            }
            tempTagLabl.backgroundColor = COLOR(redColor);
        }
    }
}

- (void) setNotCareStatus {
    self.careBtn.layer.borderColor = UICOLOR(25, 121, 202, 1).CGColor;
//    self.careBtn.titleLabel.textColor = UICOLOR(25, 121, 202, 1);
    [self.careBtn setTitle:@"关注" forState:(UIControlStateNormal)];
    [self.careBtn setTitleColor:UICOLOR(25, 121, 202, 1) forState:(UIControlStateNormal)];
}
- (void) setAlwaysCareStatus {
    self.careBtn.layer.borderColor = LINE_COLOR.CGColor;
//    self.careBtn.titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.careBtn setTitle:@"已关注" forState:(UIControlStateSelected)];
    [self.careBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:(UIControlStateSelected)];

}
//关注按钮点击事件
- (IBAction)careBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {//已关注
        [self setAlwaysCareStatus];
    }else {//（未）关注
        [self setNotCareStatus];
    }
    //提交关注状态给后台。。
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
