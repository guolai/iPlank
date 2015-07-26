//
//  CoutView.m
//  iplank
//
//  Created by bob on 1/4/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "CoutView.h"
#import "UserDefault.h"
#import "DataModel.h"
#import "BBResult.h"
#import "CandleData.h"
#import "NSDate+String.h"

@interface CoutView ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
@end

@implementation CoutView
@synthesize countType = _countType;
@synthesize panGestureRecognizer;
@synthesize pinchGestureRecognizer;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        fTopSpace_ = 10.0f;
        fBottomSpace_ = 20.0f;
        fRulerWidth_ = 50;
        
        fContentWidth_ = self.frame.size.width - fRulerWidth_ ;
        fHeight_ = self.frame.size.height - fTopSpace_  - fBottomSpace_;
 
        bShowTips_ = NO;
        fRulerMax_ = 0;
        fCandleLeftSpace_ = 4.0f;
        scrInfo_ = [[ScrInfo alloc] init];
        
        _mulDic = [NSMutableDictionary dictionaryWithCapacity:10];
        _mulArray = [NSMutableArray arrayWithCapacity:10];

        [self setBackgroundColor:[UIColor colorWithRed:22.0f/255.0f green:22.0f/255.0f blue:22.0f/255.0f alpha:1.0f]];
    }
    return self;
}



- (void)setCountType:(T_Count)countType
{
    if(_countType != countType)
    {
        _countType = countType;
        [self initDataList];
    }
    [self setNeedsDisplay];
}

- (void)drawRuler
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGRect rct = CGRectMake(0, 0, fRulerWidth_, fTopSpace_ + fHeight_);
    CGContextSetRGBFillColor(context, 0.2f, 0.2f, 0.2f, 1.0f);
    CGContextFillRect(context, rct);
    
    float fYCha = fHeight_ / 4;
    float fRulerCha = scrInfo_.fMax / 4.0f;
    NSString *strRuler;
    
    int i = 0;
    int iTextSpace = 4;
    
    
    for (; i < 5; i++) {
        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
        if(i== 0 || i == 4)
        {
            CGContextMoveToPoint(context, 0.0, fTopSpace_ + i *fYCha);
            CGContextSetShouldAntialias(context, YES);
        }
        else
        {
            CGContextMoveToPoint(context, 10.0f, fTopSpace_ + i * fYCha);
            CGContextSetShouldAntialias(context, YES);
        }
        CGContextAddLineToPoint(context, self.frame.size.width, fTopSpace_ + i * fYCha);
        CGContextStrokePath(context);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        strRuler = [NSString stringWithFormat:@"%.1f", (float)(scrInfo_.fMax - i * fRulerCha)];
        UIFont *font = [UIFont systemFontOfSize:9.0f];
        CGSize size = [strRuler sizeWithFont:font];
      
        if(i == 4)
        {
            strRuler = @"0.0f";
            [strRuler drawInRect:CGRectMake(fRulerWidth_ - size.width - iTextSpace, fTopSpace_ + i * fYCha - size.height - 4, size.width, size.height) withFont:font];
        }
        else
        {
            [strRuler drawInRect:CGRectMake(fRulerWidth_ - size.width - iTextSpace, fTopSpace_ + i * fYCha, size.width, size.height) withFont:font];
        }
       
    }
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextMoveToPoint(context, fRulerWidth_, fTopSpace_);
    CGContextAddLineToPoint(context, fRulerWidth_, fHeight_ + fTopSpace_);
    CGContextMoveToPoint(context, self.frame.size.width - 3.0f, 0.0f);
    CGContextAddLineToPoint(context, self.frame.size.width - 3.0f, fHeight_ + fTopSpace_);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

