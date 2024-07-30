//
//  FMSpotifyTrack.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMSpotifyAlbum.h"

@interface FMSpotifyTrack : NSObject

@property NSString *name;
@property NSTimeInterval duration;
@property NSString *identifier;
@property FMSpotifyAlbum *album;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (FMSpotifyTrack *)trackFromDictionary:(NSDictionary *const)dictionary;

@end
