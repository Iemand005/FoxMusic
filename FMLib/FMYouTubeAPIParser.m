//
//  LYoutubeApiParser.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 8/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMYouTubeAPIParser.h"

@implementation FMYouTubeAPIParser

- (NSArray *)parseVideosOnHomePage:(NSDictionary *)body
{
     NSMutableArray *videos = [NSMutableArray array];
    NSString *trackingParams = [body objectForKey:@"trackingParams"];
    [body writeToFile:[NSString stringWithFormat:@"homePage%@.plist", trackingParams] atomically:NO];
    
    NSDictionary *responseContext = [body objectForKey:@"responseContext"];
        NSInteger *lastRendererindex = 0;
    NSArray *preloadMessageNames = [self traverse:@[@"webResponseContextExtensionData", @"webResponseContextPreloadData", @"preloadMessageNames"] on:responseContext];
//    [[[responseContext objectForKey:@"webResponseContextExtensionData"] objectForKey:@"webResponseContextPreloadData"] objectForKey:@"preloadMessageNames"];
    NSUInteger tabRendererIndex = [preloadMessageNames indexOfObject:@"tabRenderer"];
    if (tabRendererIndex != NSNotFound) {
    NSString *listRenderer = [preloadMessageNames objectAtIndex:tabRendererIndex + 1];
    NSString *itemRenderer = [preloadMessageNames objectAtIndex:tabRendererIndex + 2];
        NSString *videoRenderer = @"videoWithContextRenderer";
//    self.isLoggedIn;
    
   
    NSArray *tabs = [self traverse:@[@"contents", @"singleColumnBrowseResultsRenderer", @"tabs"] on:body];
    for (NSDictionary *tab in tabs) {
        NSDictionary *tabContent = [[tab objectForKey:@"tabRenderer"] objectForKey:@"content"];
        NSDictionary *richRenderer = [tabContent objectForKey:listRenderer];
        NSArray *videoDataList = [richRenderer objectForKey:@"contents"];
        for (NSDictionary *videoData in videoDataList) {
            NSDictionary *renderer = [videoData objectForKey:itemRenderer];
            if (renderer) {
                NSDictionary *content = [renderer objectForKey:@"content"];
                NSArray *contents;
                if (content) contents = [NSArray arrayWithObject:content];
                else contents = [renderer objectForKey:@"contents"];
                for (NSDictionary *content in contents) {
                    NSDictionary *videokak = [content objectForKey:videoRenderer];
                    if (videokak) {
                        FMYouTubeVideo *video = [self parseVideo:videokak];
                        [videos addObject:video];
                    }
                }
            } else {
                NSArray *path = @[@"continuationItemRenderer", @"continuationEndpoint", @"continuationCommand"];
                NSDictionary *continuation = [self traverse:path on:videoData];
                [videos addObject:[self parseContinuation:continuation]];
//                renderer = [videoData objectForKey:@"continuationItemRenderer"];
            }
        }
    }
    } else {
//        NSArray *videoRenderes = [self traverse:@[@"onResponseReceivedActions", @0, @"appendContinuationItemsAction", @"continuationItems"] on:body];
        NSArray *videoRenderes =[self traverse:@[@"onResponseReceivedActions", @0, @"appendContinuationItemsAction", @0] on:body];
        for (NSDictionary *videoRenderer in videoRenderes) {
            FMYouTubeVideo *video = [self parseVideo:videoRenderer];
            [videos addObject:video];
        }
    }
    return videos;
}

- (id)traverse:(NSArray *)path on:(id)body
{
//    id result;
    for (id key in path) {
        if ([key isKindOfClass:[NSNumber class]]) {
//            NSNumber *number = object;
//            body = [body isKindOfClass:[NSArray class]] ? [body objectAtIndex:[key integerValue]]
//            if ([body isKindOfClass:[NSArray class]]) body = [body objectAtIndex:[key integerValue]];
//            else  body = [[body allValues] objectAtIndex:[key integerValue]]; //[[[NSDictionary alloc] allValues] objectAtIndex:0];
            if ([body isKindOfClass:[NSDictionary class]]) body = [body allValues];
            body = [body objectAtIndex:[key integerValue]];
        } else body = [body objectForKey:key];
    }
    return body;
}

