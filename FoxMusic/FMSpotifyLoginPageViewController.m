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
    hasShownLoginPage = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"the loading view appeared!");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    NSString *viewControllerIdentifier;
    BOOL forwards = YES;
    
    @try {
    
        [[[self.appDelegate spotifyClient] token] load];
        NSError *error;
        if (!self.appDelegate.spotifyClient.isLoggedIn) NSLog(@"SHIT TOEKN EXPIRED");
        bool isLoggedIn = [[self.appDelegate spotifyClient] refreshTokenWithError:&error];
        
        
        
        if (!error && isLoggedIn) {
            @try {
            if ([[self viewControllers] count] > 0 && [[[[self viewControllers] objectAtIndex:0] identifier] isEqualToString:@"spotify"]) return;
            } @catch (NSException *ex) {}
            viewControllerIdentifier = @"spotify";
        } else {
            if (error) {
                [self.appDelegate displayError:error];
            }
            viewControllerIdentifier = @"login";
        }
        
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
        
        UIPageViewControllerNavigationDirection direction = forwards ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
        
        [self setViewControllers:@[viewController] direction:direction animated:YES completion:nil];
            
    }
    @catch (NSException *exception) {
        [self.appDelegate displayException:exception];
    }
}

- (void)logIn:(id)sender
{
    NSError *error;
    @try {
        if (![self.appDelegate.spotifyClient tryDeviceAuhorizationWithError:&error] || error) [self.appDelegate displayError:error];
        NSLog(@"Logged in? %@", self.appDelegate.spotifyClient.token);
        if (self.appDelegate.spotifyClient.isLoggedIn) [self navigateToControllerWithIdentifier:@"spotify" forwards:YES];
        
    }
    @catch (NSException *exception) {
        [self.appDelegate displayException:exception];
    }
}
- (void)navigateToControllerWithIdentifier:(NSString *)identifier forwards:(BOOL)forwards
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    if (storyboard) [self setViewControllers:@[[storyboard instantiateViewControllerWithIdentifier:identifier]] direction:forwards ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

@end
