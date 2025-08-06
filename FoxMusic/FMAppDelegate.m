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
    
//    [self lucidaClient];
//    FMBase62Decoder *decoder = [FMBase62Decoder decoderWithString:@"GitHub"];
////    NSString *hex = [decoder toHex];
//    NSString *shouldbeHex = [[FMBase62Decoder decoderWithString:@"0nMn7LRJk9nYT0rNb5ZwAD"] toHex];
//    
//    NSLog(@"%@", shouldbeHex);
//    
//    NSDictionary *response = [[self youtubeClient] getBrowseEndpoint];
//    
//    NSArray *musicVideos = [[[self youtubeClient] parser] parseBrowseEndpoint:response];

//    SRWebSocket *socket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"wss://echo.websocket.org"]];
//    [socket setDelegate:self];
//    [socket open];
////    [socket sendPing:nil];
//    if ([socket readyState]) [socket send:@"hi"];
    
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
        default:
            break;
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
    NSError *error;
    [self setAudioPlayer:[[AVAudioPlayer alloc] initWithData:audioData error:&error]];
    if (error) {
        [self displayError:error];
    }
}

- (void)play
{
    [[self audioPlayer] prepareToPlay];
    [[self audioPlayer] play];
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
