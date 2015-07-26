//
//  CandleData.m
//  BPM-iphone
//
//  Created by zhu hb on 10/28/12.
//  Copyright (c) 2012 zhuhb. All rights reserved.
//

#import "CandleData.h"

@implementation Candle
@synthesize arrayData;
@synthesize fValue;
@synthesize strDate;
- (id)init
{
    if(self = [super init])
    {
        self.arrayData = [NSMutableArray arrayWithCapacity:10];
        self.fValue = 0;
    }
    return self;
}
@end

@implementation ScrInfo
@synthesize iMax = iMax_;
@synthesize iMin = iMin_;

@synthesize fMax = fMax_;
@synthesize iCurretIndex = iCurrentIndex_;
@synthesize iCurrentSumPnt = iCurrentSumPnt_;
@synthesize iZoomStep = iZoomStep_;
@synthesize fPntMargin = fPntMargin_;
@synthesize fPntWidth = fPntWidth_;
@synthesize fRatio = fRatio_;
@synthesize fPanPriPnt = fPanPriPnt_;
@synthesize bPanValid = bPanValid_;
@synthesize fPinchScale = fPinchScale_;
@synthesize fPriPinchScale = fPriPinchScale_;

- (id)init
{
    if(self = [super init])
    {
        [self resetScrInfo:320.0f];
    }
    return self;
}


- (void)resetScrInfo:(float)fWidth
{
    
    self.fMax = 0;
    self.iCurrentSumPnt = 10;
    self.iMin = self.iCurrentSumPnt;
    self.iMax = self.iCurrentSumPnt * 2;
    self.iCurretIndex = 0;
    self.iZoomStep = 4;
    self.fPntWidth = 8.0f;
    self.fPntMargin = (fWidth - self.fPntWidth * self.iCurrentSumPnt) / self.iCurrentSumPnt;
    self.fRatio = 0.0f;
    self.fPanPriPnt = 0.0f;
    self.fPinchScale = 1.0f;
    self.fPriPinchScale = 0.0f;
    self.bPanValid = NO;
}

- (void)logScrInfo
{
    NSLog(@"sumpnt %d\n index %d\n pntwidth %f\n pnt margin %f\n", self.iCurrentSumPnt, self.iCurretIndex, self.fPntWidth, self.fPntMargin);
}

@end
