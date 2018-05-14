//
//  AudioListNetRespondBean.h
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/8.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import "BaseModel.h"
#import "SSAudio.h"

@interface AudioListNetRespondBean : BaseModel

@property (nonatomic, copy) NSArray<SSAudio *> *musicList;

@property (nonatomic, copy) NSArray<SSAudio *> *fmList;

@end
