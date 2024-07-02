//
//  FMSpotifyPlaylistController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyPlaylistTableViewController.h"

@implementation FMSpotifyPlaylistTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    FMSpotifyClient *spotifyClient = _appDelegate.spotifyClient;
    
    @try {
        NSError *error;
        [spotifyClient getUserPlaylistsAndWhenSuccess:^(FMSpotifyPlaylistArray *playlists){
            for (FMSpotifyPlaylist *playlist in playlists) {
                NSLog(@"title: %@, description: %@", playlist.name, playlist.description);
            }
            self.playlists = playlists;
            [[self tableView] reloadData];
        } whenError:^(NSError *error){
            [_appDelegate displayError:error];
        }];
        if (error) [_appDelegate displayError:error];
    } @catch (NSException *ex) {
        
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playlists ? self.playlists.count : 0;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"The user wants to see row at index %i", indexPath.row);
//    
//    FMSpotifyPlaylist *playlist = [self.playlists itemAtIndex:indexPath.row];
//    NSLog(@"Now need fetch: %@", playlist.tracks.href);
//    self.selectedPlaylist = playlist;
////    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
////    [cell ]
//    [self performSegueWithIdentifier:@"openPlaylistSegue" sender:self];
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"oh bruh this one");
    
    NSUInteger selectedRowIndex = [[self tableView] indexPathForSelectedRow].row;
    FMSpotifyPlaylist *playlist = [[self playlists] itemAtIndex:selectedRowIndex];
    [_appDelegate setSelectedPlaylist:playlist];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playlist" forIndexPath:indexPath];
    FMSpotifyPlaylist *playlist = [self.playlists itemAtIndex:indexPath.row];
    [cell.textLabel setText:playlist.name];
    [cell.detailTextLabel setText:playlist.description];
    
    return cell;
}

@end
