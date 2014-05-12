//
//  AppDelegate.m
//  ZYAudioPlayer
//
//  Created by qingyun on 14-5-5.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "ZXLoginViewController.h"
#import "ZXScrolViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    BOOL str=[userDefaults boolForKey:@"name_preference"];
    if (!str) {
        [userDefaults setBool:YES forKey:@"name_preference"];
        ZXScrolViewController *viewCTRZX=[[ZXScrolViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:viewCTRZX];
        nav.navigationBarHidden=YES;
        self.window.rootViewController=nav;
    }else
    {
        ZXLoginViewController *logIn=[[ZXLoginViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:logIn];
       
        self.window.rootViewController=nav;
    }
    
    

    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
