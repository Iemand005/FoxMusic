//
//  FMSpotifyTrackArray.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyTrackArray.h"


@implementation FMSpotifyTrackArray

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        self.href = [NSURL URLWithString:[dictionary objectForKey:@"href"]];
        NSArray *items = [dictionary objectForKey:@"items"];
        NSMutableArray *tracks = [NSMutableArray arrayWithCapacity:[items count]];
        
        for (NSDictionary *item in items)
            [tracks addObject:[FMSpotifyTrack trackFromDictionary:item]];
        
        [[self items] addObjectsFromArray:tracks];
//        [self setItems:]?
    }
    return self;
}

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) self.href = url;
    return self;
}

- (FMSpotifyContinuableArray *)addItemsFromDictionary:(NSDictionary *)dictionary
{
    self.href = [NSURL URLWithString:[dictionary objectForKey:@"href"]];
    NSArray *items = [dictionary objectForKey:@"items"];
    NSMutableArray *tracks = [NSMutableArray arrayWithCapacity:[items count]];
    
    for (NSDictionary *item in items)
        [tracks addObject:[FMSpotifyTrack trackFromDictionary:[item objectForKey:@"track"]]];
    
//    self.items = [NSArray arrayWithArray:tracks];
    [[self items] addObjectsFromArray:tracks];
    return self;
}

- (FMSpotifyTrack *)itemAtIndex:(NSUInteger)index
{
    return [super itemAtIndex:index];
}

- (NSUInteger)count
{
    return [[self items] count];
}

+ (FMSpotifyTrackArray *)trackArrayWithDictionary:(NSDictionary *)dictionary
{
    return [[FMSpotifyTrackArray alloc] initWithDictionary:dictionary];
}

//+ (FMSpotifyTrackArray *)trackArrayWithURL:(NSURL *)url
//{
//    return [[FMSpotifyTrackArray alloc] initWithURL:url];
//}

@end
