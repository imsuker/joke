//
//  AppDelegate.m
//  Joke
//
//  Created by Gukw on 7/11/13.
//  Copyright (c) 2013 iphone. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "UserModel.h"


@implementation AppDelegate

-(void)configBaiduMobStat{
    BaiduMobStat *statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES;
    statTracker.channelId = nil;
    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;
    statTracker.sessionResumeInterval = 60;
    [statTracker startWithAppId:@"db83dba6c9"];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configBaiduMobStat];
    //http://yannickloriot.com/2012/03/magicalrecord-how-to-make-programming-with-core-data-pleasant/#sthash.Z3WA25jg.NjtiRIKV.dpbs
//    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Joke.sqlite"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UINavigationController *mainNavigation = [[UINavigationController alloc] initWithRootViewController:main];
    //设置背景样式
    [mainNavigation.navigationBar setBackgroundImage:[UIImage imageNamed:@"topmenu"] forBarMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.window setRootViewController:mainNavigation];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UserModel shareInstance] save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UserModel shareInstance] reCountVisitDate];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[UserModel shareInstance] save];
}

@end
