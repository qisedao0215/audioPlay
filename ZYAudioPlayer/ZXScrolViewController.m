//
//  ZXScrolViewController.m
//  ZYAudioPlayer
//
//  Created by qingyun on 14-5-5.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import "ZXScrolViewController.h"
#import "ZXScrollView.h"
#import "ZXLoginViewController.h"

@interface ZXScrolViewController ()

@end

@implementation ZXScrolViewController
{
    CGRect frame;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationController.navigationBarHidden=YES;
    frame=self.view.bounds;

    UIScrollView *scrViewBox=[[UIScrollView alloc]initWithFrame:frame];
    scrViewBox.delegate=self;
    scrViewBox.contentSize=CGSizeMake(CGRectGetWidth(frame)*5,CGRectGetHeight(frame));
    for (int i=0; i<5; i++)
    {
        ZXScrollView *viewImage=[[ZXScrollView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(frame)*i,
                                                                              0,
                                                                              frame.size.width,
                                                                              frame.size.height)];
        
        viewImage.imageViewZXZy.image=[UIImage imageNamed:[NSString stringWithFormat:@"new_features_%d.jpg",i+1]];
        [scrViewBox addSubview:viewImage];
        
    }
    
    scrViewBox.pagingEnabled=YES;
    
    [self.view addSubview:scrViewBox];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((scrollView.contentOffset.x-CGRectGetWidth(frame)*4) > 80 ) {
        ZXLoginViewController *viewCTL=[[ZXLoginViewController alloc]init];
        [self.navigationController pushViewController:viewCTL animated:YES];
    }

}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
