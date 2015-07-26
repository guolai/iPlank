//
//  PlankViewController.m
//  iPlank
//
//  Created by bob on 12/25/13.
//  Copyright (c) 2013 bob. All rights reserved.
//

#import "PlankViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+fixOrientation.h"
#import <CoreImage/CoreImage.h>
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import <ImageIO/ImageIO.h>
#import "NSString+UIColor.h"
#import "HistoryViewController.h"
#import "FriendViewController.h"
#import "BBNavigationViewController.h"
#import "RankingView.h"
#import "CompareView.h"
#import "DataModel.h"
#import "UserDefault.h"
#import "PickerViewController.h"
#import "ClockViewController.h"
#import "ExampleViewController.h"
#import "SettingViewController.h"
#import "PopupView.h"
#import "MobClick.h"
#import "UserDefault.h"

typedef enum {
    e_PlankType_Z,
    e_PlankType_D
}T_PlankType;


@interface PlankViewController ()
{
    T_PlankType _plankType;

    UIButton *_btnDijiShi;
    UIButton *_btnZhengJiShi;
    UIImageView *_switchImageView;
    UILabel *_lbl;
    CATextLayer *_textLayer;
    UIButton *_btnTextLayer;
    BOOL _bFirstIn;

}


@property (nonatomic, strong) CompareView *compareview;
@property (nonatomic, strong) UIButton *boyOrGirlBtn;
@property (nonatomic, strong) UILabel *lblBoyOrGirl;

@end

@implementation PlankViewController
@synthesize compareview;

@synthesize boyOrGirlBtn;
@synthesize lblBoyOrGirl;



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(OS_VERSION >= 7.0)
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self getDaojishiString];
    NSString *strUserKey = [UserDefault getUserKey];
    NSString *strParams = [NSString stringWithFormat:@"user_key == '%@'", strUserKey];
    NSArray *array = [BBResult where:strParams startFrom:0 limit:100 sortby:@"create_date^0"];
    for (BBResult *bbrsul in array) {
        DEBUGINFO(@"%@ -- %@", bbrsul.create_date, bbrsul.duration);
    }
    if(array.count >= 1)
    {
        BBResult *bbreseult1 = [array objectAtIndex:0];
        self.compareview.fCur = [bbreseult1.duration floatValue];
        self.compareview.fLast = 0;
        if(array.count >= 2)
        {
            BBResult *bbreseult2 = [array objectAtIndex:1];
            self.compareview.fLast = [bbreseult2.duration floatValue];
        }
        
        
    }
    [self.compareview reDrawData];
//    PopupView *popView = [[PopupView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT_P) withScore:10];
//    [self.navigationController.view addSubview:popView];
//    [popView fadeIn];
    if(!_bFirstIn) //如果不是第一次进入，计算一下是不是要显示广告或者评价我们
    {
        [self rateUs];
 
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _bFirstIn = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _bFirstIn = YES;
    [self showTitle:NSLocalizedString(@"iPlank", nil) style:e_Nav_Gray];
    [self showRigthButton:nil withImage:@"home_history" highlightImge:nil style:e_Nav_Gray fontsize:-1 andEvent:@selector(historyDataPressed:)];
    [self showLeftButton:nil withImage:@"home_setting" highlightImge:nil style:e_Nav_Gray andEvent:@selector(gotoSetVcPressed:)];
}

