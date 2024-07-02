//
//  FMSpotifyAlbum.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMSpotifyAlbum : NSObject

@property NSString *name;
@property NSString *type;
@property NSNumber *totalTracks;
@property NSURL *href;
@property NSURL *imageURL;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (FMSpotifyAlbum *)albumFromDictionary:(NSDictionary *const)dictionary;


@end
