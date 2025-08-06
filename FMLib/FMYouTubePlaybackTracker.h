//
//  LYPlaybackTracker.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 04/12/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//
//  The playback tracker stores the watch time of the current video to make it count as a view and allow the user to continue watching where they left off.
//

#import <Foundation/Foundation.h>

@class FMYouTubeClient;
@class FMYouTubeVideo;

@interface FMYouTubePlaybackTracker : NSObject

@property NSURL *playbackUrl;
@property NSURL *watchtimeUrl;
@property NSURL *delayplayUrl;
@property NSURL *ptrackingUrl;
@property NSURL *qoeUrl;
@property NSURL *atrUrl;

@property NSDate *rtStart;
@property NSDate *cmtStart;
@property NSDate *fmtStart;
@property NSDate *pauseStart;

@property FMYouTubeVideo *video;
@property (readonly, nonatomic) FMYouTubeClient *client;
@property (readonly, nonatomic) NSNumber *currentMediaTime;     // Current media time in video.
@property (readonly, nonatomic) NSNumber *fullMediaTime;        // Total time of video watched.
@property (readonly, nonatomic) NSNumber *realTime;             // Real time.
@property NSNumber *startTime;                                  // Start time. (end time of previous watchtime event)
@property NSNumber *endTime;                                    // End time. (current media time)
@property NSInteger lact;                                       // Latency time?
@property (readonly, nonatomic) NSNumber *volume;
@property (readonly, nonatomic) BOOL muted;
@property (readonly, nonatomic) BOOL isPaused;
@property NSInteger delay;
@property NSLocale *hostLocale;
@property NSString *clientVersion;
@property NSNumber *version;
@property NSNumber *length;

@property NSArray *scheduledFlushWalltimeSeconds;
@property NSNumber *defaultFlushIntervalSeconds;

- (void)updateWatchtime;
- (void)startTracking;
- (void)pauseTracking;
- (void)continueTracking;

+ (FMYouTubePlaybackTracker *)tracker;
+ (FMYouTubePlaybackTracker *)trackerForVideo:(FMYouTubeVideo *)video;

@end
