//
//  ClockViewController.m
//  iplank
//
//  Created by bob on 5/22/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "ClockViewController.h"
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
//#import "ShareViewController.h"
//#import "ShareWeibo.h"
#import "PickerViewController.h"
#import "AnimationHelper.h"
#import "BResult.h"
#import "BBPlayer.h"
#import "PopupView.h"
#import "MobClick.h"

typedef enum {
    e_SD_failed,
    e_SD_begin,
    e_SD_timeout,
} T_Sound_Type;

typedef enum {
    e_PlankState_Init,
    e_PlankState_Ready,
    e_PlankState_Stop,
    e_PlankState_Doing,
    e_PlankState_Pause
} T_PlankState;


@interface ClockViewController ()<BBPresentViewControlerDelegate, /*ShareToWeiboDelegate,*/ PopUpViewDelegate>
{
    T_PlankState _plankState;
    
    int _iLvl;
    UILabel *_lblReadyCount;
    UIView *_readyView;
    UIView *_countView;
    UILabel *_lblCount;
    UIView *_plankingView;
    UIImageView *_beautifaulGirlView;
    NSUInteger _nRound;
    NSUInteger _nSecond;
    NSUInteger _nRest;
    CGFloat _fCount;
    BOOL _bZhengjiShi;
}
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic, strong) NSTimer *updateGirlTimer;
@property (nonatomic, assign) double dStartTime;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioPlayer *helperPlayer;
@property (nonatomic, strong) BResult *bresult;
@property (nonatomic, assign) BOOL  bExit;

@end

@implementation ClockViewController
@synthesize audioPlayer;
@synthesize helperPlayer;
@synthesize bresult;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [super viewWillDisappear:animated];
    self.bExit = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *array = [UserDefault getdaoJishiParamers];
    _nRound = [[array objectAtIndex:0] integerValue];
    _nSecond = [[array objectAtIndex:1]  integerValue];
    _nRest = [[array objectAtIndex:2] integerValue];
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    _bZhengjiShi = [UserDefault isZhengJishi];
    if(_bZhengjiShi)
    {
        [self showTitle:NSLocalizedString(@"Plank", nil) style:e_Nav_Green];
    }
    else
    {
        [self showTitle:NSLocalizedString(@"Round 1", nil) style:e_Nav_Green];
    }
    
    _plankState = e_PlankState_Ready;
    _fCount = 3;
    _iLvl = 1;
    self.bresult = [BResult createNew];
    _lblReadyCount.text = [NSString stringWithFormat:@"%d", (int)_fCount];
    [self startPlayerHelper:e_SD_begin];
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCount) userInfo:nil repeats:YES];
 
}

