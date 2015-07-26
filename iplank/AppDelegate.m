//
//  AppDelegate.m
//  iplank
//
//  Created by bob on 12/30/13.
//  Copyright (c) 2013 bob. All rights reserved.
//
#import <SystemConfiguration/SCNetworkReachability.h>
#import "AppDelegate.h"
#import "PlankViewController.h"
#import "HomeViewController.h"
#import "DataModel.h"
#import "UserDefault.h"
//#import "ShareWeibo.h"
#import "MobClick.h"
#import "BBNavigationViewController.h"

@implementation AppDelegate

- (CMMotionManager *)motionManager
{
    if(!motionManager)
    {
        motionManager = [[CMMotionManager alloc] init];
    }
    return motionManager;
}

- (void)showHomeView
{
    HomeViewController *vc = [[HomeViewController alloc] init];
    self.window.rootViewController = vc;

}

- (void)showPlankView
{
    PlankViewController *vc = [[PlankViewController alloc] init];
    BBNavigationViewController *nav = [[BBNavigationViewController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [[ShareWeibo shareInstance] regeisterSina];
    [BBAutoSize reGetScreenSize];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    [TestFlight takeOff:@"be617b34-f4a1-4595-b94e-6f3f2adc05c2"];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [MobClick startWithAppkey:@"537b60b656240b72bb01f698"];
    [MobClick updateOnlineConfig];
    
    UIView *loadingView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //    UIView *mainview = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window addSubview:loadingView];
    
#if 1
    if([DataModel isFirstIn])
    {
        [DataModel createUser];
    }
    BBUser *bbuser = [DataModel getCurrentUser];
//    if(ISEMPTY([UserDefault getUserKey]) || ISEMPTY(bbuser.open_id))
//    {
//        [self showHomeView];
//    }
//    else
    {
        
        

        
        if(1)
        {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            [imgView setImage:[UIImage imageNamed:@"Default-568h.png"]];
            [loadingView  addSubview:imgView];
//            NSMutableArray *arrayFrames = [[NSMutableArray alloc] init];
//            for (int i = 0; i < 15; i++)
//            {
//                //            NSString *strFileName = [NSString stringWithFormat:@"loading_%d.png", i + 1];
//                UIImage *temImg = [UIImage imageNamed:@"loading_1.png"];
//                [arrayFrames addObject:temImg];
//            }
//            
//            NSLog(@"%@", arrayFrames);
//            UIImageView *animtView = [[UIImageView alloc] init];
//            [animtView setFrame:CGRectMake(185, 369, 128, 77)];
//            animtView.animationImages = arrayFrames;
//            animtView.animationDuration = 2.0;
//            animtView.animationRepeatCount = 1;
//            [loadingView addSubview:animtView];
//            [animtView startAnimating];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            loadingView.alpha = 0.8;
        } completion:^(BOOL finished) {
            [loadingView removeFromSuperview];
            [self showPlankView];
        }];
    }
#else
    //    [self showHomeView];
    [self showPlankView];
#endif

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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
//    [[ShareWeibo shareInstance] openUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"%@", url.absoluteString);
//    [[ShareWeibo shareInstance] openUrl:url];
    return YES;
}
- (BOOL)hasNetworkConnection
{
	SCNetworkReachabilityRef reach = SCNetworkReachabilityCreateWithName(kCFAllocatorSystemDefault, "baidu.com");
	SCNetworkReachabilityFlags flags;
	SCNetworkReachabilityGetFlags(reach, &flags);
	BOOL ret = (kSCNetworkReachabilityFlagsReachable & flags) || (kSCNetworkReachabilityFlagsConnectionRequired & flags);
	CFRelease(reach);
	reach = nil;
	return ret;
}
- (BOOL)hasWiFiConnection
{
	SCNetworkReachabilityRef reach = SCNetworkReachabilityCreateWithName(kCFAllocatorSystemDefault, "baidu.com");
	SCNetworkReachabilityFlags flags;
	SCNetworkReachabilityGetFlags(reach, &flags);
	BOOL ret = (kSCNetworkFlagsReachable & flags) && !(kSCNetworkReachabilityFlagsIsWWAN & flags);
	CFRelease(reach);
	reach = nil;
	return ret;
}

@end
