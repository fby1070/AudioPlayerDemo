//
//  SSPlayerNetEngine.h
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/8.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StarShareNetWorking/StarShareNetWorking.h>
#import <StarShareCommons/StarShareCommons.h>

@interface SSPlayerNetEngine : NSObject

/**
 app初始化时赋值
 */
@property (nonatomic, strong) SimpleNetworkEngine *engine;


- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock;

- (id<INetRequestHandle>)requestDomainBeanWithRequestDomainBean:(in id)netRequestDomainBean
                                                     beginBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadBeginBlock)beginBlock
                                                 successedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadSuccessedBlock)successedBlock
                                                    failedBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadFailedBlock)failedBlock
                                                       endBlock:(in DomainBeanAsyncHttpResponseListenerInUIThreadEndBlock)endBlock;
@end
