//
//  FMDeviceAuthorizationInfo.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMSpotifyDeviceAuthorizationInfo : NSObject

@property (retain) NSString *deviceCode;
@property (retain) NSString *userCode;
@property (retain) NSURL *verificationURL;
@property (retain) NSURL *completeVerificationURL;
@property (retain) NSNumber *expiresIn;
@property (retain) NSNumber *interval;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (FMSpotifyDeviceAuthorizationInfo *)deviceAuthorizationInfoFromDictionary:(NSDictionary *)dictionary;

@end