-(void)drawCandle
{
    if(_mulArray.count < scrInfo_.iCurretIndex)
    {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    Candle *cle;
    UIFont *font = [UIFont systemFontOfSize:10];
    for (int i = 0; i < scrInfo_.iCurrentSumPnt; i ++) {
        if(i + scrInfo_.iCurretIndex >= _mulArray.count)
            break;
        NSString *strIndex = [_mulArray objectAtIndex:i + scrInfo_.iCurretIndex];
        cle = [_mulDic objectForKey:strIndex];
        float fx = fCandleLeftSpace_ + fRulerWidth_ + i * (scrInfo_.fPntMargin + scrInfo_.fPntWidth);
        float fy = fTopSpace_ + (scrInfo_.fMax - cle.fValue) * scrInfo_.fRatio;
        CGRect rct = CGRectMake(fx, fy, scrInfo_.fPntWidth,  cle.fValue * scrInfo_.fRatio);
        DEBUGINFO(@"candel value %f, date %@", cle.fValue, cle.strDate);
        DEBUGINFO(@"%@", NSStringFromCGRect(rct));
        fy += rct.size.height;
        CGRect dateRct = CGRectMake(fx - scrInfo_.fPntMargin / 2, fy, scrInfo_.fPntMargin + scrInfo_.fPntWidth, fBottomSpace_);
        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
        CGContextFillRect(context, rct);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        NSString *strDate = cle.strDate;
        [strDate drawInRect:dateRct withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    }
    CGContextRestoreGState(context);
}


- (void)drawRect:(CGRect)rect
{
    [self drawRuler];
    [self drawCandle];
}

#pragma mark -- initdata
- (void)initDataList
{
    [_mulArray removeAllObjects];
    [_mulDic removeAllObjects];
    NSArray *array = [BBResult where:[NSString stringWithFormat:@"user_key == '%@'", [UserDefault getUserKey]] startFrom:0 limit:-1 sortby:@"create_date^1"];
   // DEBUGINFO(@"%@", array.debugDescription);
    if(!array || array.count == 0)
    {
        return;
    }
    for (BBResult *bbresult  in array) {
        [self fetchSection:bbresult];
    }
    [self rebuildMenuData];
    [scrInfo_ resetScrInfo:fContentWidth_];
    if(scrInfo_.iMin < _mulArray.count  && scrInfo_.iMax > _mulArray.count)
    {
        scrInfo_.iMax = _mulArray.count;
    }
    scrInfo_.bPanValid = NO;
    [scrInfo_ logScrInfo];
    [self zoom:eZoomDefault];

    
    DEBUGINFO(@"scrinfo %f--%f", scrInfo_.fPntWidth, scrInfo_.fPntMargin);
    [scrInfo_ logScrInfo];
    if (_mulArray.count > scrInfo_.iCurrentSumPnt) {
        scrInfo_.iCurretIndex = _mulArray.count - scrInfo_.iCurrentSumPnt;
        if (!self.panGestureRecognizer) {
            self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
            self.panGestureRecognizer.minimumNumberOfTouches = 1;
            self.panGestureRecognizer.maximumNumberOfTouches = 1;
            [self addGestureRecognizer:self.panGestureRecognizer];
        }
        if(!self.pinchGestureRecognizer)
        {
            self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGestrue:)];
            [self addGestureRecognizer:self.pinchGestureRecognizer];
        }
    }
    else
    {
        scrInfo_.iCurretIndex = 0;
        if(self.panGestureRecognizer)
        {
            [self removeGestureRecognizer:self.panGestureRecognizer];
            self.panGestureRecognizer = nil;
        }
        if (self.pinchGestureRecognizer) {
            [self removeGestureRecognizer:self.pinchGestureRecognizer];
            self.pinchGestureRecognizer = nil;
        }
      
    }
  
    [self getMaxResultDataOfCurrentScreen];
}

- (void)getMaxResultDataOfCurrentScreen
{
//    for (int i = scrInfo_.iCurretIndex;  i < scrInfo_.iCurrentSumPnt && i < _mulArray.count; i++) {
      for (int i = 0;  i < _mulArray.count; i++) {
        NSString *strIndex = [_mulArray objectAtIndex:i];
        Candle *cle = [_mulDic objectForKey:strIndex];
        DEBUGINFO(@"candle value = %f, date %@", cle.fValue, cle.strDate);
        if(cle.fValue > scrInfo_.fMax)
            scrInfo_.fMax = cle.fValue;
    }
    float fCha = scrInfo_.fMax * 0.05;
    scrInfo_.fMax += fCha;
    scrInfo_.fRatio = fHeight_ / scrInfo_.fMax;
}

