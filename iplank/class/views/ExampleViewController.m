//
//  ExampleViewController.m
//  iplank
//
//  Created by bob on 6/11/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "ExampleViewController.h"
#import "SCGIFImageView.h"
#import "WebViewController.h"
#import "MobClick.h"

@interface ExampleViewController ()
{
    SCGIFImageView *_gifImageView;
    int _nCurIndex;
    NSArray *_array;
}

@end

@implementation ExampleViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [MobClick event:@"gifpressed"];
    [self showBackButton:nil style:e_Nav_Green action:nil];
    [self showTitle:NSLocalizedString(@"do it with me", nil) style:e_Nav_Green];
}


- (void)loadView
{
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.view  = bgview;
    NSString *strBg = [NSString stringWithFormat:@"chat_bg_%.2d.jpg", (int)(arc4random() % 11)];
    //    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:strBg]]];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imgView setImage:[UIImage imageNamed:strBg]];
    [imgView setUserInteractionEnabled:YES];
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
        fTop += self.navBarHeight;
    }
    
    fTop += 40;
    _array = @[@"01.gif", @"02.gif", @"03.gif", @"04.gif", @"05.gif", @"06.gif", @"07.gif", @"08.gif", @"09.gif", @"10.gif"];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn  setBackgroundColor:[UIColor lightGrayColor]];
    [btn  setFrame:CGRectMake((self.width - 100) / 2, fTop, 100, 40)];
    [btn setTitle:NSLocalizedString(@"See More", nil) forState:UIControlStateNormal];
    [btn  addTarget:self action:@selector(loadWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    fTop += 40;
    
    _gifImageView = [[SCGIFImageView alloc] initWithFrame:CGRectMake(0, fTop, self.width, self.width)];
    [_gifImageView setContentMode:UIViewContentModeScaleAspectFit];
    _nCurIndex = 0;
    [self setCurrentImage];

    [self.view addSubview:_gifImageView];
    
    UIPanGestureRecognizer  *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
    [self.view addGestureRecognizer:pan];
    [pan setMaximumNumberOfTouches:1];
    [pan setMinimumNumberOfTouches:1];
}


- (void)changeImage:(UIPanGestureRecognizer *)gesture
{
    static CGPoint lastTraslation;
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        lastTraslation = CGPointZero;
    }
    else if(gesture.state == UIGestureRecognizerStateChanged)
    {

     
    }
    else
    {
        CGPoint pnt = [gesture translationInView:self.view];
        DEBUGINFO(@"%@ %@", NSStringFromCGPoint(pnt), NSStringFromCGPoint(lastTraslation));
        if(roundf(fabsf((pnt.x - lastTraslation.x)) > roundf(fabs(pnt.y - lastTraslation.y))))
        {
            if(pnt.x - lastTraslation.x > 0)
            {
                _nCurIndex--;
            }
            else
            {
                _nCurIndex++;
            }
        }
        else
        {
            if(pnt.y - lastTraslation.y > 0)
            {
                _nCurIndex--;
            }
            else
            {
                _nCurIndex++;
            }
        }
        DEBUGINFO(@"%d", _nCurIndex);
        [self setCurrentImage];
        lastTraslation = CGPointZero;
    }
}

#pragma mark -- event
- (void)setCurrentImage
{
    if(_nCurIndex < 0)
    {
        _nCurIndex = 0;
        return;
    }
    if (_nCurIndex >= _array.count) {
        _nCurIndex = _array.count - 1;
        return;
    }
    NSString* filePath = [[NSBundle mainBundle] pathForResource:[_array objectAtIndex:_nCurIndex] ofType:nil];
    NSData* imageData = [NSData dataWithContentsOfFile:filePath];
    [_gifImageView setData:imageData];
}

- (void)loadWebView
{
    WebViewController *vc = [[WebViewController alloc] init];
    vc.webType = ewebHowToPlank;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
