//
//  SSPlayerAudioManager.m
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/11.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import "SSPlayerAudioManager.h"
#import "SSCoverModel.h"

@interface SSPlayerAudioManager ()<SSDouAudioStreamDelegate>

//正常播放结束
@property (nonatomic, assign) BOOL isNaturalToEndTime;
//播放器
@property (nonatomic, strong) SSDouAudioStream *player;
@property (nonatomic, assign, readwrite) SSPlayerPlayMode playMode;
@property (nonatomic, assign, readwrite) SSPlayerPlayState state;
@property (nonatomic, strong, readwrite) NSArray<SSAudio *> *currentAudioList;
@property (nonatomic, strong, readwrite) SSPlayerCurrentModel *currentModel;

@end

@implementation SSPlayerAudioManager

- (instancetype)init {
  self = [super init];
  if (self) {
    [self configuration];
  }
  return self;
}

- (void)configuration {
  self.currentModel = [[SSPlayerCurrentModel alloc] init];
  self.playMode = SSPlayerPlayModeRepeatList;
  self.player = [[SSDouAudioStream alloc] init];
  self.player.delegate = self;
}

- (void)settingUpAudioList:(NSArray<SSAudio *> *)currentAudioList {
  self.currentAudioList = currentAudioList;
}

- (void)playWithAudioIndex:(NSInteger)index {
  if (self.currentAudioList.count <= 0) return;
  if (index >= self.currentAudioList.count ) index = 0;
  if (index < 0) index = self.currentAudioList.count - 1;
  if (self.state == SSPlayerPlayStatePlaying) {
    [self.player pause];
  }
  SSAudio * audio = self.currentAudioList[index];
  //更新当前播放信息
  self.currentModel.audio = audio;
  self.currentModel.audioIndex = index;
  //设置封面信息
  [self setCoverInfo:audio];
  if (![self formatChecks:audio.url]) {
    [self next];
    return;
  }
  [self.player loadAudioWithUrl:audio.url];
  
}

- (void)play {
  
  if (self.state == SSPlayerPlayStateIdle) {
    [self playWithAudioIndex:0];
    [self.player play];
    return;
  } else if (self.state == SSPlayerPlayStatePause) {
    [self.player play];
  } else if (self.state == SSPlayerPlayStatePlaying) {
      [self.player play];
  } else if (self.state == SSPlayerPlayStateFinished) { //模式为只播放一次时点击播放
    [self playWithAudioIndex:self.currentModel.audioIndex];
  } else if (self.state == SSPlayerPlayStateError) {
    [self next];
  } else {

  }
}

- (void)pause {
  [self.player pause];
}

- (void)next {
  if (self.playMode == SSPlayerPlayModeList) {        //列表播放
    NSInteger index = self.currentModel.audioIndex + 1;
    if (index >= self.currentAudioList.count) {
      if (self.isNaturalToEndTime) {
        self.isNaturalToEndTime = NO;
        [self pause];
        return;
      }
      index = 0;
    }
    [self playWithAudioIndex:index];
  } else if (self.playMode == SSPlayerPlayModeRepeatOne) {   //单曲循环
    if (self.isNaturalToEndTime) {
      self.isNaturalToEndTime = NO;
       [self playWithAudioIndex:self.currentModel.audioIndex];
    } else {
      [self playWithAudioIndex:self.currentModel.audioIndex + 1];
    }
  } else if (self.playMode == SSPlayerPlayModeRepeatList) {   // 列表循环
   [self playWithAudioIndex:self.currentModel.audioIndex + 1];
  } else if (self.playMode == SSPlayerPlayModeShuffle) {
    NSInteger index =  (NSInteger)((arc4random() % (self.currentAudioList.count  + 1)));
   [self playWithAudioIndex:index];
  } else if (self.playMode == SSPlayerPlayModePlayOnce) {    //播放一次
    if (self.isNaturalToEndTime) {
      self.isNaturalToEndTime = NO;
      [self pause];
    } else {
      NSInteger index = self.currentModel.audioIndex + 1;
      if (index >= self.currentAudioList.count) {
        index = 0;
      }
      [self playWithAudioIndex:self.currentModel.audioIndex + 1];
    }
  }
  [self.player play];
}

- (void)previous {
  [self playWithAudioIndex:self.currentModel.audioIndex - 1];
}

