//
//  FMSpotifyTrackTableViewController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyTrackTableViewController.h"

@implementation FMSpotifyTrackTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:@"openPlaylistSegue"]) {
        FMSpotifyPlaylistTableViewController *controller = segue.sourceViewController;
        FMSpotifyTrackArray *tracks = controller.selectedPlaylist.tracks;
        
        [[_appDelegate spotifyClient] continueArray:tracks withOnSuccess:^(FMSpotifyContinuableArray *newTracks){
            NSArray *items = newTracks.items.allObjects;
            for (FMSpotifyTrack *track in items) {
                NSLog(@"I GOT A TRACK BRO: %@", track.name);
            }
        } onError:^(NSError *error){
            [_appDelegate displayError:error];
        }];

    }
}

@end
