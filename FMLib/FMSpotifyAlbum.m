//
//  FMSpotifyAlbum.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyAlbum.h"

@implementation FMSpotifyAlbum

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self setName:[dictionary objectForKey:@"name"]];
        [self setHref:[NSURL URLWithString:[dictionary objectForKey:@"href"]]];
        [self setImageURL:[NSURL URLWithString:[[[dictionary objectForKey:@"images"] firstObject] objectForKey:@"url"]]];
    }
    return self;
}

+ (FMSpotifyAlbum *)albumFromDictionary:(NSDictionary *const)dictionary
{
    return [[FMSpotifyAlbum alloc] initWithDictionary:dictionary];
}

@end
