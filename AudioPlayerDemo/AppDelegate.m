//
//  AppDelegate.m
//  AudioPlayerDemo
//
//  Created by fuby on 2018/4/27.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import "AppDelegate.h"
#import "AudioManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  return YES;
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
  [[AudioManager shareInstance] remoteControlReceivedWithEvent:event];
}

@end