- (FMYouTubeContinuation *)parseContinuation:(NSDictionary *)body
{
    FMYouTubeContinuation *continuation = [FMYouTubeContinuation continuation];
    NSDictionary *continuationEndpoint = [body objectForKey:@"continuationEndpoint"];
    if (continuationEndpoint)
        body = [continuationEndpoint objectForKey:@"continuationCommand"];
    
    if ([[body objectForKey:@"request"] isEqualToString:LYContinuationRequestTypeBrowse]) continuation.request = LYContinuationRequestTypeBrowse;
    continuation.token = [body objectForKey:@"token"];
    if (continuation.token && continuation.request) continuation.body = body;
    return continuation;
}

- (FMYouTubeVideo *)parseVideo:(NSDictionary *)videoData
{
    FMYouTubeVideo *video = [FMYouTubeVideo video];
    
    NSDictionary *playabilityStatus = [videoData objectForKey:@"playabilityStatus"];
    if (playabilityStatus) {
        if ([[playabilityStatus objectForKey:@"status"] isEqualToString:@"OK"])
            NSLog(@"Playability OK");
        
        NSDictionary *streamingData = [videoData objectForKey:@"streamingData"];
        
        NSArray *formats = [streamingData objectForKey:@"formats"];
        //NSArray *adaptiveFormats = [streamingData objectForKey:@"adaptiveFormats"];
        
        // https://gist.github.com/sidneys/7095afe4da4ae58694d128b1034e01e2
        NSMutableArray *parsedFormats = [NSMutableArray arrayWithCapacity:formats.count];
        for (NSDictionary *format in formats)
            [parsedFormats addObject:[FMYouTubeVideoFormat formatWithDictionary:format]];
//        for (NSDictionary *format in adaptiveFormats) [parsedFormats addObject:[LYVideoFormat formatWithDictionary:format]];
        video.formats = parsedFormats;
        
        NSDictionary *videoDetails = [videoData objectForKey:@"videoDetails"];
        video.description = [videoDetails objectForKey:@"shortDescription"];
        video.title = [videoDetails objectForKey:@"title"];
        video.viewCount = [videoDetails objectForKey:@"viewCount"];
        [video setTracker:[self parsePlaybackTracker:[videoData objectForKey:@"playbackTracking"]]];
    } else {
//        NSDictionary *continuationItemRenderer = [videoData objectForKey:@"continuationItemRenderer"];
//        if (continuationItemRenderer) {
//            LYContinuation *continuation = [self parseContinuation:continuationItemRenderer];
//            return continuation;
//        } else {
            NSDictionary *richItemRenderer = [videoData objectForKey:@"richItemRenderer"];
            if (richItemRenderer)
                videoData = [self traverse:@[@"content", @0] on:richItemRenderer];
            else {
                NSDictionary *continuationItemRenderer = [videoData objectForKey:@"continuationItemRenderer"];
                if (continuationItemRenderer) {
                    FMYouTubeContinuation *continuation = [self parseContinuation:continuationItemRenderer];
                    return (FMYouTubeVideo *)continuation;
                }
            }
            
            NSString *videoId = [videoData objectForKey:@"videoId"];
        
            NSString *videoTitle = [[[[videoData objectForKey:@"headline"] objectForKey:@"runs"] firstObject] objectForKey:@"text"];
            if (!videoTitle) videoTitle = [self runText:[videoData objectForKey:@"title"]];
            
            NSDictionary *thumbnailData = [[[videoData objectForKey:@"thumbnail"] objectForKey:@"thumbnails"] lastObject];
            NSURL *thumbnailUrl = [NSURL URLWithString:[thumbnailData objectForKey:@"url"]];
            
            NSString *shortStats = [[[[videoData objectForKey:@"shortViewCountText"] objectForKey:@"runs"] firstObject] objectForKey:@"text"];
            NSString *shortLength = [[[[videoData objectForKey:@"lengthText"] objectForKey:@"runs"] firstObject] objectForKey:@"text"];
            NSString *shortTime = [self runText:[videoData objectForKey:@"publishedTimeText"]];
        
        
            video.lengthText = shortLength;
            video.shortStats = [shortStats stringByAppendingFormat:@" - %@", shortTime];

            video.videoId = videoId;
            FMYouTubeChannel *channel = [self parseChannel:[videoData objectForKey:@"channelThumbnail"]];
            NSString *channelName = [[[[videoData objectForKey:@"shortBylineText"] objectForKey:@"runs"] firstObject] objectForKey:@"text"];
            [channel setName:channelName];
            [video setChannel:channel];
            [video setThumbnailURL:thumbnailUrl];
            [video setTitle:videoTitle];
//        }
    }
    return video;
}

- (NSString *)runText:(NSDictionary *)body
{
    NSDictionary *text = [body objectForKey:@"text"];
    return [[[text ? text : body objectForKey:@"runs"] firstObject] objectForKey:@"text"];
}

