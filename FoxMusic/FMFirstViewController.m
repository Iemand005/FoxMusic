//
//  FMFirstViewController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMFirstViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface FMFirstViewController ()

@end

@implementation FMFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    MPM
    
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    
    MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
    
    NSLog(@"playing: %i", [[albumsQuery items] count]);
    
    MPMediaItem *item = [[albumsQuery items] lastObject];
    
    NSLog(@"player: %@", [item valueForProperty:MPMediaItemPropertyTitle]);
    
    MPMediaQuery *mediaQuery = [MPMediaQuery songsQuery];
    MPMediaItem *mediaItem = [[mediaQuery items] objectAtIndex:0];
    
    NSLog(@"song: %i", [mediaQuery items].count);
    NSLog(@"song title: %@", [mediaItem valueForProperty:MPMediaItemPropertyTitle]);
    
    [musicPlayer setQueueWithQuery:albumsQuery];
    [musicPlayer setNowPlayingItem:mediaItem];
    
    [musicPlayer play];
    
    [musicPlayer setVolume:1];
    
    NSString *title = [musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    
    NSLog(@"playing: %@", title);
    
    MPMediaLibrary *library = [MPMediaLibrary defaultMediaLibrary];
    
//    [MPMediaQuery ]
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