- (void)fetchSection:(BBResult *)bbresult
{
    NSArray *array = Nil;
    switch (_countType) {
           
        case e_Count_Times:
        {
            Candle *candel = [[Candle alloc] init];
            NSString *strIndex = [NSString stringWithFormat:@"%@", bbresult.since_time];
            NSString * strValue1 = [NSString stringWithFormat:@"%@", bbresult.inttime];
            NSString * strValue2 = [NSString stringWithFormat:@"%@", [strValue1 substringFromIndex:6]];
            candel.strDate = strValue2;
            [_mulDic setObject:candel forKey:strIndex];
            [candel.arrayData addObject:bbresult.duration];
            candel.fValue += [bbresult.duration floatValue];
            return;
        }
            break;
        case e_Count_Day:
        {
            array = [bbresult getYearDay];
        }
            break;
        case e_Count_Week:
        {
            array = [bbresult getWeek];
        }
            break;
        case e_Count_Month:
        {
            array = [bbresult getMooth];
        }
            break;
        case e_Count_Year:
        {
            array = [bbresult getYear];
        }
            break;
        default:
        {
            array = [bbresult getYearDay];
        }
            break;
    }
    NSString *strIndex = [array objectAtIndex:0];
    DEBUGINFO(@"%@,%@, %@",bbresult.inttime, strIndex, [array objectAtIndex:1]);
    Candle *candel = [_mulDic objectForKey:strIndex];
    if(!candel)
    {
        candel = [[Candle alloc] init];
        candel.strDate = [array objectAtIndex:1];
        [_mulDic setObject:candel forKey:strIndex];
    }
    [candel.arrayData addObject:bbresult.duration];
    candel.fValue += [bbresult.duration floatValue];
//    [_mulDic setObject:candel forKey:strIndex];
    
}

- (void)rebuildMenuData
{
    [_mulArray removeAllObjects];
    for (NSString *key in _mulDic.allKeys) {
        BOOL bFind = NO;
        int iKey = [key integerValue];
        for (int i = 0; i < _mulArray.count; i++) {
            NSString *strIndex = [_mulArray objectAtIndex:i];
            int iIndex = [strIndex integerValue];
            DEBUGINFO(@"%d, %d", iKey, iIndex);
            if(iKey > iIndex)
            {
                
            }
            else if(iKey < iIndex)
            {
                [_mulArray insertObject:key atIndex:i];
                bFind = YES;
                break;
            }
            else if(iKey == iIndex)
            {
                bFind = YES;
                break;
            }
        }
        if (!bFind) {
            [_mulArray addObject:key];
        }
    }
}

#pragma mark -- event

