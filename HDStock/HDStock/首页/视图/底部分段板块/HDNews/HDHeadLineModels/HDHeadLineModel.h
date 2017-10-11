//
//  HDHeadLineModel.h
//  HDGolden
//
//  Created by hd-app02 on 16/10/19.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDHeadLineModel : NSObject

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
@property (nonatomic,assign) NSInteger thumb;//封面图片是否缩略
@property (nonatomic,assign) NSInteger remote;//封面图片是否远程
@property (nonatomic,assign) NSInteger id;//来源id
@property (nonatomic,copy)   NSString * idtype;//来源id类型
@property (nonatomic,copy)   NSString * content;//内容分页数
@property (nonatomic,assign) NSInteger allowcomment;//是否允许评论
@property (nonatomic,assign) NSInteger owncomment;//对于推送过来的文章：1，使用文章评论;0,同步原主题/日志的帖子/评论
@property (nonatomic,assign) NSInteger click1;//表态1 id
@property (nonatomic,assign) NSInteger click2;//表态2 id
@property (nonatomic,assign) NSInteger click3;//表态3 id
@property (nonatomic,assign) NSInteger click4;//表态4 id
@property (nonatomic,assign) NSInteger click5;//表态5 id
@property (nonatomic,assign) NSInteger click6;//表态6 id
@property (nonatomic,assign) NSInteger click7;//表态7 id
@property (nonatomic,assign) NSInteger click8;//表态8 id
@property (nonatomic,strong) NSDictionary * tag;//文章属性，自带八位(已扩展至200位)
@property (nonatomic,copy)   NSString * dateline;//添加时间
@property (nonatomic,assign) NSInteger status;//文章状态 0-已审核 1-需要审核 2-已忽略
@property (nonatomic,assign) NSInteger showinnernav;//是否显示分页导航
@property (nonatomic,assign) NSInteger preaid;//上一篇文章id
@property (nonatomic,assign) NSInteger nextaid;//下一篇文章id
@property (nonatomic,assign) NSInteger htmlmade;//
@property (nonatomic,assign) NSInteger htmlname;//
@property (nonatomic,assign) NSInteger htmldir;//
@property (nonatomic,strong) NSDictionary * tags_name;//标签名称   ‘2’	=>’行情’,	行情标签 位置为2    ‘4'=>’爆料’行情标签 位置为4
@property (nonatomic,copy)   NSString * article;
@property (nonatomic,copy)   NSString * manypic0;
@property (nonatomic,copy)   NSString * manypic1;
@property (nonatomic,copy)   NSString * manypic2;
@property (nonatomic,assign) NSInteger countmanypic;
@property (nonatomic,copy)   NSString * catename;

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,copy)   NSString * tagText;

@property (nonatomic, assign) NSInteger is_fav;

@property (nonatomic, assign) NSInteger is_click;

@property (nonatomic, assign) NSInteger viewnum;

@property (nonatomic, copy) NSString * pubtime;

@property (nonatomic, copy) NSString * HourAndMinTime;

@property (nonatomic, copy) NSString * MonthAndDayTime;

@property (nonatomic, assign) NSInteger clicknum;

@end
