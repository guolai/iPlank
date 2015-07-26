//
//  PodLibViewController.m
//  iplank
//
//  Created by bob on 6/14/14.
//  Copyright (c) 2014 bob. All rights reserved.
//

#import "PodLibViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SettingCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MPMediaItem-Properties.h"
#import <AVFoundation/AVFoundation.h>
#import "BBPlayer.h"
#import "NSString+UUID.h"
#import "MobClick.h"

@interface PodLibViewController ()<UITableViewDataSource, UITableViewDelegate,MPMediaPickerControllerDelegate>
@property (nonatomic, strong) UITableView *tblView;
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end


// generic error handler from upcoming "Core Audio" book (thanks, Kevin!)
// if result is nonzero, prints error message and exits program.
static void CheckResult(OSStatus result, const char *operation)
{
	if (result == noErr) return;
	
	char errorString[20];
	// see if it appears to be a 4-char-code
	*(UInt32 *)(errorString + 1) = CFSwapInt32HostToBig(result);
	if (isprint(errorString[1]) && isprint(errorString[2]) && isprint(errorString[3]) && isprint(errorString[4])) {
		errorString[0] = errorString[5] = '\'';
		errorString[6] = '\0';
	} else
		// no, format it as an integer
		sprintf(errorString, "%d", (int)result);
	
	fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
	
	exit(1);
}


@implementation PodLibViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showBackButton:nil style:e_Nav_Green action:nil];
    [self showRigthButton:NSLocalizedString(@"Import", nil) withImage:nil highlightImge:nil style:e_Nav_Green fontsize:-1 andEvent:@selector(showPodLibrary)];
    self.arrayData = [NSMutableArray arrayWithCapacity:10];
    NSArray *array = [[BBPlayer shareInstance] podItems];
    if(array && array.count > 0)
    {
        [self.arrayData addObjectsFromArray:array];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.audioPlayer stop];
}

- (void)loadView
{
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.view  = bgview;
    NSString *strBg = [NSString stringWithFormat:@"chat_bg_%.2d.jpg", (int)(arc4random() % 11)];
    //    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:strBg]]];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imgView setImage:[UIImage imageNamed:strBg]];
    [imgView setUserInteractionEnabled:YES];
    [self.view addSubview:imgView];
    
    float viewHeight = self.height;
    
    float fTop = 0;
    if(OS_VERSION < 7.0)
    {
        viewHeight -= self.navBarHeight;
        viewHeight -= 20;
    }
    else
    {
        viewHeight -= self.navBarHeight;
        fTop += self.navBarHeight;
    }
    self.tblView = [[UITableView alloc] initWithFrame:CGRectMake(5.0, fTop, self.width - 10.0f, viewHeight) style:UITableViewStyleGrouped];
    //    self.tblView.separatorStyle = UITableViewCellAccessoryNone;
    if(OS_VERSION  >= 7.0)
    {
        [self.tblView setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [self.tblView setBackgroundColor:[UIColor clearColor]];
        [self.tblView setBackgroundView:nil];
    }
    [self.view addSubview:self.tblView];
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    self.tblView.tableFooterView = [UIView new];
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerItem *playItem = [self.arrayData objectAtIndex:indexPath.row];
    
    static NSString *strCell = @"settextcell";
    
    SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if(!cell)
    {
        cell = [[SelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
    }
    if(playItem.bSelected)
    {
        cell.checkImg.hidden = NO;
    }
    else
    {
        cell.checkImg.hidden = YES;
    }
    cell.lblText.text = playItem.strTitle;
    DEBUGINFO(@"%@, %@, %@, %d", playItem.strTitle, playItem.strFileName, playItem.strUrl, playItem.bSelected);
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row >= self.arrayData.count)
        return;
    PlayerItem *song = [self.arrayData objectAtIndex:indexPath.row];
    if(song.bSelected)
    {
        NSString *strPath = [[BBPlayer shareInstance] podLibrary];
        strPath = [strPath stringByAppendingPathComponent:song.strFileName];
        [self.audioPlayer stop];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:strPath] error:nil];
        [self.audioPlayer play];
    }
    else
    {
        for (PlayerItem *temp in self.arrayData) {
            temp.bSelected = NO;
        }
        song.bSelected = YES;
        [[BBPlayer shareInstance] updateSelectdSong:song.strFileName];
        [self.tblView reloadData];
    }
   
}

#pragma mark - event

- (void)showPodLibrary
{
    MPMediaPickerController *pickerController =	[[MPMediaPickerController alloc]
												 initWithMediaTypes: MPMediaTypeMusic];
	pickerController.prompt = @"Choose song to import";
	pickerController.allowsPickingMultipleItems = NO;
	pickerController.delegate = self;
	[self presentViewController:pickerController animated:YES completion:NULL];
}

#pragma mark MPMediaPickerControllerDelegate
- (void)mediaPicker: (MPMediaPickerController *)mediaPicker
  didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
	[self dismissViewControllerAnimated:YES completion:NULL];
	if ([mediaItemCollection count] < 1) {
		return;
	}
    MPMediaItem *song = [[mediaItemCollection items] objectAtIndex:0];
    DEBUGINFO(@"%@,%@ %f, %@--%@", song.albumTitle,song.title, song.playbackDuration, song.albumArtist, song.debugDescription);
    DEBUGINFO(@"%d", mediaItemCollection.mediaTypes);
    NSError *error = nil;
    NSURL *url = [song valueForProperty:MPMediaItemPropertyAssetURL];
//    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//    DEBUGINFO(@"%@", error);
//    [player play];
    [self exportSongItem:song];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
	[self dismissViewControllerAnimated:YES completion:NULL];
}


