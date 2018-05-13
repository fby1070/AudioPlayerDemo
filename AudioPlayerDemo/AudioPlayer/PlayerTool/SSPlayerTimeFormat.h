//
//  SSPlayerTimeFormat.h
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/3.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SSPlayerTimeFormat : NSObject

/** 格式化时间  time 123 -> 03:12*/
+ (NSString *)getFormatTime:(CGFloat)time;

/**
 *  获取格式化字符串所对应的秒数
 *
 *  @param formatTime 时间格式化字符串 00:00.89
 *
 *  @return 秒数
 */
+ (CGFloat)getTimeInterval:(NSString *)formatTime;
@end
