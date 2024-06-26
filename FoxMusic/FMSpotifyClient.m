//
//  FMSpotifyClient.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyClient.h"
#import "FMMutableURLQueryDictionary.h"
#import "FMSpotifyAuthenticator.h"

@interface NSURLRequest ()
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host;
@end

@implementation FMSpotifyClient

- (id)init
{
    self = [super init];
    if (self) {
        self.clientId = @"756a522d9f1648b89e76e80be654456a";
        
        authenticator = [FMSpotifyAuthenticator authenticatorForClient:self];
    }
    return self;
}

- (NSDictionary *)request:(NSURL *)url withBody:(NSDictionary *)requestBody
{
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"*.spotify.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *defaultBody = @{@"client_id": self.clientId};
    FMMutableURLQueryDictionary *body = [FMMutableURLQueryDictionary dictionary];
    
    [body addEntriesFromDictionary:defaultBody];
    [body addEntriesFromDictionary:requestBody];
    [request setHTTPBody:[body urlEncodedData]];
    
    [request addValue:@(request.HTTPBody.length).stringValue forHTTPHeaderField:@"Content-Length"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *responseString = [[NSString alloc ] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"I ate your foot: %@, %@", responseString, error.localizedDescription);
    return [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
}

- (FMDeviceAuthorizationInfo *)deviceAuthorizationInfo
{
    return [authenticator deviceAuthorizationInfo];
}

+ (FMSpotifyClient *)spotifyClient
{
    return [[FMSpotifyClient alloc] init];
}

@end
