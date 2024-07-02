//
//  FMSpotifyPlaylist.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyPlaylist.h"

@implementation FMSpotifyPlaylist

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.description = [dictionary objectForKey:@"description"];
        self.name = [dictionary objectForKey:@"name"];
    }
    return self;
}

+ (FMSpotifyPlaylist *)playlistFromDictionary:(NSDictionary *const)dictionary
{
    return [[FMSpotifyPlaylist alloc] initWithDictionary:dictionary];
}

@end
