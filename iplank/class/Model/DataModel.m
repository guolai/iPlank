//
//  DataModel.m
//  iplank
//
//  Created by bob on 1/4/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "DataModel.h"
#import "FileManagerController.h"
#import "UserDefault.h"

@implementation DataModel
+ (BOOL)isFirstIn
{
    NSArray *array = [BBUser all];
    if(!array || array.count < 1)
        return YES;
    else
        return NO;
}


+(BBUser *)getCurrentUserFromOpenId:(NSString *)strOpenid
{
    BBUser *bbuser = nil;
    if(ISEMPTY(strOpenid))
    {
        NSAssert(false, @"error happen");
        return nil;
    }
    NSArray *userarray = [BBUser where:[NSString stringWithFormat:@"open_id == '%@'", strOpenid]];
    if(userarray && userarray.count > 0)
    {
        bbuser = userarray.first;
    }
    if(!bbuser)
    {
        bbuser = [self getCurrentUser];
        if(bbuser)
        {
            if(!ISEMPTY(bbuser.open_id) && [bbuser.open_id isEqualToString:strOpenid])
            {
                return bbuser;
            }
            else
            {
                bbuser.open_id = strOpenid;
                [bbuser save];
            }
        }
    }

    if(!bbuser)
    {
        bbuser = [self createUser];
        bbuser.open_id = strOpenid;
        [bbuser save];
    }
    [UserDefault setUserKey:bbuser.key];
    return bbuser;
}


+(BBUser *)getCurrentUser
{
    BBUser *bbuser = nil;
    if(![UserDefault getUserKey])
    {
        //NSAssert(false, @"error happen");
        return nil;
    }
    NSArray *userarray = [BBUser where:[NSString stringWithFormat:@"key == '%@'", [UserDefault getUserKey]]];
    if(userarray && userarray.count > 0)
    {
        bbuser = userarray.first;
    }
    if(!bbuser)
    {
        //NSAssert(false, @"error happen");
    }
    return bbuser;
}

+ (BBUser *)createUser
{
    BBUser *bbuser = [BBUser createNew];
    
    [UserDefault setUserKey:bbuser.key];
    [self createUserPathWithKey:bbuser.key];//为用户创建文件夹
    bbuser.avtar_path = [[FileManagerController resourcesPath] stringByAppendingPathComponent:@"profile_headimg@2x.png"];
    [bbuser save];
    return bbuser;
}

+(BBResult *)saveResult:(float)iValue type:(T_Result)rtype
{
    BBResult *result = [BBResult createNew];
    result.duration = [NSNumber numberWithFloat:iValue];
    result.type = [NSString stringWithFormat:@"%d", rtype];
    [result save];
    
    return result;
}

+ (NSString *)createUserPathWithKey:(NSString *)strKey
{
    NSString *strPath = [[FileManagerController libraryPath] stringByAppendingPathComponent:strKey];
    DEBUGINFO(@"%@", strPath);
    if(![FileManagerController createDirectoryAtPath:strPath])
    {
        DEBUGINFO(@"createFile failed!");
        //assert(false);
        return nil;
    }
    return strPath;
}

+ (NSString *)getUserFolderPath
{
    BBUser *bbuser = [self getCurrentUser];
    NSString *strFloder = [[FileManagerController libraryPath] stringByAppendingPathComponent:bbuser.key];
    if(![FileManagerController fileExist:strFloder])
    {
        [FileManagerController createDirectoryAtPath:strFloder];
    }
    return strFloder;
}

+ (UIColor *)getPercentColor:(CGFloat)fvalue
{
    UIColor *color = [UIColor redColor];
    if(fvalue < 1 / 7.0)
    {
        color = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    }
    else if (fvalue < 2/7.0)
    {
        color = [UIColor colorWithRed:228/255.0 green:264/255.0 blue:255/255.0 alpha:1.0];
    }
    else if (fvalue < 3/7.0)
    {
        color = [UIColor colorWithRed:128/255.0 green:200/255.0 blue:255/255.0 alpha:1.0];
    }
    else if (fvalue < 4/7.0)
    {
        color = [UIColor colorWithRed:180/255.0 green:225/255.0 blue:35/255.0 alpha:1.0];
    }
    else if (fvalue < 5/7.0)
    {
        color = [UIColor colorWithRed:245/255.0 green:230/255.0 blue:50/255.0 alpha:1.0];
    }
    else if (fvalue < 6/7.0)
    {
        color = [UIColor colorWithRed:255/255.0 green:190/255.0 blue:50/255.0 alpha:1.0];
    }
    else if (fvalue <= 7/7.0)
    {
        color = [UIColor colorWithRed:255/255.0 green:124/255.0 blue:125/255.0 alpha:1.0];
    }
    return color;
}

@end