- (void)handleSwipeGesture:(UIPanGestureRecognizer *)sender
{
    DEBUGLOG();
    
    CGPoint touchPnt = [sender locationInView:self];
    float fx = touchPnt.x;
    if(fx <= fRulerWidth_)
    {
        
        scrInfo_.bPanValid = NO;
        return;
    }
    
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        scrInfo_.bPanValid = YES;
        scrInfo_.fPanPriPnt = fx;
        DEBUGINFO(@"UIGestureRecognizerStateBegan");
    }
    else if(sender.state == UIGestureRecognizerStateChanged)
    {
        if(scrInfo_.bPanValid)
        {
            float fcha = scrInfo_.fPanPriPnt - fx;
            int iIndex = fcha / scrInfo_.fPntMargin;
            // DEBUGINFO(@"juli %d", iIndex);
            if(iIndex == 0 || iIndex >= scrInfo_.iCurrentSumPnt || iIndex <= -scrInfo_.iCurrentSumPnt)
            {
                //scrInfo_.bPanValid = NO;
                return;
            }
            
            scrInfo_.iCurretIndex += iIndex;
            [self zoom:eZoomDefault];
            [scrInfo_ logScrInfo];
            scrInfo_.fPanPriPnt = fx;
            [self setNeedsDisplay];
        }
        DEBUGINFO(@"UIGestureRecognizerStateChanged");
    }
    else if(sender.state == UIGestureRecognizerStateEnded)
    {
        if(scrInfo_.bPanValid)
        {
            float fcha = scrInfo_.fPanPriPnt - fx;
            int iIndex = fcha / scrInfo_.fPntMargin;
            // DEBUGINFO(@"juli %d", iIndex);
            if(iIndex == 0 || iIndex >= scrInfo_.iCurrentSumPnt || iIndex <= -scrInfo_.iCurrentSumPnt)
            {
                //scrInfo_.bPanValid = NO;
                return;
            }
            
            scrInfo_.iCurretIndex += iIndex;
            [self zoom:eZoomDefault];
            [scrInfo_ logScrInfo];
            scrInfo_.fPanPriPnt = fx;
            [self setNeedsDisplay];
        }
        scrInfo_.bPanValid = NO;
    }
    
}


- (void)handlePinchGestrue:(UIPinchGestureRecognizer *)sender
{
    //DEBUGLOG();
    DEBUGINFO(@"sender.scale %f state is %d", sender.scale, sender.state);
    if(sender.state == UIGestureRecognizerStateBegan && scrInfo_.fPriPinchScale != 0.0f )
    {
        sender.scale = scrInfo_.fPriPinchScale;
    }
    else if(sender.state == UIGestureRecognizerStateEnded  )
    {
        scrInfo_.fPriPinchScale = sender.scale;
        scrInfo_.fPinchScale = sender.scale;
    }
    else
    {
        scrInfo_.fPinchScale = sender.scale;
        float fcha = scrInfo_.fPriPinchScale - scrInfo_.fPinchScale;
        DEBUGINFO(@"UIGestureRecognizerStateChanged %f", fcha);
        if(fabs(fcha) > 0.04f)
        {
            
            if(fcha > 0)
            {
                if([self zoom:eZoomIn])
                    [self setNeedsDisplay];
            }
            else
            {
                if([self zoom:eZoomOut])
                    [self setNeedsDisplay];
            }
        }
    }
    
    
    
    //    if(sender.state == UIGestureRecognizerStateBegan)
    //    {
    //        scrInfo_.fPinchScale = sender.scale;
    //    }
    //    else if(sender.state == UIGestureRecognizerStateEnded)
    //    {
    //        //scrInfo_.fPinchScale = sender.scale;
    //        float fcha = scrInfo_.fPinchScale - sender.scale;
    //       // DEBUGINFO(@"UIGestureRecognizerStateEnded %f", fcha);
    //        if(fabs(fcha) > 0.01f)
    //        {
    //            scrInfo_.fPinchScale = sender.scale;
    //            if(fcha > 0)
    //            {
    //                if([self zoom:eZoomIn])
    //                    [self setNeedsDisplay];
    //            }
    //            else
    //            {
    //                if([self zoom:eZoomOut])
    //                    [self setNeedsDisplay];
    //            }
    //
    //        }
    //    }
    //    else
    //    {
    //        //scrInfo_.fPinchScale = sender.scale;
    //        float fcha = scrInfo_.fPinchScale - sender.scale;
    //        DEBUGINFO(@"UIGestureRecognizerStateChanged %f", fcha);
    //        if(fabs(fcha) > 0.01f)
    //        {
    //            scrInfo_.fPinchScale = sender.scale;
    //            if(fcha > 0)
    //            {
    //                if([self zoom:eZoomIn])
    //                    [self setNeedsDisplay];
    //            }
    //            else
    //            {
    //                if([self zoom:eZoomOut])
    //                    [self setNeedsDisplay];
    //            }
    //        }
    //    }
}


