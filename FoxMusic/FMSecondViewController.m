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

@interface FMSecondViewController ()

@end

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
    NSString *spotifyAccountsURL = @"https://accounts.spotify.com/login/password";
    
    NSLog(@"Logging in...");
    
    NSString *username = [[self username] text];
    NSString *password = [[self password] text];
    
    NSLog(@"Username: %@, Password: %@", username, password);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:spotifyAccountsURL]];
    NSURLResponse *response;
    NSError *error;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    FMHTTPServer *httpServer = [FMHTTPServer httpServerWithPort:6969];
}

@end
