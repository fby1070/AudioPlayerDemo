//
//  SSPlayerCurrentModel.h
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/3.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSAudio.h"

@interface SSPlayerCurrentModel : NSObject

/**
 音频模型
 */
@property (nonatomic, strong) SSAudio *audio;

/**
 音频在列表中的序号
 */
@property (nonatomic, assign) NSInteger audioIndex;

/**
 当前音频播放进度
 */
@property (nonatomic, assign) float progress;

/**
 音频总时长
 */
@property (nonatomic, assign) NSInteger totalTime;

/**
 当前时长
 */
@property (nonatomic, assign) NSInteger currentTime;

/**
 当前音频缓冲进度
 */
@property (nonatomic, assign) NSInteger bufferProgress;
@end
