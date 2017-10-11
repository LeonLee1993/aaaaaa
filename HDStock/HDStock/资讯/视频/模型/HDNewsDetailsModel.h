//
//  HDNewsDetailsModel.h
//  HDStock
//
//  Created by hd-app02 on 2016/11/30.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDNewsDetailsModel : NSObject

@property (nonatomic,assign) NSInteger aid; //文章id
@property (nonatomic,assign) NSInteger catid;//栏目id
@property (nonatomic,assign) NSInteger bid;//模块id
@property (nonatomic,assign) NSInteger uid;//用户id
@property (nonatomic,copy)   NSString * username;//用户名
@property (nonatomic,copy)   NSString * title;//标题
@property (nonatomic,copy)   NSString * highlight;//标题样式
@property (nonatomic,copy)   NSString *  author;//原作者
@property (nonatomic,copy)   NSString * from;//来源
@property (nonatomic,copy)   NSString * fromurl;//来源url
@property (nonatomic,assign) NSInteger url;//访问url
@property (nonatomic,copy)   NSString *  summary;//摘要
@property (nonatomic,copy)   NSString *  pic;//封面图片
@property (nonatomic,assign) NSInteger id;//来源id
@property (nonatomic,assign) NSInteger contents;//内容分页数
@property (nonatomic,assign) NSInteger allowcomment;//是否允许评论
@property (nonatomic,assign) NSInteger owncomment;//对于推送过来的文章：1，使用文章评论;0,同步原主题
@property (nonatomic,strong) NSDictionary * tag;//文章属性，自带八位(已扩展至200位)
@property (nonatomic,copy)   NSString * dateline;//添加时间
@property (nonatomic,assign) NSInteger status;//文章状态 0-已审核 1-需要审核 2-已忽略
@property (nonatomic,assign) NSInteger showinnernav;//是否显示分页导航
@property (nonatomic,strong) NSDictionary * tags_name;//标签名称
@property (nonatomic,copy)   NSString * catename;
@property (nonatomic,assign) NSInteger viewnum;
@property (nonatomic,strong) NSArray * related;
@property (nonatomic,assign) NSInteger clicknum;
@end





