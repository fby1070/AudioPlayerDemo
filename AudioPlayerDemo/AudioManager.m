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
@property (nonatomic,strong) id<INetRequestHandle> requestHandle;
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

//无网络 暂时注释
- (void)requestAudioList {
  //  AudioListNetRequestBean *requestBean = [[AudioListNetRequestBean alloc] init];
  //  self.isRequsetingNetwork = YES;
  //  __weak typeof(self)weakself = self;
  //
  //  self.requestHandle = [self.playNetEngine requestDomainBeanWithRequestDomainBean:requestBean beginBlock:^{
  //    if (self.beginBlock) {
  //      self.beginBlock();
  //    }
  //  } successedBlock:^(id respondDomainBean) {
  //    //把数据交给playerManager
  //    self.isRequsetingNetwork = NO;
  //    [self playerLoadData:respondDomainBean];
  //    if (weakself.successBlock != nil) {
  //      weakself.successBlock(respondDomainBean);
  //    }
  //  } failedBlock:^(ErrorBean *error) {
  //    self.isRequsetingNetwork = NO;
  //    if (weakself.errorBlock != nil) {
  //      weakself.errorBlock(error);
  //    }
  //  } endBlock:^{
  //    if (self.endBlock) {
  //      self.endBlock();
  //    }
  //  }];


  //TODO 重置播放器
  self.categoryList = @[[self fmList], [self audioList]];
  //创建播放器保存信息数组
  [self creatSavePlayerInfo];
  self.isRequsetingNetwork = NO;
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
    if (model.currentTime > 0) {
      [self.playerAudioManager playWithAudioIndex:model.audioIndex + 1];
    } else {
      [self.playerAudioManager playWithAudioIndex:model.audioIndex];
    }
  } else {
    
  }
  [self.playerAudioManager play];
}

- (void)play {
  [self.playerAudioManager play];
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

-(void)remoteControlReceivedWithEvent:(UIEvent *)event {
  [self.playerAudioManager remoteControlReceivedWithEvent:event];
}

#pragma mark Delegate

- (void)player:(SSPlayerAudioManager *)player state:(SSPlayerPlayState)state {
  self.state = state;
  if (state == SSPlayerPlayStateError) {
    NSLog(@"播放失败");
    
  }
  if (self.delegate && [self.delegate respondsToSelector:@selector(playerState:)]) {
    [self.delegate playerState:state];
  }
}

- (void)player:(SSPlayerAudioManager *)player playMode:(SSPlayerPlayMode)playMode {
  self.playMode = playMode;
  if (self.delegate && [self.delegate respondsToSelector:@selector(playerPlayMode:)]) {
    [self.delegate playerPlayMode:playMode];
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

- (void)failedRequest {
  self.isRequsetingNetwork = YES;
  [self failedLoad];
}

- (void)threeSecondsLoad {
    self.isRequsetingNetwork = YES;
  [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
}

- (void)delayMethod {
  self.categoryList = @[[self fmList], [self audioList]];
  //创建播放器保存信息数组
  [self creatSavePlayerInfo];
  self.isRequsetingNetwork = NO;
}

- (void)failedLoad {
   self.isRequsetingNetwork = NO;
}

- (NSArray *)audioList {
  //数据
  SSAudio *audio0 = [[SSAudio alloc] init];
  audio0.url = @"http://other.web.re01.sycdn.kuwo.cn/resource/n3/67/10/2645918637.mp3";
  audio0.name = @"你还要我怎样";
  audio0.singer = @"薛之谦";
  audio0.cover = @"http://star.kuwo.cn/star/starheads/180/10/94/745334819.jpg";
//  audio0.length = 310;
  
  SSAudio *audio1 = [[SSAudio alloc] init];
  audio1.url = @"http://other.web.ra01.sycdn.kuwo.cn/resource/n3/128/3/11/3233852694.mp3";
  audio1.name = @"醉赤壁";
  audio1.singer = @"林俊杰";
  audio1.cover = @"https://y.gtimg.cn/music/photo_new/T002R300x300M000002g6zv02X7SNi.jpg?max_age=2592000";
//  audio0.length = 281;
  
  SSAudio *audio2 = [[SSAudio alloc] init];
  audio2.url = @"http://vip.baidu190.com/uploads/2017/201710b36c2ec318a5d3170b4610cd31c45de9.mp3";
  audio2.name = @"追光者";
  audio2.singer = @"汪苏泷";
  audio2.cover = @"https://y.gtimg.cn/music/photo_new/T002R300x300M000001OJP0R3NGeiF.jpg?max_age=2592000";
//  audio2.length = 249;
  
  SSAudio *audio3 = [[SSAudio alloc] init];
  audio3.url = @"http://vip.baidu190.com/uploads/2017/2017106d7d03d770c6e2fa04efcc0c93d2f368.mp3";
  audio3.name = @"This Girl";
  audio3.singer = @"Kungs";
  audio3.cover = @"https://y.gtimg.cn/music/photo_new/T002R300x300M000004cZz532Um5mc.jpg?max_age=2592000";
//  audio3.length = 195;
  
  return @[audio0, audio1, audio2, audio3];
}

- (NSArray *)fmList {
  //数据
  SSAudio *audio0 = [[SSAudio alloc] init];
  audio0.url = @"http://vip.baidu190.com/uploads/2017/201710a497c90917fe0b918fb85819bc541344.mp3";
  audio0.name = @"拥抱";
  audio0.singer = @"周玥翻唱";
  audio0.cover = @"https://y.gtimg.cn/music/photo_new/T002R300x300M000000g4srs0OyIED.jpg?max_age=2592000";
//  audio0.length = 263;
  
  SSAudio *audio1 = [[SSAudio alloc] init];
  audio1.url = @"http://vip.baidu190.com/uploads/2017/20171068c49a4e33b0838c4b2d390d75b36df3.mp3";
  audio1.name = @"自导自演";
  audio1.singer = @"周杰伦";
  audio1.cover = @"https://y.gtimg.cn/music/photo_new/T002R300x300M000000bviBl4FjTpO.jpg?max_age=2592000";
//  audio1.length = 255;
  
  SSAudio *audio2 = [[SSAudio alloc] init];
  audio2.url = @"http://other.web.rh01.sycdn.kuwo.cn/resource/n3/42/74/293434430.mp3";
  audio2.name = @"We Don't Talk Anymore";
  audio2.singer = @"双笙";
  audio2.cover = @"http://star.kuwo.cn/star/starheads/180/96/28/4279064489.jpg";
//  audio2.length = 263;
  
  SSAudio *audio3 = [[SSAudio alloc] init];
  audio3.url = @"http://vip.baidu190.com/uploads/2017/201710c211911f1abf480e4d0337583bd323b6.mp3";
  audio3.name = @"还不是因为你长得不好看";
  audio3.singer = @"希瑟";
  audio3.cover = @"https://y.gtimg.cn/music/photo_new/T002R300x300M000002GWwod4DjviD.jpg?max_age=2592000";
//  audio3.length = 264;
  
  return @[audio0, audio1, audio2, audio3];
}

- (void)setCurrentTime:(NSTimeInterval)time {
    [self.playerAudioManager setCurrentTime:time];
}
@end
