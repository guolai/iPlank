//
//  ProgressView.m
//  bbzb
//
//  Created by bob on 13-8-8.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "ProgressView.h"
#import "BBMisc.h"

@implementation ProgressView
@synthesize color;
@synthesize borderColor, bVertical,fAnimDura, bStartFromNormal;

- (void)dealloc
{
    self.color = nil;
    self.borderColor = nil;
    [updateTimer_ invalidate];
    updateTimer_ = nil;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self resetParasgram];
    }
    return self;
}

- (void)resetParasgram
{
    fPriProgress_ = 0.0;
    fDestProgress_ = 0.0;
    self.bVertical = NO;
    self.bStartFromNormal = YES;
    self.fAnimDura = 0.1;
    self.color = [UIColor yellowColor];
    self.borderColor = [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:0.6];
    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGRect progressRct = rect;
    
    if(self.bVertical)
    {
        progressRct.size.height *= fPriProgress_;
    }
    else
    {
        progressRct.size.width *= fPriProgress_;
    }
    
    if(self.bStartFromNormal)
    {
        
    }
    else
    {
        progressRct.origin.x = rect.origin.x + rect.size.width - progressRct.size.width;
        progressRct.origin.y = rect.origin.y + rect.size.height - progressRct.size.height;
    }
    
    [BBMisc addRoundedRectToPath:context inFrame:progressRct width:4 height:4];
    CGContextClip(context);
    
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextFillRect(context, progressRct);
    
    progressRct.size.width -= 1.25;
    progressRct.origin.x += 0.625;
    progressRct.size.height -= 1.25;
    progressRct.origin.y += 0.625;
    
    [BBMisc addRoundedRectToPath:context inFrame:progressRct width:4 height:4];
    CGContextClip(context);
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, self.borderColor.CGColor);
    CGContextStrokeRect(context, progressRct);
    
    if(self.bShowLinear)
    {
        CGFloat colors[] =
        {
            255.0 / 255.0, 224.0 / 255.0, 244.0 / 255.0, 0.50,
            79.0 / 255.0, 79.0 / 255.0, 79.0 / 255.0, 0.50,
            255.0 / 255.0,  224.0 / 255.0, 0.0 / 255.0, 0.50,
        };
//		CGFloat colors[8] = {
//			1, 1, 1, 0.45,
//			1, 1, 1, 0.75
//		};
        [BBMisc fillRectWithLinearGradient:context inFrame:progressRct colors:colors numberofColors:2 locations:nil];
    }
    
    CGContextRestoreGState(context);
}
- (void)setProgress:(CGFloat)fProgrs animated:(BOOL)animated
{
    if(fProgrs > 1)
    {
        fProgrs = 1.0;
    }
//        assert(false);
    if(animated)
    {
        fDestProgress_ = fProgrs;
        fPriProgress_ = 0.001;
        if(updateTimer_)
        {
            [updateTimer_ invalidate];
            updateTimer_ = nil;
        }
        updateTimer_  = [NSTimer scheduledTimerWithTimeInterval:self.fAnimDura target:self selector:@selector(moveProgress) userInfo:nil repeats:YES];
    }
    else
    {
        fPriProgress_ = fDestProgress_ = fProgrs;
        [self setNeedsDisplay];
    }
}

- (void)moveProgress
{
    if(fPriProgress_ >= fDestProgress_)
    {
        fPriProgress_ = fDestProgress_;
        [updateTimer_ invalidate];
        updateTimer_ = nil;
    }
    else
    {
        fPriProgress_ = fPriProgress_ + (fDestProgress_ - fPriProgress_) / 5;
        if(fPriProgress_ > fDestProgress_)
            fPriProgress_ = fDestProgress_;
    }
    [self setNeedsDisplay];
}

@end