- (NSString *)accessibilityText:(NSDictionary *)body
{
    return [[[body objectForKey:@"accessibility"] objectForKey:@"accessibilityData"] objectForKey:@"label"];
}

- (FMYouTubeChannel *)parseChannel:(NSDictionary *)channelData
{
    FMYouTubeChannel *youtubeChannel;
    NSDictionary *data;
    if ((data = [channelData objectForKey:@"channelThumbnailWithLinkRenderer"])) {
        youtubeChannel = [FMYouTubeChannel channel];
//        [[[NSArray alloc] init] l]
        NSDictionary *thumbnailData = [[[data objectForKey:@"thumbnail"] objectForKey:@"thumbnails"] firstObject];
        NSString *thumbnailUrl = [thumbnailData objectForKey:@"url"];
//        NSString *videoTitle = [[[[data objectForKey:@"headline"] objectForKey:@"runs"] firstObject] objectForKey:@"text"];
        
        NSDictionary *channelEndpoint = [[data objectForKey:@"navigationEndpoint"] objectForKey:@"browseEndpoint"];
//        NSNumber *thumbnailWidth = [thumbnailData objectForKey:@"width"];
//        NSNumber *thumbnailHeight = [thumbnailData objectForKey:@"height"];
        NSURL *cturl = [NSURL URLWithString:thumbnailUrl];
        NSString *fileName = [[cturl pathComponents] lastObject];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
            [youtubeChannel setThumbnailWithURL:[NSURL URLWithString:fileName]];
        }else
        [youtubeChannel setThumbnailWithURL:cturl];
        [youtubeChannel setTag:[channelEndpoint objectForKey:@"canonicalBaseUrl"]];
        [youtubeChannel setBrowseId:[channelEndpoint objectForKey:@"browseId"]];
    }
    return youtubeChannel;
}

- (FMYouTubeProfile *)parseProfile:(NSDictionary *)body
{
    FMYouTubeProfile *profile = [FMYouTubeProfile profile];
    profile.name = [body objectForKey:@"name"];
    profile.givenName = [body objectForKey:@"given_name"];
    profile.familyName = [body objectForKey:@"family_name"];
    profile.locale = [body objectForKey:@"name"];
    profile.pictureUrl = [NSURL URLWithString:[body objectForKey:@"picture"]];
//    profile.picture = [[NSImage alloc] initByReferencingURL:profile.pictureUrl];
    profile.sub = [body objectForKey:@"sub"];
    return profile;
}

- (FMYouTubePlaybackTracker *)parsePlaybackTracker:(NSDictionary *)body
{
    FMYouTubePlaybackTracker *tracker = [FMYouTubePlaybackTracker tracker];
    tracker.playbackUrl = [self trackerUrlFrom:body withKey:@"videostatsPlaybackUrl"];
    tracker.delayplayUrl = [self trackerUrlFrom:body withKey:@"videostatsDelayplayUrl"];
    tracker.watchtimeUrl = [self trackerUrlFrom:body withKey:@"videostatsWatchtimeUrl"];
    tracker.ptrackingUrl = [self trackerUrlFrom:body withKey:@"ptrackingUrl"];
    tracker.qoeUrl = [self trackerUrlFrom:body withKey:@"qoeUrl"];
    tracker.atrUrl = [self trackerUrlFrom:body withKey:@"atrUrl"];
    tracker.scheduledFlushWalltimeSeconds = [body objectForKey:@"videostatsScheduledFlushWalltimeSeconds"];
    tracker.defaultFlushIntervalSeconds = [body objectForKey:@"videostatsDefaultFlushIntervalSeconds"];
    return tracker;
}

- (NSURL *)trackerUrlFrom:(NSDictionary *)body withKey:(NSString *)key
{
    return [NSURL URLWithString:[[body objectForKey:key] objectForKey:@"baseUrl"]];
}

- (NSDictionary *)dictionaryWithQueryFromURL:(NSURL *)url
{
    NSString *query = url.query;
    NSArray *queryParameterStrings = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionaryWithCapacity:queryParameterStrings.count];
    for (NSString *queryParameterString in queryParameterStrings) {
        NSArray *queryParameterComponents = [queryParameterString componentsSeparatedByString:@"="];
        [queryParameters setObject:[queryParameterComponents objectAtIndex:1] forKey:[queryParameterComponents objectAtIndex:0]];
    }
    return queryParameters;
}

