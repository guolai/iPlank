//
//  WebViewController.m
//  iplank
//
//  Created by bob on 6/11/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "WebViewController.h"
#import "UrlCache.h"
//#import "MobClick.h"

@interface WebViewController ()<UIWebViewDelegate, UIScrollViewDelegate>
{
     UIWebView* _webView;
}
@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showBackButton:nil style:e_Nav_Green action:nil];
//    URLCache *sharedCache = [[URLCache alloc] initWithMemoryCapacity:1024 * 1024 diskCapacity:0 diskPath:nil];
//    [NSURLCache setSharedURLCache:sharedCache];
    
    NSString *strFrom = @"HowToPlank";
    NSString *strUrl = @"https://zine.la/article/5c69870a4a3c11e4898a00163e023006/";
    if(self.webType == ewebHowToPlank)
    {
        strUrl = @"https://zine.la/article/5c69870a4a3c11e4898a00163e023006/";
        strFrom = @"plank";
    }
    else if (self.webType == ewebWhyToPlank)
    {
        strUrl = @"https://zine.la/article/41236f884a3711e49f9900163e023006/";
        strFrom = @"WhyToPlank";
    }
    else if (self.webType == ewebGirl)
    {
        strUrl = @"https://zine.la/article/30d1e3dcaa5211e48b7100163e023006/";
        strFrom = @"Girl";
    }
    else if (self.webType == ewebDonate)
    {
        strUrl = @"https://zine.la/article/107ac0a0b91f11e4926400163e023006/";
        strFrom = @"Donate";
    }

//    [MobClick event:@"webbrower" label:strFrom];
    strUrl = [NSString stringWithFormat:@"%@?a=%d", strUrl, arc4random()%2000];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]]];
}


- (void)loadView
{
    CGRect rect = CGRectMake(0, 0, self.width, self.height);
    UIView* view = [[UIView alloc] initWithFrame:rect];
    self.view = view;
    
    CGRect webViewRect = rect;
    _webView = [[UIWebView alloc] initWithFrame:webViewRect];
    
    _webView.scrollView.contentInset = UIEdgeInsetsZero;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
    _webView.scrollView.showsHorizontalScrollIndicator = YES;
    [self.view  addSubview:_webView];
    

    
    // add shadow for scrollview, but only top-end have effect
    UIScrollView *scrollView = _webView.scrollView;
    [scrollView.layer setShadowColor:[UIColor grayColor].CGColor];
    [scrollView.layer setShadowOffset:CGSizeMake(2, -2)];
    [scrollView.layer setShadowOpacity: 0.7];
    [scrollView.layer setShadowRadius: 5.0];
    [scrollView.layer setShadowPath:[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, scrollView.bounds.size.width, scrollView.bounds.size.height/2)].CGPath];
    
}

@end
