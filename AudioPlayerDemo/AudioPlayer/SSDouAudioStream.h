//
//  SSDouAudioStream.h
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/10.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
  SSPlayerPlayStateIdle,                  //闲置状态
  SSPlayerPlayStatePlaying,               //正在播放
  SSPlayerPlayStatePause,                 //暂停
  SSPlayerPlayStateFinished,              //结束
  SSPlayerPlayStateBuffering,             //缓冲中
  SSPlayerPlayStateError,                 //错误
} SSPlayerPlayState;

typedef enum : NSUInteger {
  SSudioStreamerUnknownError,
  SSudioStreamerNetworkError,
  SSAudioStreamerDecodingError
} SSAudioStreamerErrorCode;

@class SSDouAudioStream;
@class SSCoverModel;

@protocol SSDouAudioStreamDelegate<NSObject>
@optional
/**
 播放进度代理 （属性isObserveProgress(默认YES)为YES时有效）
 
 @param player SSDouAudioStream音频播放管理器
 @param progress 播放进度(百分比)
 @param currentTime 当前播放到的时间
 */
- (void)player:(SSDouAudioStream *)player progress:(float)progress currentTime:(NSTimeInterval)currentTime;

/**
 缓冲进度代理
 
 @param player SSDouAudioStream音频播放管理器
 @param bufferProgress 缓冲进度(百分比)
 @param totalTime 音频总时长
 */
- (void)player:(SSDouAudioStream *)player bufferProgress:(float)bufferProgress totalTime:(NSTimeInterval)totalTime;

/**
 播放器状态
 
 @param state 播放器状态
 */
- (void)player:(SSDouAudioStream *)player state:(SSPlayerPlayState)state;

/**
 播放结束

 @param player SSDouAudioStream音频播放管理器
 */
- (void)didFinished:(SSDouAudioStream *)player;

/**
 错误码
 
 @param errorCode 错误码
 */
- (void)player:(SSDouAudioStream *)player errorCode:(SSAudioStreamerErrorCode)errorCode;

@end

@interface SSDouAudioStream : NSObject

/**
 代理
 */
@property (nonatomic, weak) id<SSDouAudioStreamDelegate> delegate;

/**
 封面信息
 */
@property (nonatomic, strong) SSCoverModel *coverModel;

/**
 播放器状态
 */
@property (nonatomic, assign, readonly) SSPlayerPlayState state;

/**
 错误
 */
@property (nonatomic, strong, readonly) NSError *error;

/**
 加载音频

 @param audioUrl 音频url
 */
- (void)loadAudioWithUrl:(NSString *)audioUrl;

/**
 设置播放进度（单位  s）

 @param value 设置的秒数
 */
- (void)setPlayProgress:(NSTimeInterval)value;

/**
 播放
 */
- (void)play;

/**
 暂停
 */
- (void)pause;

/**
 停止
 */
- (void)stop;

@end
