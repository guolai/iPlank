//
//  NSNumber+Size.m
//  bbnote
//
//  Created by Apple on 13-6-9.
//  Copyright (c) 2013年 bob. All rights reserved.
//

#import "NSNumber+Size.h"

@implementation NSNumber (Size)
- (NSString *)getBytesSize
{
    NSString *strUnit = @"kb";
    double quotaSize = [self doubleValue];
    quotaSize = quotaSize / (1024);
    if(quotaSize > 1000)
    {
        strUnit = @"mb";
        quotaSize = quotaSize / 1024;
    }
    if(quotaSize > 1000)
    {
        strUnit = @"gb";
        quotaSize = quotaSize / 1024;
    }
    return [NSString stringWithFormat:@"%d%@", (int)quotaSize, strUnit];
}
@end
