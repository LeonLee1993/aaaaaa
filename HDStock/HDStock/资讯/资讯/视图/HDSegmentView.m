//
//  HDSegmentView.m
//  HDStock
//
//  Created by hd-app02 on 16/11/17.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDSegmentView.h"
#import "ZXMyInfoViewController.h"
#import "ZJTitleView.h"

static NSString * const kMyInfoArr = @"myInfoArr";

@interface HDSegmentView(){

    KindOfTableView kind;

}

@property (nonatomic,strong) NSMutableArray * selectedLabsArr;
@property(strong, nonatomic) NSMutableArray<NSString *> *titles;

@end

@implementation HDSegmentView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        
        [self setData];
        
        [self creatControllersWithArr:_titles];
        
        [self addSubview:_segmentView];
    }

    return self;

}

- (void)layoutSubviews{
    
    [super layoutSubviews];

    _segmentView.frame = self.bounds;

}

- (void)creatControllersWithArr:(NSArray *) arr{
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    
    //    /** 是否显示附加的按钮 默认为NO*/
    style.showExtraButton = YES;
    
    //    /** 是否自动调整标题的宽度, 当设置为YES的时候 如果所有的标题的宽度之和小于segmentView的宽度的时候, 会自动调整title的位置, 达到类似"平分"的效果 默认为NO*
    style.autoAdjustTitlesWidth = YES;
    //    style.selectedTitleColor = [UIColor colorWithRed:171 green:132 blue:32 alpha:1];
    
    //    /** 设置附加按钮的背景图片 默认为nil*/
    style.extraBtnBackgroundImageName = @"+";
    
    //    /** 标题的字体 默认为14 */
    style.titleFont = [UIFont systemFontOfSize:16];
    
    style.titleMargin = self.bounds.size.width / 17.0f;
    
    style.segmentViewBounces = NO;
    
    style.selectedTitleColor = MAIN_COLOR;
    
    //style.scaleTitle = YES;
    
    //style.titleBigScale = 1.40f;
    //    /** 标题选中状态的颜色 */
    
    _segmentView = [[ZJScrollSegmentView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH * 95 / 207, self.bounds.size.width, 40) segmentStyle:style delegate:self titles:arr selected:3 titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
        
        NSString * title = titleView.text;
        
        if ([title isEqualToString:@"推荐"]) {
            
            kind = KindOfTableViewRecommend;
            
        }else if ([title isEqualToString:@"要闻"]){
        
            kind = KindOfTableViewImportant;
        
        }else if ([title isEqualToString:@"7*24小时"]){
            
            kind = KindOfTableViewTFHours;
            
        }else if ([title isEqualToString:@"日历"]){
            
            kind = KindOfTableViewCalander;
            
        }else if ([title isEqualToString:@"个股"]){
            
            kind = KindOfTableViewPersonal;
            
        }else if ([title isEqualToString:@"板块"]){
            
            kind = KindOfTableViewPlate;
            
        }else if ([title isEqualToString:@"大盘"]){
            
            kind = KindOfTableViewTape;
            
        }else if ([title isEqualToString:@"外围"]){
            
            kind = KindOfTableViewOutskirts;
            
        }
        
        [self.delegate isKindOfTableViewCells:kind];
        
    }];
    
    _segmentView.backgroundColor = BGVIEW_COLOR;
    
    WEAK_SELF;
    
    _segmentView.extraBtnOnClick = ^(UIButton * button){
        
        [button addTarget:weakSelf action:@selector(onclick:) forControlEvents:UIControlEventTouchUpInside];
        
    };
    
}
//跳转到添加标签页面
- (void)onclick:(UIButton *)button{
    
    ZXMyInfoViewController * addInfoVC = [[ZXMyInfoViewController alloc] init];
    addInfoVC.hidesBottomBarWhenPushed = YES;
    
    WEAK_SELF;
    addInfoVC.infoBlcok = ^(NSArray * selectedInfoArr)  {
        //获取选中的资讯数组
        STRONG_SELF;
        [strongSelf.selectedLabsArr removeAllObjects];
        [strongSelf.selectedLabsArr addObjectsFromArray:selectedInfoArr];
        
        //创建控制器titles
        [strongSelf.titles removeAllObjects];
        [strongSelf.titles addObjectsFromArray:selectedInfoArr];
        [strongSelf creatControllersWithArr:strongSelf.titles];
        
        [strongSelf.delegate reloadSegmentView];
        
    };
    
    [self.delegate addButtonForScrollSegmentsOnClicked:button toPushToController:addInfoVC];
    
}

- (NSMutableArray *)selectedLabsArr {
    if (!_selectedLabsArr) {
        _selectedLabsArr = [NSMutableArray array];
    }
    return _selectedLabsArr;
}

- (void)setData{
    
    if (!_titles) {
        if ([ZHFactory readPlistWithPlistName:@"infoLabels.plist"]) {//有缓存
            _titles = [[ZHFactory readPlistWithPlistName:@"infoLabels.plist"] objectForKey:kMyInfoArr];
        }else {//没缓存
            _titles = [NSMutableArray arrayWithArray:@[@"推荐",@"要闻",@"7*24小时",@"日历",]];
        }
        
        //[self creatControllersWithArr:_titles];
    }
    
    
}


@end