- (BOOL)zoom:(EZoom)zoom
{
    int iTotal = 0;
    
    switch(zoom)
    {
        case eZoomIn:
        {
            if(scrInfo_.iMin >= _mulArray.count)
                return NO;
            if(scrInfo_.iCurrentSumPnt >= scrInfo_.iMax)
            {
                scrInfo_.iCurrentSumPnt = scrInfo_.iMax;
                return NO;
            }
            int iSumPntPri = scrInfo_.iCurrentSumPnt;
            int iIndexPri = scrInfo_.iCurretIndex;
            scrInfo_.iCurrentSumPnt += scrInfo_.iZoomStep * 2;
            scrInfo_.iCurretIndex -= scrInfo_.iZoomStep;
            if(scrInfo_.iCurrentSumPnt > scrInfo_.iMax)
            {
                int iCha = (scrInfo_.iMax - iSumPntPri) / 2;
                scrInfo_.iCurrentSumPnt = scrInfo_.iMax;
                scrInfo_.iCurretIndex = iIndexPri - iCha;
            }
            if(scrInfo_.iCurretIndex < 0)
                scrInfo_.iCurretIndex = 0;
            break;
        }
            
        case eZoomOut:
        {
            if(scrInfo_.iMax == scrInfo_.iMin)
                return NO;
            if(scrInfo_.iCurrentSumPnt <= scrInfo_.iMin)
            {
                //scrInfo_.iCurrentSumPnt = scrInfo_.iMin;
                return NO;
            }
            int iSumPntPri = scrInfo_.iCurrentSumPnt;
            int iIndexPri = scrInfo_.iCurretIndex;
            scrInfo_.iCurrentSumPnt -= scrInfo_.iZoomStep * 2;
            scrInfo_.iCurretIndex += scrInfo_.iZoomStep;
            if(scrInfo_.iCurrentSumPnt < scrInfo_.iMin)
            {
                int iCha = (iSumPntPri - scrInfo_.iMin) / 2;
                scrInfo_.iCurrentSumPnt = scrInfo_.iMin;
                scrInfo_.iCurretIndex = iIndexPri + iCha;
            }
            if(scrInfo_.iCurretIndex > _mulArray.count - scrInfo_.iMax)
            {
                scrInfo_.iCurretIndex = _mulArray.count - scrInfo_.iMax;
            }
            
            break;
        }
        case eZoomDefault:
        {
            if(scrInfo_.iCurrentSumPnt > scrInfo_.iMax)
            {
                if(_mulArray.count > scrInfo_.iMax)
                {
                    scrInfo_.iCurrentSumPnt = scrInfo_.iMax;
                    scrInfo_.iCurretIndex = _mulArray.count - scrInfo_.iCurrentSumPnt;
                }
                else
                {
                    scrInfo_.iCurrentSumPnt = _mulArray.count;
                    scrInfo_.iCurretIndex = 0;
                }
            }
            if(scrInfo_.iCurretIndex < 0)
            {
                scrInfo_.iCurretIndex = 0;
            }
            if(scrInfo_.iCurretIndex + scrInfo_.iCurrentSumPnt > _mulArray.count)
            {
                scrInfo_.iCurretIndex =  _mulArray.count - scrInfo_.iCurrentSumPnt;
            }
            break;
        }
        default:
        {
            break;
        }
    }
    if(scrInfo_.iCurrentSumPnt < scrInfo_.iMin)
        iTotal = scrInfo_.iMin;
    else
        iTotal = scrInfo_.iCurrentSumPnt;
    float fw = fContentWidth_ / iTotal;
    scrInfo_.fPntWidth = fw / 3 ;
    scrInfo_.fPntMargin = (fContentWidth_ - scrInfo_.fPntWidth  * iTotal) / iTotal ;
    if(_mulArray.count < scrInfo_.iCurrentSumPnt + scrInfo_.iCurretIndex)
    {
        return NO;
    }
    return YES;
}



@end
