//
//  DataModel.h
//
//  http://www.cnblogs.com/YouXianMing/
//  https://github.com/YouXianMing
//
//  Copyright (c) YouXianMing All rights reserved.
//


#import <Foundation/Foundation.h>

@interface MyCollectedDataModel : NSObject
/*
 favid			收藏id
 uid			会员id
 id			文章id
 idtype		文章类型
 spaceuid		空间会员id
 title			文章标题
 description	简介
 dateline		收藏时间
 countmanypic	图片总数
 pic			封面
 manypic1		内容图片
 catename	分类名称
 viewnum		浏览次数
 from			来源
 fromurl		来源地址
 author		作者
 */
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *Desc;
@property (nonatomic, strong) NSString *catename;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *spaceuid;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *dateline;
@property (nonatomic, strong) NSString *idtype;
@property (nonatomic, strong) NSString *favid;
@property (nonatomic, strong) NSNumber *countmanypic;
@property (nonatomic, strong) NSString *viewnum;
@property (nonatomic, strong) NSString *fromurl;



/**
 *  Init the model with dictionary
 *
 *  @param dictionary dictionary
 *
 *  @return model
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

