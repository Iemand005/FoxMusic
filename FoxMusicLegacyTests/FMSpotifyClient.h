//
//  FMSpotifyClient.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMSpotifyDeviceAuthorizationInfo.h"

@interface FMSpotifyClient : NSObject

@property (assign) NSString *clientId;

@property NSURL *baseAddress;
@property NSURL *authorizeDeviceEndpoint;
@property NSURL *tokenEndpoint;

- (NSDictionary *)request:(NSURL *)url withBody:(NSDictionary *)requestBody;
- (FMSpotifyDeviceAuthorizationInfo *)deviceAuthorizationInfo;

+ (FMSpotifyClient *)spotifyClient;

@end
