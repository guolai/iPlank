//
//  UrlCache.m
//  iplank
//
//  Created by bob on 6/11/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "UrlCache.h"
#include <CommonCrypto/CommonDigest.h>


static NSString *cacheDirectory;
static NSSet *supportSchemes;



@implementation URLCache

@synthesize cachedResponses, responsesInfo;
@synthesize isReload;

static inline char hexChar(unsigned char c) {
    return c < 10 ? '0' + c : 'a' + c - 10;
}

static inline void hexString(unsigned char *from, char *to, NSUInteger length) {
    for (NSUInteger i = 0; i < length; ++i) {
        unsigned char c = from[i];
        unsigned char cHigh = c >> 4;
        unsigned char cLow = c & 0xf;
        to[2 * i] = hexChar(cHigh);
        to[2 * i + 1] = hexChar(cLow);
    }
    to[2 * length] = '\0';
}

NSString * md5(const char *string) {
    static const NSUInteger LENGTH = 16;
    unsigned char result[LENGTH];
    CC_MD5(string, (CC_LONG)strlen(string), result);
    
    char hexResult[2 * LENGTH + 1];
    hexString(result, hexResult, LENGTH);
    
    return [NSString stringWithUTF8String:hexResult];
}

NSString * sha1(const char *string) {
    static const NSUInteger LENGTH = 20;
    unsigned char result[LENGTH];
    CC_SHA1(string, (CC_LONG)strlen(string), result);
    
    char hexResult[2 * LENGTH + 1];
    hexString(result, hexResult, LENGTH);
    
    return [NSString stringWithUTF8String:hexResult];
}




+ (void)initialize {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    cacheDirectory = [paths objectAtIndex:0];
    supportSchemes = [NSSet setWithObjects:@"http", @"https", nil];
    
}

-(NSString *)getFullUrlByRequest:(NSURLRequest *)request {
    NSString *url = nil;
    if ([request.HTTPMethod compare:@"GET"]== NSOrderedSame) {
        url = [[request URL] absoluteString];
    }
    else if ([request.HTTPMethod compare:@"POST"]== NSOrderedSame){
        
        NSString *bodyStr = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        url = [NSString stringWithFormat:@"%@?%@",[[request URL] absoluteString],bodyStr];
        
        
    }
    return url;
    
}


- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    
    NSURL *url = request.URL;
    
    NSString *absoluteString = url.absoluteString;
    NSLog(@"%@", absoluteString);
    NSLog(@"httpmethord:%@",request.HTTPMethod);
    
    
    if ([request.HTTPMethod compare:@"GET"] != NSOrderedSame && [request.HTTPMethod compare:@"POST"] != NSOrderedSame ) {//
        return [super cachedResponseForRequest:request];
    }
    
    if (![supportSchemes containsObject:url.scheme]) {
        return [super cachedResponseForRequest:request];
    }
    //...
    
    //if is back or forward ,reload from cache
    NSString *fullURL = [self getFullUrlByRequest:request];
    NSCachedURLResponse *cachedResponse = [cachedResponses objectForKey:fullURL];
    //NSDictionary *responseInfo = [responsesInfo objectForKey:fullURL];
    NSLog(@"fullurl :%@",fullURL);
    if (isReload == NO) {
        NSLog(@"back or forward");
        
        
        if (cachedResponse ) {
            NSLog(@"cachedResponse cached: %@", absoluteString);
            return cachedResponse;
        }
        
        
        //        if (responseInfo ) {
        //            NSLog(@"responeInfo find");
        //            NSString *path = [cacheDirectory stringByAppendingString:[responseInfo objectForKey:@"filename"]];
        //            NSFileManager *fileManager = [[NSFileManager alloc] init];
        //            if ([fileManager fileExistsAtPath:path]) {
        //                [fileManager release];
        //
        //                NSData *data = [NSData dataWithContentsOfFile:path];
        //                NSURLResponse *response = [[NSURLResponse alloc] initWithURL:request.URL MIMEType:[responseInfo objectForKey:@"MIMEType"] expectedContentLength:data.length textEncodingName:[responseInfo objectForKey:@"textEncodingName"]];
        //                cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
        //                [response release];
        //
        //                [cachedResponses setObject:cachedResponse forKey:fullURL];
        //                [cachedResponse release];
        //                NSLog(@"file cached: %@", absoluteString);
        //                if (cachedResponse == nil) {
        //                    NSLog(@"cache nil");
        //                }
        //                return cachedResponse;
        //            }
        //            [fileManager release];
        //        }
        
    }
    
    NSLog(@"request from sever");
    NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:request.timeoutInterval];
    newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
    newRequest.HTTPShouldHandleCookies = request.HTTPShouldHandleCookies;
    newRequest.HTTPBody = request.HTTPBody;
    newRequest.HTTPMethod = request.HTTPMethod;
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:newRequest returningResponse:&response error:&error];
    if (error) {
        NSLog(@"%@", error);
        NSLog(@"not cached: %@", absoluteString);
        return nil;
    }
    
    //    NSString *filename = sha1([fullURL UTF8String]);
    //    NSString *path = [cacheDirectory stringByAppendingString:filename];
    //    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //    if ([fileManager fileExistsAtPath:path]){
    //        NSError *error;
    //        [fileManager removeItemAtPath:path error:&error];
    //    }
    //    NSLog(@"cache file:%@",path);
    //    [fileManager createFileAtPath:path contents:data attributes:nil];
    //    [fileManager release];
    
    NSURLResponse *newResponse = [[NSURLResponse alloc] initWithURL:response.URL MIMEType:response.MIMEType expectedContentLength:data.length textEncodingName:response.textEncodingName];
    //    responseInfo = [NSDictionary dictionaryWithObjectsAndKeys:filename, @"filename", newResponse.MIMEType, @"MIMEType",newResponse.textEncodingName,@"textEncodingName", nil];
    //    [responsesInfo setObject:responseInfo forKey:fullURL];
    NSLog(@"saved: %@", absoluteString);
    
    cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:newResponse data:data];

    
    [cachedResponses setObject:cachedResponse forKey:fullURL];

    return cachedResponse;
    
}

- (void)saveInfo {
    if ([responsesInfo count]) {
        NSString *path = [cacheDirectory stringByAppendingString:@"responsesInfo.plist"];
        [responsesInfo writeToFile:path atomically: YES];
    }
}



- (void)removeCachedResponseForRequest:(NSURLRequest *)request {
    NSLog(@"removeCachedResponseForRequest:%@", request.URL.absoluteString);
    NSString *fullURL = [self getFullUrlByRequest:request];
    
    [cachedResponses removeObjectForKey:fullURL];
    [super removeCachedResponseForRequest:request];
}

- (void)removeAllCachedResponses {
    NSLog(@"removeAllObjects");
    [cachedResponses removeAllObjects];
    [super removeAllCachedResponses];
}



- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path {
    if (self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path]) {
        cachedResponses = [[NSMutableDictionary alloc] init];
        NSString *path = [cacheDirectory stringByAppendingString:@"responsesInfo.plist"];
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if ([fileManager fileExistsAtPath:path]) {
            responsesInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        } else {
            responsesInfo = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

@end


