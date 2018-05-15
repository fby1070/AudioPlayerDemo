//
//  AudioListNetRespondBean.m
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/8.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import "AudioListNetRespondBean.h"
#import <StarShareCommons/StarShareCommons.h>
#import "SSAudio.h"

@implementation AudioListNetRespondBean

- (void)setValue:(id)value forKey:(NSString *)key {
  if ([key isEqualToString:@"musicList"]) {
    for (id item in value){
      SSAudio *model = nil;
      if ([item isKindOfClass:[SSAudio class]]) {
        model = item;
      }else if ([item isKindOfClass:[NSDictionary class]]){
        model = [[SSAudio alloc] initWithDictionary:item];
      }
      [(NSMutableArray<SSAudio *> *)self.musicList addObject:model];
    }
  } else if ([key isEqualToString:@"fmList"]) {
    for (id item in value){
      SSAudio *model = nil;
      if ([item isKindOfClass:[SSAudio class]]) {
        model = item;
      }else if ([item isKindOfClass:[NSDictionary class]]){
        model = [[SSAudio alloc] initWithDictionary:item];
      }
      [(NSMutableArray<SSAudio *> *)self.fmList addObject:model];
    }
  } else {
    [super setValue:value forKey:key];
  }
}

-(NSArray<SSAudio *> *)musicList {
  if (_musicList == nil) {
    _musicList = [NSMutableArray array];
  }
  return _musicList;
}

-(NSArray<SSAudio *> *)fmList {
  if (_fmList == nil) {
    _fmList = [NSMutableArray array];
  }
  return _fmList;
}

- (NSString *)description {
  return descriptionForDebug(self);
}
@end
