//
//  BBUser.m
//  iplank
//
//  Created by bob on 1/2/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "BBUser.h"
#import "BUser.h"
#import "NSString+UUID.h"

@implementation BUser

@synthesize open_id;
@synthesize type;
@synthesize nick_name;
@synthesize gender;
@synthesize created;
@synthesize create_date;
@synthesize status;
@synthesize reserver;
@synthesize reserver2;
@synthesize key;
@synthesize avtar_url;
@synthesize avtar_path;

- (id)initWithBBUser:(BBUser *)bbuser
{
    if(self = [super init])
    {
        self.key = bbuser.key;
        self.open_id = bbuser.open_id;
        self.type = bbuser.type;
        self.nick_name = bbuser.nick_name;
        self.gender = bbuser.gender;
        self.created = bbuser.created;
        self.create_date = bbuser.create_date;
        self.status = bbuser.status;
        self.reserver = bbuser.reserver;
        self.reserver2 = bbuser.reserver2;
        self.avtar_path = bbuser.avtar_path;
        self.avtar_url = bbuser.avtar_url;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic
{
    return Nil;
}
- (id)updateWithDictionary:(NSDictionary *)dic
{
    return Nil;
}

@end
