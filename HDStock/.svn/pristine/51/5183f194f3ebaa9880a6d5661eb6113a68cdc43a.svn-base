//
//  HDRelatedCell.m
//  HDStock
//
//  Created by hd-app02 on 2017/1/13.
//  Copyright © 2017年 hd-app02. All rights reserved.
//

#import "HDRelatedCell.h"

@interface HDRelatedCell()

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, strong) UILabel * timeLabel;

@property (nonatomic, strong) UILabel * fromLabel;

@property (nonatomic, strong) UIImageView * lookImageView;

@end

@implementation HDRelatedCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.numberOfLines = 0;
        self.timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        
        self.fromLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.fromLabel.font = [UIFont systemFontOfSize:12];
        self.fromLabel.numberOfLines = 0;
        self.fromLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        
        self.lookImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectZero];
        self.lineView.backgroundColor = COLOR(lightGrayColor);
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.fromLabel];
        [self.contentView addSubview:self.lookImageView];
        [self.contentView addSubview:self.lineView];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.right.equalTo(self.titleLabel);
            make.width.mas_equalTo(50);
            
        }];
        [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.timeLabel.mas_left).offset(-20);
            make.centerY.equalTo(self.timeLabel);

        }];
        [self.lookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.size.mas_equalTo(CGSizeMake(15, 9));
            make.centerY.equalTo(self.timeLabel);
            make.right.equalTo(self.fromLabel.mas_left).offset(-5);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(0.5f);
            make.top.equalTo(self.contentView);
            
        }];
    }
    
    return self;
    
}

- (void)setModel:(HDHeadLineModel *)model{

    _model = model;
    
    self.titleLabel.text = model.title;
    
    self.timeLabel.text = model.dateline;
    
    self.fromLabel.text = [NSString stringWithFormat:@"%ld",(long)model.viewnum + 478];

    self.lookImageView.image = imageNamed(@"reading_counting_icon");
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
