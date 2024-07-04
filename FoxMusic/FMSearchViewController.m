//
//  FMSearchDisplayController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 4/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSearchViewController.h"

@implementation FMSearchViewController

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"This dood want u to search!!: %@", searchText);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView ]
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"spotifySearchResult" forIndexPath:indexPath];
    [[tableViewCell textLabel] setText:@"Vratten und tatten"];
    return tableViewCell;
}

@end
