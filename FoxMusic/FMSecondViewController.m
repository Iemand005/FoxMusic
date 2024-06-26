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

@interface FMSecondViewController ()

@end

@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host;
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
    NSString *spotifyAuthorizeEndpoint = @"https://accounts.spotify.com/authorize";
    NSString *limitedInputEndrpoid = @"http://accounts.spotify.com/api/device/code";
    NSString *spotifyClientID = @"a7613f878e5a432ba2e0bd342b93085e";
    
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"*.spotify.com"];
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"accounts.spotify.com"];
    NSMutableURLRequest *requast = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:limitedInputEndrpoid]];
    
    [requast setHTTPMethod:@"POST"];
//    [requast setHTTPBody:[[FMURLQueryBuilder queryFromDictionary:@{@"client_id": spotifyClientID}] dataUsingEncoding:NSUTF8StringEncoding]];
    [requast setHTTPBody:[@"client_id=a7613f878e5a432ba2e0bd342b93085e" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [requast addValue:@"42" forHTTPHeaderField:@"Content-Length"];
    [requast addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSError *errord;
    NSURLResponse *respanse;
    NSData *responsible = [NSURLConnection sendSynchronousRequest:requast returningResponse:&respanse error:&errord];
    
    NSString *responsibledata = [[NSString alloc ] initWithData:responsible encoding:NSUTF8StringEncoding];
    
    NSLog(@"I ate your foot: %@, %@", responsibledata, errord.localizedDescription);
    
    return;
    
    
    NSString *redirectUri = @"https://localhost:35587";
    
    NSString *authURL = [FMURLQueryBuilder addQueryToURLString:spotifyAuthorizeEndpoint query:@{
                         @"client_id": spotifyClientID,
                         @"response_type": @"code",
                         @"redirect_uri": redirectUri,
                         @"scope": @"user-read-private user-read-email"
                         }];
    
    NSLog(@"Logging in...");
    
    UIWebView *webView = self.webView;
    webView.delegate = self;
    
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:webView];
    
    NSLog(@"auth url>: %@", authURL);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authURL]];
    
    [webView loadRequest:request];
    [[self username] setText:authURL];
    return;
    
    NSString *username = [[self username] text];
    NSString *password = [[self password] text];
    
    NSLog(@"Username: %@, Password: %@", username, password);
    
    NSURLRequest *reque3st = [NSURLRequest requestWithURL:[NSURL URLWithString:spotifyAccountsURL]];
    NSURLResponse *response;
    NSError *error;
    [NSURLConnection sendSynchronousRequest:reque3st returningResponse:&response error:&error];
    
    FMHTTPServer *httpServer = [FMHTTPServer httpServerWithPort:6969];
    
    [httpServer start];
}

@end
