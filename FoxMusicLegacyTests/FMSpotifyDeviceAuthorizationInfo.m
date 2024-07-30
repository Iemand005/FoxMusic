//
//  FMDeviceAuthorizationInfo.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyDeviceAuthorizationInfo.h"

@implementation FMSpotifyDeviceAuthorizationInfo

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

+ (FMSpotifyDeviceAuthorizationInfo *)deviceAuthorizationInfoFromDictionary:(NSDictionary *)dictionary
{
    return [[FMSpotifyDeviceAuthorizationInfo alloc] initWithDictionary:dictionary];
}

@end
