//
//  HDStockSayingCell.m
//  HDStock
//
//  Created by hd-app02 on 2016/12/15.
//  Copyright © 2016年 hd-app02. All rights reserved.
//

#import "HDStockSayingCell.h"
#import <AVFoundation/AVFoundation.h>
#import "HDStockSayingViewController.h"
@interface HDStockSayingCell()

@property (nonatomic, assign) int currentPlayIndex;

@property (nonatomic, assign) CGFloat localProgress;

@property (nonatomic, strong) UIButton * selectedButton;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) AVPlayer               *player;
@property (nonatomic, strong) AVPlayerItem           *playerItem;
@property (nonatomic, strong) AVURLAsset             *urlAsset;

@property (nonatomic, strong) NSURL                  *videoURL;

@property (nonatomic, strong) NSMutableArray * urls;
@property (nonatomic, strong) NSMutableArray * titles;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *progressviewWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *progressviewHeight;
- (IBAction)moreButton:(UIButton *)sender;

@end

@implementation HDStockSayingCell

- (NSMutableArray *)urls{

    if (!_urls) {
        
        _urls = [[NSMutableArray alloc]init];
    }

    return _urls;

}

- (NSMutableArray *)titles{
    
    if (!_titles) {
        
        _titles = [[NSMutableArray alloc]init];
    }
    
    return _titles;
    
}

- (void)configZFPlayer
{
    [self resetPlayer];
    
    //NSString * cachePath = [NSTemporaryDirectory() stringByAppendingString:@"MediaCache"];
    self.urlAsset = [AVURLAsset assetWithURL:self.videoURL];
    // 初始化playerItem
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PlayedidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    WEAK_SELF;
    
    [weakSelf.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        CMTime duration = weakSelf.player.currentItem.asset.duration;
        float seconds = CMTimeGetSeconds(duration);
        if (weakSelf.player.currentItem) {
            float currentTime = weakSelf.player.currentItem.currentTime.value/weakSelf.player.currentItem.currentTime.timescale;
            weakSelf.localProgress = currentTime / seconds;
            [weakSelf.progressView setProgress:weakSelf.localProgress];
        }
        
        
    }];

    
}

- (void)setUrlArray:(NSArray *)urlArray{
    
    _urlArray = urlArray;
    
    if (urlArray.count != 0) {
        self.contentView.userInteractionEnabled = YES;
        [self.contentView setHidden:NO];
        for (HDHeadLineModel * model in urlArray) {
            
            NSURL * url = [NSURL URLWithString:model.from];
            if(url!=nil){
            [self.urls addObject:url];
            }
            [self.titles addObject:model.title];
            
        }
        [self.stockOne setTitle:[self.titles objectAtIndexCheck:0] forState:UIControlStateNormal];
        [self.stockTwo setTitle:[self.titles objectAtIndexCheck:1] forState:UIControlStateNormal];
        [self.stockThree setTitle:[self.titles objectAtIndexCheck:2] forState:UIControlStateNormal];
        
    }else{
    
        self.contentView.userInteractionEnabled = NO;
    
    }
    
}

- (void)setupProgressView{
    _isPlaying = NO;
    self.playButton.userInteractionEnabled = NO;
    self.playButton.selected = NO;
    self.progressView.fillOnTouch = NO;
    self.progressView.centralView = self.playButton;
    self.progressView.lineWidth = 3;
    self.progressView.borderWidth = 0;
    self.progressView.tintColor = [UIColor colorWithHexString:@"#f4c74e"];
    
    WEAK_SELF;
    
    self.progressView.didSelectBlock = ^(UAProgressView *progressView){
        
        weakSelf.playButton.selected = !weakSelf.playButton.selected;
        
        if (!weakSelf.selectedButton) {
            weakSelf.selectedButton = weakSelf.stockOne;
            weakSelf.selectedButton.selected = YES;
            _isPlaying = YES;
            weakSelf.videoURL = weakSelf.urls[0];
            [weakSelf configZFPlayer];
            [weakSelf.player play];
            
        }else{
            
            if (weakSelf.isPlaying) {
                
                [weakSelf.player pause];
                _isPlaying = NO;
            }else{
                
                weakSelf.selectedButton.selected = YES;
                [weakSelf.player play];
                _isPlaying = YES;
                
            }
        }
    };
    
    self.progressView.progress = 0;
    
    [self.stockOne addTarget:self action:@selector(stockOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.stockTwo addTarget:self action:@selector(stockOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.stockThree addTarget:self action:@selector(stockOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (kScreenIphone4 || kScreenIphone5) {
        
        _toRightDis.constant = 20.0f;
        
    }else{
    
        _toRightDis.constant = 40.0f;
    
    }
    
    
}

- (void)stockOnClicked:(UIButton *)button{
    
    if (button!= self.selectedButton) {
        
        switch (button.tag) {
            case 9100:
                self.videoURL = self.urls[0];
                [self resetPlayer];
                [self configZFPlayer];
                break;
            case 9101:
                self.videoURL = self.urls[1];
                [self resetPlayer];
                [self configZFPlayer];
                break;
            case 9102:
                self.videoURL = self.urls[2];
                [self resetPlayer];
                [self configZFPlayer];
                break;
                
            default:
                break;
        }
        
        [self.player play];
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
            [self.player pause];
            _isPlaying = NO;
        }else{
            [self.player play];
            _isPlaying = YES;
        }
        
    }
    
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
        
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            
            
        }
        
    }
    
    
}


//缓冲进度
- (NSTimeInterval)availableDuration{
    
    NSArray * loadedTimeRanges = [[self.player currentItem]loadedTimeRanges];
    
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    
    float starSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = starSeconds + durationSeconds;
    
    return result;
}

- (void)dealloc{
    
    NSLog(@"cell销毁");
    [self resetPlayer];
    
}

- (void)resetPlayer
{
    self.playerItem = nil;
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[self.player removeTimeObserver:self];
    [self.player removeObserver:self forKeyPath:@"status"];
    [self.player pause];
    
    self.player = nil;
}

- (void)playerPause{

    [self.player pause];
    self.isPlaying = NO;
    self.selectedButton.selected = NO;
    self.playButton.selected = NO;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupProgressView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)moreButton:(UIButton *)sender {
    
    HDStockSayingViewController * sayVC = [[HDStockSayingViewController alloc]init];

    [self.parentController.navigationController pushViewController:sayVC animated:YES];
    
}
@end
