//
//  FMSpotifyLoginLoadingViewController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyLoginLoadingViewController.h"

@implementation FMSpotifyLoginLoadingViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    hasShownLoginPage = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"the loading view appeared!");
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
//    NSString *viewControllerIdentifier;
//    if (appDelegate.spotifyClient.isLoggedIn){
//        viewControllerIdentifier = @"account";
//    } else if (storyboard && (hasShownLoginPage = !hasShownLoginPage)){
//        viewControllerIdentifier = @"login";
//    } else {
//        viewControllerIdentifier = @"loggedOff";
//    }
//    
//    [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier] animated:YES completion:nil];
}

@end
