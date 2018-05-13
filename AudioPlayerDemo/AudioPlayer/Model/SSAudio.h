//
//  SSAudio.h
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/3.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StarShareNetWorking/StarShareNetWorking.h>

@interface SSAudio: BaseModel

/**
 封面图url
 */
@property (nonatomic, copy) NSString *cover;

/**
 音频名称
 */
@property (nonatomic, copy) NSString *name;

/**
 歌手
 */
@property (nonatomic, copy) NSString *singer;

/**
 音频文件总长度
 */
@property (nonatomic, assign) NSInteger length;

/**
 音频url
 */
@property (nonatomic, copy) NSString *url;

@end
