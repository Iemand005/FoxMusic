//
//  FMSpotifyTrack.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyTrack.h"

@implementation FMSpotifyTrack

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self setName:[dictionary objectForKey:@"name"]];
    }
    return self;
}

+ (FMSpotifyTrack *)trackFromDictionary:(NSDictionary *const)dictionary
{
    return [[FMSpotifyTrack alloc] initWithDictionary:dictionary];
}

@end