- (void)loadView
{
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.view  = bgview;
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg.png"]]];
    UIImageView *imgViewtmp = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imgViewtmp setImage:[UIImage imageNamed:@"home_bg.png"]];
    [self.view addSubview:imgViewtmp];

    float viewHeight = self.height;
    
    float fWidth = 120;
    float fPicWidth = self.width;
    float fTop = 0;
    float fWSpace = (SCR_WIDTH - fWidth * 2) / 3;
    float fHeight = 44;
    if(OS_VERSION < 7.0)
    {
        viewHeight -= self.navBarHeight;
        viewHeight -= 20;
        fPicWidth = fPicWidth - 80;
    }
    else
    {
        if(self.height < 500)
        {
            fPicWidth = fPicWidth - 80;
        }
        fTop = self.navBarHeight;
    }
    
    fTop += 2;
    UIImage *bgImage = [UIImage imageNamed:@"plank1"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - fPicWidth) / 2, fTop, fPicWidth, fPicWidth)];
    [bgImageView setImage:bgImage];
    [self.view addSubview:bgImageView];
    fTop += fPicWidth;
    UIButton *btnExample = [[UIButton alloc] initWithFrame:bgImageView.frame];
    [btnExample addTarget:self action:@selector(examplePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnExample];
    
    float fbtnWidth = 80;
    
    
    CGRect prgsRct = CGRectMake(0, fTop + 10, self.width / 2 - fbtnWidth / 2 - 20, viewHeight - fTop - 20);
    compareview = [[CompareView alloc] initWithFrame:prgsRct];
    [self.view addSubview:compareview];
    
    UIImage *boyImge = [UIImage imageNamed:@"b"];
    UIButton *boygirlBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width / 2 + 30 , fTop, boyImge.size.width, boyImge.size.height)];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.width / 2 + 30 + boyImge.size.width , fTop + 10, 100, 30)];
    [lbl setTextColor:[UIColor whiteColor]];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:lbl];
    self.lblBoyOrGirl  = lbl;
    
    if([UserDefault isGirl])
    {
        [boygirlBtn setBackgroundImage:[UIImage imageNamed:@"g"] forState:UIControlStateNormal];
        [boygirlBtn setBackgroundImage:[UIImage imageNamed:@"g_hl"] forState:UIControlStateHighlighted];
        [self.lblBoyOrGirl setText:NSLocalizedString(@"I am Girl", nil)];
    }
    else
    {
        [boygirlBtn setBackgroundImage:[UIImage imageNamed:@"b"] forState:UIControlStateNormal];
        [boygirlBtn setBackgroundImage:[UIImage imageNamed:@"b_hl"] forState:UIControlStateHighlighted];
        [self.lblBoyOrGirl setText:NSLocalizedString(@"I am Boy", nil)];
    }
    [boygirlBtn addTarget:self action:@selector(boyOrGirlPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:boygirlBtn];
    self.boyOrGirlBtn = boygirlBtn;

    fTop += boyImge.size.height;
    fTop += 15.0;

    UIImage *switchImage = [UIImage imageNamed:@"switch_d"];
    UIImage *daojishiImage = [UIImage imageNamed:@"daojishi_hl"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(self.width / 2 + 30  , fTop, daojishiImage.size.width, daojishiImage.size.height)];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(zhengjishiPressed:) forControlEvents:UIControlEventTouchUpInside];
    _btnZhengJiShi = btn;
    
    _switchImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(_btnZhengJiShi.frame.origin.x + daojishiImage.size.width, fTop + daojishiImage.size.height - switchImage.size.height, switchImage.size.width, switchImage.size.height)];
    [_switchImageView setImage:switchImage];
    [self.view addSubview:_switchImageView];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(_switchImageView.frame.origin.x + switchImage.size.width, fTop, daojishiImage.size.width, daojishiImage.size.height)];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(daojishiPressed:) forControlEvents:UIControlEventTouchUpInside];
    _btnDijiShi = btn;
    
    fTop += daojishiImage.size.height;
    fTop += 20;
    _textLayer = [CATextLayer layer];
    _textLayer.frame = CGRectMake(_switchImageView.frame.origin.x, fTop, 100, 20);
    _btnTextLayer = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnTextLayer setFrame:_textLayer.frame];
    [_btnTextLayer addTarget:self action:@selector(textLayerPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnTextLayer];

    [self.view.layer addSublayer:_textLayer];
    [self getDaojishiString];
    fTop += 20;
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.width / 2 + fbtnWidth / 2, fTop, 100, 40)];
    [lbl setTextColor:[UIColor blackColor]];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setText:NSLocalizedString(@"Click everywhere, there will be a surprise", nil)];
    [lbl setNumberOfLines:4];
    [lbl setFont:[UIFont italicSystemFontOfSize:10]];
    [self.view addSubview:lbl];
    
    if([UserDefault isZhengJishi])
    {
        [self zhengjishiPressed:nil];
    }
    else
    {
        [self daojishiPressed:nil];
    }
    
    fTop = viewHeight - fbtnWidth - 10;
    
    UIButton *btnStartBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.width - fbtnWidth) / 2, fTop, fbtnWidth, fbtnWidth)];
    [btnStartBtn setBackgroundImage:[UIImage imageNamed:@"centerbtn-hl"] forState:UIControlStateNormal];
    [btnStartBtn setBackgroundImage:[UIImage imageNamed:@"centerbtn"] forState:UIControlStateHighlighted];
    [btnStartBtn setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
    [btnStartBtn addTarget:self action:@selector(startPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnStartBtn];
}

- (void)getDaojishiString
{
    NSString *strFontRef = [UIFont boldSystemFontOfSize:12].fontName;
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)strFontRef, 10, nil);
    
    _textLayer.shadowColor = [UIColor redColor].CGColor;
    _textLayer.backgroundColor = [UIColor clearColor].CGColor;
    _textLayer.foregroundColor = [UIColor orangeColor].CGColor;
    _textLayer.shadowOffset = CGSizeMake(1, 1);
    _textLayer.alignmentMode = kCAAlignmentLeft;
    _textLayer.wrapped = true;
    _textLayer.shadowOpacity = 0.9;
    _textLayer.font = font;
    
    
    NSArray *array = [UserDefault getdaoJishiParamers];
    NSString *strRound = [array objectAtIndex:0];
    NSString *strSec = [array objectAtIndex:1];
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@R  %@S", strRound, strSec]];
    //把this的字体颜色变为红色
    [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)[UIColor blueColor].CGColor
                        range:NSMakeRange(0, strRound.length)];
 
    font = CTFontCreateWithName((__bridge CFStringRef)strFontRef, 20, nil);
    [attriString addAttribute:(NSString *)kCTFontAttributeName
                        value:(__bridge id)font
                        range:NSMakeRange(0, strRound.length)];
    //把is变为黄色
    [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)[UIColor blueColor].CGColor
                        range:NSMakeRange(strRound.length + 3, strSec.length)];
    
    font = CTFontCreateWithName((__bridge CFStringRef)strFontRef, 20, nil);
    [attriString addAttribute:(NSString *)kCTFontAttributeName
                        value:(__bridge id)font
                        range:NSMakeRange(strRound.length + 3, strSec.length)];
    //给this加上下划线，value可以在指定的枚举中选择
    [attriString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                        value:(id)[NSNumber numberWithInt:kCTUnderlineStyleDouble]
                        range:NSMakeRange(0, strRound.length + 3 + strSec.length)];
    _textLayer.string = attriString;
}

