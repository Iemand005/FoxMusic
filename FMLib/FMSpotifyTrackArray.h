//
//  FMSpotifyTrackArray.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMSpotifyTrack.h"

@interface FMSpotifyTrackArray : NSObject

@property NSURL *href;

@property NSArray *items;

@property (readonly, nonatomic) NSUInteger count;

- (id)initWithDictionary:(NSDictionary *)dictionary;
//- (id)initWithURL:(NSURL *)url;

- (FMSpotifyTrack *)itemAtIndex:(NSUInteger)index;

+ (FMSpotifyTrackArray *)trackArrayWithDictionary:(NSDictionary *)dictionary;
//+ (FMSpotifyTrackArray *)trackArrayWithURL:(NSURL *)url;

@end
