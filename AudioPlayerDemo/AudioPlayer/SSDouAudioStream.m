//
//  SSDouAudioStream.m
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/10.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import "SSDouAudioStream.h"
#import "Track.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SSCoverModel.h"
#import <AVFoundation/AVFoundation.h>
#import "DOUAudioStreamer.h"

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface SSDouAudioStream ()

@property (nonatomic, strong) DOUAudioStreamer *player;
@property (nonatomic, assign, readwrite) SSPlayerPlayState state;
@property (nonatomic, strong, readwrite) NSError *error;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isBackground;
@end

@implementation SSDouAudioStream

- (instancetype)init {
  self = [super init];
  if (self) {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
    self.coverModel = [[SSCoverModel alloc] init];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self addSystemObserver];
  }
  return self;
}

- (void)loadAudioWithUrl:(NSString *)audioUrl {
  if (self.player != nil) {
    [self removeStreamerObserver];
    self.player = nil;
  }
  Track *track = [[Track alloc] init];
  track.audioFileURL = [NSURL URLWithString:audioUrl];
  self.player = [DOUAudioStreamer streamerWithAudioFile:track];
  [self addStreamerObserver];
  
  //锁屏后台信息
  [self addInformationOfLockScreen];
}

- (void)setPlayProgress:(NSTimeInterval)value {
  [self.player setCurrentTime:value];
}

- (void)removeStreamerObserver {
  [self.player removeObserver:self forKeyPath:@"status"];
  [self.player removeObserver:self forKeyPath:@"duration"];
  [self.player removeObserver:self forKeyPath:@"bufferingRatio"];
}

- (void)addStreamerObserver {
  [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
  [self.player addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
  [self.player addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
  if (context == kStatusKVOKey) {
    [self performSelector:@selector(_updateStatus)
                 onThread:[NSThread mainThread]
               withObject:nil
            waitUntilDone:NO];
  } else if (context == kDurationKVOKey) {
    [self performSelector:@selector(_timerAction:)
                 onThread:[NSThread mainThread]
               withObject:nil
            waitUntilDone:NO];
  } else if (context == kBufferingRatioKVOKey) {
    [self performSelector:@selector(_updateBufferingStatus)
                 onThread:[NSThread mainThread]
               withObject:nil
            waitUntilDone:NO];
  }
  else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)play {
  [self.player play];
}

- (void)pause {
  [self.player pause];
}

- (void)stop {
  [self.player stop];
}

- (void)_updateStatus {
  switch ([self.player status]) {
    case DOUAudioStreamerPlaying:
      self.state = SSPlayerPlayStatePlaying;
      break;
    case DOUAudioStreamerPaused:
      self.state = SSPlayerPlayStatePause;
      break;
    case DOUAudioStreamerIdle:
      self.state = SSPlayerPlayStateIdle;
      break;
      
    case DOUAudioStreamerFinished:
      self.state = SSPlayerPlayStateFinished;
      if (self.delegate && [self.delegate respondsToSelector:@selector(didFinished:)]) {
        [self.delegate didFinished:self];
      }
      break;
    case DOUAudioStreamerBuffering:
      self.state = SSPlayerPlayStateBuffering;
      break;
    case DOUAudioStreamerError:
      self.state = SSPlayerPlayStateError;
      self.error = self.player.error;
      SSAudioStreamerErrorCode errorCode;
      switch (self.player.error.code) {
        case DOUAudioStreamerNetworkError:
          errorCode = SSudioStreamerNetworkError;
          break;
        case DOUAudioStreamerDecodingError:
          errorCode = SSAudioStreamerDecodingError;
          break;
        default:
          errorCode = SSudioStreamerUnknownError;
          break;
      }
      if (self.delegate && [self.delegate respondsToSelector:@selector(player:errorCode:)]) {
        [self.delegate player:self errorCode:errorCode];
      }
      break;
  }
  if (self.delegate && [self.delegate respondsToSelector:@selector(player:state:)]) {
    [self.delegate player:self state:self.state];
  }
}

- (void)_timerAction:(id)timer {
  if (self.delegate &&  [self.delegate respondsToSelector:@selector(player:progress:currentTime:)]) {
    float progress = 0;
    if ([self.player duration] != 0) {
      progress = [self.player currentTime] / [self.player duration];
    }
    [self.delegate player:self progress:progress currentTime:[self.player currentTime]];
  }
  if (self.isBackground) {
    [self updateControlCenterInfo];
  }
}

- (void)_updateBufferingStatus {
  if (self.delegate &&  [self.delegate respondsToSelector:@selector(player:bufferProgress:totalTime:)]) {
    [self.delegate player:self bufferProgress:[self.player bufferingRatio] totalTime:[self.player duration]];
  }
}

- (void)addSystemObserver {
  //将要进入后台
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_playerWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
  //已经进入前台
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_playerDidEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
  //监测耳机
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_playerAudioRouteChange:) name:AVAudioSessionRouteChangeNotification object:nil];
  //监听播放器被打断（别的软件播放音乐，来电话）
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_playerAudioBeInterrupted:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
  //监测其他app是否占据AudioSession
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_playerSecondaryAudioHint:) name:AVAudioSessionSilenceSecondaryAudioHintNotification object:nil];
}

- (void)_playerWillResignActive {
  self.isBackground = YES;
}

- (void)_playerDidEnterForeground {
  self.isBackground = NO;
}

- (void)_playerAudioRouteChange:(NSNotification *)notification {
  //  [self pause];
}

- (void)_playerAudioBeInterrupted:(NSNotification *)notification {
  [self pause];
}

- (void)_playerSecondaryAudioHint:(NSNotification *)notification {
  [self pause];
}

//锁屏、后台模式信息
- (void)addInformationOfLockScreen {
  if (!self.coverModel.audioName &&
      !self.coverModel.audioAlbum &&
      !self.coverModel.audioSinger
      ) {
    return;
  }
  
  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
  dic[MPMediaItemPropertyTitle] = self.coverModel.audioName;
  dic[MPMediaItemPropertyArtist] = self.coverModel.audioSinger;
  dic[MPMediaItemPropertyAlbumTitle] = self.coverModel.audioAlbum;
  if ([self.coverModel.audioImage isKindOfClass:[UIImage class]] && self.coverModel.audioImage) {
    if (@available(iOS 10.0, *)) {
      MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeMake(200, 100) requestHandler:^UIImage * _Nonnull(CGSize size) {
        return self.coverModel.audioImage;
      }];
      dic[MPMediaItemPropertyArtwork] = artwork;
    } else {
      MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:self.coverModel.audioImage];
      dic[MPMediaItemPropertyArtwork] = artwork;
    }
  }
  [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
}

- (void)updateControlCenterInfo {
  NSDictionary *info = [[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo];
  NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:info];
  dic[MPNowPlayingInfoPropertyElapsedPlaybackTime] = [NSNumber numberWithDouble:[self.player currentTime]];
  dic[MPMediaItemPropertyPlaybackDuration] = [NSNumber numberWithDouble:[self.player duration]];
  [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
}
@end
