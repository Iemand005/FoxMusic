//
//  FMDAppDelegate.m
//  FoxMusicDesktop
//
//  Created by Lasse Lauwerys on 17/07/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import "FMDAppDelegate.h"
#import <CoreAudio/CoreAudio.h>
#import <CoreMedia/CoreMedia.h>

@implementation FMDAppDelegate
@synthesize spotifyClient;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
//    [self setSpotifyClient:[FMSpotifyClient spotifyClient]];
//    
//    NSError *error;
//    FMSpotifyDeviceAuthorizationInfo *authInfo = [spotifyClient refreshDeviceAuthorizationInfoWithError:error];
//    NSString *code = [authInfo userCode];
//    
//    [[self codeLabel] setValue:code];
    
}

- (void)openAudioFile:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:YES];
    [panel setAllowedFileTypes:@[@"mp3"]];
//    NSArray* imageTypes = [CM imageTypes];
//    [panel setAllowedFileTypes:imageTypes];
//    [panel setDirectoryURL:NSMusicDirectory];
    
//    NSInteger selected = [panel runModal];
    [panel beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            
            FMTrack *track = [FMTrack trackWithURL:[panel URL]];
            [[self tracks] addObject:track];
            [[self trackTable] reloadData];
        }
    }];
}



@end
