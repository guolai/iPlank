//
//  BBResult.m
//  iplank
//
//  Created by bob on 1/2/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "BBResult.h"
#import "BResult.h"
#import "BUser.h"
#import "NSString+UUID.h"
#import "NSDate+String.h"
#import "UserDefault.h"

@implementation BResult

@synthesize rid;
@synthesize open_id;
@synthesize duration;
@synthesize since_time;
@synthesize created;
@synthesize create_date;
@synthesize type;
@synthesize key;
@synthesize inttime;
@synthesize user_key;
-(id)initWithDictionary:(NSDictionary *)dic
{
    return Nil;
}

- (id)initWithBBResult:(BBResult *)bbresut
{
    if (self = [super init]) {
        self.key = bbresut.key;
        self.rid = bbresut.rid;
        self.open_id = bbresut.open_id;
        self.duration = bbresut.duration;
        self.since_time = bbresut.since_time;
        self.created = bbresut.created;
        self.create_date = bbresut.create_date;
        self.type = bbresut.type;
        self.inttime = bbresut.inttime;
        self.user_key = bbresut.user_key;
    }
    return self;
}

+ (instancetype)createNew
{
    BResult *bresult = [[BResult alloc] init];
    bresult.create_date = [NSDate date];
    bresult.key = [NSString generateKey];
    bresult.since_time = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    bresult.inttime = [NSNumber numberWithInt:[bresult.create_date getFloatNumOfYearMonthDay]];
    NSString *strUserkey = [UserDefault getUserKey];
    if(ISEMPTY(strUserkey))
    {
        NSAssert(false, @"user error");
    }
    bresult.user_key = strUserkey;
    
    return bresult;
}

@end
