//
//  FMSecondViewController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMSecondViewController.h"

#import "FMAppDelegate.h"

@interface FMSecondViewController ()

@end

@implementation FMSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    FMAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    spotifyClient = [FMSpotifyClient spotifyClient];
    
    [[self navigationController] setToolbarHidden:NO animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    if (storyboard) {
        UIViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"accountPage"];
        //        [self.navigationController pushViewController:dest animated:YES];
        [self presentViewController:dest animated:YES completion:nil];
    }
    
    //[self getNewUserCode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logIn:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    if (storyboard) {
        UIViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"accountPage"];
//        [self.navigationController pushViewController:dest animated:YES];
        [self presentViewController:dest animated:YES completion:nil];
    }
    return;
    NSError *error;
    @try {
        if (![spotifyClient tryDeviceAuhorizationWithError:&error] || error) [self displayError:error];
        NSLog(@"Logged in? %@", spotifyClient.token);
    }
    @catch (NSException *exception) {
        [self displayException:exception];
    }
}

- (void)refreshCode:(id)sender
{
    [self getNewUserCode];
}

- (void)shareCode:(id)sender
{
    if (shareURL) [self presentViewController:[[UIActivityViewController alloc] initWithActivityItems:@[shareURL] applicationActivities:nil] animated:YES completion:nil];
    else [[[UIAlertView alloc] initWithTitle:@"Error" message:@"The URL was not found." delegate:nil cancelButtonTitle:@"Shut up!" otherButtonTitles:nil, nil] show];
}

- (void)displayError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@\n%@", error.localizedFailureReason, error.localizedDescription] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
}

- (void)displayException:(NSException *)exception
{
    [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:exception.description delegate:nil cancelButtonTitle:@"Sorry" otherButtonTitles:nil, nil] show];
}

- (void)getNewUserCode
{
    if (activeTimer) [activeTimer invalidate];
    
    [self setProgressIndeterminate:YES];
    
    FMSpotifyDeviceAuthorizationInfo *deviceAuthorizationInfo = [spotifyClient refreshDeviceAuthorizationInfo];
    
    NSLog(@"device code: %@", [deviceAuthorizationInfo deviceCode]);
    NSLog(@"user code: %@", [deviceAuthorizationInfo userCode]);
    NSLog(@"url: %@", [deviceAuthorizationInfo verificationURL]);
    expiresIn = [[deviceAuthorizationInfo expiresIn] doubleValue];
    shareURL = deviceAuthorizationInfo.completeVerificationURL;
    [self.shareButton setEnabled:shareURL != nil];
    [self.remainingTimeView setProgress:1];
    [self setProgressIndeterminate:NO];
    [self.userCodeField setText:deviceAuthorizationInfo.userCode];
    
    NSLog(@"expires in %lf", expiresIn);
    activeTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateRemainingTime) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:activeTimer forMode:NSRunLoopCommonModes];
}

- (void)setProgressIndeterminate:(BOOL)indeterminate
{
    if (indeterminate) {
        [self.activityIndicator startAnimating];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    } else {
        [self.activityIndicator startAnimating];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)updateRemainingTime
{
    [self.remainingTimeView setProgress:self.remainingTimeView.progress - (1 / expiresIn)];
    if (self.remainingTimeView.progress <= 0) [self getNewUserCode];
}

@end