- (void)loadView
{
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.view  = bgview;
    NSString *strBg = [NSString stringWithFormat:@"chat_bg_%.2d.jpg", (int)(arc4random() % 11)];
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:strBg]]];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imgView setImage:[UIImage imageNamed:strBg]];
    [self.view addSubview:imgView];
    
    float viewHeight = self.height;

    float fPicWidth = self.width;
    float fTop = 0;
    if(OS_VERSION < 7.0)
    {
        viewHeight -= self.navBarHeight;
        viewHeight -= 20;
        fPicWidth = fPicWidth - 80;
    }
    else
    {
        fTop = self.navBarHeight;
    }
    
    fTop += 20;
    
    _plankingView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_plankingView];
    _plankingView.hidden = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(plankViewPressed)];
    [_plankingView addGestureRecognizer:tap2];
    
    
    _readyView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_readyView];
    tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(plankViewPressed)];
    [_readyView addGestureRecognizer:tap2];
    
    _beautifaulGirlView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_beautifaulGirlView];
    _beautifaulGirlView.hidden = YES;
    _beautifaulGirlView.userInteractionEnabled = YES;
    [_beautifaulGirlView setContentMode:UIViewContentModeScaleAspectFit];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beautifulGirlPressed)];
    [_beautifaulGirlView addGestureRecognizer:tap];
    
    CGFloat fWidth = 200;
    
    _countView = [[UIView alloc] initWithFrame:CGRectMake((self.width - fWidth) / 2, fTop, fWidth, fWidth)];
    [_countView.layer setBorderColor:[UIColor whiteColor].CGColor];
    _countView.layer.borderWidth = 1.0;
    _countView.layer.cornerRadius = _countView.bounds.size.width / 2;
    _countView.clipsToBounds = YES;
    [_countView setBackgroundColor:[DataModel getPercentColor:0.0]];
    _countView.alpha = 0.8;
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, fWidth/4, fWidth, fWidth/2)];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl  setTextColor:[UIColor blackColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setFont:[UIFont boldSystemFontOfSize:fWidth/4]];
    [_countView addSubview:lbl];
    _lblCount = lbl;
    [_plankingView addSubview:_countView];
    

    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake((self.width - fWidth) / 2, fTop, fWidth, fWidth)];
    [circleView.layer setBorderColor:[UIColor whiteColor].CGColor];
    circleView.layer.borderWidth = 1.0;
    circleView.layer.cornerRadius = circleView.bounds.size.width / 2;
    circleView.clipsToBounds = YES;
    [circleView setBackgroundColor:[UIColor blackColor]];
    circleView.alpha = 0.8;
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, fWidth/4, fWidth, fWidth/2)];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setFont:[UIFont boldSystemFontOfSize:fWidth/2]];
    [lbl  setTextColor:[UIColor whiteColor]];
    _lblReadyCount = lbl;
    [circleView addSubview:lbl];
    [_readyView addSubview:circleView];
    
    fTop += fWidth;
    fTop += 40;
    fWidth = 60.0;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(self.width / 2 - fWidth / 2, fTop, fWidth, fWidth)];
    [btn  setBackgroundImage:[UIImage imageNamed:@"centerbtn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(stopPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [btn setTitle:NSLocalizedString(@"Stop", nil) forState:UIControlStateNormal];
    [_plankingView addSubview:btn];
    
    fTop += fWidth;
    fTop += 10;
    lbl = [[UILabel alloc] initWithFrame:CGRectMake((self.width - 200) / 2, fTop, 200, 20)];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setFont:[UIFont boldSystemFontOfSize:12]];
    [lbl  setTextColor:[UIColor redColor]];
    [lbl setText:NSLocalizedString(@"Tap the screen to have a surprise", nil)];
    [_plankingView addSubview:lbl];
    
//    CGFloat fSpace = 20;
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(self.width / 2 - fSpace - fWidth, fTop, fWidth, fWidth)];
//    [btn  setBackgroundImage:[UIImage imageNamed:@"centerbtn"] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(pausePressed:) forControlEvents:UIControlEventTouchUpInside];
//    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
//    [btn setTitle:@"Pause" forState:UIControlStateNormal];
//    [_plankingView addSubview:btn];
//    
//    btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(self.width / 2 +fSpace, fTop, fWidth, fWidth)];
//    [btn  setBackgroundImage:[UIImage imageNamed:@"centerbtn"] forState:UIControlStateNormal];
//    [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
//    [btn setTitle:@"Stop" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(stopPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [_plankingView addSubview:btn];
    
}

#pragma mark - event
- (void)pausePressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [btn setTitle:@"Resume" forState:UIControlStateNormal];
}

- (void)stopPressed:(id)sender
{
    [self.updateGirlTimer invalidate];
    [self.updateTimer invalidate];
    [self stopPlayerHelper];
    [self stopMusic];
    if(_plankState == e_PlankState_Stop)
    {
        
    }
    else
    {
        if(_bZhengjiShi)
        {
            double currentTime = CFAbsoluteTimeGetCurrent();
            double elapsedTime = currentTime - self.dStartTime;
            self.bresult.duration = [NSNumber numberWithFloat:elapsedTime];
        }
        else if(_plankState == e_PlankState_Doing)
        {
            double currentTime = CFAbsoluteTimeGetCurrent();
            double elapsedTime = currentTime - self.dStartTime;
            float fDuration = [self.bresult.duration floatValue];
            fDuration += elapsedTime;
            self.bresult.duration = [NSNumber numberWithFloat:fDuration];
        }
    }
    int iValue = [self.bresult.duration floatValue];
    PopupView *popview = [[PopupView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT_P) withScore:iValue];
    popview.delegate = self;
    [self.navigationController.view addSubview:popview];
    [popview fadeIn];
}


