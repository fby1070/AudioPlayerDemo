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
@class AudioManager;

@protocol AudioManagerDelegate<NSObject>

@optional

/**
 播放状态
 
 @param state 播放状态
 */
- (void)player:(AudioManager *)player state:(SSPlayerPlayState)state;

/**
 播放模式
 
 @param playMode 播放模式
 */
- (void)player:(AudioManager *)player playMode:(SSPlayerPlayMode)playMode;

/**
 错误码
 
 @param errorCode 播放模式
 */
- (void)player:(AudioManager *)player errorCode:(SSAudioStreamerErrorCode)errorCode;
@end

@interface AudioManager : NSObject

/**
 AppDelegate 中设置
 */
@property (nonatomic, strong) SSPlayerNetEngine *playNetEngine;

/**
 *  音频列表加载失败回调block
 */
@property (nonatomic, copy) void (^errorBlock)(NSError *error);

/**
 *  音频加载成功
 */
@property (nonatomic, copy) void (^successBlock)(AudioListNetRespondBean *responseBean);

/**
 *  音频列表开始要加载时
 */
@property (nonatomic, copy) void (^beginBlock)(void);

/**
 *  音频列表结束加载时
 */
@property (nonatomic, copy) void (^endBlock)(void);

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

/**
 错误
 */
@property (nonatomic, strong, readonly) NSError *error;

//单例
+ (instancetype)shareInstance;

/**
 设置播放列表
 
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
 上一首
 */
- (void)previous;

/**
 取消网络请求
 */
- (void)cancelRequest;

/**
 设置播放模式（默认列表循环）
 
 @param playMode 播放模式
 */
- (void)settingUpPlayMode:(SSPlayerPlayMode)playMode;

/**
 设置进度
 
 @param time 时间（s）
 */
- (void)setCurrentTime:(NSTimeInterval)time;

/**
 接收到远程控制时执行的方法（在APPDelegate里调用，否则控制中心以及锁屏后的播放器操作按键不起作用）
 
 @param event event
 */
-(void)remoteControlReceivedWithEvent:(UIEvent *)event;
@end
