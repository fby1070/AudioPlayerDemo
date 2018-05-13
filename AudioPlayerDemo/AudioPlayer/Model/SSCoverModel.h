//
//  SSCoverModel.h
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/2.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 可改成代理形式赋值
 */
@interface SSCoverModel : NSObject

/**
 音频名称
 */
@property (nonatomic, copy) NSString *audioName;

/**
 音频专辑
 */
@property (nonatomic, copy) NSString *audioAlbum;

/**
 歌手
 */
@property (nonatomic, copy) NSString *audioSinger;

/**
 封面图
 */
@property (nonatomic, strong) UIImage *audioImage;

@end
