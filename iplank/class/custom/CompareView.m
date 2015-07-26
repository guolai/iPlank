//
//  CompareView.m
//  iplank
//
//  Created by bob on 5/8/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "CompareView.h"

@implementation CompareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.fCur = 0.0;
        self.fLast = 0.0;
        _fSpace = 40;
        _fBtmHeight = 20;
        _fHeigth = self.bounds.size.height - _fBtmHeight;
        float fWidth = self.bounds.size.width - _fSpace;
        UIFont *font = [UIFont systemFontOfSize:10];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, _fSpace, 12)];
        [lbl setTextColor:[UIColor blackColor]];
        [lbl setFont:font];
        [lbl setTextAlignment:NSTextAlignmentRight];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [self addSubview:lbl];
        _lblMax = lbl;
        
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 4 + _fHeigth / 2, _fSpace, 12)];
        [lbl setTextColor:[UIColor blackColor]];
        [lbl setFont:font];
        [lbl setTextAlignment:NSTextAlignmentRight];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [self addSubview:lbl];
        _lblAvg = lbl;
        
        font = [UIFont systemFontOfSize:10];
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(_fSpace , _fHeigth, fWidth / 2, 12)];
        [lbl setTextColor:[UIColor blueColor]];
        [lbl setFont:font];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setText:NSLocalizedString(@"Last", nil)];
        [self addSubview:lbl];
        
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(_fSpace + fWidth / 2, _fHeigth, fWidth / 2, 12)];
        [lbl setTextColor:[UIColor redColor]];
        [lbl setFont:font];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setText:NSLocalizedString(@"Now", nil)];
        [self addSubview:lbl];
        
        float fMargin = 10;
        float fPerWidth = fWidth - fMargin * 3;
        fPerWidth = fPerWidth / 2;
        
        CGRect prgsRct = CGRectMake(_fSpace + fMargin, 0, fPerWidth, _fHeigth);
        ProgressView *progressView = [[ProgressView alloc] initWithFrame:prgsRct];
        [progressView.layer setShadowColor:[UIColor grayColor].CGColor];
        [progressView.layer setShadowOffset:CGSizeMake(3, 3)];
        [progressView.layer setShadowOpacity: 0.7];
        [progressView.layer setShadowRadius: 3.0];
        progressView.bVertical = YES;
        progressView.bStartFromNormal = NO;
        progressView.color = [UIColor blueColor];
        progressView.bShowLinear = YES;
        [progressView setProgress:0.8 animated:YES];
        [self addSubview:progressView];
        _lastPrgrView = progressView;
        
        prgsRct = CGRectMake(_fSpace + fMargin * 2 + fPerWidth, 0, fPerWidth, _fHeigth);
        progressView = [[ProgressView alloc] initWithFrame:prgsRct];
        [progressView.layer setShadowColor:[UIColor grayColor].CGColor];
        [progressView.layer setShadowOffset:CGSizeMake(3, 3)];
        [progressView.layer setShadowOpacity: 0.7];
        [progressView.layer setShadowRadius: 3.0];
        progressView.bVertical = YES;
        progressView.bStartFromNormal = NO;
        progressView.color = [UIColor redColor];
        progressView.bShowLinear = YES;
        [progressView setProgress:0.8 animated:YES];
        [self addSubview:progressView];
        _nowPrgrView = progressView;
        [self reDrawData];
    }
    return self;
}



- (void)reDrawData
{
    if(self.fLast < 1e-3 && self.fCur < 1e-3)
    {
        [_lastPrgrView setProgress:0.05 animated:YES];
        [_nowPrgrView setProgress:0.05 animated:YES];
        _lblAvg.text = @"30s";
        _lblMax.text = @"60s";
    }
    else
    {
        int fMax = 0;
        if(self.fLast > self.fCur)
        {
            fMax = self.fLast;
        }
        else
        {
            fMax = self.fCur;
        }
        int iCount = fMax / 60;
        iCount += (fMax % 60 ? 1 : 0);
        fMax = iCount * 60;
        _lblAvg.text = [self getMeasureText:fMax / 2];
        _lblMax.text = [self getMeasureText:fMax];
        [_lastPrgrView setProgress:self.fLast / (float)fMax animated:YES];
        [_nowPrgrView setProgress:self.fCur / (float)fMax animated:YES];
    }
}

- (NSString *)getMeasureText:(CGFloat)fvalue
{
    NSString *strRet = @"";
    if(fvalue <= 60)
    {
        strRet = [NSString stringWithFormat:@"%ds", (int)fvalue];
    }
    else if (fvalue <= 3600)
    {
        if((int)fvalue % 60)
        {
            strRet = [NSString stringWithFormat:@"%dm%ds", (int)(fvalue / 60), (int)((int)fvalue % 60)];
        }
        else
        {
            strRet = [NSString stringWithFormat:@"%dm", (int)(fvalue / 60)];
        }
    }
    else
    {
        strRet = [NSString stringWithFormat:@"%dh%dm", (int)(fvalue / 3600), (int)((int)fvalue % 3600)% 60];
    }
    return strRet;
}

-(void)drawRect:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetRGBFillColor(context, 0.2f, 0.2f, 0.2f, 0.0f);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextMoveToPoint(context, _fSpace, 0);
    CGContextAddLineToPoint(context, _fSpace, _fHeigth);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, _fSpace, _fHeigth);
    CGContextAddLineToPoint(context, rect.size.width, _fHeigth);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, _fSpace / 4 * 3, 0);
    CGContextAddLineToPoint(context, _fSpace, 0);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, _fSpace / 4 * 3, _fHeigth / 2);
    CGContextAddLineToPoint(context, _fSpace, _fHeigth / 2);
    CGContextStrokePath(context);
   
    CGContextRestoreGState(context);
}


@end
