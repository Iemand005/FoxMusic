//
//  FMAppDelegate.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMAppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

@interface NSURLRequest (FoxesAreCool)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host;
@end

@implementation FMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"*.spotify.com"];
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"accounts.spotify.com"];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
//    NSLog(@"Dinges: %@", UIEventSubtypeRemoteControlPause);
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [[self audioPlayer] play];
            break;
            
        case UIEventSubtypeRemoteControlPause:
            [[self audioPlayer] pause];
            break;
    }
    [super remoteControlReceivedWithEvent:event];
}

- (void)displayError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:[error localizedFailureReason] message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
}

- (void)displayException:(NSException *)exception
{
    [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:exception.description delegate:nil cancelButtonTitle:@"Sorry" otherButtonTitles:nil, nil] show];
}

- (FMSpotifyClient *)spotifyClient
{
    return _spotifyClient ? _spotifyClient : (_spotifyClient = [FMSpotifyClient spotifyClient]);
}

@end
