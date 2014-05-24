//
//  ZXAudioViewController.m
//  ZYAudioPlayer
//
//  Created by qingyun on 14-5-8.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "ZXAudioViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZXAudioPlay.h"

@interface ZXAudioViewController ()

@property (retain, nonatomic) IBOutlet UISlider *sliderVolume;
@property (retain, nonatomic) IBOutlet UISlider *sliderDuration;
@property (retain, nonatomic) IBOutlet UIButton *playBtn;
@property (retain, nonatomic) IBOutlet UILabel *labelView;
@property (retain, nonatomic) IBOutlet UILabel *lrcLabel;
@property (retain, nonatomic) IBOutlet UILabel *timerLabelView;



@property(nonatomic,retain) ZXAudioPlay *audioPlayMusic;
@property(nonatomic,copy)NSString *musicStr;
@end

@implementation ZXAudioViewController
{
    NSMutableArray *timerArray;
    NSMutableDictionary *lrcDictionary;
  
    BOOL playMusicStat;
    NSUInteger timer;
    NSTimer *musicTimer;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
        
    }
    return self;
}
- (IBAction)playNext:(UIButton *)sender {
    if (self.audioPlayMusic.countMusic == [self.audioPlayMusic.musicFile count]-1) {
        self.audioPlayMusic.countMusic = -1;
    }
    
    self.audioPlayMusic.musicStr=self.audioPlayMusic.musicFile[self.audioPlayMusic.countMusic+=1];
    
    [self playMusic];
    [self.audioPlayMusic.audioPlay play];
    
    playMusicStat=YES;
}
- (IBAction)playPrev:(UIButton *)sender {

    if (self.audioPlayMusic.countMusic < 1) {
        self.audioPlayMusic.countMusic = [self.audioPlayMusic.musicFile count];
    }
    
    self.audioPlayMusic.musicStr=self.audioPlayMusic.musicFile[self.audioPlayMusic.countMusic-=1];
  
    [self playMusic];
    [self.audioPlayMusic.audioPlay play];
    
    playMusicStat=YES;
    
}


-(void)playMusic
{
    [self.audioPlayMusic stopMusicPlay];
    
    [self.audioPlayMusic playMusic];
  
    [self.audioPlayMusic.audioPlay prepareToPlay];
  
    self.musicStr=self.audioPlayMusic.musicStr;
   
 
    [self lableTimer];
    
    playMusicStat=NO;
    
    
    
    self.sliderDuration.value=0.0;
    self.sliderDuration.maximumValue=self.audioPlayMusic.audioPlay.duration;
    
    self.labelView.text=self.musicStr;
    self.lrcLabel.text=self.musicStr;
    
    [self.playBtn setImage:[UIImage imageNamed:@"AudioPlayerPause"] forState:UIControlStateNormal];
    
    [self musicLrc];
}

//歌词显示
//自定义方法
-(void)musicLrc
{
    self.labelView.text=self.musicStr;
    self.lrcLabel.text=self.musicStr;
    [timerArray removeAllObjects];
    [lrcDictionary removeAllObjects];
    NSString *strMusicUrl=[[NSBundle mainBundle]pathForResource:self.musicStr ofType:@"lrc"];
    NSString *strLrcKu=[NSString stringWithContentsOfFile:strMusicUrl encoding:NSUTF8StringEncoding error:nil];
    //    把文件安行分割，以每行为单位放入数组
    NSArray *strlineArray=[strLrcKu componentsSeparatedByString:@"\n"];
    //    安行读取歌词歌词
    for (int i=0; i<[strlineArray count]; i++) {
        //      将时间和歌词分割
        NSArray *lineComponents=[[strlineArray objectAtIndex:i] componentsSeparatedByString:@"]"];
        //        取出每行的时间  注意有些歌词是重复使用的，所以会有多个时间点
        for (int n=0; n<[lineComponents count]; n++) {
            NSString *strKuTimer = lineComponents[n];
            //"[03:12.23][02:38.68][01:12.38]哥有老婆 请你别爱我,"  这样的时间串取，安九个字符串去取。
            if ([strKuTimer length]==9) {
                //    取出“:”和“.”符号来对比，是否是我们所需要的时间
                NSString *str1=[strKuTimer substringWithRange:NSMakeRange(3, 1)];
                NSString *str2=[strKuTimer substringWithRange:NSMakeRange(6, 1)];
                if ([str1 isEqualToString:@":"]&&[str2 isEqualToString:@"."]) {
                    //    将时间和歌词暂时放在两个字符串里
                    NSString *lineTimer=[[lineComponents objectAtIndex:n] substringWithRange:NSMakeRange(1, 5)];
                    NSString *lineStr=[lineComponents objectAtIndex:([lineComponents count]-1)];
                    //    以时间为key,歌词为值，放入字典中
                    [lrcDictionary setObject:lineStr forKey:lineTimer];
                }
            }
        }
    }
    
    
    timerArray = [[lrcDictionary allKeys] mutableCopy];
    [timerArray sortUsingSelector:@selector(compare:)];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.hidesBackButton=NO;

    self.labelView.tintColor=[UIColor greenColor];
    
    self.sliderVolume.value=1.0;
    self.sliderVolume.maximumValue=1.0;
    self.sliderVolume.minimumValue=0.0;
    
    self.sliderDuration.minimumValue=0.0;
    
    timerArray =[[NSMutableArray alloc]init];
    lrcDictionary=[[NSMutableDictionary alloc]initWithCapacity:100];
    
    playMusicStat=YES;
    
    musicTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    _audioPlayMusic=[ZXAudioPlay defPlay];
    
    _musicStr=self.audioPlayMusic.musicFile[self.countMusic];
    if ([(self.musicStr) isEqualToString:self.audioPlayMusic.musicStr]) {
        
        self.sliderDuration.maximumValue=self.audioPlayMusic.audioPlay.duration;
        playMusicStat=YES;
        [self.playBtn setImage:[UIImage imageNamed:@"AudioPlayerPause"] forState:UIControlStateNormal];
        [self musicLrc];

    }else{
 
        [self playMusic];

        [self onTimer:nil];
       
        [self.audioPlayMusic.audioPlay play];
        playMusicStat=YES;
    }
   
}

