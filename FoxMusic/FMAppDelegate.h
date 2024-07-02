//
//  FMAppDelegate.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FMTouch.h"

@interface FMAppDelegate : UIResponder <UIApplicationDelegate>
{
    FMSpotifyClient *_spotifyClient;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly) FMSpotifyClient *spotifyClient;

@property IBOutlet UITabBarController *mainTabBarController;

@property FMSpotifyPlaylist *selectedPlaylist;

- (void)displayError:(NSError *)error;
- (void)displayException:(NSException *)exception;

@end
