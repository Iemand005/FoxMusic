//
//  FMSpotifyTrackViewController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//



#import "FMSpotifyTrackViewController.h"

@implementation FMSpotifyTrackViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    FMSpotifyTrack *track = [[self appDelegate] selectedTrack];
    [self setTrack:track];
    [self setTitle:[track name]];
    
    // Load album cover image safely
    @try {
        NSURL *imageURL = [[track album] imageURL];
        if (imageURL) {
            [[[self appDelegate] spotifyClient] getDataFromURL:imageURL withCallback:^(NSData *data){
                if (data && data.length > 0) {
                    UIImage *image = [UIImage imageWithData:data];
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self setAlbumCoverImage:image];
                            [[self albumCoverImageView] setImage:image];
                        });
                    }
                }
            }];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error loading album cover: %@", exception.reason);
        [[self appDelegate] displayException:exception];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    FMSpotifyTrack *track = [[self appDelegate] selectedTrack];
    [self setTitle:track.name];
}

- (void)play:(id)sender
{
    @try {
        // Validate track exists
        if (!self.track) {
            NSLog(@"No track selected for playback");
            return;
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        // Download track with proper error handling
        [[[self appDelegate] spotifyClient] downloadTrack:[self track] callback:^(NSData *musicData){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                @try {
                    // Validate audio data
                    if (!musicData || musicData.length == 0) {
                        NSLog(@"No audio data received");
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        return;
                    }
                    
                    NSError *error;
                    
                    // Setup audio session
                    AVAudioSession *session = [AVAudioSession sharedInstance];
                    [session setCategory:AVAudioSessionCategoryPlayback
                             withOptions:AVAudioSessionCategoryOptionDuckOthers|AVAudioSessionCategoryOptionAllowBluetooth
                                   error:&error];
                    if (error) {
                        NSLog(@"Audio session setup error: %@", error.localizedDescription);
                        [_appDelegate displayError:error];
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        return;
                    }
                    
                    // Begin receiving remote control events
                    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                    
                    // Setup now playing info safely
                    NSMutableDictionary *nowPlayingInfo = [NSMutableDictionary dictionary];
                    
                    if (self.albumCoverImage) {
                        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:self.albumCoverImage];
                        [nowPlayingInfo setObject:artwork forKey:MPMediaItemPropertyArtwork];
                    }
                    
                    NSString *title = self.track.name ?: @"Unknown Track";
                    [nowPlayingInfo setObject:title forKey:MPMediaItemPropertyTitle];
                    
                    NSString *albumTitle = _appDelegate.selectedPlaylist.name ?: self.track.album.name ?: @"Unknown Album";
                    [nowPlayingInfo setObject:albumTitle forKey:MPMediaItemPropertyAlbumTitle];
                    
                    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nowPlayingInfo];
                    
                    // Create audio player with error handling
                    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:musicData error:&error];
                    if (error) {
                        NSLog(@"Audio player creation error: %@", error.localizedDescription);
                        [_appDelegate displayError:error];
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        return;
                    }
                    
                    // Set audio player and prepare
                    [[self appDelegate] setAudioPlayer:audioPlayer];
                    [audioPlayer prepareToPlay];
                    
                    // Activate audio session
                    [session setActive:YES error:&error];
                    if (error) {
                        NSLog(@"Audio session activation error: %@", error.localizedDescription);
                        [_appDelegate displayError:error];
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        return;
                    }
                    
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    [self play];
                    
                } @catch (NSException *exception) {
                    NSLog(@"Exception during audio playback setup: %@", exception.reason);
                    [[self appDelegate] displayException:exception];
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                }
            });
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception in play method: %@", exception.reason);
        [[self appDelegate] displayException:exception];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)play
{
    @try {
        AVAudioPlayer *audioPlayer = [[self appDelegate] audioPlayer];
        if (!audioPlayer) {
            NSLog(@"No audio player available");
            return;
        }
        
        // Update UI on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *items = [NSMutableArray arrayWithArray:[[self toolbar] items]];
            
            if (items.count > 2) {
                UIBarButtonItem *pauseButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pause:)];
                [pauseButtonItem setStyle:UIBarButtonItemStyleBordered];
                [items replaceObjectAtIndex:2 withObject:pauseButtonItem];
                [[self toolbar] setItems:items animated:YES];
            }
        });
        
        // Play audio
        BOOL success = [audioPlayer play];
        if (!success) {
            NSLog(@"Failed to start audio playback");
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Exception in play method: %@", exception.reason);
        [[self appDelegate] displayException:exception];
    }
}

- (void)pause
{
    @try {
        AVAudioPlayer *audioPlayer = [[self appDelegate] audioPlayer];
        if (audioPlayer) {
            [audioPlayer pause];
        }
        
        // Update UI on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *items = [NSMutableArray arrayWithArray:[[self toolbar] items]];
            
            if (items.count > 2) {
                UIBarButtonItem *playButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play:)];
                [playButtonItem setStyle:UIBarButtonItemStyleBordered];
                [items replaceObjectAtIndex:2 withObject:playButtonItem];
                [[self toolbar] setItems:items animated:YES];
            }
        });
        
    } @catch (NSException *exception) {
        NSLog(@"Exception in pause method: %@", exception.reason);
        [[self appDelegate] displayException:exception];
    }
}

- (void)pause:(id)sender
{
    [self pause];
}

- (void)rewind:(id)sender
{
    @try {
        AVAudioPlayer *audioPlayer = [[self appDelegate] audioPlayer];
        if (audioPlayer) {
            [audioPlayer setCurrentTime:0];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception in rewind method: %@", exception.reason);
        [[self appDelegate] displayException:exception];
    }
}

@end
