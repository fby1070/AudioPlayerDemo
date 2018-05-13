//
//  SSUIPlayerControlManager.h
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/4.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Masonry.h"

@interface SSUIPlayerControlManager : NSObject

/**
 封面图
 
 @param superView 图片父视图
 @param block Masonry布局block
 @return 封面图
 */
- (UIImageView *_Nullable)coverImageViewWithSuperView:(UIView *)superView
                                   makeConstraints:(void(^)(MASConstraintMaker *make))block;

/**
 单曲循环按钮
 
 @param superView 按钮父视图
 @param action 按钮action 若无其他操作需求，传nil即可
 @param block Masonry布局block
 @return 单曲循环按钮
 */
- (UIButton *_Nullable)singleCycleButtonWithSuperView:(UIView *)superView
                                              action:(void(^)(void))action
                                     makeConstraints:(void(^)(MASConstraintMaker *make))block;

/**
 播放暂停按钮
 
 @param superView 按钮父视图
 @param action 按钮action 若无其他操作需求，传nil即可
 @param block Masonry布局block
 @return 播放暂停按钮
 */
- (UIButton *_Nullable)playAndPauseButtonWithSuperView:(UIView *)superView
                                                action:(void(^)(void))action
                                       makeConstraints:(void(^)(MASConstraintMaker *make))block;

/**
 下一首按钮
 
 @param superView 按钮父视图
 @param action 按钮action 若无其他操作需求，传nil即可
 @param block Masonry布局block
 @return 下一首按钮
 */
- (UIButton *_Nullable)nextAudioButtonWithSuperView:(UIView *_Nonnull)superView
                                             action:(void(^_Nullable)(void))action
                                    makeConstraints:(void(^)(MASConstraintMaker *make))block;

/**
 进度条
 
 @param superView 进度条父视图
 @param trackTintColor 未播放进度条颜色
 @param progressTintColor 已播放部分进度条颜色
 @param block Masonry布局block
 @return 进度条
 */
- (UIProgressView *_Nullable)playProgressViewWithSuperView:(UIView *_Nonnull)superView
                                            trackTintColor:(UIColor *_Nonnull)trackTintColor
                                         progressTintColor:(UIColor *_Nonnull)progressTintColor
                                           makeConstraints:(void(^)(MASConstraintMaker *make))block;

/**
 音频当前时间label
 
 @param superView label父视图
 @param block Masonry布局block
 @return label
 */
- (UILabel *_Nullable)currentTimeLabelWithSuperView:(UIView *_Nonnull)superView
                                    makeConstraints:(void(^)(MASConstraintMaker *make))block;


/**
 音频总时长label
 
 @param superView label父视图
 @param block Masonry布局block
 @return label
 */
- (UILabel *_Nullable)totalTimeLabelWithSuperView:(UIView *_Nonnull)superView
                                  makeConstraints:(void(^)(MASConstraintMaker *make))block;

/**
 音频名称label
 
 @param superView label父视图
 @param block Masonry布局block
 @return label
 */
- (UILabel *_Nullable)audioNameLabelWithSuperView:(UIView *_Nonnull)superView
                                  makeConstraints:(void(^)(MASConstraintMaker *make))block;

/**
 歌手label
 
 @param superView label父视图
 @param block Masonry布局block
 @return label
 */
- (UILabel *_Nullable)audioSingerLabelWithSuperView:(UIView *_Nonnull)superView
                                    makeConstraints:(void(^)(MASConstraintMaker *make))block;
@end