-(void) exportSongItem:(MPMediaItem*) song
{
	// get the special URL
	if (! song) {
		return;
	}
	NSURL *assetURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
	AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    
	NSLog (@"Core Audio %@ directly open library URL %@",
		   [[BBPlayer shareInstance] coreAudioCanOpenURL:assetURL] ? @"can" : @"cannot",
		   assetURL);
	
	NSLog (@"compatible presets for songAsset: %@",
		   [AVAssetExportSession exportPresetsCompatibleWithAsset:songAsset]);
	
	
	/* approach 1: export just the song itself
	 */
	AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
									  initWithAsset: songAsset
									  presetName: AVAssetExportPresetAppleM4A];
	NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
	exporter.outputFileType = @"com.apple.m4a-audio";
    PlayerItem *plarItem = [[PlayerItem alloc] init];
    plarItem.strUrl = song.debugDescription;
    plarItem.strFileName = [NSString stringWithFormat:@"%lld.m4a", song.persistentID];
    plarItem.bSelected = YES;
    if(song.title)
    {
        plarItem.strTitle = song.title;
    }
    else
    {
       plarItem.strTitle = song.albumTitle;
    }
	NSString *exportFile = [[[BBPlayer shareInstance] podLibrary] stringByAppendingPathComponent:plarItem.strFileName];
	// end of approach 1
	
	/* approach 1.5: export just the song itself in a quicktime container
     AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
     initWithAsset: songAsset
     presetName: AVAssetExportPresetMediumQuality];
     NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
     
     // exporter.outputFileType = @"public.mpeg-4"; // nope - uncaught exception 'NSInvalidArgumentException', reason: 'Invalid output file type'
     exporter.outputFileType = @"com.apple.quicktime-movie";
     NSString *exportFile = [myDocumentsDirectory() stringByAppendingPathComponent: @"exported.mov"];
	 // end of approach 1.5
     */
	
	
	/* approach 2: create a movie with the song as a track, export that
     AVMutableComposition *composition = [AVMutableComposition composition];
     AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio
     preferredTrackID:kCMPersistentTrackID_Invalid];
     AVAssetTrack *songTrack = [songAsset compatibleTrackForCompositionTrack:compositionTrack];
     NSError *insertError = nil;
     [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, songAsset.duration)
     ofTrack:songTrack
     atTime:kCMTimeZero
     error:&insertError];
     if (insertError) {
     NSLog (@"Error inserting into compositionTrack: %@", insertError);
     return;
     }
     NSLog (@"Created composition");
     AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
     initWithAsset: composition
     presetName: AVAssetExportPresetMediumQuality];
     NSLog (@"output types: %@", [exporter supportedFileTypes]);
     exporter.outputFileType = @"com.apple.quicktime-movie";
     NSString *exportFile = [myDocumentsDirectory() stringByAppendingPathComponent: @"exported.mov"];
	 // end of approach 2
	 */
    
	// set up export (hang on to exportURL so convert to PCM can find it)
	exporter.outputURL = [NSURL fileURLWithPath:exportFile];
	
	// do the export
	[exporter exportAsynchronouslyWithCompletionHandler:^{
		int exportStatus = exporter.status;
		switch (exportStatus) {
			case AVAssetExportSessionStatusFailed: {
				// log error to text view
				NSError *exportError = exporter.error;
				NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
				NSString *strError = exportError ? [exportError description] : @"Unknown failure";
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showProgressHUDWithDetail:strError hideafterDelay:4.0];
                });
				break;
			}
			case AVAssetExportSessionStatusCompleted: {
				NSLog (@"AVAssetExportSessionStatusCompleted");
//				fileNameLabel.text = [exporter.outputURL lastPathComponent];
				// set up AVPlayer
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[BBPlayer shareInstance] addPlayerItemToFile:plarItem];
                    [self.arrayData addObject:plarItem];
                    [self.tblView reloadData];
                    [MobClick event:@"import"];
                    [self dismissProgressHUD];
                });
               
				break;
			}
			case AVAssetExportSessionStatusUnknown:
            {
                NSLog (@"AVAssetExportSessionStatusUnknown");
                [self dismissProgressHUD];
                break;
            }
			case AVAssetExportSessionStatusExporting:
            {
                NSLog (@"AVAssetExportSessionStatusExporting");
                [self dismissProgressHUD];
                break;
            }
			case AVAssetExportSessionStatusCancelled:
            {
                NSLog (@"AVAssetExportSessionStatusCancelled");
                [self dismissProgressHUD];
                break;
            }
			case AVAssetExportSessionStatusWaiting: {
                NSLog (@"AVAssetExportSessionStatusWaiting");
                [self dismissProgressHUD];
                break;
            }
			default:
            {
                NSLog (@"didn't get export status");
                [self dismissProgressHUD];
                break;
            }
		}
	}];
	[self showProgressHUD];
	NSTimer *progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
															  target:self
															selector:@selector (updateExportProgress:)
															userInfo:exporter
															 repeats:YES];
}

-(void) updateExportProgress: (NSTimer*) timer {
	AVAssetExportSession *exporter = [timer userInfo];
    NSString *strProgress = [NSString stringWithFormat:@"Progressed:%.1f/100", exporter.progress * 100];
    [self showProgressHUDWithStr:strProgress];
//	exportProgressView.progress = exporter.progress;
	// can we end?
	int exportStatus = exporter.status;
	// NSLog (@"updateProgress. status = %d, progress = %f", exportStatus, exporter.progress);
	if ((exportStatus == AVAssetExportSessionStatusCompleted) ||
		(exportStatus == AVAssetExportSessionStatusFailed) ||
		(exportStatus == AVAssetExportSessionStatusCancelled)) {
		NSLog (@"invaldating timer");
		[timer invalidate];
        [self dismissProgressHUD];
	}
}

@end
