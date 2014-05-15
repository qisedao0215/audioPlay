//
//  ZXAudioPlayView.h
//  ZYAudioPlayer
//
//  Created by qingyun on 14-5-15.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ZXAudioPlayView : UIView <AVAudioPlayerDelegate>

@property(nonatomic,assign)NSInteger countMusic;
@property(nonatomic,retain)NSArray *musicFile;
@property(nonatomic,retain) AVAudioPlayer *audioPlay;
-(void)playMusicZX;

@end
