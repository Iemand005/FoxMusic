//
//  FMTrack.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 24/09/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import "FMTrack.h"

@implementation FMTrack

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        [self setURL:url];
    }
    return self;
}

+ (FMTrack *)track
{
    return [[FMTrack alloc] init];
}

+ (FMTrack *)trackWithURL:(NSURL *)url
{
    return [[FMTrack alloc] initWithURL:url];
}

@end
