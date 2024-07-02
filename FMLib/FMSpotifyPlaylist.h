//
//  FMSpotifyPlaylist.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMSpotifyPlaylist : NSObject

@property NSString *description;
@property NSString *href;
@property NSString *identifier;
@property NSString *name;
@property NSString *color;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (FMSpotifyPlaylist *)playlistFromDictionary:(NSDictionary *const)dictionary;

@end
