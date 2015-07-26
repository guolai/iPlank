//
//  BBNavigationViewController.m
//  Zine
//
//  Created by bob on 13-9-13.
//  Copyright (c) 2013年 user1. All rights reserved.
//

#import "BBNavigationViewController.h"

@implementation BBNavigationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(OS_VERSION >= 7.0)
        self.navigationBar.translucent = YES;
    else
    {
        self.navigationBar.translucent = NO;
    }
    if(OS_VERSION >= 7.0)
    {
        [self.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navbar_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    }
    else
    {
        [self.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navbar_bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forBarMetrics:UIBarMetricsDefault];
    }
//    self.navigationBar.barStyle = UIBarStyleDefault;

    [self.navigationBar setBackgroundColor:[UIColor clearColor]];

}

- (void)changeBgStyleToBlack:(BOOL)bBlack
{
    if(bBlack)
    {
        if(OS_VERSION >= 7.0)
        {
            [self.navigationBar setBackgroundImage:[[UIImage imageNamed:@"image_style_top_bar_iOS7.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        }
        else
        {
            [self.navigationBar setBackgroundImage:[[UIImage imageNamed:@"image_style_top_bar.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forBarMetrics:UIBarMetricsDefault];
        }

    }
    else
    {
        if(OS_VERSION >= 7.0)
        {
            [self.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navbar_bg_lightgray_iOS7.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
        }
        else
        {
            [self.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navbar_bg_lightgray.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0] forBarMetrics:UIBarMetricsDefault];
        }
    }
    
}


@end




