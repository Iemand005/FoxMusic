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
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

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
    
    [self setTrackStore:[FMTrackStore loadSavedStore]];
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
            
            NSArray *urls = [panel URLs];
            
            for (NSURL *url in urls) {
                FMDTrackTableItem *track = [FMDTrackTableItem trackWithURL:url];
                [[self tracks] addObject:track];
                
            }
            [[self trackTable] reloadData];
            
        }
    }];
}

- (void)play:(id)sender
{
    FMTrack *track = [self.tracks objectAtIndex:0];
    
//    SystemSoundID soundId;
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)track.URL, &soundId);
//    
//    AudioServicesPlaySystemSound(soundId);

    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:track.URL error:&error];
    [player prepareToPlay];
    [player play];
}

- (void)generateWaveform:(id)sender
{
    FMWaveForm *waveform = [[FMWaveForm alloc] init];
    FMTrack *track = [self.tracks objectAtIndex:0];
    AVURLAsset *asset = [AVURLAsset assetWithURL:[track URL]];
    NSData *imageData = [waveform renderPNGAudioPictogramForAsset:asset];
    
    NSImage *image = [[NSImage alloc] initWithData:imageData];
    
    [[self imageView] setImage:image];
}


@end
