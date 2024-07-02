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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //id presentingViewController = self.presentingViewController;
//    if ([presentingViewController isKindOfClass:[FMSpotifyPlaylistTableViewController class]]) {
    
//        FMSpotifyPlaylistTableViewController *controller = presentingViewController;
        FMSpotifyTrackArray *tracks = _appDelegate .selectedPlaylist.tracks;
    
    self.playlist = [_appDelegate selectedPlaylist];
    
    [self setTitle:self.playlist.name];
//    [self set]
    
        [[_appDelegate spotifyClient] continueArray:tracks withOnSuccess:^(FMSpotifyContinuableArray *newTracks){
            NSArray *items = newTracks.items.allObjects;
            for (FMSpotifyTrack *track in items) {
                NSLog(@"I GOT A TRACK BRO: %@", track.name);
            }
            
            [[self tableView] reloadData];
        } onError:^(NSError *error){
            [_appDelegate displayError:error];
        }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    }
//    if ([presentingViewController isMemberOfClass:[UINavigationController class]]) {
//        NSLog(@"YES");
//    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playlist ? self.playlist.tracks.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trackCell" forIndexPath:indexPath];
    FMSpotifyTrack *playlist = [self.playlist.tracks itemAtIndex:indexPath.row];
    [cell.textLabel setText:playlist.name];
    [cell.detailTextLabel setText:@(playlist.duration).stringValue];
    
    return cell;
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    [super prepareForSegue:segue sender:sender];
//    if ([segue.identifier isEqualToString:@"openPlaylistSegue"]) {
//        FMSpotifyPlaylistTableViewController *controller = segue.sourceViewController;
//        FMSpotifyTrackArray *tracks = controller.selectedPlaylist.tracks;
//        
//        [[_appDelegate spotifyClient] continueArray:tracks withOnSuccess:^(FMSpotifyContinuableArray *newTracks){
//            NSArray *items = newTracks.items.allObjects;
//            for (FMSpotifyTrack *track in items) {
//                NSLog(@"I GOT A TRACK BRO: %@", track.name);
//            }
//        } onError:^(NSError *error){
//            [_appDelegate displayError:error];
//        }];
//    }
//}

@end
