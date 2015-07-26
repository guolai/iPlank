//
//  CoutView.h
//  iplank
//
//  Created by bob on 1/4/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CandleData.h"

typedef enum {
    e_Count_Times = 4,
    e_Count_Day = 3,
    e_Count_Week = 2,
    e_Count_Month = 1,
    e_Count_Year = 0,
    e_Count_Max = 5
}T_Count;

typedef enum E_ZOOM_TYPE {
	eZoomOut = 0,
    eZoomIn = 1,
    eZoomDefault = 2
} EZoom;

@interface CoutView : UIView
{
    float fTopSpace_;
    float fBottomSpace_;
    float fRulerWidth_;
    float fContentWidth_;
    float fHeight_;
    float fCandleLeftSpace_;
//    NSMutableArray *arrayCandle_;
    float fRulerMax_;
    BOOL bShowTips_;
    
    ScrInfo *scrInfo_;
    NSMutableDictionary *_mulDic;
    NSMutableArray *_mulArray;
}
@property (nonatomic, assign)T_Count countType;
@end