- (NSURL *)addParameters:(NSDictionary *)parameters toURL:(NSURL *)url
{
    NSDictionary *oldParameters = [self dictionaryWithQueryFromURL:url];
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:oldParameters];
    [newParams addEntriesFromDictionary:parameters];
    NSMutableString *newUrlString = [NSMutableString stringWithString:[self stringByRemovingQueryFromURL:url]];
    if (newParams.count) {
        NSMutableArray *parameterParts = [NSMutableArray arrayWithCapacity:newParams.count];
        for (NSString *key in newParams) [parameterParts addObject:[NSString stringWithFormat:@"%@=%@", key, [newParams objectForKey:key]]];
        [newUrlString appendFormat:@"?%@", [parameterParts componentsJoinedByString:@"&"]];
    }
    NSString *escapedString = [newUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    url = [NSURL URLWithString:escapedString];
    return url;
}

- (NSString *)stringByRemovingQueryFromURL:(NSURL *)url
{
    return [[url.absoluteString componentsSeparatedByString:@"?"] objectAtIndex:0];
}

- (void)sendParameters:(NSDictionary *)parameters toEndpoint:(NSURL *)endpoint
{
    endpoint = [self addParameters:parameters toURL:endpoint];
    NSLog(@"%@", endpoint);
    [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:endpoint] returningResponse:nil error:nil];
}

- (void)addVideoData:(NSDictionary *)videoData toVideo:(FMYouTubeVideo *)video
{
    NSDictionary *videoContents = [videoData objectForKey:@"contents"];
    if (videoContents) {
        NSArray *videoResultContents = [[[[videoContents objectForKey:@"singleColumnWatchNextResults"] objectForKey:@"results"] objectForKey:@"results"] objectForKey:@"contents"];
        for (NSDictionary *videoResultContent in videoResultContents) {
            NSDictionary *videoMetadata = [videoResultContent objectForKey:@"slimVideoMetadataSectionRenderer"];
            if (videoMetadata) {
                NSDictionary *videoMetadataContents = [videoMetadata objectForKey:@"contents"];
                for (NSDictionary *videoMetadataContent in videoMetadataContents) {
                    NSDictionary * videoInformationRenderer = [videoMetadataContent objectForKey:@"slimVideoInformationRenderer"];
                    if (videoInformationRenderer) {
//                    NSDictionary *videoInformationRenderer = [videoMetadataContent objectForKey:@"slimVideoInformationRenderer"];
                    NSString *title = [self runText:[videoInformationRenderer objectForKey:@"title"]];
                    if (title) [video setTitle:title];
                    NSString *collapsedSubtitle = [self runText:[videoInformationRenderer objectForKey:@"collapsedSubtitle"]];
                    if (collapsedSubtitle) [video setSubtitle:collapsedSubtitle];
                    } else{
                        NSDictionary *actionBarRenderer = [videoMetadataContent objectForKey:@"slimVideoActionBarRenderer"];
                        if (actionBarRenderer) {
                            NSDictionary *segmentedViewModel = [[[[[actionBarRenderer objectForKey:@"buttons"] firstObject] objectForKey:@"slimMetadataButtonRenderer"] objectForKey:@"button"] objectForKey:@"segmentedLikeDislikeButtonViewModel"];
                            // I quit this is way too much, I need to know where the liked state is.
                        }
                    }
                }
                
            } else {
//                videoMetadata = [videoResultContent objectForKey:@"itemSectionRenderer"];
//                if (videoMetadata) {
//                    NSDictionary *contents = [videoMetadata objectForKey:@"contents"];
//                    
//                }
            }
        }
    } else {
        NSDictionary *playabilityStatus = [videoData objectForKey:@"playabilityStatus"];
        if (playabilityStatus) { // this one is for the player API
            if ([[playabilityStatus objectForKey:@"status"] isEqualToString:@"OK"])
                NSLog(@"Playability OK");
            
            NSDictionary *streamingData = [videoData objectForKey:@"streamingData"];
            
            NSArray *formats = [streamingData objectForKey:@"formats"];
            //NSArray *adaptiveFormats = [streamingData objectForKey:@"adaptiveFormats"];
            
            // https://gist.github.com/sidneys/7095afe4da4ae58694d128b1034e01e2
            NSMutableArray *parsedFormats = [NSMutableArray arrayWithCapacity:formats.count];
            for (NSDictionary *format in formats)
                [parsedFormats addObject:[FMYouTubeVideoFormat formatWithDictionary:format]];
            //        for (NSDictionary *format in adaptiveFormats) [parsedFormats addObject:[LYVideoFormat formatWithDictionary:format]];
            video.formats = parsedFormats;
            
            NSDictionary *videoDetails = [videoData objectForKey:@"videoDetails"];
            video.description = [videoDetails objectForKey:@"shortDescription"];
            video.title = [videoDetails objectForKey:@"title"];
            video.viewCount = [videoDetails objectForKey:@"viewCount"];
            [video setTracker:[self parsePlaybackTracker:[videoData objectForKey:@"playbackTracking"]]];
        } else {
            NSString *videoId = [videoData objectForKey:@"videoId"];
            NSString *videoTitle = [[[[videoData objectForKey:@"headline"] objectForKey:@"runs"] firstObject] objectForKey:@"text"];
            
            NSDictionary *thumbnailData = [[[videoData objectForKey:@"thumbnail"] objectForKey:@"thumbnails"] lastObject];
            NSURL *thumbnailUrl = [NSURL URLWithString:[thumbnailData objectForKey:@"url"]];
            
            NSString *shortStats = [[[[videoData objectForKey:@"shortViewCountText"] objectForKey:@"runs"] firstObject] objectForKey:@"text"];
            NSString *shortLength = [[[[videoData objectForKey:@"lengthText"] objectForKey:@"runs"] firstObject] objectForKey:@"text"];
            NSString *shortTime = [self runText:[videoData objectForKey:@"publishedTimeText"]];
            video.lengthText = shortLength;
            video.subtitle = [shortStats stringByAppendingFormat:@" - %@", shortTime];
//            video.
            video.videoId = videoId;
            FMYouTubeChannel *channel = [self parseChannel:[videoData objectForKey:@"channelThumbnail"]];
            NSString *channelName = [[[[videoData objectForKey:@"shortBylineText"] objectForKey:@"runs"] firstObject] objectForKey:@"text"];
            [channel setName:channelName];
            [video setChannel:channel];
            [video setThumbnailURL:thumbnailUrl];
            [video setTitle:videoTitle];
        }
    }
}

