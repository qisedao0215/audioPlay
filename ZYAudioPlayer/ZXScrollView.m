//
//  ZXScrollView.m
//  ZYAudioPlayer
//
//  Created by qingyun on 14-5-5.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "ZXScrollView.h"

@implementation ZXScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageViewZXZy=[[UIImageView alloc]initWithFrame:self.bounds];
        
        self.delegate=self;
        self.contentSize=CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        self.maximumZoomScale=2.0;
        self.minimumZoomScale=0.6;
        
        [self addSubview:self.imageViewZXZy];

    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    return self.imageViewZXZy;
}

@end
