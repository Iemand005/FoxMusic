//
//  FMAppDelegate.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMAppDelegate.h"




@interface NSURLRequest (FoxesAreCool)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host;
@end

@implementation FMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setAlertDelegate:[[FMAlertDelegate alloc] init]];
    // Override point for customization after application launch.
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"*.spotify.com"];
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"accounts.spotify.com"];
    
    return YES;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSString *data = message;
    NSLog(@"hi %@", data);
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
    
    @try {
        // Ensure audio continues playing in the background
        if ([self audioPlayer] && [[self audioPlayer] isPlaying]) {
            // Audio will continue playing due to background modes in Info.plist
            NSLog(@"Audio continuing in background");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception entering background: %@", exception.reason);
    }
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
    
    @try {
        // Stop audio playback
        if (self.audioPlayer) {
            [self.audioPlayer stop];
            self.audioPlayer = nil;
        }
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:NO error:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception during app termination: %@", exception.reason);
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"%@, application: %@", url, sourceApplication);
    
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    @try {
        AVAudioPlayer *audioPlayer = [self audioPlayer];
        if (!audioPlayer) {
            NSLog(@"No audio player available for remote control");
            return;
        }
        
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [[self audioPlayer] play];
                break;
                
            case UIEventSubtypeRemoteControlPause:
                [[self audioPlayer] pause];
                break;
                
            case UIEventSubtypeRemoteControlStop:
                [[self audioPlayer] stop];
                break;
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if (audioPlayer.isPlaying)
                    [audioPlayer pause];
                else [audioPlayer play];
                break;
                
            default:
                break;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in remote control: %@", exception.reason);
        [self displayException:exception];
    }
    
    [super remoteControlReceivedWithEvent:event];
}

- (void)displayError:(NSError *)error
{
    [self displayError:error withCompletionHandler:nil];
}

- (void)displayError:(NSError *)error withCompletionHandler:(void(^)())completionHandler
{
    bool debug = true;
    NSString *debugDescription = [[error userInfo] objectForKey:@"NSDebugDescription"];
    NSString *description = debugDescription ? [NSString stringWithFormat:@"%@\n%@", [error localizedDescription], debugDescription] : [error localizedDescription];
    
    NSString *debugButtonTitle = nil;
    
    if (debug) {
        debugButtonTitle = @"Details";
        
        [[self alertDelegate] setCompletionHandler:^void(int buttonIndex){
            if (buttonIndex == 1)
                [[[UIAlertView alloc] initWithTitle:[error localizedFailureReason] message:[error debugDescription] delegate:[self alertDelegate] cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
            if (completionHandler) completionHandler();
        }];
    } else [[self alertDelegate] setCompletionHandler:completionHandler];
    [[[UIAlertView alloc] initWithTitle:[error localizedFailureReason] message:description delegate:[self alertDelegate] cancelButtonTitle:@"Close" otherButtonTitles:debugButtonTitle, nil] show];
}

- (void)displayException:(NSException *)exception
{
    [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:exception.description delegate:[self alertDelegate] cancelButtonTitle:@"Sorry" otherButtonTitles:nil, nil] show];
}

- (void)loadAudioFromData:(NSData *)audioData
{
    @try {
        if (!audioData || audioData.length == 0) {
            NSLog(@"No audio data provided");
            return;
        }
        
        NSError *error;
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
        
        if (error) {
            NSLog(@"Error creating audio player: %@", error.localizedDescription);
            [self displayError:error];
            return;
        }
        
        [self setAudioPlayer:audioPlayer];
        [audioPlayer prepareToPlay];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception loading audio: %@", exception.reason);
        [self displayException:exception];
    }
}

- (void)play
{
    @try {
        AVAudioPlayer *audioPlayer = [self audioPlayer];
        if (!audioPlayer) {
            NSLog(@"No audio player available");
            return;
        }
        
        [audioPlayer prepareToPlay];
        BOOL success = [audioPlayer play];
        if (!success)
            NSLog(@"Failed to start audio playback");
    }
    @catch (NSException *exception) {
        NSLog(@"Exception playing audio: %@", exception.reason);
        [self displayException:exception];
    }
}

- (FMSpotifyClient *)spotifyClient
{
    return _spotifyClient ? _spotifyClient : (_spotifyClient = [FMSpotifyClient spotifyClient]);
}

- (FMYouTubeClient *)youtubeClient
{
    return _youtubeClient ? _youtubeClient : (_youtubeClient = [FMYouTubeClient youtubeMusicClient]);
}

- (FMLucidaClient *)lucidaClient
{
    return _lucidaClient ? _lucidaClient : (_lucidaClient = [FMLucidaClient lucidaClient]);
}

@end
