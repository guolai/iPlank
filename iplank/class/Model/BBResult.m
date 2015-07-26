//
//  BBResult.m
//  iplank
//
//  Created by bob on 1/2/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "BBResult.h"
#import "BBUser.h"
#import "NSString+UUID.h"
#import "NSDate+String.h"
#import "UserDefault.h"

@implementation BBResult

@dynamic rid;
@dynamic open_id;
@dynamic duration;
@dynamic since_time;
@dynamic created;
@dynamic create_date;
@dynamic type;
@dynamic user_key;

@dynamic key;
@dynamic inttime;

+(id)createNew
{
    BBResult *result = [BBResult create];
    result.create_date = [NSDate date];
    result.key = [NSString generateKey];
    result.since_time = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    result.inttime = [NSNumber numberWithInt:[result.create_date getFloatNumOfYearMonthDay]];
    NSString *strUserkey = [UserDefault getUserKey];
    if(ISEMPTY(strUserkey))
    {
        NSAssert(false, @"user error");
    }
    result.user_key = strUserkey;
    
    [result save];
    return result;
}

+(BBResult *)BBResultCreateWithBReuslt:(BResult *)bresult
{
    BBResult *bbresult = [BBResult create];
    bbresult.rid = bresult.rid;
    bbresult.open_id = bresult.open_id;
    bbresult.duration = bresult.duration;
    bbresult.since_time = bresult.since_time;
    bbresult.create_date = bresult.create_date;
    bbresult.type = bresult.type;
    bbresult.user_key = bresult.user_key;
    bbresult.inttime = bresult.inttime;
    return bbresult;
}




- (NSArray *)getYearDay
{
    NSString * strValue1 = [NSString stringWithFormat:@"%@", self.inttime];
    NSString * strValue2 = [NSString stringWithFormat:@"%@", [strValue1 substringFromIndex:6]];
    return @[strValue1, strValue2];
}

- (NSArray *)getWeek
{
    NSString * strTemp = [NSString stringWithFormat:@"%@", self.inttime];
    NSString * strDay = [strTemp substringFromIndex:6];
    NSString *strMonth = [strTemp substringWithRange:NSMakeRange(4, 2)];
    int iDay = [strDay intValue];
    int iMonth = [strMonth intValue];
    int iValue = (iMonth - 1) * 4;
    if(iDay <= 7)
    {
        iValue += 1;
    }
    else if(iDay <= 14)
    {
        iValue += 2;
    }
    else if(iDay <= 21)
    {
        iValue += 3;
    }
    else
    {
        iValue += 4;
    }
    NSString *strValue1 = [NSString stringWithFormat:@"%@%.2d", [strTemp substringToIndex:4], iValue];
    NSString *strValue2 = [NSString stringWithFormat:@"%.2d", iValue];
    return @[strValue1, strValue2];
}

- (NSArray *)getMooth
{
    NSString * strTemp = [NSString stringWithFormat:@"%@", self.inttime];
    NSString *strValue1 = [NSString stringWithFormat:@"%@", [strTemp substringToIndex:6]];
    NSString *strValue2 = [strTemp substringWithRange:NSMakeRange(4, 2)];
    return @[strValue1, strValue2];
}

- (NSArray *)getYear
{
    NSString * strTemp = [NSString stringWithFormat:@"%@", self.inttime];
    NSString *strValue1 = [NSString stringWithFormat:@"%@", [strTemp substringToIndex:4]];
    NSString *strValue2 = [strTemp substringWithRange:NSMakeRange(2, 2)];
    return @[strValue1, strValue2];
}


@end
