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
    FMSpotifyClient *spotifyClient = _appDelegate.spotifyClient;
    
    @try {
        NSError *error;
        [spotifyClient getUserPlaylistsAndWhenSuccess:^(FMSpotifyPlaylistArray *playlists){
            for (FMSpotifyPlaylist *playlist in playlists) {
                NSLog(@"title: %@, description: %@", playlist.name, playlist.description);
            }
            _playlists = playlists;
            [[self tableView] reloadData];
        } whenError:^(NSError *error){
            [_appDelegate displayError:error];
        }];
        if (error) [_appDelegate displayError:error];
    } @catch (NSException *ex) {
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _playlists ? _playlists.items.count : 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"The user wants to see row at index %@", indexPath);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playlist" forIndexPath:indexPath];
    FMSpotifyPlaylist *playlist = [_playlists itemAtIndex:indexPath.row];
    [cell.textLabel setText:playlist.name];
    [cell.detailTextLabel setText:playlist.description];
    
    return cell;
}

//- table

@end
