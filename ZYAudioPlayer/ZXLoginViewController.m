//
//  ZXLoginViewController.m
//  ZYAudioPlayer
//
//  Created by qingyun on 14-5-5.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "ZXLoginViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "ZXAudioViewController.h"

@interface ZXLoginViewController ()
@property(nonatomic,retain)NSArray *musicArray;
@end

@implementation ZXLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.musicArray=@[@"爱情鸟",@"爱囚",@"把悲伤留给自己",
                          @"爸爸去哪儿",@"哥有老婆",@"好男人寂寞了也犯错",
                          @"老婆最大",@"媳妇你真好",@"一万个舍不得",@"月亮惹的祸",@"咱们结婚吧",@"传奇",@"倩女幽魂",];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigationItem.hidesBackButton=YES;
    self.view.backgroundColor=[UIColor orangeColor];
    
    CGRect btnFrame=CGRectMake(0, 0, 100, 40);
    CGRect frame=self.view.bounds;
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(frame)/2-CGRectGetWidth(btnFrame)/2,
                                                            CGRectGetHeight(frame)/2,
                                                            CGRectGetWidth(btnFrame),
                                                            CGRectGetHeight(btnFrame))];
    btn.backgroundColor=[UIColor greenColor];
    [btn setTitle:@"play" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];

    
    
    
}

-(void)onBtn:(UIButton*)sender
{
    ZXAudioViewController *audioPlay=[[ZXAudioViewController alloc]init];
    audioPlay.musicFile=self.musicArray;
    audioPlay.musicStr=self.musicArray[1];
    audioPlay.extension=@"mp3";
    
    [self.navigationController pushViewController:audioPlay animated:YES];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
}


@end
