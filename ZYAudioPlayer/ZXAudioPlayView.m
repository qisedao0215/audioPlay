//
//  ZXAudioPlayView.m
//  ZYAudioPlayer
//
//  Created by qingyun on 14-5-15.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "ZXAudioPlayView.h"

@interface ZXAudioPlayView ()
@property (retain, nonatomic)  UISlider *sliderVolume;
@property (retain, nonatomic)  UISlider *sliderDuration;
@property (retain, nonatomic)  UIButton *playBtn;
@property (retain, nonatomic)  UILabel *labelView;
@property (retain, nonatomic)  UILabel *lrcLabel;
@property (retain, nonatomic)  UILabel *timerLabelView;



@property(nonatomic,assign)NSString *musicStr;

@end
@implementation ZXAudioPlayView
{
    NSMutableArray *timerArray;
    NSMutableDictionary *lrcDictionary;
    
    BOOL playMusicStat;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"IMG_1464.jpg"]];
        [self addSubview:imageView];
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(20, 50, 60, 40)];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        self.sliderVolume=[[UISlider alloc]initWithFrame:CGRectMake(10, 80, 300, 40)];
        [self.sliderVolume addTarget:self action:@selector(sliderVolume:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.sliderVolume];
        
        self.labelView=[[UILabel alloc]initWithFrame:CGRectMake(10, 130, 300, 50)];
        self.labelView.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.labelView];
        
        self.lrcLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 200, 300, 40)];
        self.lrcLabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.lrcLabel];

        self.timerLabelView=[[UILabel alloc]initWithFrame:CGRectMake(10, 330, 300, 40)];
        [self addSubview:self.timerLabelView];

        
        self.sliderDuration=[[UISlider alloc]initWithFrame:CGRectMake(10, 400, 300, 40)];
        [self.sliderDuration addTarget:self action:@selector(sliderDuration:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.sliderDuration];
        
        self.playBtn =[[UIButton alloc]initWithFrame:CGRectMake(140, 450, 40, 30)];
        [self.playBtn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.playBtn];
        
  //      self.labelView.tintColor=[UIColor greenColor];
                
        self.sliderVolume.value=0.5;
        self.sliderVolume.maximumValue=1.0;
        self.sliderVolume.minimumValue=0.0;

        [self playMusic];
        [self.playBtn setImage:[UIImage imageNamed:@"AudioPlayerPlay"] forState:UIControlStateNormal];
       
        playMusicStat=YES;
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        
    }
    return self;
}

-(void)onBack
{
    self.alpha=0;
}

- (void)sliderDuration:(UISlider *)sender {
    self.audioPlay.currentTime = sender.value;
}
- (void)sliderVolume:(UISlider *)sender {
    self.audioPlay.volume=sender.value;
    
}

-(void)onTimer:(NSTimer*)sender
{
    if (playMusicStat) {
        
        NSUInteger timer=(int)self.audioPlay.currentTime;
        if (timer % 60 < 10) {
            self.timerLabelView.text = [NSString stringWithFormat:@"0%d:0%d",timer / 60, timer % 60];
        } else {
            self.timerLabelView.text = [NSString stringWithFormat:@"0%d:%d",timer / 60, timer % 60];
        }
        
        self.sliderDuration.value=timer;
        
        
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

-(void)playMusicZX
{
    [self playMusic];
    [self.audioPlay play];
    [self.playBtn setImage:[UIImage imageNamed:@"AudioPlayerPause"] forState:UIControlStateNormal];
}

- (void)playNext:(UIButton *)sender {
    
    if (self.countMusic == [self.musicFile count]-1) {
        self.countMusic=-1;
    }
    self.musicStr=self.musicFile[self.countMusic+=1];
    [self playMusic];
    [self.audioPlay play];
    
}
- (void)playPrev:(UIButton *)sender {
    if (self.countMusic < 1) {
        self.countMusic = [self.musicFile count];
    }
    
    self.musicStr=self.musicFile[self.countMusic-=1];
    [self playMusic];
    [self.audioPlay play];
}

- (void)onBtn:(UIButton *)sender {
    
    if ([self.audioPlay isPlaying]) {
        [sender setImage:[UIImage imageNamed:@"AudioPlayerPlay"] forState:UIControlStateNormal];
        [self.audioPlay pause];
        playMusicStat=NO;
        
    }else{
        [self.audioPlay play];
        [sender setImage:[UIImage imageNamed:@"AudioPlayerPause"] forState:UIControlStateNormal];
        playMusicStat=YES;
    }
}

-(void)playMusic
{
    [self.audioPlay stop];
    playMusicStat=NO;
    
    self.musicStr=self.musicFile[self.countMusic];
    self.lrcLabel.text=nil;
    self.labelView.text=nil;
    
    NSURL *strURL=[[NSBundle mainBundle]URLForResource:self.musicStr withExtension:@"mp3"];
    self.audioPlay=[[AVAudioPlayer alloc]initWithContentsOfURL:strURL error:nil];
    [self.audioPlay prepareToPlay];
    self.audioPlay.delegate =self;
    
    self.sliderDuration.value=0;
    self.sliderDuration.maximumValue=self.audioPlay.duration;
    
    
    [self.playBtn setImage:[UIImage imageNamed:@"AudioPlayerPause"] forState:UIControlStateNormal];
    
    self.labelView.text=self.musicStr;
    
    self.lrcLabel.text=self.musicStr;
    
    timerArray=nil;
    lrcDictionary=nil;
    
    timerArray =[[NSMutableArray alloc]init];
    lrcDictionary=[[NSMutableDictionary alloc]initWithCapacity:20];
    lrcDictionary=[self musicLrc:(self.musicStr)];
    
    
    timerArray = [[lrcDictionary allKeys] mutableCopy];
    [timerArray sortUsingSelector:@selector(compare:)];
    playMusicStat=YES;
    

    
}

-(NSMutableDictionary*)musicLrc:(NSString*)musicName
{
    
    //    初始化一个字典
    NSMutableDictionary *musicLrcDictionary=[[NSMutableDictionary alloc]initWithCapacity:20];
    //    加载歌词到内存
    NSString *strMusicUrl=[[NSBundle mainBundle]pathForResource:musicName ofType:@"lrc"];
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
            if ([strKuTimer length]==9) {
                //    取出“:”和“.”符号来对比，是否是我们所需要的时间
                NSString *str1=[strKuTimer substringWithRange:NSMakeRange(3, 1)];
                NSString *str2=[strKuTimer substringWithRange:NSMakeRange(6, 1)];
                if ([str1 isEqualToString:@":"]&&[str2 isEqualToString:@"."]) {
                    //    将时间和歌词暂时放在两个字符串里
                    NSString *lineTimer=[[lineComponents objectAtIndex:n] substringWithRange:NSMakeRange(1, 5)];
                    NSString *lineStr=[lineComponents objectAtIndex:([lineComponents count]-1)];
                    //    以时间为key,歌词为值，放入字典中
                    [musicLrcDictionary setObject:lineStr forKey:lineTimer];
                }
            }
        }
    }
    //    在这里返回整个字典
    return musicLrcDictionary;
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self playNext:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self viewWillAppear:animated];
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	[self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self viewWillDisappear:animated];
	[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
	[self resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
	return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
	if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [self onBtn:(nil)]; // 切换播放、暂停按钮
                break;
                
            case UIEventSubtypeRemoteControlPause:
                [self onBtn:(nil)]; // 切换播放、暂停按钮
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self playPrev:(nil)]; // 播放上一曲按钮
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [self playNext:(nil)]; // 播放下一曲按钮
                break;
                
            default:
                break;
        }
    }
}


@end
