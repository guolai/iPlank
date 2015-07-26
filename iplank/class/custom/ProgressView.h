//
//  ProgressView.h
//  bbzb
//
//  Created by bob on 13-8-8.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView
{
    CGFloat fPriProgress_;
    CGFloat fDestProgress_;
    NSTimer *updateTimer_;
}
@property(nonatomic, retain) UIColor *color;
@property(nonatomic, retain) UIColor *borderColor;
@property(nonatomic, assign) BOOL bVertical;
@property(nonatomic, assign) BOOL bStartFromNormal;
@property(nonatomic, assign) BOOL bShowLinear;
@property(nonatomic, assign) CGFloat fAnimDura;//animation duration

- (void)resetParasgram;
- (void)setProgress:(CGFloat)fProgrs animated:(BOOL)animated;

@end
