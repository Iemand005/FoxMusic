//
//  FMSpotifyTrack.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMSpotifyTrack : NSObject

@property NSString *name;
@property NSTimeInterval duration;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSUInteger)hash;
- (BOOL)isEqual:(id)object;

+ (FMSpotifyTrack *)trackFromDictionary:(NSDictionary *const)dictionary;

@end
