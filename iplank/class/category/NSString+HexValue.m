//
//  NSString+HexValue.m
//  Zine
//
//  Created by user1 on 13-12-3.
//  Copyright (c) 2013年 aura marker stdio. All rights reserved.
//

#import "NSString+HexValue.h"

@implementation NSString (HexValue)
- (int) hexValue
{
	int n = 0;
	sscanf([self UTF8String], "%x", &n);
	return n;
}
@end
