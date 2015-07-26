//
//  PickerViewController.m
//  iplank
//
//  Created by bob on 5/11/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "PickerViewController.h"
#import "TSLocateView.h"
#import "UserDefault.h"

@interface PickerViewController ()<UIActionSheetDelegate>
@property (nonatomic, strong) TSLocateView *pickerView;
@property (nonatomic, strong) UILabel *lblRound;
@property (nonatomic, strong) UILabel *lblSec;
@property (nonatomic, strong) UILabel *lblRest;

@end

@implementation PickerViewController
@synthesize pickerView;
@synthesize strRound = _strRound;
@synthesize strSec = _strSec;
@synthesize strRest = _strRest;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showTitle:NSLocalizedString(@"Countdown", nil) style:e_Nav_Green];
    [self showBackButton:nil style:e_Nav_Green action:nil];
  
}

- (void)loadView
{
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.view  = bgview;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg.png"]]];
    
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
        fTop = self.navBarHeight;
    }
    
    fTop += 20;
    CGFloat fFontsize = 40;
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.width / 2 - 100, fTop, 100, fFontsize)];
    UIFont *font = [UIFont boldSystemFontOfSize:fFontsize];
    [lbl setFont:font];
    [lbl setTextAlignment:NSTextAlignmentRight];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:[UIColor redColor]];
    [self.view addSubview:lbl];
    self.lblRound = lbl;
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.width / 2, fTop, 100, fFontsize)];
    [lbl setFont:font];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl  setText:@" 轮"];
    [lbl setTextColor:[UIColor redColor]];
    [self.view addSubview:lbl];
    
    fTop += fFontsize;
    fTop += 10;
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.width / 2 - 100, fTop, 100, fFontsize)];
    [lbl setFont:font];
    [lbl setTextAlignment:NSTextAlignmentRight];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:[UIColor purpleColor]];
    [self.view addSubview:lbl];
    self.lblSec = lbl;
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.width / 2, fTop, 100, fFontsize)];
    [lbl setFont:font];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:[UIColor purpleColor]];
    [lbl  setText:@" 秒"];
    [self.view addSubview:lbl];
    
    fTop += fFontsize;
    fTop += 10;
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.width / 2 - 100, fTop, 100, fFontsize)];
    [lbl setFont:font];
    [lbl setTextAlignment:NSTextAlignmentRight];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:[UIColor orangeColor]];
    [self.view addSubview:lbl];
    self.lblRest = lbl;
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.width / 2, fTop, 200, fFontsize)];
    [lbl setFont:font];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:[UIColor orangeColor]];
    [lbl  setText:@" 秒间隔"];
    [self.view addSubview:lbl];
    
    NSArray *array = [UserDefault getdaoJishiParamers];
    self.strRound = [array objectAtIndex:0];
    self.strSec = [array objectAtIndex:1];
    self.strRest = [array objectAtIndex:2];
    
    self.lblRound.text = self.strRound;
    self.lblSec.text = self.strSec;
    self.lblRest.text = self.strRest;
    TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:NSLocalizedString(@"Please select", nil) delegate:self];
    locateView.pickerVc = self;
    [locateView showInView:self.view];
    [locateView reloadPickerView];
}

- (void)setStrRest:(NSString *)strRest
{
    if(_strRest != strRest)
    {
        _strRest = strRest;
        _lblRest.text = strRest;
    }
}

- (void)setStrRound:(NSString *)strRound
{
    if(_strRound != strRound)
    {
        _strRound = strRound;
        _lblRound.text = strRound;
    }
}

- (void)setStrSec:(NSString *)strSec
{
    if(_strSec != strSec)
    {
        _strSec = strSec;
        _lblSec.text = strSec;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSArray *array = @[self.strRound, self.strSec, self.strRest];
    [UserDefault setDaoJiShiParamers:array];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
