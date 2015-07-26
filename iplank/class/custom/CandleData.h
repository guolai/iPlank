//
//  CandleData.h
//  BPM-iphone
//
//  Created by zhu hb on 10/28/12.
//  Copyright (c) 2012 zhuhb. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Candle : NSObject
{
}
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, assign) float fValue;
@property (nonatomic, strong) NSString *strDate;
@end

@interface ScrInfo : NSObject
{
    float fMax_;

    int iMax_;
    int iMin_;
    
    int iCurrentIndex_;
    int iCurrentSumPnt_;
    
    int iZoomStep_;
    
    float fPntMargin_;
    float fPntWidth_;
    float fRatio_;
    
    float fPanPriPnt_;
    BOOL bPanValid_;
    
    float fPinchScale_;
    float fPriPinchScale_;
}
@property (nonatomic, assign) int iMax;
@property (nonatomic, assign) int iMin;

@property (nonatomic, assign) float fMax;

@property (nonatomic, assign) int iCurretIndex;
@property (nonatomic, assign) int iCurrentSumPnt;
@property (nonatomic, assign) int iZoomStep;
@property (nonatomic, assign) float fPntMargin;
@property (nonatomic, assign) float fPntWidth;
@property (nonatomic, assign) float fRatio;
@property (nonatomic, assign) float fPanPriPnt;
@property (nonatomic, assign) BOOL bPanValid;
@property (nonatomic, assign) float fPinchScale;
@property (nonatomic, assign) float fPriPinchScale;

- (void)resetScrInfo:(float)fWidth;
- (void)logScrInfo;
@end
