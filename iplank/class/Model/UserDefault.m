//
//  UserDefault.m
//  iplank
//
//  Created by bob on 1/4/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "UserDefault.h"
#import "NSDate+String.h"

@implementation UserDefault
+(NSString*)getUserKey
{
    NSString *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"userkey"];
    return number;
}


+(void)setUserKey:(NSString *)number
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:number forKey:@"userkey"];
    [userDefault synchronize];
}

+ (BOOL)isGirl
{
    BOOL bRet = NO;
    bRet = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isGirl"] boolValue];
    return bRet;
}
+ (void)setGirl:(BOOL)bValue
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithBool:bValue] forKey:@"isGirl"];
    [userDefault synchronize];
}

+ (BOOL)isZhengJishi
{
    BOOL bRet = NO;
    bRet = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isZhengJishi"] boolValue];
    return bRet;
}

+ (void)setZhengJishi:(BOOL)bValue
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithBool:bValue] forKey:@"isZhengJishi"];
    [userDefault synchronize];
}

+ (NSArray *)getdaoJishiParamers
{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"daoJishiParamers"];
    if(array.count != 3)
    {
        array = @[@"6", @"60", @"10"];
    }
    return array;
}

+ (void)setDaoJiShiParamers:(NSArray *)array
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:array forKey:@"daoJishiParamers"];
    [userDefault synchronize];
}

+ (BOOL)isShouldShowHomeAD //一天只显示一次在首页
{
    BOOL bRet = YES;
    int iOldData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"lastshowguanggao"] integerValue];
    if(iOldData > 0)
    {
        int iCurDate = [[NSDate date] getFloatNumOfYearMonthDay];
        if(iCurDate <= iOldData + 3)
        {
            bRet = NO;
        }
    }
    
    if(bRet)
    {
        [self updateShowHomeADDate];
    }
    return bRet;
}

+ (void)updateShowHomeADDate
{
    int iCurDate = [[NSDate date] getFloatNumOfYearMonthDay];
    [[NSUserDefaults standardUserDefaults] setInteger:iCurDate forKey:@"lastshowguanggao"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
