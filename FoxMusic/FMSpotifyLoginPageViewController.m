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
    if (appDelegate.spotifyClient.isLoggedIn){
        viewControllerIdentifier = @"account";
    } else if (storyboard && (hasShownLoginPage = !hasShownLoginPage)){
        viewControllerIdentifier = @"login";
    } else {
        viewControllerIdentifier = @"loggedOff";
        forwards = NO;
    }
    
    UIViewController *rat = [storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
    
    UIPageViewControllerNavigationDirection direction = forwards ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    
    [self setViewControllers:@[rat] direction:direction animated:YES completion:nil];
}

- (void)cancelLogin:(id)sender
{
    [self navigateToControllerWithIdentifier:@"loggedOff" forwards:NO];
}

- (void)promptLogin:(id)sender
{
    [self navigateToControllerWithIdentifier:@"login" forwards:YES];
}

- (void)logIn:(id)sender
{
    NSError *error;
    @try {
        if (![appDelegate.spotifyClient tryDeviceAuhorizationWithError:&error] || error) [self displayError:error];
//        else {
            NSLog(@"Logged in? %@", appDelegate.spotifyClient.token);
            if (appDelegate.spotifyClient.isLoggedIn) [self navigateToControllerWithIdentifier:@"account" forwards:YES];
        
    }
    @catch (NSException *exception) {
        [self displayException:exception];
    }
}

- (void)displayError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@\n%@", error.localizedFailureReason, error.localizedDescription] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
}

- (void)displayException:(NSException *)exception
{
    [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:exception.description delegate:nil cancelButtonTitle:@"Sorry" otherButtonTitles:nil, nil] show];
}

- (void)navigateToControllerWithIdentifier:(NSString *)identifier forwards:(BOOL)forwards
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    if (storyboard) [self setViewControllers:@[[storyboard instantiateViewControllerWithIdentifier:identifier]] direction:forwards ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

@end