- (void)saveData
{
    if([self.bresult.duration floatValue] < 2)
    {
        return;
    }
    BBResult *bbresult = [BBResult BBResultCreateWithBReuslt:self.bresult];
    [bbresult save];
}

#pragma mark - timer
- (void)updateCount
{
    if(self.bExit)
    {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
    }
    if(_plankState == e_PlankState_Ready)
    {
        _fCount--;
        if(_fCount < 1)
        {
            [self.updateTimer invalidate];
            self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateCount) userInfo:nil repeats:YES];
            _plankState = e_PlankState_Doing;
            
            [self playMusic:_iLvl];
            self.dStartTime = CFAbsoluteTimeGetCurrent();
            [AnimationHelper animationEaseOut:self.view];
            _readyView.hidden = YES;
            _plankingView.hidden = NO;
            [_countView setBackgroundColor:[DataModel getPercentColor:(float)((float)_iLvl / (float)_nRound)]];
            _fCount = _nSecond;
            if(_bZhengjiShi)
            {
                 _lblCount.text = [NSString stringWithFormat:@"0.0"];
            }
            else
            {
                 _lblCount.text = [NSString stringWithFormat:@"%d.0", _nSecond];
            }
           
        
        }
        else
        {
          
            if(_fCount == 3)
            {
//                [self playSoundWithType:e_SD_ID3];
            }
            else if (_fCount == 2)
            {
//                [self playSoundWithType:e_SD_ID2];
            }
            else if(_fCount == 1)
            {
                
            }
            _lblReadyCount.text = [NSString stringWithFormat:@"%d", (int)_fCount];
        }
    }
    else if (_plankState == e_PlankState_Doing)
    {
        double currentTime = CFAbsoluteTimeGetCurrent();
        
        double elapsedTime = currentTime - self.dStartTime;
        if(_bZhengjiShi)
        {
             _lblCount.text = [NSString stringWithFormat:@"%.1f", elapsedTime];
        }
        else
        {
            double fDuration = _fCount - elapsedTime;
            if(fDuration < 0.01)
            {
                if(_iLvl >= _nRound)
                {
                    float fDuration = [self.bresult.duration floatValue];
                    fDuration += _nSecond;
                    self.bresult.duration = [NSNumber numberWithFloat:fDuration];
                    [self.updateTimer invalidate];
                    _plankState = e_PlankState_Stop;
                    
                    [self stopPressed:nil];
                }
                else
                {
                    _iLvl ++;
                    _plankState = e_PlankState_Ready;
                    float fDuration = [self.bresult.duration floatValue];
                    fDuration += _nSecond;
                    self.bresult.duration = [NSNumber numberWithFloat:fDuration];
                    [self.updateTimer invalidate];
                    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCount) userInfo:nil repeats:YES];
                    
                    [self startPlayerHelper:e_SD_begin];
                    [AnimationHelper animationEaseOut:self.view];
                    _readyView.hidden = NO;
                    _plankingView.hidden = YES;
                    _fCount = _nRest;
                    _lblReadyCount.text = [NSString stringWithFormat:@"%d", (int)_fCount];
                    NSString *strRound = [NSString stringWithFormat:NSLocalizedString(@"Round %d", nil), _iLvl];
                    [self showTitle:strRound style:e_Nav_Green];
                }
                return;
            }
            else if(fDuration - 5 < 1 && fDuration - 5 >0.01)
            {
                [self startPlayerHelper:e_SD_timeout];
            }
            _lblCount.text = [NSString stringWithFormat:@"%.1f", fDuration];
//            DEBUGINFO(@"%f", elapsedTime);
        }
      
    }
    else
    {
        [self.updateTimer invalidate];
    }
}


