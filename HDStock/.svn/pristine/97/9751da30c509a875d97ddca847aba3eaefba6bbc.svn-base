//
//  HDLiveHistoryDetailTableViewCell.m
//  HDStock
//
//  Created by hd-app01 on 16/11/30.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDLiveHistoryDetailTableViewCell.h"

@implementation HDLiveHistoryDetailTableViewCell {
    UILabel *timeLabl;
   
    UIImageView * sangleIMV;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //时间
        timeLabl = [UILabel new];
        timeLabl.textAlignment = NSTextAlignmentLeft;
        timeLabl.textColor = [UIColor colorWithHexString:@"#666666"];
        timeLabl.font = systemFont(11);
        [self.contentView addSubview:timeLabl];
        //三角形图片
        sangleIMV = [UIImageView new];
        sangleIMV.image = imageNamed(@"Live_history_sangle");
        [self.contentView addSubview:sangleIMV];
        
        //内容的白色背景
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR(whiteColor);
        _bgView.layer.cornerRadius = 4;
        _bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_bgView];
        //内容
        _titleLabl = [UILabel new];
        _titleLabl.textAlignment = NSTextAlignmentLeft;
        _titleLabl.textColor = TEXT_COLOR;
        _titleLabl.font = systemFont(13);
        _titleLabl.numberOfLines = 0;
        [_bgView addSubview:_titleLabl];
    }
    
    return self;
}

- (void) configUIWithModel:(HDLiveHistoryDetailModel*)model{
    _dataModel = model;
    _titleLabl.text = model.content;
    timeLabl.text = model.ctime;
    
    timeLabl.frame = model.timeLablFrame;
    sangleIMV.frame = model.sangleIMVFrame;
    _bgView.frame = model.bgViewFrame;
    _titleLabl.frame = model.titleLablFrame;
    
//    NSLog(@"_timeLabl--%@,model.time--%@",_timeLabl.text,model.time);
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
