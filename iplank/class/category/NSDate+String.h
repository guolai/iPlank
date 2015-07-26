//
//  NSDate+String.h
//  Zine
//
//  Created by bob on 9/21/13.
//  Copyright (c) 2013 user1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (String)
- (int) qzgetYear;
- (NSString *)qzgetYearDate;
- (NSString *)qzgetDateFormat;
- (NSString *)qzgetDateTime;
//for note
- (NSString *)qzGetDate; // 今天，昨天，前天，05/01
- (NSString *)qzGetWeek;  //周一，。。。
- (NSString *)qzGetTime; // 12:00
- (NSString *)getMonthDay;
- (NSString *)getNumOfMonthDay;//0725
- (NSString *)getNumOfYearMonth; //201307
- (int)getFloatNumOfYearMonthDay;



@end
