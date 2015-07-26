//
//  DataModel.h
//  iplank
//
//  Created by bob on 1/4/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBUser.h"
#import "BBResult.h"

@interface DataModel : NSObject
+ (BOOL)isFirstIn;
+ (BBUser *)createUser;
+(BBUser *)getCurrentUserFromOpenId:(NSString *)strOpenid;
+(BBUser *)getCurrentUser;

+(BBResult *)saveResult:(float)iValue type:(T_Result)rtype;

+ (NSString *)getUserFolderPath;//获取用户的记录目录
+ (UIColor *)getPercentColor:(CGFloat)fvalue;
@end
