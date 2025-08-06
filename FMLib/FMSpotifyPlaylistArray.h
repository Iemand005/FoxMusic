//
//  FMSpotifyItemArray.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMSpotifyContinuableArray.h"
#import "FMSpotifyPlaylist.h"

@interface FMSpotifyPlaylistArray : FMSpotifyContinuableArray <NSFastEnumeration>



//- (id)initWithDictionary:(NSDictionary *)dictionary;

- (FMSpotifyPlaylist *)itemAtIndex:(NSUInteger)index;

//- (void)extendTracksWithDictionary:(NSDictionary *)dictionary;

+ (FMSpotifyPlaylistArray *)playlistArrayWithDictionary:(NSDictionary *)dictionary;

@end
