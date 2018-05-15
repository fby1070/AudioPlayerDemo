//
//  AudioManager.m
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/8.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import "AudioManager.h"
#import "AudioListNetRequestBean.h"
#import "AudioListNetRespondBean.h"

@interface AudioManager () <SSPlayerAudioManagerDelegate>

@property (nonatomic, strong) SSPlayerAudioManager *playerAudioManager;
@property (nonatomic, assign, readwrite) BOOL isRequsetingNetwork;
@property (nonatomic, assign, readwrite) SSPlayerPlayState state;
@property (nonatomic, assign, readwrite) SSPlayerPlayMode playMode;
@property (nonatomic, strong, readwrite) NSArray<NSArray<SSAudio *> *> *categoryList;
@property (nonatomic, strong) NSArray<SSPlayerCurrentModel *> *savePlayerInfo;
@property (nonatomic, strong) id<INetRequestHandle> requestHandle;
@end

@implementation AudioManager

- (instancetype)init {
  self = [super init];
  if (self) {
    self.playerAudioManager = [[SSPlayerAudioManager alloc] init];
    self.playerAudioManager.delegate = self;
  }
  return self;
}

//数据请求
- (void)requestAudioList {
  AudioListNetRequestBean *requestBean = [[AudioListNetRequestBean alloc] init];
  self.isRequsetingNetwork = YES;
  __weak typeof(self)weakself = self;
  
  self.requestHandle = [self.playNetEngine requestDomainBeanWithRequestDomainBean:requestBean beginBlock:^{
    if (self.beginBlock) {
      self.beginBlock();
    }
  } successedBlock:^(id respondDomainBean) {
    //把数据交给playerManager
    self.isRequsetingNetwork = NO;
    [self playerLoadData:respondDomainBean];
    [self creatSavePlayerInfo];
    if (weakself.successBlock != nil) {
      weakself.successBlock(respondDomainBean);
    }
  } failedBlock:^(ErrorBean *error) {
    self.isRequsetingNetwork = NO;
    if (weakself.errorBlock != nil) {
      weakself.errorBlock(error);
    }
  } endBlock:^{
    if (self.endBlock) {
      self.endBlock();
    }
  }];
}

- (void)cancelRequest {
  if (self.isRequsetingNetwork) {
    [self.requestHandle cancel];
  }
}

//若果增加列表需要在这里设置
- (void)playerLoadData:(AudioListNetRespondBean *)respondDomainBean {
  NSMutableArray *audioList = [NSMutableArray array];
  if (respondDomainBean.musicList.count > 0) {
    [audioList addObject:respondDomainBean.musicList];
  } else {
    [audioList addObject:[NSArray array]];
  }
  if (respondDomainBean.fmList.count > 0) {
    [audioList addObject:respondDomainBean.fmList];
  } else {
    [audioList addObject:[NSArray array]];
  }
  self.categoryList = [audioList copy];
}

- (void)setAudioList:(NSArray<SSAudio *> *)audioList {
  if (audioList != self.currentAudioList) {
    if (self.currentAudioList.count > 0) {
      //在切换列表之前，先记录一下当前的播放信息，
      [self updateSaveInfoArray:self.currentAudioList];
    }
    //给播放器音频列表，并设置播放索引
    [self.playerAudioManager settingUpAudioList:audioList];
    SSPlayerCurrentModel *model = [self getInfoModelByCategoryList:audioList];
    if (!model.isPlayed) {
      model.isPlayed = YES;
      [self.playerAudioManager playWithAudioIndex:model.audioIndex];
    } else {
      [self.playerAudioManager playWithAudioIndex:model.audioIndex + 1];
    }
  }
  [self.playerAudioManager play];
}

