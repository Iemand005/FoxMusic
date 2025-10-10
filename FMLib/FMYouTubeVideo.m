//
//  LYouTubeVideo.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 7/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMYouTubeVideo.h"
#import "FMYouTubeClient.h"

@implementation FMYouTubeVideo

- (id)init
{
    self = [super init];
    if (self) {
        self.tracker = [FMYouTubePlaybackTracker trackerForVideo:self];
    }
    return self;
}

- (id)initWithId:(NSString *)videoId
{
    self = [self init];
    if (self) {
        self.videoId = [self getVideoIdFromArbitraryString:videoId];
    }
    return self;
}

- (void)play
{
    [self.tracker updateWatchtime];
}

- (void)pause
{
    [self.tracker pauseTracking];
}

- (NSInteger)currentMediaTime
{
    return 0;//self.movie.currentTime.timeScale ? round(self.movie.currentTime.timeValue / self.movie.currentTime.timeScale) : 0;
}

- (NSURL *)channelThumbnailURL
{
    return self.channel.thumbnailUrl;
}

//- (QTMovie *)getMovieWithFormat:(FMYouTubeVideoFormat *)format
//{
//    self.url = [NSURL URLWithString:format.url];
//    return self.movie = [[QTMovie alloc] initWithURL:self.url error:nil];
//}
//
//- (QTMovie *)getMovieWithFormatIndex:(NSUInteger)index
//{
//    return [self getMovieWithFormat:[self.formats objectAtIndex:index]];
//}
//
//- (QTMovie *)getDefaultMovie
//{
//    if (!self.isYouTubeVideo) return [[QTMovie alloc] initWithURL:self.url error:nil];
//    return [self getMovieWithFormatIndex:0];
//}

- (NSData *)getVideoDataWithFormat:(FMYouTubeVideoFormat *)format
{
    NSURL *formatURL = [format url];
    return [NSData dataWithContentsOfURL:formatURL];
}

- (NSData *)getDataWithFormatIndex:(NSUInteger)index
{
    return [self getVideoDataWithFormat:[self.formats objectAtIndex:index]];
}

- (NSData *)getDefaultData
{
    return [self getDataWithFormatIndex:0];
}

- (void)like
{
    [self sendActionForEndpoint:self.client.likeLikeEndpoint];
}

- (void)dislike
{
    [self sendActionForEndpoint:self.client.likeDislikeEndpoint];
}

- (void)removeLike
{
    [self sendActionForEndpoint:self.client.likeRemoveLikeEndpoint];
}

- (NSDictionary *)sendActionForEndpoint:(NSURL *)endpoint
{
    return [self.client POSTRequest:endpoint withBody:[self rateBody] error:nil];
}

- (NSDictionary *)rateBody
{
    return @{@"context": self.client.context, @"target": @{@"videoId": self.videoId}};
}

- (NSDictionary *)actionBody
{
    NSDictionary *body = @{@"context": self.client.context, @"videoId": self.videoId};
    return body;
}

- (NSString *)getVideoIdFromArbitraryString:(NSString *)string
{
    NSString *result;
//    self.client.par wait morgan and morgan is real???
    NSDictionary *query = [self.client.parser dictionaryWithQueryFromURL:[NSURL URLWithString:string]];
    result = [query objectForKey:@"v"];
    
    if (!result) result = string;

    if (!result) result = string;
    return result;
}

- (BOOL)isUrl:(NSString *)string
{
    return [string hasPrefix:@"http"] || [string hasPrefix:@"www"];
}

- (void)updateTracker
{
    [self.tracker updateWatchtime];
}

+ (FMYouTubeVideo *)video
{
    return [[FMYouTubeVideo alloc] init];
}

+ (FMYouTubeVideo *)videoWithId:(NSString *)videoId
{
    return [[FMYouTubeVideo alloc] initWithId:videoId];
}

@end

//@implementation LVideoFormat
//
//
//
//@end
