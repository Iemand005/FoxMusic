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
    
//    [self loadUserPlaylists];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadUserPlaylists];
}

- (void)loadUserPlaylists
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    @try {
        NSError *error;
        [[self appDelegate].spotifyClient getUserPlaylistsAndWhenSuccess:^(FMSpotifyPlaylistArray *playlists){
            self.playlists = playlists;
            [[self tableView] reloadData];
            [self loadMorePlaylists];
        } whenError:^(NSError *error){
            [[self appDelegate] displayError:error];
        }];
        if (error) [[self appDelegate] displayError:error];
    } @catch (NSException *ex) {
        [[self appDelegate] displayException:ex];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)loadMorePlaylists
{
    @try {
        if (![[self playlists] isComplete] && [[self playlists] hasNext]) [[[self appDelegate] spotifyClient] continueArray:[self playlists] withOnSuccess:^(FMSpotifyContinuableArray *playlists){
            [self.playlists addItems:playlists];
            [[self tableView] reloadData];
             [self loadMorePlaylists];
        } onError:^(NSError *error){
            if(error.code != 3840)
                [[self appDelegate] displayError:error];
        }];
    } @catch (NSException *ex) {
        [[self appDelegate] displayException:ex];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger itemCount = self.playlists ? self.playlists.count : 0;
    NSLog(@"Loaded playlist count: %d", itemCount);
    return itemCount;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"oh bruh this one");
    
    NSUInteger selectedRowIndex = [[self tableView] indexPathForSelectedRow].row;
    FMSpotifyPlaylist *playlist = [[self playlists] itemAtIndex:selectedRowIndex];
    [[self appDelegate] setSelectedPlaylist:playlist];
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
