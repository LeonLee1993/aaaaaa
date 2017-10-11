//
//  HDTextDetailCell.m
//  HDStock
//
//  Created by hd-app02 on 2017/1/10.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "HDTextDetailCell.h"
#import <WebKit/WebKit.h>

@interface HDTextDetailCell()<WKNavigationDelegate, WKUIDelegate, UIWebViewDelegate>

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIImageView * iconView;

@property (nonatomic, strong) UILabel * timeLabel;

@property (nonatomic, strong) UIView * lineView;

@end

@implementation HDTextDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:21];
        [self.titleLabel sizeToFit];
        
        //self.iconView = [[UIImageView alloc]initWithFrame:CGRectZero];
        //self.iconView.hidden = YES;
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        //self.timeLabel.hidden = YES;
        
        self.fontButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.fontButton setBackgroundImage:[UIImage imageNamed:@"font_size"] forState:UIControlStateNormal];
        self.fontButton.selected = NO;
        //self.fontButton.hidden = YES;
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.titleLabel];
        //[self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.fontButton];
        [self.contentView addSubview:self.lineView];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.left.equalTo(self.contentView).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
            
        }];
//        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
//           
//            make.left.equalTo(self.contentView).with.offset(10);
//            
//            make.size.mas_equalTo(CGSizeMake(35,35));
//            
//            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
//            
//        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(10);
            //make.centerY.equalTo(self.iconView);
            //make.left.equalTo(self.iconView.mas_right).with.offset(10);
            
        }];
        [self.fontButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(self.timeLabel);
            make.right.equalTo(self.contentView.mas_right).with.offset(-20);
            make.size.mas_equalTo(CGSizeMake(28, 28));

        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5f);
            make.top.equalTo(self.timeLabel.mas_bottom).with.offset(10);
            
        }];
        [self.contentView setHidden:YES];
    }

    return self;

}

- (void)setModel:(HDHeadLineModel *)model{

    _model = model;
    
    if (model.title) {
        
        self.lineView.backgroundColor = COLOR(lightGrayColor);
        
        self.titleLabel.text = model.title;
        
        NSString * dateline = [NSString stringWithFormat:@"发表于%@",model.dateline];
        
        self.timeLabel.text = dateline;
        
        //self.iconView.image = imageNamed(@"iconimage");
        
        [self.contentView setHidden:NO];
        
    }
    
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
