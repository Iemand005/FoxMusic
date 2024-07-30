//
//  FMDeviceAuthorizationInfo.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

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
