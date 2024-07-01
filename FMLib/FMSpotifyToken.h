//
//  FMSpotifyToken.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMSpotifyToken : NSObject

@property NSString *accessToken;
@property NSNumber *expiresIn;
@property NSString *refreshToken;
@property NSString *scope;
@property NSString *tokenType;
@property NSDate *createdOn;

@property (readonly) NSDictionary *dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)bearer;

- (BOOL)isValid;

- (BOOL)save;
- (BOOL)load;

+ (FMSpotifyToken *)tokenWithDictionary:(NSDictionary *)dictionary;
+ (FMSpotifyToken *)savedToken;

@end

extern NSString *const FMSpotifyTokenAccessTokenKey;
extern NSString *const FMSpotifyTokenExpiresInKey;
extern NSString *const FMSpotifyTokenRefreshTokenKey;
extern NSString *const FMSpotifyTokenScopeKey;
extern NSString *const FMSpotifyTokenTokenTypeKey;
extern NSString *const FMSpotifyTokenCreatedOnKey;
