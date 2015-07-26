//
//  HomeViewController.m
//  iPlank
//
//  Created by bob on 12/30/13.
//  Copyright (c) 2013 bob. All rights reserved.
//

#import "HomeViewController.h"
//#import "ShareWeibo.h"
#import "DataModel.h"
#import "AppDelegate.h"


@interface HomeViewController ()
{
   
}

@end

@implementation HomeViewController

//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSinaWeiboLogIn object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSinaWeiboGetUserInfo object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSinaWeiboLogOut object:nil];
//}



- (void)viewDidLoad
{
    [super viewDidLoad];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetUserInfo:) name:kSinaWeiboGetUserInfo object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginSina) name:kSinaWeiboLogIn object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogOutSina) name:kSinaWeiboLogOut object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)loadView
{
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.view  = bgview;
    [self.view setBackgroundColor:[UIColor purpleColor]];
    
    float viewHeight = self.height - self.navBarHeight;
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    if(SCR_HEIGHT_P > 480)
    {
        [imgview setImage:[UIImage imageNamed:@"Default-568h.png"]];
    }
    else
    {
        [imgview setImage:[UIImage imageNamed:@"Default.png"]];
    }
    [self.view addSubview:imgview];
    
    float fWidth = 100;
    float fHeight = 40;
    float fSpace = (SCR_WIDTH  - fWidth) / 2;
    UIButton *btnSina = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSina setBackgroundColor:[UIColor whiteColor]];
    [btnSina addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnSina setTitle:NSLocalizedString(@"新浪登录", Nil)  forState:UIControlStateNormal];
    [btnSina setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btnSina setTag:600 + 2];
    [btnSina setFrame:CGRectMake(fSpace, viewHeight - fWidth, fWidth, fHeight)];
    [self.view addSubview:btnSina];
    
//    UIButton *btnWeixin = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnWeixin addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [btnWeixin setTag:600 + 2];
//    [btnWeixin setFrame:CGRectMake(fSpace + SCR_WIDTH / 2, viewHeight - fWidth, fWidth, fHeight)];
//    [self.view addSubview:btnWeixin];
}

#pragma mark -event 
- (void)btnPressed:(id)sender
{
//    UIButton *btn = (UIButton *)sender;
//    int iTag = btn.tag - 600;
//    [[ShareWeibo shareInstance] setCurrentShareType:e_Share_Sina];
//    [[ShareWeibo shareInstance] loginSinaAuth];
}


#pragma mark --- event get sina msg
- (void)didGetUserInfo:(NSNotification *)nt
{
    NSDictionary *dic = nt.userInfo;
    if(![dic objectForKey:@"result"] || ![[dic objectForKey:@"result"] isEqualToString:@"successed"])
    {
        
        [self showProgressHUDWithStr:NSLocalizedString(@"login failed , please try again", nick_name) hideafterDelay:2.0];
        return;
    }
    [self dismissProgressHUD];
    NSString *strOpenid = [NSString stringWithFormat:@"%@", [dic objectForKey:@"openid"]];
    BBUser *bbuser = [DataModel getCurrentUserFromOpenId:strOpenid];
    bbuser.nick_name = [dic objectForKey:@"nick_name"];
    bbuser.avtar_url = [dic objectForKey:@"avtar_url"];
    bbuser.type = @"sinalogin";
    [bbuser save];
        
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate showPlankView];
}

- (void)didLoginSina
{
//    [[ShareWeibo shareInstance] setCurrentShareType:e_Share_Max];
    [self showProgressHUD];
    
}

- (void)didLogOutSina
{
    dispatch_async( dispatch_get_main_queue(), ^{
        NSString *strMsg = [NSString stringWithFormat:@"%@  %@", NSLocalizedString(@"sina", Nil), NSLocalizedString(@"Logged Out", Nil)];
        [self showProgressHUDWithStr:strMsg hideafterDelay:2.0];
        
    });
}



@end
