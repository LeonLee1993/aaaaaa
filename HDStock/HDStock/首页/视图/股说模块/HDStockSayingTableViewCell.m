//
//  HDStockSayingTableViewCell.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/9.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDStockSayingTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface HDStockSayingTableViewCell(){
    
    NSArray * arrayPlayList;
    
    AVPlayer *player;
    
    int currentPlayIndex;

}


@property (nonatomic, assign) CGFloat localProgress;

@property (nonatomic, strong) UIButton * selectedButton;

@property (nonatomic, assign) BOOL isPlaying;

@end

@implementation HDStockSayingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setUrlArray:(NSArray *)urlArray{

    _urlArray = urlArray;
    
    NSMutableArray * urls = [NSMutableArray new];
    NSMutableArray * titles = [NSMutableArray new];
    
    if (urlArray.count != 0) {
        
        for (HDHeadLineModel * model in urlArray) {
            
            NSURL * url = [NSURL URLWithString:model.fromurl];
            [urls addObject:url];
            
            [titles addObject:model.title];
            
        }
    }
    
    [self.stockOne setTitle:[titles objectAtIndexCheck:0] forState:UIControlStateNormal];
    [self.stockTwo setTitle:[titles objectAtIndexCheck:1] forState:UIControlStateNormal];
    [self.stockThree setTitle:[titles objectAtIndexCheck:2] forState:UIControlStateNormal];
    NSURL * url1 = [NSURL URLWithString:@"http://mp333.oss-cn-hangzhou.aliyuncs.com/12.12%20%E6%B1%A4%E5%A8%81%20%E8%82%A1%E5%B8%82%E6%9A%B4%E8%B7%8C%EF%BC%8C%E8%B0%81%E8%83%BD%E5%8A%9B%E6%8C%BD%E7%8B%82%E6%BE%9C_clip.mp3"];
    NSURL * url2 = [NSURL URLWithString:@"http://mp333.oss-cn-hangzhou.aliyuncs.com/%E5%88%98%E9%98%B3-%E8%82%A1%E6%B5%B7%E6%9C%9D%E9%98%B3-12%E6%9C%8812%E6%97%A5_clip.mp3"];
    NSURL * url3 = [NSURL URLWithString:@"http://mp333.oss-cn-hangzhou.aliyuncs.com/%E9%B3%84%E9%B1%BC%E5%98%B4%E9%9C%B2%E7%8B%B0%E7%8B%9E%20%E8%AF%86%E5%88%AB%E9%A3%8E%E9%99%A9%E6%9C%89%E5%A6%99%E6%8B%9B_clip.mp3"];
    _urlArray = @[url1,url2,url3];

    if (urls.count!=0) {
        NSLog(@"地址%@",urls[2]);
    }
    
    [self setupPlayer:urls];
    [self setupProgressView];

}

- (void)setupProgressView{
    _isPlaying = NO;
    self.playButton.selected = NO;

    self.progressView.fillOnTouch = NO;
    self.progressView.centralView = self.playButton;
    self.progressView.lineWidth = 3;
    self.progressView.borderWidth = 0;
    self.progressView.tintColor = MAIN_COLOR;
    
    WEAK_SELF;
    __weak AVPlayer * weakPlayer = player;
    
    self.progressView.didSelectBlock = ^(UAProgressView *progressView){
        
        weakSelf.playButton.selected = !weakSelf.playButton.selected;
        
        if (!weakSelf.selectedButton) {
            weakSelf.selectedButton = weakSelf.stockOne;
            weakSelf.selectedButton.selected = YES;
            _isPlaying = YES;
            [weakPlayer play];
            
        }else{
            
        if (weakSelf.isPlaying) {
            
            [weakPlayer pause];
            _isPlaying = NO;
        }else{
        
            weakSelf.selectedButton.selected = YES;
            [weakPlayer play];
            _isPlaying = YES;
        
        }
        }
    };
    
    self.progressView.progress = 0;
    
    [self.stockOne addTarget:self action:@selector(stockOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.stockTwo addTarget:self action:@selector(stockOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.stockThree addTarget:self action:@selector(stockOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)stockOnClicked:(UIButton *)button{
    
    if (button!= self.selectedButton) {
        
        switch (button.tag) {
            case 9100:
                [player replaceCurrentItemWithPlayerItem:arrayPlayList[0]];
                break;
            case 9101:
                [player replaceCurrentItemWithPlayerItem:arrayPlayList[1]];
                break;
            case 9102:
                [player replaceCurrentItemWithPlayerItem:arrayPlayList[2]];
                break;
                
            default:
                break;
        }
        
        [player play];
        _isPlaying = YES;
    
        self.selectedButton.selected = NO;
        button.selected = YES;
        self.selectedButton = button;
        
        self.localProgress = 0;
        [self.progressView setProgress:_localProgress];
        
        self.playButton.selected = YES;

    }else{
        
        self.playButton.selected = !self.playButton.selected;
        self.selectedButton.selected = !self.selectedButton.selected;
        
        if (_isPlaying) {
            [player pause];
            _isPlaying = NO;
        }else{
            [player play];
            _isPlaying = YES;
        }

    }

}


- (void)setupPlayer:(NSArray *)array{

    if (array.count != 0) {
        AVPlayerItem * item0 = [[AVPlayerItem alloc]initWithURL:[array objectAtIndexCheck:0]];
        AVPlayerItem * item1 = [[AVPlayerItem alloc]initWithURL:[array objectAtIndexCheck:1]];
        AVPlayerItem * item2 = [[AVPlayerItem alloc]initWithURL:[array objectAtIndexCheck:2]];
        
        arrayPlayList = @[item0,item1,item2];
    }
    
    
    if (player != nil){
        [player removeObserver:self forKeyPath:@"status"];
    }
    
    player = [[AVPlayer alloc]initWithPlayerItem:arrayPlayList[0]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PlayedidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];

    WEAK_SELF;
    
    __weak AVPlayer * weakPlayer = player;
    
    [player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        CMTime duration = weakPlayer.currentItem.asset.duration;
        float seconds = CMTimeGetSeconds(duration);
        NSLog(@"当前总时长%lf",seconds);
        
        if (weakPlayer.currentItem) {
            float currentTime = weakPlayer.currentItem.currentTime.value/weakPlayer.currentItem.currentTime.timescale;
            
            NSLog(@"当前%lf",currentTime);
            weakSelf.localProgress = currentTime / seconds;
            [weakSelf.progressView setProgress:weakSelf.localProgress];
        }
        
        
    }];

}

- (void)PlayedidEnd{
    
    self.selectedButton.selected = NO;
    _isPlaying = NO;
    self.playButton.selected = NO;
    self.localProgress = 0;
    [self.progressView setProgress:_localProgress];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"status"]) {
        
        if (player.status == AVPlayerStatusReadyToPlay) {
            
            
        }
        
    }
    
    
}


//缓冲进度
- (NSTimeInterval)availableDuration{
    
    NSArray * loadedTimeRanges = [[player currentItem]loadedTimeRanges];
    
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    
    float starSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = starSeconds + durationSeconds;
    
    return result;
}

- (void)dealloc{

    [player replaceCurrentItemWithPlayerItem:nil];
    player = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [player removeTimeObserver:self];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
