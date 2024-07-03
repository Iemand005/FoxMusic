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
    [self loadUserPlaylists];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadUserPlaylists];
}

- (void)loadUserPlaylists
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    FMSpotifyClient *spotifyClient = _appDelegate.spotifyClient;
    
    @try {
        NSError *error;
//        __block UITableView *tableView = [self tableView];
        [spotifyClient getUserPlaylistsAndWhenSuccess:^(FMSpotifyPlaylistArray *playlists){
            for (FMSpotifyPlaylist *playlist in playlists) {
                NSLog(@"title: %@, description: %@", playlist.name, playlist.description);
            }
            self.playlists = playlists;
            [[self tableView] reloadData];
            [self loadMorePlaylists];

            
        } whenError:^(NSError *error){
            if(error.code != 3840)[_appDelegate displayError:error];
        }];
        if (error) [_appDelegate displayError:error];
    } @catch (NSException *ex) {
        
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)loadMorePlaylists
{
    if ([[self playlists] hasNext]) [[_appDelegate spotifyClient] continueArray:[self playlists] withOnSuccess:^(FMSpotifyContinuableArray *playlists){
        [[self tableView] reloadData];
         [self loadMorePlaylists];
    } onError:^(NSError *error){
        [_appDelegate displayError:error];
    }];
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
@try {
    [cell.textLabel setText:playlist.name];
    [cell.detailTextLabel setText:playlist.description];
    }
    @catch (NSException *ex) {
        [cell.textLabel setText:@""];
        [cell.detailTextLabel setText:@"Error"];
    }
    return cell;
}

@end
