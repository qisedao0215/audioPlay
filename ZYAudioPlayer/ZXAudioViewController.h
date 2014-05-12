//
//  ZXAudioViewController.h
//  ZYAudioPlayer
//
//  Created by qingyun on 14-5-8.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ZXAudioViewController : UIViewController<AVAudioPlayerDelegate>
@property(nonatomic,assign)NSString *musicStr;
@property(nonatomic,retain)NSArray *musicFile;
@property(nonatomic,assign)NSString *extension;

@property(nonatomic,assign)NSInteger countMusic;
@end
