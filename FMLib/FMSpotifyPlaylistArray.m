//
//  FMSpotifyItemArray.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyPlaylistArray.h"
#import "FMSpotifyPlaylist.h"

@implementation FMSpotifyPlaylistArray

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.href = [dictionary objectForKey:@"href"];
        self.limit = [dictionary objectForKey:@"limit"];
        self.next = [dictionary objectForKey:@"next"];
        self.previous = [dictionary objectForKey:@"previous"];
        self.total = [dictionary objectForKey:@"total"];
        self.offset = [dictionary objectForKey:@"offset"];
        
        NSArray *items = [dictionary objectForKey:@"items"];
        NSMutableArray *playlists = [NSMutableArray arrayWithCapacity:items.count];
        for (NSDictionary *item in items) {
            [playlists addObject:[FMSpotifyPlaylist playlistFromDictionary:item]];
        }
        self.items = [NSArray arrayWithArray:playlists];
    }
    return self;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [[self items] countByEnumeratingWithState:state objects:buffer count:len];
}




- (FMSpotifyPlaylist *)itemAtIndex:(NSUInteger)index
{
    return [super itemAtIndex:index];
}

+ (FMSpotifyPlaylistArray *)playlistArrayWithDictionary:(NSDictionary *)dictionary
{
    return [[FMSpotifyPlaylistArray alloc] initWithDictionary:dictionary];
}

@end