//音乐的声音控制条
//IB初始化
- (IBAction)sliderVolume:(UISlider *)sender {

    
    self.audioPlayMusic.audioPlay.volume=sender.value;
 
   
}
//播放，暂停按键
//IB初始化
- (IBAction)onBtn:(UIButton *)sender {
    
    if ([self.audioPlayMusic.audioPlay isPlaying]) {
        [sender setImage:[UIImage imageNamed:@"AudioPlayerPlay"] forState:UIControlStateNormal];
        [self.audioPlayMusic.audioPlay pause];
        playMusicStat=NO;
        
    }else{

        [self.audioPlayMusic.audioPlay play];
        [sender setImage:[UIImage imageNamed:@"AudioPlayerPause"] forState:UIControlStateNormal];
        playMusicStat=YES;
    }
  
}
//歌曲进度条
//IB初始化
- (IBAction)sliderDuration:(UISlider *)sender {

    if (sender.value>self.audioPlayMusic.audioPlay.duration-1) {
        [self playNext:nil];
    }
    self.audioPlayMusic.audioPlay.currentTime=sender.value;
   
}
//定时器执行动作
//自定义方法
-(void)onTimer:(NSTimer*)sender
{
    if (playMusicStat) {
        
        [self lableTimer];
        self.sliderDuration.value=timer;
 
       
        
        if (timer>self.audioPlayMusic.audioPlay.duration-1) {
            [self playNext:nil];
        }
 ////////////////////////////
        for (int i=0; i < [timerArray count]; i++) {
            NSArray *array = [timerArray[i] componentsSeparatedByString:@":"];
            NSUInteger currentTime = [array[0] intValue] * 60 + [array[1] intValue];
            if (i==([timerArray count]-1)) {
                NSArray *array1 = [timerArray[[timerArray count]-1] componentsSeparatedByString:@":"];
                NSUInteger currentTime1 = [array1[0] intValue] * 60 + [array1[1] intValue];
                
                if (timer < currentTime1) {
                    
                    NSString *lrcLabelStr=[lrcDictionary objectForKey:self.timerLabelView.text];
                    if (lrcLabelStr) {
                        self.lrcLabel.text=lrcLabelStr;
                        break;
                    }
                }
                
            }else{
                NSArray *array2 = [timerArray[0] componentsSeparatedByString:@":"];
                NSUInteger currentTime2 = [array2[0] intValue] * 60 + [array2[1] intValue];
                
                if (timer < currentTime2) {
                    
                    NSString *lrcLabelStr=[lrcDictionary objectForKey:self.timerLabelView.text];
                    if (lrcLabelStr) {
                        self.lrcLabel.text=lrcLabelStr;
                        break;
                    }
                }
                NSArray *array3 = [timerArray[i+1] componentsSeparatedByString:@":"];
                NSUInteger currentTime3 = [array3[0] intValue] * 60 + [array3[1] intValue];
                
                if (timer >= currentTime && timer <= currentTime3) {
                    
                    NSString *lrcLabelStr=[lrcDictionary objectForKey:self.timerLabelView.text];
                    if (lrcLabelStr) {
                        self.lrcLabel.text=lrcLabelStr;
                        
                        break;
                    }
                }
            }
        }
        

    }

    
}

//取出当前的播放时间。
//自定义方法
-(void)lableTimer
{
    timer=self.audioPlayMusic.audioPlay.currentTime;
    if (timer % 60 < 10) {
        _timerLabelView.text = [NSString stringWithFormat:@"0%d:0%d",timer / 60, timer % 60];
    } else {
        _timerLabelView.text = [NSString stringWithFormat:@"0%d:%d",timer / 60, timer % 60];
    }
}
//销毁定时器
//系统方法
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [musicTimer invalidate];
}


- (void)dealloc {

    [_musicStr release];
    [_sliderDuration release];
    [_sliderVolume release];
    [_playBtn release];
    [_labelView release];
    [_lrcLabel release];
    [_timerLabelView release];

    [super dealloc];
    
}
@end


