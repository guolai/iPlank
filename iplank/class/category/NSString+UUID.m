//
//  NSString+UUID.m
//  Zine
//
//  Created by bob on 13-9-13.
//  Copyright (c) 2013年 user1. All rights reserved.
//

#import "NSString+UUID.h"



@implementation NSString (UUID)
+(NSString *)generateKey{
    CFUUIDRef identifier = CFUUIDCreate(NULL);
    
    NSString* identifierString = (NSString*)CFUUIDCreateString(NULL, identifier);
    CFRelease(identifier);
    
    NSString *str2=[identifierString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(identifierString);
    NSString *str3=[str2 lowercaseString];
    //DEBUGINFO(@"%@", str3);
    return str3;
}


@end
