//
//  FMSpotifyTrackTableViewController.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FMSpotifyPlaylistTableViewController.h"

@interface FMSpotifyTrackTableViewController : UITableViewController
{
    FMAppDelegate *_appDelegate;
//    FMSP *_playlists;
}

@property FMSpotifyPlaylist *playlist;

@end
