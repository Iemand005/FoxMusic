//
//  FMAppDelegate.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "FMTouch.h"
#import "FMAlertDelegate.h"

@interface FMAppDelegate : UIResponder <UIApplicationDelegate>
{
    FMSpotifyClient *_spotifyClient;
    FMYouTubeClient *_youtubeClient;
    FMLucidaClient *_lucidaClient;
    
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly) FMSpotifyClient *spotifyClient;
@property (readonly) FMYouTubeClient *youtubeClient;
@property (readonly) FMLucidaClient *lucidaClient;
@property FMAlertDelegate *alertDelegate;

@property IBOutlet UITabBarController *mainTabBarController;

@property FMSpotifyPlaylist *selectedPlaylist;
@property FMSpotifyTrack *selectedTrack;

@property AVAudioPlayer *audioPlayer;

- (void)displayError:(NSError *)error;
- (void)displayError:(NSError *)error withCompletionHandler:(void(^)())completionHandler;
- (void)displayException:(NSException *)exception;

@end
