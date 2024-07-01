//
//  FMSpotifyPlaylistsViewController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 1/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyPlaylistsViewController.h"

@implementation FMSpotifyPlaylistsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)viewDidAppear:(BOOL)animated
{
    FMSpotifyClient *spotifyClient = appDelegate.spotifyClient;
    
    NSError *error;
    [spotifyClient getUserPlaylistsWithError:&error];
    [appDelegate displayError:error];
//    }
//    @catch (NSException *exception) {
//        [appDelegate displayException:exception];
//    }
}

@end
