//
//  TendentMainTopView.m
//  YJCard
//
//  Created by paradise_ on 2017/8/7.
//  Copyright © 2017年 yijieguangxun. All rights reserved.
//

#import "TendentMainTopView.h"
#import "TendentCategoryModel.h"
//#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "tendentMainTopViewButton.h"
#import "TendentMainPageControl.h"
@interface TendentMainTopView()<UIPageViewControllerDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,strong) TendentMainPageControl * pageControl;

@end

@implementation TendentMainTopView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.mainScrollView.delegate = self;
    self.mainScrollView.alwaysBounceVertical = NO;
    [self setTendentCategoryArr:_TendentCategoryArr];
}

-(void)setTendentCategoryArr:(NSArray *)TendentCategoryArr{
    
    _TendentCategoryArr = TendentCategoryArr;
    NSInteger pageNum = self.TendentCategoryArr.count/8 +1;
    CGFloat perWidth = ScreenWidth/375;
    self.mainScrollView.contentSize = CGSizeMake(pageNum*ScreenWidth, 0);
    NSInteger pageFlag = 0;
    NSInteger numFlag = 0;
    NSInteger indexFlag =0;
    NSInteger subFlag = 0;
    
    for (TendentCategoryModel *model in self.TendentCategoryArr) {
        subFlag = numFlag/4;
        pageFlag = numFlag/8;
        indexFlag = (numFlag/4)%2;
        tendentMainTopViewButton *tendentButton = [[tendentMainTopViewButton alloc]initWithFrame:CGRectMake((numFlag - subFlag *4 )*93.75*perWidth + pageFlag*ScreenWidth , 80*perWidth *indexFlag , perWidth*93.75, perWidth*80)];
        tendentButton.titleStr = model.name;
        [tendentButton setTitleColor:RGBColor(51, 51, 51) forState:UIControlStateNormal];
        [self.mainScrollView addSubview:tendentButton];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tendentButton sd_setImageWithURL:[NSURL URLWithString:model.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"交易记录"]];
            NSLog(@"%@",model.icon);
        });
        [tendentButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        numFlag++;
    }
    
    _pageControl = [[TendentMainPageControl alloc] init];
    
    if(ScreenWidth==414){
        _pageControl.frame = CGRectMake(ScreenWidth/2-10, ScreenWidth/375*175, 20, 20);//指定位置大小
    }else{
        _pageControl.frame = CGRectMake(93.75*perWidth*2, ScreenWidth/375*175, 23, 20);//指定位置大小
    }

    _pageControl.numberOfPages = 2;//指定页面个数
    _pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    //添加委托方法，当点击小白点就执行此方法
    //_pageControl.pageIndicatorTintColor = [UIColor redColor];// 设置非选中页的圆点颜色
    //_pageControl.currentPageIndicatorTintColor = [UIColor blueColor]; // 设置选中页的圆点颜色
    [_pageControl addTarget:self action:@selector(pageChange) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    // 设置页码
    _pageControl.currentPage = page;
}

- (void)pageChange{
    int page = self.mainScrollView.contentOffset.x / self.mainScrollView.frame.size.width;
    self.mainScrollView.contentOffset = CGPointMake(page * ScreenWidth, 0);
}
//输出sender的Text
- (void)buttonAction:(tendentMainTopViewButton *)sender{
    self.TendentTopViewClickBlock(sender.titleLabel.text);
}



@end
