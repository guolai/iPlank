//
//  UrlCache.h
//  iplank
//
//  Created by bob on 6/11/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLCache : NSURLCache{
    NSMutableDictionary *cachedResponses;
    NSMutableDictionary *responsesInfo;
    
    BOOL isReload;
}

@property (nonatomic, retain) NSMutableDictionary *cachedResponses;
@property (nonatomic, retain) NSMutableDictionary *responsesInfo;
@property (nonatomic, readwrite) BOOL isReload;

- (void)saveInfo;

@end
