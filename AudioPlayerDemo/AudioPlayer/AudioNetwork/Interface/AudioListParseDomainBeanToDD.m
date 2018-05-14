//
//  AudioListParseDomainBeanToDD.m
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/8.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import "AudioListParseDomainBeanToDD.h"
#import "AudioListNetRequestBean.h"
#import <StarShareNetWorking/StarShareNetWorking.h>

@implementation AudioListParseDomainBeanToDD

- (NSDictionary *)parseNetRequestDomainBeanToDataDictionary:(in AudioListNetRequestBean *)netRequestBean error:(out ErrorBean **)errorOUT {
  NSString *errorMessage = nil;
  do {
    if (![netRequestBean isMemberOfClass:[AudioListNetRequestBean class]]) {
      errorMessage = @"传入的业务Bean的类型不符 !";
      break;
    }
    if (netRequestBean.starId == nil || [netRequestBean.starId isEqualToString:@""]) {
      errorMessage = @"传入starId 不能为空或者空字符串 !";
      break;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"starId"] = netRequestBean.starId;
    if (errorOUT != NULL) {
      *errorOUT = nil;
    }
    return params;
  } while (NO);
  if (errorOUT != NULL) {
    *errorOUT = [ErrorBean errorBeanWithErrorCode:ErrorCodeEnum_Client_NetRequestBeanInvalid errorMessage:errorMessage];
  }
  return nil;
}
@end
