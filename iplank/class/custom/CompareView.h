//
//  CompareView.h
//  iplank
//
//  Created by bob on 5/8/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressView.h"


@interface CompareView : UIView
{
    float _fSpace;
    float _fBtmHeight;
    float _fHeigth;
    UILabel *_lblMax;
    UILabel *_lblAvg;
    ProgressView *_lastPrgrView;
    ProgressView *_nowPrgrView;
}

@property (nonatomic, assign) CGFloat fLast;
@property (nonatomic, assign) CGFloat fCur;
- (void)reDrawData;

@end
