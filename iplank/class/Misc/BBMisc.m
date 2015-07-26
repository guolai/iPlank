//
//  BBMisc.m
//  bbzb
//
//  Created by bob on 13-8-9.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "BBMisc.h"

@implementation BBMisc
+ (CGFloat)screenHeight
{
    static dispatch_once_t onceToken;
    static CGFloat screenHeight;
    dispatch_once(&onceToken, ^{
        screenHeight = [[UIScreen mainScreen] bounds].size.height;
    });
    return screenHeight;
}


+ (CGFloat)scrrenScaleSize
{
    CGFloat scale = 1.0;
    if([[UIScreen mainScreen]respondsToSelector:@selector(scale)])
    {
        CGFloat tmp = [[UIScreen mainScreen] scale];
        if (tmp > 1.5)
        {
            scale = 2.0;
        }
    }
    return scale;
}

+ (CGSize)scaledSizeFromSize:(CGSize)fromSize toSize:(CGSize)toSize
{
    CGFloat fHeight = fromSize.height;
    CGFloat fWidth = fromSize.width;
    if(fHeight > fWidth)
    {
        
        float fScale = fWidth / toSize.width;
        float iHeight = fHeight / fScale;
        return CGSizeMake(toSize.width, iHeight);
    }
    else
    {
        float fScale = fHeight / toSize.height;
        float iWidth = fWidth / fScale;
        return CGSizeMake(iWidth, toSize.height);
    }
}

+ (void) addRoundedRectToPath:(CGContextRef)context  inFrame:(CGRect)rect width:(float)ovalWidth height:(float)ovalHeight
{
	float fw, fh;
	// If the width or height of the corner oval is zero, then it reduces to a right angle,
	// so instead of a rounded rectangle we have an ordinary one.
	if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(context, rect);
		return;
	}
	
	//  Save the context's state so that the translate and scale can be undone with a call
	//  to CGContextRestoreGState.
	CGContextSaveGState(context);
	
	//  Translate the origin of the contex to the lower left corner of the rectangle.
	CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	
	//Normalize the scale of the context so that the width and height of the arcs are 1.0
	CGContextScaleCTM(context, ovalWidth, ovalHeight);
	
	// Calculate the width and height of the rectangle in the new coordinate system.
	fw = CGRectGetWidth(rect) / ovalWidth;
	fh = CGRectGetHeight(rect) / ovalHeight;
	
	// CGContextAddArcToPoint adds an arc of a circle to the context's path (creating the rounded
	// corners).  It also adds a line from the path's last point to the begining of the arc, making
	// the sides of the rectangle.
	CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
	CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
	CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
	CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
	CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
	
	// Close the path
	CGContextClosePath(context);
	
	// Restore the context's state. This removes the translation and scaling
	// but leaves the path, since the path is not part of the graphics state.
	CGContextRestoreGState(context);
}

+ (void) fillRectWithLinearGradient:(CGContextRef)context inFrame:(CGRect)rect colors:(CGFloat *)colors numberofColors:(int)num locations:(CGFloat *)locations
{
	CGContextSaveGState(context);
	
	if(!CGContextIsPathEmpty(context))
		CGContextClip(context);
	
	CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	CGPoint start = CGPointMake(0, 0);
	CGPoint end = CGPointMake(0, rect.size.height);
	
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, colors, locations, num);
	CGContextDrawLinearGradient(context, gradient, end, start, 0);
	CGContextRestoreGState(context);
	
	CGColorSpaceRelease(space);
	CGGradientRelease(gradient);
}

@end
