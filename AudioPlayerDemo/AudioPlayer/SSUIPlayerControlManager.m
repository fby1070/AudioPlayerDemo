//
//  SSUIPlayerControlManager.m
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/4.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import "SSUIPlayerControlManager.h"
#import "AudioManager.h"
#import "SSPlayerTimeFormat.h"
#import "UIImageView+WebCache.h"

#define LabelFontSize [UIFont systemFontOfSize:10];
#define LabelTextColor [UIColor whiteColor];

@interface SSUIPlayerControlManager ()

@end

@implementation SSUIPlayerControlManager

#pragma mark - 封面图
/**
 封面图
 
 @param superView 图片父视图
 @param block Masonry布局block
 @return 封面图
 */
- (UIImageView *_Nullable)coverImageViewWithSuperView:(UIView *)superView
                                      makeConstraints:(void(^)(MASConstraintMaker *make))block {
  UIImageView *imageView = [[UIImageView alloc] init];
  [superView addSubview:imageView];
  [imageView mas_makeConstraints:block];

  [RACObserve([AudioManager shareInstance].currentModel, audio) subscribeNext:^(SSAudio *audio) {
    [imageView sd_setImageWithURL:[NSURL URLWithString:audio.cover] placeholderImage:[UIImage imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(80, 80) cornerRadius:0]];
  }];
  
  return imageView;
}

#pragma mark - 单曲循环按钮
/**
 单曲循环按钮
 
 @param superView 按钮父视图
 @param action 按钮action 若无其他操作需求，传nil即可
 @param block Masonry布局block
 @return 单曲循环按钮
 */
- (UIButton *_Nullable)singleCycleButtonWithSuperView:(UIView *)superView
                                               action:(void(^)(void))action
                                      makeConstraints:(void(^)(MASConstraintMaker *make))block {
  
  UIButton *button = [self btnWithSuperView:superView makeConstraints:block];
  [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    if ([AudioManager shareInstance].playMode == SSPlayerPlayModeRepeatOne) {
      [[AudioManager shareInstance] settingUpPlayMode:SSPlayerPlayModeRepeatList];
    } else if ([AudioManager shareInstance].playMode == SSPlayerPlayModeRepeatList) {
      [[AudioManager shareInstance] settingUpPlayMode:SSPlayerPlayModeRepeatOne];
    }
    if (action != nil) {
      action();
    }
  }];
  return button;
}

#pragma mark - 播放暂停按钮
/**
 播放暂停按钮
 
 @param superView 按钮父视图
 @param action 按钮action 若无其他操作需求，传nil即可
 @param block Masonry布局block
 @return 播放暂停按钮
 */
- (UIButton *_Nullable)playAndPauseButtonWithSuperView:(UIView *)superView
                                                action:(void(^)(void))action
                                       makeConstraints:(void(^)(MASConstraintMaker *make))block {
  UIButton *button = [self btnWithSuperView:superView makeConstraints:block];
  
  [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
      if ([AudioManager shareInstance].state == SSPlayerPlayStatePlaying) {
        [[AudioManager shareInstance] pause];
      } else if ([AudioManager shareInstance].state == SSPlayerPlayStateBuffering){
        [[AudioManager shareInstance] pause];
      } else {
        [[AudioManager shareInstance] play];
      }
    
    
    if (action != nil) {
      action();
    }
  }];
  return button;
}

#pragma mark - 下一首按钮
/**
 下一首按钮
 
 @param superView 按钮父视图
 @param action 按钮action 若无其他操作需求，传nil即可
 @param block Masonry布局block
 @return 下一首按钮
 */
- (UIButton *_Nullable)nextAudioButtonWithSuperView:(UIView *_Nonnull)superView
                                             action:(void(^_Nullable)(void))action
                                    makeConstraints:(void(^)(MASConstraintMaker *make))block {
  UIButton *nextBtn = [self btnWithSuperView:superView makeConstraints:block];
  [[nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    [[AudioManager shareInstance] next];
    if (action != nil) {
      action();
    }
  }];
  return nextBtn;
}

#pragma mark - 播放进度条
/**
 播放进度条
 
 @param superView 进度条父视图
 @param trackTintColor 未播放进度条颜色
 @param progressTintColor 已播放部分进度条颜色
 @param block Masonry布局block
 @return 进度条
 */
