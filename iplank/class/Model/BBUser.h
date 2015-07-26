//
//  BBUser.h
//  iplank
//
//  Created by bob on 1/2/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BUser;
@interface BBUser : NSManagedObject

@property (nonatomic, retain) NSString * open_id;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * nick_name;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSNumber * created;
@property (nonatomic, retain) NSDate * create_date;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * reserver;
@property (nonatomic, retain) NSString * reserver2;

@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString * avtar_url;
@property (nonatomic, retain) NSString * avtar_path;
+(id)createNew;
+(BBUser *)BBUserCreateWithBUser:(BUser *)buser;
@end


