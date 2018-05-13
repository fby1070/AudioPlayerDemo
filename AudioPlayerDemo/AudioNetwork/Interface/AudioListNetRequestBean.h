//
//  AudioListNetRequestBean.h
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/8.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioListNetRequestBean : NSObject

@property (nonatomic, copy, readonly) NSString *starId;

- (instancetype)initWithStarId:(NSString *)starId;
@end