- (NSArray *)parseBrowseEndpoint:(NSDictionary *)body
{
    NSMutableArray *videos = [NSMutableArray array];
    NSDictionary *contents = [body objectForKey:@"contents"];
    NSArray *tabs = [[contents objectForKey:@"singleColumnBrowseResultsRenderer"] objectForKey:@"tabs"];
    for (NSDictionary *tab in tabs) { // tabs like FEmusic_home
        NSDictionary *tabRenderer = [tab objectForKey:@"tabRenderer"];
        
        // This sectionlistrenderer thing has continuation, needs to be handelled later
        NSArray *musicRenderers = [[[tabRenderer objectForKey:@"content"] objectForKey:@"sectionListRenderer"] objectForKey:@"contents"];
        for (NSDictionary *musicRenderer in musicRenderers) {
            
            NSDictionary *musicShelfRenderer = [musicRenderer objectForKey:@"musicCarouselShelfRenderer"];
            if (!musicShelfRenderer) musicShelfRenderer = [musicRenderer objectForKey:@"musicTastebuilderShelfRenderer"];
            
            // These shelves have a title, they can be categorised in the app later
            NSArray *musicRendererContents = [musicShelfRenderer objectForKey:@"contents"];
            
            for (NSDictionary *musicRendererContent in musicRendererContents) {
                NSDictionary *videoRenderer = [musicRendererContent objectForKey:@"musicResponsiveListItemRenderer"];
                
                NSString *videoId = [[videoRenderer objectForKey:@"playlistItemData"] objectForKey:@"videoId"];
                
                NSString *videoTitle = [self runText:[[[videoRenderer objectForKey:@"flexColumns"] firstObject] objectForKey:@"musicResponsiveListItemFlexColumnRenderer"]];
                
                NSString *thumbnailImageLink = [[[[videoRenderer objectForKey:@"thumbnail"] objectForKey:@"thumbnails"] firstObject] objectForKey:@"url"];
                
                FMYouTubeVideo *video = [FMYouTubeVideo videoWithId:videoId];
                [video setThumbnailURL:[NSURL URLWithString:thumbnailImageLink]];
                [video setTitle:videoTitle];

                [videos addObject:video];
            }
        }
    }
    return videos;
}

- (id)firstKeyOf:(id)object times:(NSInteger)times
{
//    id nextDict;
    for (int i = 0; i < times; ++i) {
        object = [object firstObject];
    }
    return object;
}

+ (FMYouTubeAPIParser *)parser
{
    return [[FMYouTubeAPIParser alloc] init];
}

@end
