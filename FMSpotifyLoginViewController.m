//
//  FMSpotifyLoginViewController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyLoginViewController.h"
#import "FMAppDelegate.h"
#import "FMSecondViewController.h"

@implementation FMSpotifyLoginViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    
    [self getNewUserCode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (FMSpotifyClient *)spotifyClient
{
    return appDelegate.spotifyClient;
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

- (void)getNewUserCode
{
    if (activeTimer) [activeTimer invalidate];
    
    [self setProgressIndeterminate:YES];
    
    FMSpotifyDeviceAuthorizationInfo *deviceAuthorizationInfo = [appDelegate.spotifyClient refreshDeviceAuthorizationInfo];
    
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
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    } else {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)updateRemainingTime
{
    [self.remainingTimeView setProgress:self.remainingTimeView.progress - (1 / expiresIn)];
    if (self.remainingTimeView.progress <= 0) [self getNewUserCode];
}

@end