- (void)settingUpPlayMode:(SSPlayerPlayMode)playMode {
  self.playMode = playMode;
}

//设置锁屏信息
- (void)setCoverInfo:(SSAudio *)audio {
  self.player.coverModel.audioName = audio.name;
  self.player.coverModel.audioSinger = audio.singer;
  self.player.coverModel.audioAlbum = @"";
  NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:audio.cover]];
  self.player.coverModel.audioImage = [UIImage imageWithData:data];
}

- (void)setCurrentTime:(NSTimeInterval)time {
  [self.player setPlayProgress:time];
}


- (void)didFinished:(SSDouAudioStream *)player {
  NSLog(@"播放结束");
  self.isNaturalToEndTime = YES;
  [self next];
}

- (void)player:(SSDouAudioStream *)player bufferProgress:(float)bufferProgress totalTime:(NSTimeInterval)totalTime {
  self.currentModel.totalTime = totalTime;
  self.currentModel.bufferProgress = bufferProgress;
}

- (void)player:(SSDouAudioStream *)player progress:(float)progress currentTime:(NSTimeInterval)currentTime {
  if (self.currentModel.totalTime - currentTime <= 1 && self.playMode == SSPlayerPlayModeRepeatOne) {//设置单曲循环
    [self setCurrentTime:0];
  }
  self.currentModel.progress = progress;
  self.currentModel.currentTime = currentTime;
}

- (void)setPlayMode:(SSPlayerPlayMode)playMode {
  _playMode = playMode;
  if (self.delegate && [self.delegate respondsToSelector:@selector(player:playMode:)]) {
    [self.delegate player:self playMode:playMode];
  }
}

- (void)player:(SSDouAudioStream *)player state:(SSPlayerPlayState)state {
  self.state = state;
  if (self.delegate && [self.delegate respondsToSelector:@selector(player:state:)]) {
    [self.delegate player:self state:state];
  }
}

- (void)player:(SSDouAudioStream *)player errorCode:(SSAudioStreamerErrorCode)errorCode {
  if (self.delegate && [self.delegate respondsToSelector:@selector(player:errorCode:)]) {
    [self.delegate player:self errorCode:errorCode];
  }
}

- (NSError *)error {
  return self.player.error;
}

- (BOOL)formatChecks:(NSString *)url {
  NSString *mp3 = [url substringFromIndex:url.length - 4];
  if ([@".mp3" isEqualToString:mp3] || [@".MP3" isEqualToString:mp3]) {
    return YES;
  }
  NSString *ape = [url substringFromIndex:url.length - 4];
  if ([@".ape" isEqualToString:ape] || [@".APE" isEqualToString:ape]) {
    return YES;
  }
  NSString *flac = [url substringFromIndex:url.length - 5];
  if ([@".flac" isEqualToString:flac] || [@".FLAC" isEqualToString:flac]) {
    return YES;
  }
  return NO;
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event {
  if (event.type == UIEventTypeRemoteControl) {
    switch (event.subtype) {
      case UIEventSubtypeRemoteControlPlay:
        [self.player play];
        
        //播放：100
        break;
      case UIEventSubtypeRemoteControlPause:
        [self.player pause];
        
        //暂停：101
        break;
      case UIEventSubtypeRemoteControlStop:
        //停止：102
        break;
      case UIEventSubtypeRemoteControlTogglePlayPause:
      {
        //播放暂停切换键：103
        if (self.state == SSPlayerPlayStatePlaying) {
          [self.player pause];
        }else{
          [self.player play];
        }
      }
        break;
      case UIEventSubtypeRemoteControlNextTrack:
      {
        //双击暂停键（下一曲）：104
        [self next];
      }
        break;
      case UIEventSubtypeRemoteControlPreviousTrack:
      {
        //三击暂停键（上一曲）：105
      }
        break;
      case UIEventSubtypeRemoteControlBeginSeekingBackward:
        //三击不松开（快退开始）：106
        break;
      case UIEventSubtypeRemoteControlEndSeekingBackward:
        //三击到了快退的位置松开（快退停止）：107
        break;
      case UIEventSubtypeRemoteControlBeginSeekingForward:
        //两击不要松开（快进开始）：108
        break;
      case UIEventSubtypeRemoteControlEndSeekingForward:
        //两击到了快进的位置松开（快进停止）：109
        break;
      default:
        break;
    }
  }
}
@end
