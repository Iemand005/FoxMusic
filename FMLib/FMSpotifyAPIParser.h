//
//  FMSpotifyAPIParser.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMSpotifyAPIParser : NSObject

- (NSArray *)playlists;

+ (FMSpotifyAPIParser *)apiParser;

@end
