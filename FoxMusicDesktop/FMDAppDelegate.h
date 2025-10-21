//
//  FMDAppDelegate.h
//  FoxMusicDesktop
//
//  Created by Lasse Lauwerys on 17/07/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FMTouch.h"

#import "FMDTrackTableView.h"

@interface FMDAppDelegate : NSObject <NSApplicationDelegate>
{
    
    FMSpotifyClient *_spotifyClient;
}

@property (strong) FMTrackStore *trackStore;

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, strong) FMSpotifyClient *spotifyClient;

@property (assign) IBOutlet NSTextFieldCell *codeLabel;

@property (assign) IBOutlet NSTableView *tableView;

@property (assign) IBOutlet NSMutableArray *tracks;

@property (assign) IBOutlet FMDTrackTableView *trackTable;

@property (assign) IBOutlet NSImageView *imageView;

- (IBAction)openAudioFile:(id)sender;

- (IBAction)play:(id)sender;

- (IBAction)generateWaveform:(id)sender;

@end
