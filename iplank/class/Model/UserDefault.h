//
//  UserDefault.h
//  iplank
//
//  Created by bob on 1/4/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefault : NSObject
+(NSString*)getUserKey;
+(void)setUserKey:(NSString *)number;

+ (BOOL)isGirl;
+ (void)setGirl:(BOOL)bValue;

+ (BOOL)isZhengJishi;
+ (void)setZhengJishi:(BOOL)bValue;

+ (NSArray *)getdaoJishiParamers;
+ (void)setDaoJiShiParamers:(NSArray *)array;

+ (BOOL)isShouldShowHomeAD;
+ (void)updateShowHomeADDate;

@end
