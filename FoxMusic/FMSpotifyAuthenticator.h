//
//  FMSpotifyAuthenticator.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMSpotifyClient;

@interface FMDeviceAuthorizationInfo : NSObject

@property NSString *deviceCode;
@property NSString *userCode;
@property NSURL *verificationURL;
@property NSURL *completeVerificationURL;
@property NSNumber *expiresIn;
@property NSNumber *interval;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (FMDeviceAuthorizationInfo *)deviceAuthorizationInfoFromDictionary:(NSDictionary *)dictionary;

@end

@interface FMSpotifyAuthenticator : NSObject
{
    FMSpotifyClient *client;
}

@property NSURL *baseAddress;
@property NSURL *authorizeDeviceEndpoint;
@property NSURL *tokenEndpoint;

- (FMDeviceAuthorizationInfo *)deviceAuthorizationInfo;

+ (FMSpotifyAuthenticator *)authenticatorForClient:(FMSpotifyClient *)client;

@end
