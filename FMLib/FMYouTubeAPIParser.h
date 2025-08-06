//
//  LYoutubeApiParser.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 04/12/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMYouTubeProfile.h"
#import "FMYouTubeChannel.h"
#import "FMYouTubeVideo.h"
#import "FMYouTubeContinuation.h"

//@class LYouTubeVideo;
//@class LYPlaybackTracker;

@interface FMYouTubeAPIParser : NSObject

@property NSArray *webResponseContextPreloadData;
@property BOOL isLoggedIn;

- (NSArray *)parseVideosOnHomePage:(NSDictionary *)body;
- (NSArray *)parseBrowseEndpoint:(NSDictionary *)body;
- (FMYouTubeVideo *)parseVideo:(NSDictionary *)videoData;
- (void)addVideoData:(NSDictionary *)videoInfo toVideo:(FMYouTubeVideo *)video;
- (FMYouTubeProfile *)parseProfile:(NSDictionary *)body;
- (NSURL *)addParameters:(NSDictionary *)parameters toURL:(NSURL *)url;
- (NSDictionary *)dictionaryWithQueryFromURL:(NSURL *)url;
- (NSString *)stringByRemovingQueryFromURL:(NSURL *)url;
- (void)sendParameters:(NSDictionary *)parameters toEndpoint:(NSURL *)endpoint;

+ (FMYouTubeAPIParser *)parser;

@end