#pragma mark --- music
- (void)playMusic:(int)ivalue
{

    [self stopMusic];
    [self stopPlayerHelper];
    if ([[BBPlayer shareInstance] playItem]) {
        if(self.audioPlayer)
        {
            
        }
        else
        {
            NSString *strPath = [[BBPlayer shareInstance] podLibrary];
            strPath = [strPath stringByAppendingPathComponent:[[BBPlayer shareInstance] playItem].strFileName];
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:strPath] error:nil];
            //self.audioPlayer.volume = 1.0;
            [self.audioPlayer prepareToPlay];
            self.audioPlayer.numberOfLoops = -1;
        }
        [self.audioPlayer play];
        if (self.audioPlayer) {
            return;
        }
    }
    ivalue = ivalue % 4;
    ivalue += 1;
    NSString *strUrl = [[NSBundle mainBundle] resourcePath];
   if(ivalue == 1)
    {
        strUrl = [strUrl stringByAppendingPathComponent:@"sound1.mp3"];
    }
    else if(ivalue == 2)
    {
        strUrl = [strUrl stringByAppendingPathComponent:@"sound2.mp3"];
    }
    else if(ivalue == 3)
    {
        strUrl = [strUrl stringByAppendingPathComponent:@"sound3.mp3"];
    }
    else if(ivalue == 4)
    {
        strUrl = [strUrl stringByAppendingPathComponent:@"sound4.mp3"];
    }
    else
    {
        strUrl = [strUrl stringByAppendingPathComponent:@"sound1.mp3"];
    }
    
    DEBUGINFO(@"%@",strUrl);
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:strUrl] error:nil];
    //self.audioPlayer.volume = 1.0;
    [self.audioPlayer prepareToPlay];
    self.audioPlayer.numberOfLoops = -1;
    [self.audioPlayer play];
}

- (void)stopMusic
{
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}

- (void)stopPlayerHelper
{
    [self.helperPlayer stop];
    self.helperPlayer = nil;
}

- (void)startPlayerHelper:(T_Sound_Type)type
{
    [self stopPlayerHelper];
    [self stopMusic];
    NSString *strUrl = [[NSBundle mainBundle] resourcePath];
    switch (type) {
        case e_SD_begin:
        {
            strUrl = [strUrl stringByAppendingPathComponent:@"start_time.wav"];
        }
            break;
            case e_SD_failed:
        {
            
        }
            break;
            case e_SD_timeout:
        {
            strUrl = [strUrl stringByAppendingPathComponent:@"renpin.wav"];
        }
            break;
        default:
            break;
    }
    
    DEBUGINFO(@"%@",strUrl);
    self.helperPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:strUrl] error:nil];
    //self.audioPlayer.volume = 1.0;
    [self.helperPlayer prepareToPlay];
    self.helperPlayer.numberOfLoops = -1;
    [self.helperPlayer play];
    
}

#pragma mark - event
- (void)plankViewPressed
{
    [MobClick endEvent:@"meinv"];
    _beautifaulGirlView.hidden = NO;
    [self updateGirl];
    self.updateGirlTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(updateGirl) userInfo:nil repeats:YES];
    [self.updateGirlTimer fire];
}

- (void)beautifulGirlPressed
{
    [self.updateGirlTimer invalidate];
    _beautifaulGirlView.hidden = YES;
}

- (void)updateGirl
{
//    if([UserDefault isGirl])
    {
        NSString *strImage = [NSString stringWithFormat:@"%.2d.jpg", (int)(arc4random() % 8)];
        DEBUGINFO(@"%@", strImage);
        [_beautifaulGirlView setImage:[UIImage imageNamed:strImage]];
    }
//    else
//    {
//        NSString *strImage = [NSString stringWithFormat:@"pic%.2d.jpg", (int)(arc4random() % 30)];
//        DEBUGINFO(@"%@", strImage);
//        [_beautifaulGirlView setImage:[UIImage imageNamed:strImage]];
//    }
//    
}


#pragma mark -- popviewdelegate
- (void)popupViewDidPressed:(T_PopupEvent)event
{
    switch (event) {
        case e_Popup_Cancle:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case e_Popup_Done:
        {
            [self saveData];
            if(_bZhengjiShi)
            {
                [MobClick event:@"savedata" label:@"zhengjishi"];
            }
            else
            {
               [MobClick event:@"savedata" label:@"daojishi"];
            }
            if([UserDefault isGirl])
            {
                [MobClick event:@"boygirl" label:@"girl"];
            }
            else
            {
                [MobClick event:@"boygirl" label:@"boy"];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark --- share callback
- (void)shareCallBack:(NSString *)strMsg
{
    if(!self.view)
    {
        
    }
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:strMsg delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
    [alertview show];
    
    
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
