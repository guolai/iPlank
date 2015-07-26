//
//  BBMisc.h
//  bbzb
//
//  Created by bob on 13-8-9.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBMisc : NSObject
+ (CGFloat)screenHeight;
+ (CGFloat)scrrenScaleSize;
+ (CGSize)scaledSizeFromSize:(CGSize)fromSize toSize:(CGSize)toSize;
+ (void) addRoundedRectToPath:(CGContextRef)context  inFrame:(CGRect)rect width:(float)ovalWidth height:(float)ovalHeight;
+ (void) fillRectWithLinearGradient:(CGContextRef)context inFrame:(CGRect)rect colors:(CGFloat *)colors numberofColors:(int)num locations:(CGFloat *)locations;

@end
