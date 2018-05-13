//
//  SSPlayerNetEngine.m
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/8.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import "SSPlayerNetEngine.h"

@implementation SSPlayerNetEngine


- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock {
  return [self.engine requestDomainBeanWithRequestDomainBean:netRequestDomainBean
                                              successedBlock:successedBlock
                                                 failedBlock:failedBlock];
}

- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                                     beginBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadBeginBlock)beginBlock
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock
                                                       endBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadEndBlock)endBlock {
  return [self.engine requestDomainBeanWithRequestDomainBean:netRequestDomainBean
                                                  beginBlock:beginBlock
                                              successedBlock:successedBlock
                                                 failedBlock:failedBlock
                                                    endBlock:endBlock];
}
@end
