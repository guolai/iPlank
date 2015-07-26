//
//  NSString+UIColor.m
//  bbnote
//
//  Created by zhuhb on 13-6-2.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "NSString+UIColor.h"

@implementation NSString (UIColor)

- (UIColor *)getColorFromString
{
    UIColor *color = nil;
    if([self componentsSeparatedByString:@","].count == 4)
    {
        int iR = [[[self componentsSeparatedByString:@","] objectAtIndex:0] intValue];
        int iG = [[[self componentsSeparatedByString:@","] objectAtIndex:1] intValue];
        int iB = [[[self componentsSeparatedByString:@","] objectAtIndex:2] intValue];
        int iA = [[[self componentsSeparatedByString:@","] objectAtIndex:3] intValue];
        color = [UIColor colorWithRed:iR/255.0 green:iG/255.0 blue:iB/255.0 alpha:iA/255.0];
    }
    else
    {
//        assert(false);
    }

    return color;
}

- (UIColor *)getColorFromRGBA //rgba(26,20,20,1.0)
{
    if(self.length < 5)
    {
//        assert(false);
        return nil;
    }
    NSString *strColor = [self substringFromIndex:5];
    NSArray *array = [strColor componentsSeparatedByString:@","];
    NSAssert(array.count == 4, @"rgb color error");
    int iR = [[array objectAtIndex:0] intValue];
    int iG = [[array objectAtIndex:1] intValue];
    int iB = [[array objectAtIndex:2] intValue];
    UIColor * color = [UIColor colorWithRed:iR/255.0 green:iG/255.0 blue:iB/255.0 alpha:1.0];
    return color;
}

- (UIColor *)getColorFromHexString
{
    UIColor *color = [UIColor clearColor];
    int iR = 0, iG = 0, iB = 0;
    if(self.length != 7)
    {
        return color;
    }
    NSString *strValue = [self substringFromIndex:1];
    strValue = [strValue lowercaseString];
    NSData *data = [strValue dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[data bytes];
    if(data.length != 6)
    {
        return color;
    }
    for (int i = 0; i < 6; i++) {
        
        int *iRet = 0;
        if(i < 2)
        {
            iRet = &iR;
        }
        else if(i < 4)
        {
            iRet = &iG;
        }
        else
        {
            iRet = &iB;
        }
        int iResult = 0;
        if(bytes[i] >= '0' && bytes[i] <= '9')
        {
            iResult = bytes[i] - '0';
        }
        else if(bytes[i] >= 'a' && bytes[i] <= 'f')
        {
            iResult = bytes[i] - 'a' + 10;
        }
        if(i%2 == 0)
        {
            *iRet = iResult * 16 + *iRet;
        }
        else
        {
            *iRet = iResult + *iRet;
        }
    }
    DEBUGINFO(@"%d, %d, %d", iR, iG, iB);
    color = [UIColor colorWithRed:iR/255.0 green:iG/255.0 blue:iB/255.0 alpha:1.0];
    return color;
}



@end
