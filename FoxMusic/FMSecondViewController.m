//
//  FMSecondViewController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMSecondViewController.h"
#import "FMHTTPServer.h"
#import "FMURLQueryBuilder.h"
#import "FMSpotifyClient.h"

@interface FMSecondViewController ()

@end

//@interface NSURLRequest (DummyInterface)
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;
//+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host;
//@end

@implementation FMSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logIn:(id)sender
{
    FMSpotifyClient *spotifyClient = [FMSpotifyClient spotifyClient];
    
    FMDeviceAuthorizationInfo *deviceAuthorizationInfo = [spotifyClient deviceAuthorizationInfo];
    
    NSLog(@"device code: %@", [deviceAuthorizationInfo deviceCode]);
    NSLog(@"user code: %@", [deviceAuthorizationInfo userCode]);
    NSLog(@"url: %@", [deviceAuthorizationInfo verificationURL]);
    self.expiresIn = [[deviceAuthorizationInfo expiresIn] doubleValue];
    
    [self.remainingTimeView setProgress:1];
    [self.userCodeField setText:deviceAuthorizationInfo.userCode];
    
    NSLog(@"expires in %lf", self.expiresIn);
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateRemainingTime) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)updateRemainingTime
{
    [self.remainingTimeView setProgress:self.remainingTimeView.progress - (1 / self.expiresIn)];
}

@end
