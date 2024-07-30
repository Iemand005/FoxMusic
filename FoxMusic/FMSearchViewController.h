//
//  FMSearchDisplayController.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 4/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FMAppDelegate.h"

@interface FMSearchViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>
{
    FMAppDelegate *_appDelegate;
}

@property IBOutlet UITableView *searchResultTableView;
@property IBOutlet UISearchBar *searchBar;

@property FMSpotifyTrackArray *tracks;

//- (IBAction)cancelSearch:(id)sender;

@end
