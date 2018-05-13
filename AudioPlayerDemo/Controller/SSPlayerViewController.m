//
//  SSPlayerViewController.m
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/8.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import "SSPlayerViewController.h"
#import "SSUIPlayerControlManager.h"
#import "Masonry.h"
#import "AudioManager.h"
#import "UIImageView+WebCache.h"

@interface SSPlayerViewController ()

@property (nonatomic, strong) SSUIPlayerControlManager *controlManager;
@property (nonatomic, strong) UIImageView *bgImageView;
@end

@implementation SSPlayerViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationController.title = @"播放器";

  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didBecomeActive:)
                                               name:UIApplicationDidBecomeActiveNotification object:nil];
  [self initViews];
  
  if ([AudioManager shareInstance].state == SSPlayerPlayStatePause || [AudioManager shareInstance].state == SSPlayerPlayStateIdle) {
    [[AudioManager shareInstance] play];
  }
  
  self.controlManager = [[SSUIPlayerControlManager alloc] init];
  
  UIImageView *cover = [self.controlManager coverImageViewWithSuperView:self.view makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.top.equalTo(self.view).offset(200);
    make.size.mas_equalTo(CGSizeMake(240, 240));
  }];
  cover.layer.masksToBounds = YES;
  cover.layer.cornerRadius = 120;
  
  UIButton *coverLoading = [[UIButton alloc] init];
  [coverLoading setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self.view addSubview:coverLoading];
  [coverLoading mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.top.equalTo(self.view).offset(200);
    make.size.mas_equalTo(CGSizeMake(240, 240));
  }];
  
  [RACObserve([AudioManager shareInstance], isRequsetingNetwork) subscribeNext:^(id x) {
    if ([x boolValue]) {
      [coverLoading setTitle:@"加载中" forState:UIControlStateNormal];
      coverLoading.enabled = NO;
    } else {
      if ([AudioManager shareInstance].categoryList.count <= 0) {
        [coverLoading setTitle:@"点击重试" forState:UIControlStateNormal];
        coverLoading.enabled = YES;
      } else {
        [coverLoading setTitle:@"" forState:UIControlStateNormal];
        coverLoading.enabled = NO;
      }
    }
  }];
  
  [[coverLoading rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    [[AudioManager shareInstance] threeSecondsLoad];
  }];
  

  UIButton *playButton = [self.controlManager playAndPauseButtonWithSuperView:self.view action:nil makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.bottom.equalTo(self.view).offset(-10);
  }];
  
  UILabel *loadingLabel = [[UILabel alloc] init];
  loadingLabel.textColor = [UIColor whiteColor];
  loadingLabel.font = [UIFont systemFontOfSize:10];
  [self.view addSubview:loadingLabel];
  [loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.bottom.equalTo(playButton.mas_top).offset(-8);
  }];
  
  [RACObserve([AudioManager shareInstance], state) subscribeNext:^(id x) {
    
      if ([AudioManager shareInstance].state == SSPlayerPlayStatePlaying) {
        [playButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
        [playButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause_prs"] forState:UIControlStateHighlighted];
        loadingLabel.text = @"";
      } else if ([AudioManager shareInstance].state == SSPlayerPlayStateBuffering ) {
        [playButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
        [playButton setImage:[UIImage imageNamed:@"cm2_fm_btn_pause_prs"] forState:UIControlStateHighlighted];
        loadingLabel.text = @"加载中...";
      } else {
        [playButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
        [playButton setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
        loadingLabel.text = @"";
      }
  
  }];
  
  UIButton *nextButton = [self.controlManager nextAudioButtonWithSuperView:self.view action:nil makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(playButton);
    make.left.equalTo(playButton.mas_right).offset(80);
    
  }];
  [nextButton setImage:[UIImage imageNamed:@"cm2_fm_btn_next"] forState:UIControlStateNormal];
  [nextButton setImage:[UIImage imageNamed:@"cm2_fm_btn_next_prs"] forState:UIControlStateHighlighted];

  
  UIButton *playModeButton = [self.controlManager singleCycleButtonWithSuperView:self.view action:nil makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(playButton);
    make.right.equalTo(playButton.mas_left).offset(-80);
  }];
  
  [RACObserve([AudioManager shareInstance], playMode) subscribeNext:^(id x) {
    if ([x integerValue] == SSPlayerPlayModeRepeatOne) {
      [playModeButton setImage:[UIImage imageNamed:@"cm2_icn_one"] forState:UIControlStateNormal];
      [playModeButton setImage:[UIImage imageNamed:@"cm2_icn_one_prs"] forState:UIControlStateHighlighted];
    }  else {
      [playModeButton setImage:[UIImage imageNamed:@"cm2_icn_loop"] forState:UIControlStateNormal];
      [playModeButton setImage:[UIImage imageNamed:@"cm2_icn_loop_prs"] forState:UIControlStateHighlighted];
    }
  }];
  
  UILabel *currentLabel = [self.controlManager currentTimeLabelWithSuperView:self.view makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(playButton.mas_top).offset(-30);
    make.left.equalTo(self.view).offset(10);
    make.width.mas_equalTo (40);
  }];
  
  UILabel *totalLabel = [self.controlManager totalTimeLabelWithSuperView:self.view makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(currentLabel);
    make.right.equalTo(self.view).offset(-10);
  }];
  
  UIProgressView *progressView = [self.controlManager playProgressViewWithSuperView:self.view trackTintColor:[UIColor lightGrayColor] progressTintColor:[UIColor redColor] makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(currentLabel);
    make.left.equalTo(currentLabel.mas_right).offset(10);
    make.right.equalTo(totalLabel.mas_left).offset(-10);
    make.height.mas_equalTo(2);
  }];
  
  [self.controlManager audioNameLabelWithSuperView:self.view makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(progressView.mas_top).offset(-60);
    make.centerX.equalTo(progressView);
  }];
  
  [self.controlManager audioSingerLabelWithSuperView:self.view makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(progressView.mas_top).offset(-90);
    make.centerX.equalTo(progressView);
  }];
 
  UIButton *fmButton = [[UIButton alloc] init];
  fmButton.layer.cornerRadius = 4;
  fmButton.layer.borderColor = [UIColor whiteColor].CGColor;
  fmButton.layer.borderWidth = 1;
  [fmButton setTitle:@"FM" forState:UIControlStateNormal];
  [fmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  fmButton.titleLabel.font = [UIFont systemFontOfSize:11];
  [self.view addSubview:fmButton];
  [fmButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.view).offset(-40);
    make.top.equalTo(self.view).offset(90);
    make.size.mas_equalTo(CGSizeMake(50, 30));
  }];
  
  UIButton *musicButton = [[UIButton alloc] init];
  musicButton.layer.cornerRadius = 4;
  musicButton.layer.borderColor = [UIColor whiteColor].CGColor;
  musicButton.layer.borderWidth = 1;
  [musicButton setTitle:@"音乐" forState:UIControlStateNormal];
  [musicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  musicButton.titleLabel.font = [UIFont systemFontOfSize:11];
  [self.view addSubview:musicButton];
  [musicButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(fmButton.mas_left).offset(-10);
    make.centerY.equalTo(fmButton);
    make.size.mas_equalTo(CGSizeMake(50, 30));
  }];
  
  [[musicButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    musicButton.enabled = NO;
    fmButton.enabled = YES;
    [[AudioManager shareInstance] setAudioList:[AudioManager shareInstance].categoryList[0]] ;
    [[AudioManager shareInstance] play];
  }];
  
  [[fmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    fmButton.enabled = NO;
    musicButton.enabled = YES;
    [[AudioManager shareInstance] setAudioList:[AudioManager shareInstance].categoryList[1]] ;
    [[AudioManager shareInstance] play];
  }];
  
  UIButton *setCurrentTime = [[UIButton alloc] init];
  [setCurrentTime setTitle:@"设置进度" forState:UIControlStateNormal];
  [setCurrentTime setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.view addSubview:setCurrentTime];
  [setCurrentTime mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view).offset(80);
    make.top.equalTo(self.view).offset(80);
    make.size.mas_equalTo(CGSizeMake(150, 80));
  }];
  
  [[setCurrentTime rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    [[AudioManager shareInstance] setCurrentTime:240];
  }];
  
  [RACObserve([AudioManager shareInstance], isRequsetingNetwork) subscribeNext:^(id x) {
    if ([x boolValue]) {
      playButton.enabled = NO;
      nextButton.enabled = NO;
      playModeButton.enabled = NO;
    } else {
      playButton.enabled = YES;
      nextButton.enabled = YES;
      playModeButton.enabled = YES;
    }
  }];
}

- (void)initViews {
  self.bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
  self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
  self.bgImageView.userInteractionEnabled = NO;
  self.bgImageView.clipsToBounds = YES;
  self.bgImageView.image = [UIImage imageNamed:@"cm2_fm_bg-ip6"];
  // 添加模糊效果
  UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
  UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
  effectView.frame = self.bgImageView.bounds;
  [self.bgImageView addSubview:effectView];
  [self.view addSubview:self.bgImageView];
  @weakify(self)
  [RACObserve([AudioManager shareInstance].currentModel, audio) subscribeNext:^(SSAudio *audio) {
    @strongify(self)
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:audio.cover] placeholderImage:[UIImage imageNamed:@"cm2_fm_bg-ip6"]];
  }];
}

- (void)didBecomeActive:(NSNotification *)notification {
  NSLog(@"进入前台");
  if ([AudioManager shareInstance].state == SSPlayerPlayStatePause) {
    [[AudioManager shareInstance] play];
  }
}


- (void)dealloc {
  NSLog(@"%s", __func__);
}
@end
