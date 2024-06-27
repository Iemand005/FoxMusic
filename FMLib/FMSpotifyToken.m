//
//  FMSpotifyToken.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyToken.h"

@implementation FMSpotifyToken

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self && dictionary) {
        self.accessToken = [dictionary objectForKey:@"access_token"];
        self.expiresIn = [dictionary objectForKey:@"expires_in"];
        self.refreshToken = [dictionary objectForKey:@"refresh_token"];
        self.scope = [dictionary objectForKey:@"scope"];
        self.tokenType = [dictionary objectForKey:@"token_type"];
    }
    return self;
}

- (NSString *)description
{
    return self.accessToken;
}

- (NSDictionary *)dictionary
{
    return @{@"access_token": self.accessToken, @"expires_in": self.expiresIn, @"refresh_token": self.refreshToken, @"scope": self.scope, @"token_type": self.tokenType};
}

+ (FMSpotifyToken *)tokenWithDictionary:(NSDictionary *)dictionary
{
    return [[FMSpotifyToken alloc] initWithDictionary:dictionary];
}

@end
