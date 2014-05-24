//
//  ZXAudioPlay.h
//  ZYAudioPlayer
//
//  Created by qingyun on 14-5-17.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface ZXAudioPlay : NSObject<AVAudioPlayerDelegate>

@property(nonatomic,retain) AVAudioPlayer *audioPlay;
@property(nonatomic,copy) NSArray *musicFile;
@property(nonatomic,assign) NSInteger countMusic;
@property(nonatomic,copy) NSString *musicStr;

- (void)stopMusicPlay;
- (void)playMusic;
+(ZXAudioPlay*)defPlay;
@end