- (void)play {
  if (self.state == SSPlayerPlayStateIdle) {
    [self.playerAudioManager playWithAudioIndex:self.currentModel.audioIndex];
    [self.playerAudioManager play];
  } else if (self.state == SSPlayerPlayStatePause) {
    [self.playerAudioManager play];
  } else if (self.state == SSPlayerPlayStateFinished) { //模式为只播放一次时点击播放
    [self.playerAudioManager playWithAudioIndex:self.currentModel.audioIndex];
    [self.playerAudioManager play];
  } else if (self.state == SSPlayerPlayStateError) {
    if (self.error.code == SSudioStreamerNetworkError) {
      [self.playerAudioManager playWithAudioIndex:self.currentModel.audioIndex];
      [self.playerAudioManager play];
    } else {
      [self next];
    }
  }
}

- (void)pause {
  [self.playerAudioManager pause];
}

- (void)next {
  [self.playerAudioManager next];
}

- (void)previous {
  [self.playerAudioManager previous];
}

- (NSError *)error {
  return self.playerAudioManager.error;
}

- (SSPlayerCurrentModel *)currentModel {
  return self.playerAudioManager.currentModel;
}

- (NSArray<SSAudio *> *)currentAudioList {
  return self.playerAudioManager.currentAudioList;
}

- (void)creatSavePlayerInfo {
  NSMutableArray *array = [NSMutableArray array];
  for (int i = 0; i < self.categoryList.count; i ++) {
    SSPlayerCurrentModel *model = [[SSPlayerCurrentModel alloc] init];
    if (self.categoryList[i].firstObject != nil) {
      model.audio = self.categoryList[i].firstObject;
    }
    model.audioIndex = 0;
    [array addObject:model];
  }
  self.savePlayerInfo = [array copy];
}

- (SSPlayerCurrentModel *)getInfoModelByCategoryList:(NSArray<SSAudio *> *)audioList {
  NSInteger index = [self.categoryList indexOfObject:audioList];
  SSPlayerCurrentModel *model = self.savePlayerInfo[index];
  return model;
}

- (void)settingUpPlayMode:(SSPlayerPlayMode)playMode {
  return [self.playerAudioManager settingUpPlayMode:playMode];
}

- (void)updateSaveInfoArray:(NSArray<SSAudio *> *)audioList {
  SSPlayerCurrentModel *model = [self getInfoModelByCategoryList:audioList];
  model.audio = self.playerAudioManager.currentModel.audio;
  model.audioIndex = self.playerAudioManager.currentModel.audioIndex;
  model.currentTime = self.playerAudioManager.currentModel.currentTime;
}

- (void)setCurrentTime:(NSTimeInterval)time {
  [self.playerAudioManager setCurrentTime:time];
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event {
  [self.playerAudioManager remoteControlReceivedWithEvent:event];
}

#pragma mark Delegate

- (void)player:(SSPlayerAudioManager *)player state:(SSPlayerPlayState)state {
  self.state = state;
  if (self.delegate && [self.delegate respondsToSelector:@selector(player:state:)]) {
    [self.delegate player:self state:state];
  }
}

- (void)player:(SSPlayerAudioManager *)player playMode:(SSPlayerPlayMode)playMode {
  self.playMode = playMode;
  if (self.delegate && [self.delegate respondsToSelector:@selector(player:playMode:)]) {
    [self.delegate player:self playMode:playMode];
  }
}

- (void)player:(SSPlayerAudioManager *)player errorCode:(SSAudioStreamerErrorCode)errorCode {
  if (errorCode == SSudioStreamerNetworkError) {
    NSLog(@"网络错误");
  } else if (errorCode == SSudioStreamerNetworkError) {
    NSLog(@"解析错误");
  } else {
    NSLog(@"未知错误");
  }
  if (self.delegate && [self.delegate respondsToSelector:@selector(player:errorCode:)]) {
    [self.delegate player:self errorCode:errorCode];
  }
}

#pragma mark 单例

static AudioManager* _instance = nil;
+ (instancetype)shareInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [[super allocWithZone:NULL] init];
  });
  return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
  return [AudioManager shareInstance];
}

- (id) copyWithZone:(struct _NSZone *)zone {
  return [AudioManager shareInstance];
}
@end
