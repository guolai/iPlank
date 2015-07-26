//
//  AppDelegate.h
//  iplank
//
//  Created by bob on 12/30/13.
//  Copyright (c) 2013 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
     CMMotionManager *motionManager;
}

@property (strong, nonatomic) UIWindow *window;

- (void)showHomeView;
- (void)showPlankView;
@end
