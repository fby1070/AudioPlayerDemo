//
//  SSHomeViewController.m
//  AudioPlayerDemo
//
//  Created by fuby on 2018/5/8.
//  Copyright © 2018年 SSFBY. All rights reserved.
//

#import "SSHomeViewController.h"
#import "SSPlayerViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "AudioManager.h"

@interface SSHomeViewController ()

@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation SSHomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
 [self.rightButton setImage:[UIImage imageNamed:@"cm2_list_icn_loading1"] forState:UIControlStateNormal];
  UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
  self.navigationItem.rightBarButtonItem = item;
  
  [RACObserve([AudioManager shareInstance], state) subscribeNext:^(id x) {
    if ([x integerValue] == SSPlayerPlayStateBuffering || [x integerValue] == SSPlayerPlayStatePlaying ) {
      NSMutableArray *images = [NSMutableArray new];
      
      for (NSInteger i = 0; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"cm2_list_icn_loading%zd", i + 1]];
        [images addObject:image];
      }
      
      for (NSInteger i = 4; i > 0; i--) {
        NSString *imageName = [NSString stringWithFormat:@"cm2_list_icn_loading%zd", i];
        [images addObject:[UIImage imageNamed:imageName]];
      }
      
      self.rightButton.imageView.animationImages = images;
      self.rightButton.imageView.animationDuration = 0.85;
      [self.rightButton.imageView startAnimating];
    } else {
      [self.rightButton.imageView stopAnimating];
    }
  }];
  
  
  
  [self.rightButton addTarget:self action:@selector(goPlayer) forControlEvents:UIControlEventTouchUpInside];
}

- (void)goPlayer {
  SSPlayerViewController *vc = [[SSPlayerViewController alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}

@end
