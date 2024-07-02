//
//  FMSpotifyTrackViewController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//



#import "FMSpotifyTrackViewController.h"

@implementation FMSpotifyTrackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    FMSpotifyTrack *track = [_appDelegate selectedTrack];
    self.track = track;
    [self setTitle:track.name];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[[track album] imageURL]];
    
    [[self albumCoverImageView] setImage:[UIImage imageWithData:imageData]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    FMSpotifyTrack *track = [_appDelegate selectedTrack];
    [self setTitle:track.name];
}

- (void)play:(id)sender
{
    NSData *musicData = [[_appDelegate spotifyClient] downloadTrack:self.track];
    NSError *error;
//    [AVAudioPlayer play]
    [_appDelegate setAudioPlayer:[[AVAudioPlayer alloc] initWithData:musicData error:&error]];
//    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:musicData error:&error];
    if (error) {
        [_appDelegate displayError:error];
    }
    [_appDelegate.audioPlayer prepareToPlay];
    [_appDelegate.audioPlayer setVolume:1];
    [_appDelegate.audioPlayer play];
}

- (void)pause:(id)sender
{
    
}

@end
