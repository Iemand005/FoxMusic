//
//  FMSpotifyLoginPageViewController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyLoginPageViewController.h"

@implementation FMSpotifyLoginPageViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    hasShownLoginPage = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"the loading view appeared!");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    NSString *viewControllerIdentifier;
    BOOL forwards = YES;
    
    [[[appDelegate spotifyClient] token] load];
    NSError *error;
    if (!appDelegate.spotifyClient.isLoggedIn) NSLog(@"SHIT TOEKN EXPIRED");
    [[appDelegate spotifyClient] refreshTokenWithError:&error];
//    if (appDelegate.spotifyClient.isLoggedIn) NSLog(@"TOKEN VALID AGAIN?");
    if (error) {
        [appDelegate displayError:error];
    }
    
    if (appDelegate.spotifyClient.isLoggedIn) {
        @try {
        if ([[self viewControllers] count] > 0 && [[[[self viewControllers] objectAtIndex:0] identifier] isEqualToString:@"spotify"]) return;
        } @catch (NSException *ex) {}
        viewControllerIdentifier = @"spotify";
    } else {
        viewControllerIdentifier = @"login";
    }
    
    UIViewController *rat = [storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
    
    UIPageViewControllerNavigationDirection direction = forwards ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    
    [self setViewControllers:@[rat] direction:direction animated:YES completion:nil];
}

- (void)logIn:(id)sender
{
    NSError *error;
    @try {
        if (![appDelegate.spotifyClient tryDeviceAuhorizationWithError:&error] || error) [appDelegate displayError:error];
        NSLog(@"Logged in? %@", appDelegate.spotifyClient.token);
        if (appDelegate.spotifyClient.isLoggedIn) [self navigateToControllerWithIdentifier:@"spotify" forwards:YES];
        
    }
    @catch (NSException *exception) {
        [appDelegate displayException:exception];
    }
}
- (void)navigateToControllerWithIdentifier:(NSString *)identifier forwards:(BOOL)forwards
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    if (storyboard) [self setViewControllers:@[[storyboard instantiateViewControllerWithIdentifier:identifier]] direction:forwards ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

@end
