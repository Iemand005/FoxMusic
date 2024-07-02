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
        self.tracks = [FMSpotifyTrackArray trackArrayWithDictionary:[dictionary objectForKey:@"tracks"]];
    }
    return self;
}

- (void)extendTracksWithDictionary:(NSDictionary *)dictionary
{
    self.tracks = [FMSpotifyTrackArray trackArrayWithDictionary:[dictionary objectForKey:@"tracks"]];
}

+ (FMSpotifyPlaylist *)playlistFromDictionary:(NSDictionary *const)dictionary
{
    return [[FMSpotifyPlaylist alloc] initWithDictionary:dictionary];
}

@end
