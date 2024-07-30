//
//  FMSpotifyTrackArray.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMSpotifyContinuableArray.h"
#import "FMSpotifyTrack.h"

@interface FMSpotifyTrackArray : FMSpotifyContinuableArray

- (id)initWithDictionary:(NSDictionary *)dictionary;
//- (id)initWithURL:(NSURL *)url;

- (FMSpotifyTrack *)itemAtIndex:(NSUInteger)index;

+ (FMSpotifyTrackArray *)trackArrayWithDictionary:(NSDictionary *)dictionary;
//+ (FMSpotifyTrackArray *)trackArrayWithURL:(NSURL *)url;

@end