- (UIProgressView *_Nullable)playProgressViewWithSuperView:(UIView *_Nonnull)superView
                                            trackTintColor:(UIColor *_Nonnull)trackTintColor
                                         progressTintColor:(UIColor *_Nonnull)progressTintColor
                                           makeConstraints:(void(^)(MASConstraintMaker *make))block {
  UIProgressView *playProgressView = [[UIProgressView alloc] init];
  playProgressView.trackTintColor = trackTintColor;
  playProgressView.progressTintColor = progressTintColor;
  [superView addSubview:playProgressView];
  [playProgressView mas_makeConstraints:block];

  [RACObserve([AudioManager shareInstance].currentModel, progress) subscribeNext:^(id value) {
    [playProgressView setProgress:[value floatValue]];
  }];
  
  return playProgressView;
}

#pragma mark - 音频当前时间
/**
 音频当前时间label
 
 @param block Masonry布局block
 @param superView label父视图
 @return label
 */
- (UILabel *_Nullable)currentTimeLabelWithSuperView:(UIView *_Nonnull)superView
                                    makeConstraints:(void(^)(MASConstraintMaker *make))block{
  UILabel *currentLabel = [[UILabel alloc] init];
  currentLabel.textColor = [UIColor blackColor];
  currentLabel.text = @"00:00";
  currentLabel.font = LabelFontSize;
  currentLabel.textColor = LabelTextColor;
  currentLabel.textAlignment = NSTextAlignmentCenter;
  [superView addSubview:currentLabel];
  [currentLabel mas_makeConstraints:block];
  
  [RACObserve([AudioManager shareInstance].currentModel, currentTime) subscribeNext:^(id value) {
    currentLabel.text = [SSPlayerTimeFormat getFormatTime:[value integerValue]];
  }];
  return currentLabel;
}

#pragma mark - 音频总时长

/**
 音频总时长label
 
 @param block Masonry布局block
 @param superView label父视图
 @return label
 */
- (UILabel *_Nullable)totalTimeLabelWithSuperView:(UIView *_Nonnull)superView
                                  makeConstraints:(void(^)(MASConstraintMaker *make))block {
  
  UILabel *totalLabel = [[UILabel alloc] init];
  totalLabel.text = @"00:00";
  totalLabel.font = LabelFontSize;
  totalLabel.textColor = LabelTextColor;
  totalLabel.textAlignment = NSTextAlignmentCenter;
  [superView addSubview:totalLabel];
  [totalLabel mas_makeConstraints:block];

  [RACObserve([AudioManager shareInstance].currentModel, totalTime) subscribeNext:^(id value) {
    totalLabel.text = [SSPlayerTimeFormat getFormatTime:[value integerValue]];
  }];
  return totalLabel;
}

/**
 音频名称label
 
 @param superView label父视图
 @param block Masonry布局block
 @return label
 */
- (UILabel *_Nullable)audioNameLabelWithSuperView:(UIView *_Nonnull)superView
                                  makeConstraints:(void(^)(MASConstraintMaker *make))block {
  UILabel *nameLabel = [[UILabel alloc] init];
  nameLabel.font = [UIFont systemFontOfSize:13];
  nameLabel.textColor = LabelTextColor;
  nameLabel.textAlignment = NSTextAlignmentCenter;
  [superView addSubview:nameLabel];
  [nameLabel mas_makeConstraints:block];

  [RACObserve([AudioManager shareInstance].currentModel, audio) subscribeNext:^(SSAudio *audio) {
     nameLabel.text = audio.singer;
  }];
  return nameLabel;
}

/**
 歌手label
 
 @param superView label父视图
 @param block Masonry布局block
 @return label
 */
- (UILabel *_Nullable)audioSingerLabelWithSuperView:(UIView *_Nonnull)superView
                                    makeConstraints:(void(^)(MASConstraintMaker *make))block {
  UILabel *singerLabel = [[UILabel alloc] init];
  singerLabel.textAlignment = NSTextAlignmentCenter;
  singerLabel.textColor = LabelTextColor;
  singerLabel.font = [UIFont systemFontOfSize:13];
  [superView addSubview:singerLabel];
  [singerLabel mas_makeConstraints:block];

  [RACObserve([AudioManager shareInstance].currentModel, audio) subscribeNext:^(SSAudio *audio) {
   singerLabel.text = audio.name;
  }];
  return singerLabel;
}

- (UIButton *)btnWithSuperView:(UIView *)superView makeConstraints:(void(^)(MASConstraintMaker *make))block{
  UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
  [superView addSubview:btn];
  [btn mas_makeConstraints:block];
  return btn;
}
@end
