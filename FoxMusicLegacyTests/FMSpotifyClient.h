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
#import "FMURLConnection.h"

@interface FMSpotifyClient : FMURLConnection

@property (retain) NSString *clientId;

@property NSURL *accountsBaseAddress;
@property NSURL *authorizeDeviceEndpoint;
@property NSURL *tokenEndpoint;

@property NSURL *apiBaseAddress;
@property NSURL *searchEndpoint;

@property (retain) FMSpotifyDeviceAuthorizationInfo *deviceAuthorizationInfo;
@property (retain) FMSpotifyToken *token;

@property (readonly, nonatomic) BOOL isLoggedIn;

- (NSURL *)makeEndpointURL:(NSString *)endpoint;

- (NSDictionary *)request:(NSURL *)url withBody:(NSDictionary *)requestBody;
- (NSDictionary *)request:(NSURL *)url withBody:(NSDictionary *)requestBody error:(NSError **)error;
- (NSDictionary *)request:(NSURL *)url withBody:(NSDictionary *)requestBody addClientId:(BOOL)injectClientId;
- (NSDictionary *)request:(NSURL *)url withBody:(NSDictionary *)requestBody addClientId:(BOOL)injectClientId error:(NSError **)error;
- (FMSpotifyDeviceAuthorizationInfo *)refreshDeviceAuthorizationInfoWithError:(NSError **)error;

- (BOOL)refreshToken;
- (BOOL)refreshTokenWithError:(NSError **)error;

- (BOOL)tryDeviceAuhorization;
- (BOOL)tryDeviceAuhorizationWithError:(NSError **)error;

//- (NSArray *)getUserPlaylists;
- (void)getUserPlaylistsAndWhenSuccess:(void(^)(FMSpotifyPlaylistArray *playlists))callbackSuccess whenError:(void(^)(NSError *))callbackError;

- (void)continueArray:(FMSpotifyContinuableArray *)continuableArray withOnSuccess:(void(^)(FMSpotifyContinuableArray *))callbackSuccess onError:(void(^)(NSError *))callbackError;

- (NSData *)downloadTrack:(FMSpotifyTrack *)track;
- (void)downloadTrack:(FMSpotifyTrack *)track callback:(void(^)(NSData *))callback;
- (void)getTrackDownloadURL:(FMSpotifyTrack *)track callback:(void(^)(NSURL *))callback;

- (void)search:(NSString *)query withOnSuccess:(void(^)(FMSpotifyTrackArray *tracks))callbackSuccess onError:(void(^)(NSError *error))callbackError;

+ (FMSpotifyClient *)spotifyClient;

@end
