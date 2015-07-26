//
//  BBResult.h
//  iplank
//
//  Created by bob on 1/2/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BResult.h"


@interface BBResult : NSManagedObject

@property (nonatomic, retain) NSString * rid;
@property (nonatomic, retain) NSString * open_id;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * since_time;
@property (nonatomic, retain) NSString * created;
@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * inttime;
@property (nonatomic, retain) NSString * user_key;

+(id)createNew;
+(BBResult *)BBResultCreateWithBReuslt:(BResult *)bresult;
- (NSArray *)getYearDay;
- (NSArray *)getWeek;
- (NSArray *)getMooth;
- (NSArray *)getYear;
- (NSArray *)getYearDayHourMiniSec;
@end
