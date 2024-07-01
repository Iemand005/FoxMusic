//
//  FMSpotifyToken.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyToken.h"

NSString *const FMSpotifyTokenAccessTokenKey = @"access_token";
NSString *const FMSpotifyTokenExpiresInKey = @"expires_in";
NSString *const FMSpotifyTokenRefreshTokenKey = @"refresh_token";
NSString *const FMSpotifyTokenScopeKey = @"scope";
NSString *const FMSpotifyTokenTokenTypeKey = @"token_type";
NSString *const FMSpotifyTokenCreatedOnKey = @"created_on";

@implementation FMSpotifyToken

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self && dictionary) {
        self.accessToken = [dictionary objectForKey:FMSpotifyTokenAccessTokenKey];
        self.expiresIn = [dictionary objectForKey:FMSpotifyTokenExpiresInKey];
        self.refreshToken = [dictionary objectForKey:FMSpotifyTokenRefreshTokenKey];
        self.scope = [dictionary objectForKey:FMSpotifyTokenScopeKey];
        self.tokenType = [dictionary objectForKey:FMSpotifyTokenTokenTypeKey];
        self.createdOn = [NSDate date];
    }
    return self;
}

- (NSString *)description
{
    return [self bearer];
}

- (NSString *)bearer
{
    return [self.tokenType stringByAppendingFormat:@" %@", self.accessToken];
}

- (NSDictionary *)dictionary
{
    return @{
             FMSpotifyTokenAccessTokenKey: self.accessToken,
             FMSpotifyTokenExpiresInKey: self.expiresIn,
             FMSpotifyTokenRefreshTokenKey: self.refreshToken,
             FMSpotifyTokenScopeKey: self.scope,
             FMSpotifyTokenTokenTypeKey: self.tokenType
             };
}

- (BOOL)save
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.accessToken forKey:FMSpotifyTokenAccessTokenKey];
    [userDefaults setObject:self.expiresIn forKey:FMSpotifyTokenExpiresInKey];
    [userDefaults setObject:self.refreshToken forKey:FMSpotifyTokenRefreshTokenKey];
    [userDefaults setObject:self.scope forKey:FMSpotifyTokenScopeKey];
    [userDefaults setObject:self.tokenType forKey:FMSpotifyTokenTokenTypeKey];
    [userDefaults setObject:self.createdOn forKey:FMSpotifyTokenCreatedOnKey];
    return [self isValid];
}

- (BOOL)load
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults valueForKey:FMSpotifyTokenAccessTokenKey];
    self.expiresIn = [userDefaults valueForKey:FMSpotifyTokenExpiresInKey];
    self.refreshToken = [userDefaults valueForKey:FMSpotifyTokenRefreshTokenKey];
    self.scope = [userDefaults valueForKey:FMSpotifyTokenScopeKey];
    self.tokenType = [userDefaults valueForKey:FMSpotifyTokenTokenTypeKey];
    self.createdOn = [userDefaults valueForKey:FMSpotifyTokenCreatedOnKey];
    return [self isValid];
}

- (BOOL)isValid
{
    return [[self.createdOn dateByAddingTimeInterval:self.expiresIn.doubleValue] compare:[NSDate date]] == NSOrderedDescending;
}

+ (FMSpotifyToken *)token
{
    return [[FMSpotifyToken alloc] init];
}

+ (FMSpotifyToken *)tokenWithDictionary:(NSDictionary *)dictionary
{
    return [[FMSpotifyToken alloc] initWithDictionary:dictionary];
}

+ (FMSpotifyToken *)savedToken
{
    FMSpotifyToken *token = [FMSpotifyToken token];
    [token load];
    return token;
}

@end
