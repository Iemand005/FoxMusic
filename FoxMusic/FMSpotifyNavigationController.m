//
//  FMSpotifyPlaylistsViewController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 1/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyNavigationController.h"
#import "FMSpotifyPlaylistArray.h"

@implementation FMSpotifyNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)viewDidAppear:(BOOL)animated
{
    FMSpotifyClient *spotifyClient = self.appDelegate.spotifyClient;
    @try {
        NSError *error;
            [spotifyClient getUserPlaylistsAndWhenSuccess:^(FMSpotifyPlaylistArray *playlists){
                for (FMSpotifyPlaylist *playlist in playlists) {
                    NSLog(@"title: %@, description: %@", playlist.name, playlist.description);
                }
            } whenError:^(NSError *error){
                [self.appDelegate displayError:error];
            }];
        if (error) [self.appDelegate displayError:error];
        } @catch (NSException *ex) {
            
        }
}

@end
