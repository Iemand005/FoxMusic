//
//  FMSpotifyClient.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMSpotifyDeviceAuthorizationInfo.h"
#import "FMSpotifyToken.h"
//#import "FMSpotifyAPIParser.h"
#import "FMSpotifyPlaylistArray.h"

@interface FMSpotifyClient : NSObject
{
//    FMSpotifyAPIParser *apiParser;
}

@property (assign) NSString *clientId;

@property NSURL *accountsBaseAddress;
@property NSURL *authorizeDeviceEndpoint;
@property NSURL *tokenEndpoint;

@property NSURL *apiBaseAddress;
@property NSURL *searchEndpoint;

@property FMSpotifyDeviceAuthorizationInfo *deviceAuthorizationInfo;
@property FMSpotifyToken *token;

@property (readonly, nonatomic) BOOL isLoggedIn;

- (NSDictionary *)request:(NSURL *)url withBody:(NSDictionary *)requestBody;
- (NSDictionary *)request:(NSURL *)url withBody:(NSDictionary *)requestBody error:(NSError **)error;
- (NSDictionary *)request:(NSURL *)url withBody:(NSDictionary *)requestBody addClientId:(BOOL)injectClientId;
- (NSDictionary *)request:(NSURL *)url withBody:(NSDictionary *)requestBody addClientId:(BOOL)injectClientId error:(NSError **)error;
- (FMSpotifyDeviceAuthorizationInfo *)refreshDeviceAuthorizationInfo;

- (BOOL)refreshToken;
- (BOOL)refreshTokenWithError:(NSError **)error;

- (BOOL)tryDeviceAuhorization;
- (BOOL)tryDeviceAuhorizationWithError:(NSError **)error;

- (NSArray *)getUserPlaylists;
- (NSArray *)getUserPlaylistsWithError:(NSError **)error;
- (void)getUserPlaylistsAndWhenSuccess:(void(^)(FMSpotifyPlaylistArray *playlists))callbackSuccess whenError:(void(^)(NSError *))callbackError;

- (void)continueArray:(FMSpotifyContinuableArray *)continuableArray withOnSuccess:(void(^)(FMSpotifyContinuableArray *))callbackSuccess onError:(void(^)(NSError *))callbackError;

- (NSData *)downloadTrack:(FMSpotifyTrack *)track;

+ (FMSpotifyClient *)spotifyClient;

@end
