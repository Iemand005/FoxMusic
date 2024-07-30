//
//  FMSearchDisplayController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 4/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSearchViewController.h"

@implementation FMSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appDelegate = [[UIApplication sharedApplication] delegate];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"This dood want u to search!!: %@", searchText);
//    [[_appDelegate spotifyClient] search:searchText withOnSuccess:^(FMSpotifyTrackArray *tracks){
//        [self setTracks:tracks];
//        [[self searchResultTableView] reloadData];
//    } onError:^(NSError *error){
//        [_appDelegate displayError:error];
//    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try {
        [super prepareForSegue:segue sender:sender];
        if ([segue.identifier isEqualToString:@"openSearchTrackResultSegue"]) {
            FMSpotifyTrack *track = [self.tracks itemAtIndex:[[self searchResultTableView] indexPathForSelectedRow].row];
            [_appDelegate setSelectedTrack:track];
        }
    } @catch (NSException *exception) {
        [_appDelegate displayException:exception];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self tracks] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"spotifyTrackSearchResult" forIndexPath:indexPath];
    [[cell textLabel] setText:@"Vratten und tatten"];
    
    FMSpotifyTrack *track = [[self tracks] itemAtIndex:[indexPath row]];
    @try {
        [[cell textLabel] setText:[track name]];
        [[cell detailTextLabel] setText:[@([track duration]) stringValue]];
    } @catch (NSException *exception) {
        [_appDelegate displayException:exception];
    }
    return cell;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    [[_appDelegate spotifyClient] search:[searchBar text] withOnSuccess:^(FMSpotifyTrackArray *tracks){
        [self setTracks:tracks];
        [[self searchResultTableView] reloadData];
    } onError:^(NSError *error){
        [_appDelegate displayError:error];
    }];
}

//- (void)cancelSearch:(id)sender
//{
//    [[[self searchBar] ]
//}

@end
