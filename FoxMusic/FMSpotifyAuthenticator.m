//
//  FMSpotifyAuthenticator.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyAuthenticator.h"
#import "FMSpotifyClient.h"

@implementation FMSpotifyAuthenticator

- (id)init
{
    self = [super init];
    if (self) {
        NSString *baseAddress = @"https://accounts.spotify.com";
        NSString *authorizeDeviceEndpoint = @"oauth2/device/authorize";
        NSString *tokenEndpoint = @"api/token";
        
        self.baseAddress = [NSURL URLWithString:baseAddress];
        self.authorizeDeviceEndpoint = [NSURL URLWithString:[baseAddress stringByAppendingPathComponent:authorizeDeviceEndpoint]];
        self.tokenEndpoint = [NSURL URLWithString:[baseAddress stringByAppendingPathComponent:tokenEndpoint]];
    }
    return self;
}

- (id)initForClient:(FMSpotifyClient *)spotifyClient
{
    self = [self init];
    if (self) {
        client = spotifyClient;
    }
    return self;
}

- (FMDeviceAuthorizationInfo *)deviceAuthorizationInfo
{
    NSDictionary *response = [client request:self.authorizeDeviceEndpoint withBody:@{@"scope": @"streaming"}];
    return [FMDeviceAuthorizationInfo deviceAuthorizationInfoFromDictionary:response];
}

+ (FMSpotifyAuthenticator *)authenticatorForClient:(FMSpotifyClient *)client
{
    return [[FMSpotifyAuthenticator alloc] initForClient:client];
}

@end

@implementation FMDeviceAuthorizationInfo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.deviceCode = [dictionary objectForKey:@"device_code"];
        self.userCode = [dictionary objectForKey:@"user_code"];
        self.verificationURL = [NSURL URLWithString:[dictionary objectForKey:@"verification_uri"]];
        self.completeVerificationURL = [NSURL URLWithString:[dictionary objectForKey:@"verification_uri_complete"]];
        self.expiresIn = [dictionary objectForKey:@"expires_in"];
        self.interval = [dictionary objectForKey:@"interval"];
    }
    return self;
}

+ (FMDeviceAuthorizationInfo *)deviceAuthorizationInfoFromDictionary:(NSDictionary *)dictionary
{
    return [[FMDeviceAuthorizationInfo alloc] initWithDictionary:dictionary];
}

@end
