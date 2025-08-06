//
//  FMYouTubeVideo.h
//  FoxMusic YouTube testing
//
//  Created by Lasse Lauwerys on 04/12/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMYouTubeChannel.h"
#import "FMYouTubeVideoFormat.h"
#import "FMYouTubePlaybackTracker.h"
#import "FMYouTubeContinuation.h"

@class FMYouTubeAPIParser;
@class FMYouTubeClient;

@interface FMYouTubeVideo : NSObject

@property NSString *videoId;
@property NSArray *formats;
@property NSArray *adaptiveFormats;
@property NSString *title;
@property NSString *description;
@property NSNumber *viewCount;
@property NSString *subtitle;
//@property QTMovie *movie;
@property FMYouTubeClient *client;
@property FMYouTubeChannel *channel;
@property FMYouTubePlaybackTracker *tracker;
@property BOOL isWatched;
//@property NSImage *thumbnail;
@property NSURL *thumbnailURL;
@property NSString *shortStats;
@property NSString *lengthText;

@property NSURL *url;

@property BOOL isYouTubeVideo;

@property (nonatomic, readonly) NSInteger currentMediaTime;
@property (nonatomic, readonly) NSURL *channelThumbnailURL;

- (id)initWithId:(NSString *)videoId;

- (void)updateTracker;
//- (QTMovie *)getDefaultMovie;
//- (QTMovie *)getMovieWithFormat:(FMYouTubeVideoFormat *)format;
- (NSData *)getVideoDataWithFormat:(FMYouTubeVideoFormat *)format;
- (NSData *)getDataWithFormatIndex:(NSUInteger)index;
- (NSData *)getDefaultData;

- (void)play;
- (void)pause;
- (void)like;
- (void)dislike;
- (void)removeLike;

+ (FMYouTubeVideo *)video;
+ (FMYouTubeVideo *)videoWithId:(NSString *)videoId;

@end
