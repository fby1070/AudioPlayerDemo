//
//  AudioManager.h
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/8.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSPlayerNetEngine.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "AudioListNetRespondBean.h"
#import "SSPlayerAudioManager.h"

@class SSAudio;

@protocol AudioManagerDelegate<NSObject>

@optional

/**
 播放状态
 
 @param state 播放状态
 */
- (void)playerState:(SSPlayerPlayState)state;

/**
 播放模式
 
 @param playMode 播放模式
 */
- (void)playerPlayMode:(SSPlayerPlayMode)playMode;
@end

@interface AudioManager : NSObject

/**
 AppDelegate 中设置
 */
@property (nonatomic, strong) SSPlayerNetEngine *playNetEngine;

/**
 *  音频列表加载失败回调block
 */
@property (copy, nonatomic) void (^errorBlock)(NSError *error);

/**
 *  音频加载成功
 */
@property (copy, nonatomic) void (^successBlock)(AudioListNetRespondBean *responseBean);

/**
 *  音频列表开始要加载时
 */
@property (copy, nonatomic) void (^beginBlock)(void);

/**
 *  音频列表结束加载时
 */
@property (copy, nonatomic) void (^endBlock)(void);

/**
 代理
 */
@property (nonatomic, weak) id<AudioManagerDelegate> delegate;

/**
 网络请求是否正在执行
 */
@property (nonatomic, assign, readonly) BOOL isRequsetingNetwork;

/**
 播放状态
 */
@property (nonatomic, assign, readonly) SSPlayerPlayState state;

/**
 播放模式
 */
@property (nonatomic, assign, readonly) SSPlayerPlayMode playMode;

/**
 当前播放模型
 */
@property (nonatomic, strong, readonly) SSPlayerCurrentModel *currentModel;


/**
 音频分类列表<音频列表>
 */
@property (nonatomic, strong, readonly) NSArray<NSArray<SSAudio *> *> *categoryList;

/**
 当前播放列表
 */
@property (nonatomic, strong, readonly) NSArray<SSAudio *> *currentAudioList;

//单例
+ (instancetype)shareInstance;

/**
 切换播放列表

 @param audioList 播放列表
 */
- (void)setAudioList:(NSArray<SSAudio *> *)audioList;

/**
 请求音频数据
 */
- (void)requestAudioList;

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
 上一首(暂无)
 */
- (void)previous;

/**
 取消网络请求
 */
- (void)cancelRequest;

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
 设置进度

 @param time 时间（s）
 */
- (void)setCurrentTime:(NSTimeInterval)time;

- (void)failedRequest;

- (void)threeSecondsLoad;
@end
