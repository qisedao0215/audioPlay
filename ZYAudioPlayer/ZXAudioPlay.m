//
//  ZXAudioPlay.m
//  ZYAudioPlayer
//
//  Created by qingyun on 14-5-17.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "ZXAudioPlay.h"

@implementation ZXAudioPlay
+(ZXAudioPlay*)defPlay
{
    static ZXAudioPlay * share=nil;
    @synchronized(self)
    {
        if (!share) {
            share=[[super allocWithZone:NULL]init];
        }
    }
    return share;
}


- (void)playMusic
{
    _musicStr=self.musicFile[self.countMusic];
    NSURL *strURL=[[NSBundle mainBundle]URLForResource:self.musicStr withExtension:@"mp3"];
    _audioPlay=[[AVAudioPlayer alloc]initWithContentsOfURL:strURL error:nil];
       
}



- (void)stopMusicPlay
{
    [_audioPlay stop];
    [_audioPlay release];
    _audioPlay =nil;

}

-(void)dealloc
{
    [_musicStr release],_musicStr=nil;
    [_musicFile release],_musicFile=nil;
    
    [super dealloc];
}

@end
