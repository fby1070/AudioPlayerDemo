//
//  SSPlayerAudioManager.h
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/11.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSPlayerCurrentModel.h"
#import "SSDouAudioStream.h"

typedef enum : NSUInteger {
  SSPlayerPlayModeList = 0,        //列表播放
  SSPlayerPlayModeRepeatOne,       //单曲循环
  SSPlayerPlayModeRepeatList,      //列表循环
  SSPlayerPlayModeShuffle,         //随机播放
  SSPlayerPlayModePlayOnce,        //播放一次
} SSPlayerPlayMode;

@class SSPlayerAudioManager;

@protocol SSPlayerAudioManagerDelegate <NSObject>

@optional

/**
 播放状态
 
 @param state 播放状态
 */
- (void)player:(SSPlayerAudioManager *)player state:(SSPlayerPlayState)state;

/**
 播放模式
 
 @param playMode 播放模式
 */
- (void)player:(SSPlayerAudioManager *)player playMode:(SSPlayerPlayMode)playMode;

/**
 错误码
 
 @param errorCode 错误码
 */
- (void)player:(SSPlayerAudioManager *)player errorCode:(SSAudioStreamerErrorCode)errorCode;

@end

@interface SSPlayerAudioManager : NSObject

/**
 代理
 */
@property (nonatomic, weak) id<SSPlayerAudioManagerDelegate> delegate;

/**
 播放状态
 */
@property (nonatomic, assign, readonly) SSPlayerPlayState state;

/**
 播放模式
 */
@property (nonatomic, assign, readonly) SSPlayerPlayMode playMode;

/**
 当前播放列表
 */
@property (nonatomic, strong, readonly) NSArray<SSAudio *> *currentAudioList;

/**
 当前播放模型
 */
@property (nonatomic, strong, readonly) SSPlayerCurrentModel *currentModel;

/**
 错误
 */
@property (nonatomic, strong, readonly) NSError *error;

/**
 设置播放列表
 
 @param currentAudioList 播放列表
 */
- (void)settingUpAudioList:(NSArray<SSAudio *> *)currentAudioList;

/**
 播放
 */
- (void)play;

/**
 暂停
 */
- (void)pause;

/**
 下一首
 */
- (void)next;

/**
 上一首
 */
- (void)previous;

/**
 根据序号播放

 @param index 在列表中的位置
 */
- (void)playWithAudioIndex:(NSInteger)index;

/**
 设置播放模式
 
 @param playMode 播放模式
 */
- (void)settingUpPlayMode:(SSPlayerPlayMode)playMode;

/**
 接收到远程控制时执行的方法
 
 @param event event
 */
-(void)remoteControlReceivedWithEvent:(UIEvent *)event;

/**
 设置播放进度

 @param time 时间
 */
- (void)setCurrentTime:(NSTimeInterval)time;

@end
