//
//  FMDAppDelegate.h
//  FoxMusicDesktop
//
//  Created by Lasse Lauwerys on 17/07/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FMTouch.h"

@interface FMDAppDelegate : NSObject <NSApplicationDelegate>
{
    FMSpotifyClient *_spotifyClient;
}

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, strong) FMSpotifyClient *spotifyClient;

@property (assign) IBOutlet NSTextFieldCell *codeLabel;

@end
