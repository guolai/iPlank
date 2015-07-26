//
//  PopupView.m
//  Zine
//
//  Created by bob on 5/15/14.
//  Copyright (c) 2014 aura marker stdio. All rights reserved.
//

#import "PopupView.h"
#import "UserDefault.h"

@implementation PopupView



- (instancetype)initWithFrame:(CGRect)frame withScore:(int)iValue;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        _bgView.alpha = 0.7f;
        [self addSubview:_bgView];
        
        UIImage *bgImg = [UIImage imageNamed:@"result"];
        float fShowAreaWidth = bgImg.size.width;
        float fShowAreaHeight = bgImg.size.height;
        float fLeftSpace = (frame.size.width - bgImg.size.width) / 2;
        
        _shareView = [[UIImageView alloc] initWithFrame:CGRectMake(fLeftSpace, self.frame.size.height - fShowAreaHeight, fShowAreaWidth, fShowAreaHeight)];
        [_shareView setImage:bgImg];
        [self addSubview:_shareView];
        [_shareView setUserInteractionEnabled:YES];
        
        float fTop = 20.0;
        NSString *strReult = NSLocalizedString(@"Result", nil);
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(60, fTop, 70, 20)];
        [lbl setText:strReult];
        [lbl  setTextAlignment:NSTextAlignmentCenter];
        [lbl setTextColor:[UIColor whiteColor]];
        [lbl setFont:[UIFont systemFontOfSize:16]];
        [_shareView addSubview:lbl];
        
        NSString *strRet = @"";
        if(iValue <= 60)
        {
            strRet = [NSString stringWithFormat:@"%ds", (int)iValue];
        }
        else if (iValue <= 3600)
        {
            if((int)iValue % 60)
            {
                strRet = [NSString stringWithFormat:@"%dm%ds", (int)(iValue / 60), (int)((int)iValue % 60)];
            }
            else
            {
                strRet = [NSString stringWithFormat:@"%dm", (int)(iValue / 60)];
            }
        }
        else
        {
            strRet = [NSString stringWithFormat:@"%ds", (int)iValue];
        }
//        fTop += 20;
        fTop += 30;
        
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, fTop, 150, 40)];
        [lbl setText:strRet];
        [lbl  setTextAlignment:NSTextAlignmentCenter];
        [lbl setTextColor:[UIColor redColor]];
        [lbl setFont:[UIFont systemFontOfSize:20]];
        [_shareView addSubview:lbl];
        
        if(iValue < 30)
        {
            strRet = NSLocalizedString(@"You are really weak burst!", nil);
        }
        else if(iValue < 180)
        {
            strRet = NSLocalizedString(@"Come On!", nil);
        }
        else
        {
            if([UserDefault isGirl])
            {
                strRet = NSLocalizedString(@"You truly are an amazing woman", nil);
            }
            else
            {
                strRet = NSLocalizedString(@"You truly are an amazing man", nil);
            }
            
        }
        
        fTop += 30;
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, fTop, 150, 60)];
        [lbl setText:strRet];
        [lbl  setTextAlignment:NSTextAlignmentCenter];
        [lbl setTextColor:[UIColor whiteColor]];
        [lbl setNumberOfLines:2];
        [lbl setFont:[UIFont systemFontOfSize:12]];
        [_shareView addSubview:lbl];
        fTop += 60;
        
        UIImage *btnImge = [UIImage imageNamed:@"btn_bg"];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn  setFrame:CGRectMake(fShowAreaWidth / 2 - 70, fTop, 64, 40)];
        [btn setBackgroundImage:btnImge forState:UIControlStateNormal];
        [btn setTitle:NSLocalizedString(@"Cancle", nil) forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn addTarget:self action:@selector(btnCanclePressed) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:btn];
        
        
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn  setFrame:CGRectMake(fShowAreaWidth / 2 + 6, fTop, 64, 40)];
        [btn setBackgroundImage:btnImge forState:UIControlStateNormal];
        [btn setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn addTarget:self action:@selector(btnPressed) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:btn];
        
        _shareView.center = CGPointMake(self.center.x, self.center.y);
    }
    return self;
}

- (void)btnCanclePressed
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(popupViewDidPressed:)])
    {
        [self.delegate popupViewDidPressed:e_Popup_Cancle];
    }
    [self fadeOut];
}

- (void)btnPressed
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(popupViewDidPressed:)])
    {
        [self.delegate popupViewDidPressed:e_Popup_Done];
    }
    [self fadeOut];
}

-(void) fadeOut
{
    _bgView.alpha = 0.f;
    _shareView.alpha = 0.0f;
    [self removeFromSuperview];
}


-(void) fadeIn
{
    [UIView animateWithDuration:0.2f animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        _bgView.alpha = .6f;
        _shareView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint pt = [touch locationInView:self];
//    if (!CGRectContainsPoint([_shareView frame], pt)) {
//        if(self.delegate && [self.delegate respondsToSelector:@selector(popupViewDidPressed:)])
//        {
//            [self.delegate popupViewDidPressed:e_Popup_Cancle];
//        }
//        else
//        {
//            [self fadeOut];
//        }
//    }
//    
//}
@end