#pragma mark -- actionsheet event


#pragma mark -- event

- (void)daojishiPressed:(id)sender
{
    [UserDefault setZhengJishi:NO];
    _textLayer.hidden = NO;
    _btnTextLayer.enabled = YES;
    [_switchImageView setImage:[UIImage imageNamed:@"switch_d"]];
    [_btnDijiShi setImage:[UIImage imageNamed:@"daojishi_hl"] forState:UIControlStateNormal];
    [_btnDijiShi setImage:[UIImage imageNamed:@"daojishi"] forState:UIControlStateHighlighted];
    [_btnZhengJiShi setImage:[UIImage imageNamed:@"zhengjishi"] forState:UIControlStateNormal];
    [_btnZhengJiShi setImage:[UIImage imageNamed:@"zhengjishi_hl"] forState:UIControlStateHighlighted];
}

- (void)zhengjishiPressed:(id)sender
{
    [UserDefault setZhengJishi:YES];
    _textLayer.hidden = YES;
    _btnTextLayer.enabled = NO;
    [_switchImageView setImage:[UIImage imageNamed:@"switch_z"]];
    [_btnDijiShi setImage:[UIImage imageNamed:@"daojishi_hl"] forState:UIControlStateHighlighted];
    [_btnDijiShi setImage:[UIImage imageNamed:@"daojishi"] forState:UIControlStateNormal];
    [_btnZhengJiShi setImage:[UIImage imageNamed:@"zhengjishi"] forState:UIControlStateHighlighted];
    [_btnZhengJiShi setImage:[UIImage imageNamed:@"zhengjishi_hl"] forState:UIControlStateNormal];
}

