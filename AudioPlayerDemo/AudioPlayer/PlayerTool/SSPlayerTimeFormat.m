//
//  SSPlayerTimeFormat.m
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/3.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import "SSPlayerTimeFormat.h"

@implementation SSPlayerTimeFormat

+ (NSString *)getFormatTime:(CGFloat)time{
  
  // time 123
  // 03:12
  
  NSInteger min = time / 60;
  NSInteger second = time - min * 60;
  
  NSString *result = [NSString stringWithFormat:@"%02ld:%02ld",(long)min,(long)second];
  
  return result;
}

+ (CGFloat)getTimeInterval:(NSString *)formatTime {
  
  // 00:00.89  -> 多少秒
  NSArray *minAndSec = [formatTime componentsSeparatedByString:@":"];
  if (minAndSec.count == 2) {
    
    // 分钟
    CGFloat min = [minAndSec[0] doubleValue];
    // 秒数
    CGFloat sec = [minAndSec[1] doubleValue];
    
    return min * 60 + sec;
  }
  return 0;
}

@end
