//
//  FMDAppDelegate.m
//  FoxMusicDesktop
//
//  Created by Lasse Lauwerys on 17/07/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import "FMDAppDelegate.h"

@implementation FMDAppDelegate
@synthesize spotifyClient;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    [self setSpotifyClient:[FMSpotifyClient spotifyClient]];
    
    NSError *error;
    FMSpotifyDeviceAuthorizationInfo *authInfo = [spotifyClient refreshDeviceAuthorizationInfoWithError:error];
    NSString *code = [authInfo userCode];
    
    [[self codeLabel] setValue:code];
    
}

@end
