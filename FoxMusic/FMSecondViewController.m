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
    
    //[self getNewUserCode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logIn:(id)sender
{
    [self getNewUserCode];
}

- (void)refreshCode:(id)sender
{
    [self getNewUserCode];
}

- (void)shareCode:(id)sender
{
    NSArray *activityItems = @[shareURL];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)getNewUserCode
{
    if (activeTimer) [activeTimer invalidate];
    
    [self setProgressIndeterminate:YES];
    
    FMSpotifyDeviceAuthorizationInfo *deviceAuthorizationInfo = [spotifyClient deviceAuthorizationInfo];
    
    NSLog(@"device code: %@", [deviceAuthorizationInfo deviceCode]);
    NSLog(@"user code: %@", [deviceAuthorizationInfo userCode]);
    NSLog(@"url: %@", [deviceAuthorizationInfo verificationURL]);
    expiresIn = [[deviceAuthorizationInfo expiresIn] doubleValue] / 1000;
    shareURL = deviceAuthorizationInfo.completeVerificationURL;
    
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
