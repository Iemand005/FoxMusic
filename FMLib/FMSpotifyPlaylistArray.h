//
//  FMSpotifyItemArray.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMSpotifyPlaylist.h"

@interface FMSpotifyPlaylistArray : NSObject <NSFastEnumeration>

@property NSArray *items;

@property NSNumber *total;
@property NSNumber *offset;
@property NSNumber *limit;

@property NSURL *current;
@property NSURL *next;
@property NSURL *previous;

@property (readonly, nonatomic) BOOL hasNext;
@property (readonly, nonatomic) BOOL hasPrevious;
@property (readonly, nonatomic) NSUInteger count;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (FMSpotifyPlaylist *)itemAtIndex:(NSUInteger)index;

- (void)extendTracksWithDictionary:(NSDictionary *)dictionary;

+ (FMSpotifyPlaylistArray *)playlistArrayWithDictionary:(NSDictionary *)dictionary;

@end
