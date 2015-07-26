//
//  BBPlayer.m
//  iplank
//
//  Created by bob on 6/15/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "BBPlayer.h"
#import "FileManagerController.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation PlayerItem

@synthesize strFileName;
@synthesize strUrl;
@synthesize strTitle;
@synthesize bSelected;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.strFileName forKey:@"strFileName"];
    [aCoder encodeObject:self.strUrl forKey:@"strUrl"];
    [aCoder encodeObject:self.strTitle forKey:@"strTitle"];
    [aCoder encodeBool:self.bSelected forKey:@"bSelected"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.strFileName = [aDecoder decodeObjectForKey:@"strFileName"];
        self.strUrl = [aDecoder decodeObjectForKey:@"strUrl"];
        self.strTitle = [aDecoder decodeObjectForKey:@"strTitle"];
        self.bSelected = [aDecoder decodeBoolForKey:@"bSelected"];
    }
    return self;
}

@end





static BBPlayer *bbplayer;

@implementation BBPlayer

@synthesize playItem = _playItem;


+ (BBPlayer *)shareInstance
{
    static dispatch_once_t  once;
    dispatch_once(&once, ^{
        bbplayer = [[BBPlayer alloc] init];
    });
    return bbplayer;
}

- (NSString *)podLibrary
{
    NSString *strPath = [FileManagerController libraryPath];
    strPath = [strPath stringByAppendingPathComponent:@"podlibrary"];
    if(![FileManagerController fileExist:strPath])
    {
        [FileManagerController createDirectoryAtPath:strPath];
    }
    return strPath;
}

- (PlayerItem *)playItem
{
    if(!_playItem)
    {
        NSArray *array = [self podItems];
        for (PlayerItem *tem in array) {
            if (tem.bSelected) {
                _playItem = tem;
            }
        }
    }
    return _playItem;
}

- (NSArray *)podItems
{
    NSString *strPath = [self podFilePath];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:strPath];
    return array;
    
}

- (NSString *)podFilePath
{
    NSString *strPath = [self podLibrary];
    strPath = [strPath stringByAppendingPathComponent:@"pod.bin"];
    return strPath;
}

- (void)updateSelectdSong:(NSString *)strFileName
{
    NSArray *array = [self podItems];
    if(!array || [array isEqual:[NSNull null]])
    {
        return;
    }
    for (PlayerItem *song in array) {
        if([song.strFileName isEqualToString:strFileName])
        {
            song.bSelected = YES;
            self.playItem = song;
        }
        else
        {
            song.bSelected = NO;
        }
    }
    [NSKeyedArchiver archiveRootObject:array toFile:[self podFilePath]];
}

- (void)addPlayerItemToFile:(PlayerItem *)player
{
    NSArray *array = [self podItems];
    NSMutableArray *mulArray = [NSMutableArray arrayWithCapacity:4];
    if(!array || [array isEqual:[NSNull null]])
    {
        
    }
    else
    {
        for (PlayerItem *play in array) {
            play.bSelected = NO;
            [mulArray addObject:play];
        }
    }
    player.bSelected = YES;
    self.playItem = player;
    DEBUGINFO(@"%@, %@, %@, %d", player.strTitle, player.strFileName, player.strUrl, player.bSelected);
    [mulArray addObject:player];
    [NSKeyedArchiver archiveRootObject:mulArray toFile:[self podFilePath]];
}
- (BOOL)coreAudioCanOpenURL:(NSURL *)url
{
	OSStatus openErr = noErr;
	AudioFileID audioFile = NULL;
	openErr = AudioFileOpenURL((__bridge CFURLRef) url,
							   kAudioFileReadPermission ,
							   0,
							   &audioFile);
	if (audioFile) {
		AudioFileClose (audioFile);
	}
	return openErr ? NO : YES;
}

@end
