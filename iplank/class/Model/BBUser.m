//
//  BBUser.m
//  iplank
//
//  Created by bob on 1/2/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "BBUser.h"
#import "NSString+UUID.h"
#import "BUser.h"
#import "NSDate+String.h"

@implementation BBUser

@dynamic open_id;
@dynamic type;
@dynamic nick_name;
@dynamic gender;
@dynamic created;
@dynamic create_date;
@dynamic status;
@dynamic reserver;
@dynamic reserver2;

@dynamic key;
@dynamic avtar_path;
@dynamic avtar_url;

+(id)createNew
{
    BBUser *user = [BBUser create];
    user.create_date = [NSDate date];
    user.key = [NSString generateKey];
    [user save];
    return user;
}

+(BBUser *)BBUserCreateWithBUser:(BUser *)buser
{
    BBUser *bbuser = [BBUser create];
    bbuser.open_id = buser.open_id;
    bbuser.type = buser.type;
    bbuser.nick_name = buser.nick_name;
    bbuser.gender = buser.gender;
    bbuser.created = buser.created;
    bbuser.create_date = buser.create_date;
    bbuser.status = buser.status;
    bbuser.reserver = buser.reserver;
    bbuser.reserver2 = buser.reserver2;
    bbuser.avtar_path = buser.avtar_path;
    bbuser.avtar_url = buser.avtar_url;
    return bbuser;
}
@end
