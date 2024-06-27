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

@property (readonly) NSDictionary *dictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (FMSpotifyToken *)tokenWithDictionary:(NSDictionary *)dictionary;

@end