- (void)textLayerPressed
{
    PickerViewController  *vc = [[PickerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    DEBUGLOG();
}

- (void)friendRankPressed:(id)sender
{
    FriendViewController *vc = [[FriendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoSetVcPressed:(id)sender
{
    SettingViewController *vc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)historyDataPressed:(id)sender
{
    HistoryViewController *vc = [[HistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)startPressed:(id)sender
{
    ClockViewController *vc = [[ClockViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)boyOrGirlPressed:(id)sender
{
    if([UserDefault isGirl])
    {
        [UserDefault setGirl:NO];
        [self.boyOrGirlBtn setBackgroundImage:[UIImage imageNamed:@"b"] forState:UIControlStateNormal];
        [self.boyOrGirlBtn setBackgroundImage:[UIImage imageNamed:@"b_hl"] forState:UIControlStateHighlighted];
        [self.lblBoyOrGirl setText:NSLocalizedString(@"I am Boy", nil)];
    }
    else
    {
        [UserDefault setGirl:YES];
        [self.boyOrGirlBtn setBackgroundImage:[UIImage imageNamed:@"g"] forState:UIControlStateNormal];
        [self.boyOrGirlBtn setBackgroundImage:[UIImage imageNamed:@"g_hl"] forState:UIControlStateHighlighted];
        [self.lblBoyOrGirl setText:NSLocalizedString(@"I am Girl", nil)];
    }
}

- (void)examplePressed:(id)sender
{
    ExampleViewController *vc = [[ExampleViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)rateUs
{
    { //评价计数
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        if(![userdefault objectForKey:@"system-version"])
        {
            NSString* strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            [userdefault setObject:strVersion forKey:@"system-version"];
            [userdefault setObject:[NSNumber numberWithInt:0] forKey:@"usetimes"];
            [userdefault synchronize];
        }
        float fVersion = [[userdefault objectForKey:@"system-version"] floatValue];
        NSNumber *nTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"usetimes"];
        int iTime = [nTime intValue];
        
        NSString* strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        float version = [strVersion floatValue];
        if(version == fVersion)
        {
            iTime ++;
            if(iTime == 10 || iTime == 20 || iTime == 30 || iTime == 40 || iTime == 50)
                //                if(iTime == 1 || iTime == 2 || iTime == 3 || iTime == 4 || iTime == 5)
                //                if (iTime > 2)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"Like it or not , please rate us!", nil)
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Cancle", nil)
                                                      otherButtonTitles:NSLocalizedString(@"Rate Us", nil), nil];
                [alert show];
            }
            [userdefault setObject:[NSNumber numberWithInt:iTime] forKey:@"usetimes"];
            [userdefault synchronize];
        }
        else if(version > fVersion)
        {
            [self removeRateUs];
        }
        else
        {
            [userdefault setObject:strVersion forKey:@"system-version"];
            [userdefault setObject:[NSNumber numberWithInt:0] forKey:@"usetimes"];
            [userdefault synchronize];
        }
    }
}

- (void)removeRateUs
{
    NSString* strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    float version = [strVersion floatValue];
    version += 0.01;
    strVersion = [NSString stringWithFormat:@"%f", version];
    [[NSUserDefaults standardUserDefaults] setObject:strVersion forKey:@"system-version"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"usetimes"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Rate Us", Nil)])
    {
        [self removeRateUs];
        NSString *strMyid = [NSString stringWithFormat:
                             @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", MYAPPID];
        if(OS_VERSION >= 7.0)
        {
            strMyid = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/zine/id%@?ls=1&mt=8", MYAPPID];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strMyid]];
    }
}
#pragma mark --- presentViewcontroller callback delegate
- (void)presentViewCtrDidCancel:(UIViewController *)seder
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)presentViewCtrDidFinish:(UIViewController *)seder
{
 
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
