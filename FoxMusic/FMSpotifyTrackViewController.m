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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    FMSpotifyTrack *track = [_appDelegate selectedTrack];
    [self setTitle:track.name];
}

- (void)play:(id)sender
{
    [[_appDelegate spotifyClient] downloadTrack:self.track];
}

- (void)pause:(id)sender
{
    
}

@end
