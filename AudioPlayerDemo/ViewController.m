//
//  ViewController.m
//  AudioPlayerDemo
//
//  Created by fuby on 2018/4/27.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import "ViewController.h"
#import "SSHomeViewController.h"
#import "AudioManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UIButton *nowButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 300, 80, 40)];
  [nowButton setTitle:@"立即" forState:UIControlStateNormal];
  [nowButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  [nowButton addTarget:self action:@selector(nowButtonClick) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:nowButton];
}

- (void)nowButtonClick {
  [[AudioManager shareInstance] requestAudioList];
  SSHomeViewController *vc = [[SSHomeViewController alloc] init];
  UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:nc animated:YES completion:nil];
}
@end
