//
//  ViewController.m
//  AudioPlayerDemo
//
//  Created by fuby on 2018/4/27.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import "ViewController.h"
#import "SSCoverModel.h"
#import "SSAudio.h"
#import "SSUIPlayerControlManager.h"
#import "Masonry.h"
#import "SSHomeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(200, 300, 80, 40)];
  [button setTitle:@"开始" forState:UIControlStateNormal];
  [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:button];

}

- (void)buttonClick {
  SSHomeViewController *vc = [[SSHomeViewController alloc] init];
  UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:nc animated:YES completion:nil];
}

- (NSArray *)audioList {
  //数据
  SSAudio *audio0 = [[SSAudio alloc] init];
  audio0.url = @"http://other.web.rh01.sycdn.kuwo.cn/resource/n3/42/74/293434430.mp3";
  audio0.name = @"We Don't Talk Anymore";
  audio0.singer = @"双笙";
  audio0.cover = @"http://star.kuwo.cn/star/starheads/180/96/28/4279064489.jpg";
  
  SSAudio *audio1 = [[SSAudio alloc] init];
  audio1.url = @"http://other.web.ri01.sycdn.kuwo.cn/resource/n1/48/31/983199783.mp3";
  audio1.name = @"Rather Be";
  audio1.singer = @"Clean Bandit / Jess Glynne ";
  audio1.cover = @"http://star.kuwo.cn/star/starheads/180/15/54/2141539665.jpg";
  
  SSAudio *audio2 = [[SSAudio alloc] init];
  audio2.url = @"http://vip.baidu190.com/uploads/2017/201710b36c2ec318a5d3170b4610cd31c45de9.mp3";
  audio2.name = @"追光者";
  audio2.singer = @"汪苏泷";
  audio2.cover = @"https://y.gtimg.cn/music/photo_new/T002R300x300M000001OJP0R3NGeiF.jpg?max_age=2592000";
  
  SSAudio *audio3 = [[SSAudio alloc] init];
  audio3.url = @"http://vip.baidu190.com/uploads/2017/2017106d7d03d770c6e2fa04efcc0c93d2f368.mp3";
  audio3.name = @"This Girl";
  audio3.singer = @"Kungs";
  audio3.cover = @"https://y.gtimg.cn/music/photo_new/T002R300x300M000004cZz532Um5mc.jpg?max_age=2592000";
  
  return @[audio0, audio1, audio2, audio3];
}

- (NSArray *)fmList {
  //数据
  SSAudio *audio0 = [[SSAudio alloc] init];
  audio0.url = @"http://vip.baidu190.com/uploads/2017/201710a497c90917fe0b918fb85819bc541344.mp3";
  audio0.name = @"拥抱";
  audio0.singer = @"周玥翻唱";
  audio0.cover = @"https://y.gtimg.cn/music/photo_new/T002R300x300M000000g4srs0OyIED.jpg?max_age=2592000";
  
  SSAudio *audio1 = [[SSAudio alloc] init];
  audio1.url = @"http://vip.baidu190.com/uploads/2017/20171068c49a4e33b0838c4b2d390d75b36df3.mp3";
  audio1.name = @"自导自演";
  audio1.singer = @"周杰伦";
  audio1.cover = @"https://y.gtimg.cn/music/photo_new/T002R300x300M000000bviBl4FjTpO.jpg?max_age=2592000";
  
  SSAudio *audio2 = [[SSAudio alloc] init];
  audio2.url = @"http://vip.baidu190.com/uploads/2017/201710a813eb493d5cec91159aec06231724e5.mp3";
  audio2.name = @"321对不起";
  audio2.singer = @"徐良";
  audio2.cover = @"https://y.gtimg.cn/music/photo_new/T002R300x300M000002apRhZ4Bq99d.jpg?max_age=2592000";
  
  SSAudio *audio3 = [[SSAudio alloc] init];
  audio3.url = @"http://vip.baidu190.com/uploads/2017/201710c211911f1abf480e4d0337583bd323b6.mp3";
  audio3.name = @"还不是因为你长得不好看";
  audio3.singer = @"希瑟";
  audio3.cover = @"https://y.gtimg.cn/music/photo_new/T002R300x300M000002GWwod4DjviD.jpg?max_age=2592000";
  
  return @[audio0, audio1, audio2, audio3];
}


@end
