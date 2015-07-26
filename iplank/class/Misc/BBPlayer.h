//
//  BBPlayer.h
//  iplank
//
//  Created by bob on 6/15/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerItem : NSObject<NSCoding>
@property (nonatomic, strong) NSString *strUrl;
@property (nonatomic, strong) NSString *strFileName;
@property (nonatomic, assign) BOOL bSelected;
@property (nonatomic, strong) NSString *strTitle;

@end


@interface BBPlayer : NSObject
@property (nonatomic, strong) PlayerItem *playItem;
+ (BBPlayer *)shareInstance;
- (NSString *)podLibrary;
- (void)updateSelectdSong:(NSString *)strFileName;
- (void)addPlayerItemToFile:(PlayerItem *)player;
- (BOOL)coreAudioCanOpenURL:(NSURL *)url;
- (NSArray *)podItems;
@end
