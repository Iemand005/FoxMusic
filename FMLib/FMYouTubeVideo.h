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

@property (retain) NSString *videoId;
@property (retain) NSArray *formats;
@property (retain) NSArray *adaptiveFormats;
@property (retain) NSString *title;
@property (retain) NSString *description;
@property (retain) NSNumber *viewCount;
@property (retain) NSString *subtitle;
//@property QTMovie *movie;
@property (retain) FMYouTubeClient *client;
@property (retain) FMYouTubeChannel *channel;
@property (retain) FMYouTubePlaybackTracker *tracker;
@property BOOL isWatched;
//@property NSImage *thumbnail;
@property (retain) NSURL *thumbnailURL;
@property (retain) NSString *shortStats;
@property (retain) NSString *lengthText;

@property (retain) NSURL *url;

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
