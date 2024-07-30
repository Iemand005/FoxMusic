//
//  FMSpotifyPlaylistController.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMAppDelegate.h"
#import "FMTouch.h"

@interface FMSpotifyPlaylistTableViewController : UITableViewController
{
    FMAppDelegate *_appDelegate;
}

@property FMSpotifyPlaylistArray *playlists;

@property FMSpotifyPlaylist *selectedPlaylist;

@end
