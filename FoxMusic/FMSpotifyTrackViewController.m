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
    
//    NSData *imageData = [NSData dataWithContentsOfURL:[[track album] imageURL]];
    
    [[_appDelegate spotifyClient] getDataFromURL:[[track album] imageURL] withCallback:^(NSData *data){
        NSString *blob = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        UIImage *image = [UIImage imageWithData:data];
        [self setAlbumCoverImage:image];
        [[self albumCoverImageView] setImage:image];
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    FMSpotifyTrack *track = [_appDelegate selectedTrack];
    [self setTitle:track.name];
}

- (void)play:(id)sender
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSData *musicData = [[_appDelegate spotifyClient] downloadTrack:self.track];
    NSError *error;
//    [AVAudioPlayer play]
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDuckOthers|AVAudioSessionCategoryOptionAllowBluetooth error:&error];
    if (error) [_appDelegate displayError:error];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[self albumCoverImage]];
    
    NSString *title = self.track.name;
    if (!title) title = @"unknown";
    NSString *albumTitle = _appDelegate.selectedPlaylist.name;
    if (!albumTitle) albumTitle = self.track.album.name;
    if (!albumTitle) albumTitle = @"unknown";
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:@{
                                   MPMediaItemPropertyArtwork: artwork,
                                     MPMediaItemPropertyTitle: title,
                                MPMediaItemPropertyAlbumTitle: albumTitle
     }];
    
    [_appDelegate setAudioPlayer:[[AVAudioPlayer alloc] initWithData:musicData error:&error]];
        if (error) [_appDelegate displayError:error];
    [session setActive:YES error:&error];
        if (error) [_appDelegate displayError:error];
//    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:musicData error:&error];
//    if (error) {
//        [_appDelegate displayError:error];
//    }
    [_appDelegate.audioPlayer prepareToPlay];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self play];
//    [[self playButtonItem] setStyle:UIBarButtonSystemItemPause];
}

- (void)play
{
    NSMutableArray *items = [NSMutableArray arrayWithArray:[[self toolbar] items]];
    
    UIBarButtonItem *pauseButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pause)];
    [pauseButtonItem setStyle:UIBarButtonItemStyleBordered];
    [items replaceObjectAtIndex:2 withObject:pauseButtonItem];
    [[self toolbar] setItems:items animated:YES];
    [_appDelegate.audioPlayer play];

}

- (void)pause
{
    [_appDelegate.audioPlayer pause];
    NSMutableArray *items = [NSMutableArray arrayWithArray:[[self toolbar] items]];
    
    UIBarButtonItem *playButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play)];
    [playButtonItem setStyle:UIBarButtonItemStyleBordered];
    [items replaceObjectAtIndex:2 withObject:playButtonItem];
    [[self toolbar] setItems:items animated:YES];
}

- (void)pause:(id)sender
{
    [self pause];
}

- (void)rewind:(id)sender
{
    [[_appDelegate audioPlayer] setCurrentTime:0];
}

@end
