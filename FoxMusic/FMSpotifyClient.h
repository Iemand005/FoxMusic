//
//  FMSpotifyClient.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMSpotifyAuthenticator.m"

@interface FMSpotifyClient : NSObject
{
    FMSpotifyAuthenticator *authenticator;
}


@property (assign) NSString *clientId;

- (NSDictionary *)request:(NSURL *)url withBody:(NSDictionary *)requestBody;
- (FMDeviceAuthorizationInfo *)deviceAuthorizationInfo;

+ (FMSpotifyClient *)spotifyClient;

@end
