//
//  AudioListNetRequestBean.m
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/8.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import "AudioListNetRequestBean.h"
#import <StarShareCommons/StarShareCommons.h>

@implementation AudioListNetRequestBean

- (instancetype)initWithStarId:(NSString *)starId {
  if (self = [super init]) {
    _starId = starId;
  }
  return self;
}

- (NSString *)description {
  return descriptionForDebug(self);
}
@end
