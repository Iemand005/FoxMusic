//
//  LYPlaybackTracker.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 10/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMYouTubePlaybackTracker.h"
#import "FMYouTubeClient.h"
#import "FMYouTubeVideo.h"

@implementation FMYouTubePlaybackTracker

-(id)init
{
    self = [super init];
    if (self) {
        self.lact = -1;
        self.rtStart = [NSDate date];
//        self.muted = NO;
//        self.volume = 100;
        self.delay = 0;
        self.version = @2;
        self.hostLocale = [NSLocale currentLocale];
        self.length = @-1;
        self.startTime = @0;
        self.endTime = @0;
    }
    return self;
}
//}'\]]]]]]]opl09--- miniiiiii
- (id)initWithVideo:(FMYouTubeVideo *)video
{
    self = [self init];
    if (self) self.video = video;
    return self;
}

- (NSNumber *)currentMediaTime
{
//    QTTime time = self.video.movie.currentTime;
//    NSLog(@"%li, %li, %lli", time.flags, time.timeScale, time.timeValue);
    NSLog(@"%li", (long)self.video.currentMediaTime);
    return @(self.video.currentMediaTime);
    //return @(round(self.cmtStart ? [[NSDate date] timeIntervalSinceDate:self.cmtStart] : 0));
}

- (NSNumber *)fullMediaTime
{
    return @(round(self.fmtStart ? [[NSDate date] timeIntervalSinceDate:self.fmtStart] : 0));
}

- (NSNumber *)realTime //real time?
{
    return @(round(self.rtStart ? [[NSDate date] timeIntervalSinceDate:self.rtStart] : 0));
}

- (void)updateWatchtime
{
    self.startTime = self.endTime;
    self.endTime = self.currentMediaTime;
    [self pollTracker:self.watchtimeUrl];
}

- (void)startTracking
{
    self.fmtStart = [NSDate date];
    [self pollPlayback];
}

- (FMYouTubeClient *)client
{
    return self.video.client;
}

// pauses cmt
- (void)pauseTracking
{
    [self setPauseStart:[NSDate date]];
    [self pollTracker:self.delayplayUrl];
}

// Poll playback 5 seconds after the video starts playing. (elapsedMediaTimeSeconds?)
// start cmt timer.
- (void)pollPlayback
{
    [self pollTracker:self.playbackUrl];
}

- (void)continueTracking
{
    if ([self isPaused]) {NSTimeInterval pauseDuration = [[self pauseStart] timeIntervalSinceNow];
//    [[self fmtStart] ];
        self.fmtStart = [NSDate dateWithTimeInterval:pauseDuration sinceDate:[self fmtStart]];
        [self setPauseStart:nil];
    }
    
    [self pollTracker:self.watchtimeUrl];
    [self updateWatchtime];
}

- (NSNumber *)volume
{
    return @1; // needs to be
}

- (BOOL)muted
{
    return NO;//self.video.movie.muted;
}

- (BOOL)isPaused
{
    return !![self pauseStart];
}

- (void)pollTracker:(NSURL *)endpoint withParameters:(NSDictionary *)parameters
{
    NSDictionary *defaultParameters = @{
                                        @"cmt": self.currentMediaTime,
                                        @"rt": self.realTime,
                                        @"lact": @(self.lact),
//                                        @"ns": @"yt",
//                                        @"el": @"detailpage",
                                        @"cpn": [self randomStringWithLength:16],
                                        @"ver": self.version,
                                        @"fmt": self.fullMediaTime,
                                        @"fs": @"0",
                                        @"euri": @"",
//                                         @"live": @"dvr",
                                        @"state": @"playing",
                                        @"volume": self.volume,
                                        @"c": self.client,
                                        @"cbr": self.client.browser,
                                        @"cbrver": self.client.browserVersion,
                                        @"cplayer": self.client.player,
                                        @"cver": self.client.version,
                                        @"cos": self.client.operatingSystem,
                                        @"cosver": self.client.operatingSystemVersion,
                                        @"cplatform": self.client.player,
                                        @"delay": @(self.delay),
                                        @"hl": self.hostLocale,
                                        @"rtn": self.realTime,
                                        @"aftm": @0,
                                        @"rti": self.realTime,
                                        @"muted": @(self.muted),
                                        @"st": self.startTime,
                                        @"et": self.endTime,
                                        @"len": self.length
                                        };
    
    if (parameters && parameters.count) {
        NSMutableDictionary *combinedParameters = [NSMutableDictionary dictionaryWithDictionary:defaultParameters];
        [combinedParameters addEntriesFromDictionary:parameters];
        parameters = combinedParameters;
    } else {
        parameters = defaultParameters;
        //NSURL *spart = [self.client.parser addParameters:defaultParameters toURL:endpoint];
        //endpoint = spart;
    }
    if (![self isPaused]) {
        NSLog(@"help me to know %@, %@, %@", self.currentMediaTime, self.realTime, self.fullMediaTime);
        if (endpoint) [self.client.parser sendParameters:parameters toEndpoint:endpoint];
    }
}

NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";

-(NSString *) randomStringWithLength: (int) len {
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i = 0; i < len; i++)
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    return randomString;
}

- (void)pollTracker:(NSURL *)endpoint
{
    [self pollTracker:endpoint withParameters:nil];
}

- (void)playbackUrlGen
{
    /*
     
     Using InnerTube API is not always easy due to a complete lack of documentation.
     Here is my attempt at deciphering the things based on the info I can find:
     
     https://forums.anandtech.com/threads/how-does-youtube-track-your-viewing-activity.2522111/
     https://stackoverflow.com/questions/64900350/youtube-api-stats-qoe-metrics
     https://www.blackhatworld.com/seo/how-to-sent-http-request-to-youtube-stats-server.873021/
     https://www.blackhatworld.com/seo/interesting-script-to-get-youtube-views.1052157/
     https://unixforum.org/viewtopic.php?t=138376
     https://gist.github.com/omarroth/aa41eab7a91892ce47f9218d2e9e9e14
     https://stackoverflow.com/questions/78096984/you-tube-live-streaming-and-watch-time-api
     https://github.com/topics/youtube-view-bot
     
     -- Every 10 seconds by default for watchtime reports? Probably doesn't matter what interval we use. That means youtube has a max 10 second deviation on watch time in case of sudden shutdown it, probably registers on planned redirect more accurately if the destination is also youtube.
     
     https://s.youtube.com/api/stats/watchtime? -- watchtime parameters provided by the player endpoint
     cl=621014728&
     docid=tpAugZVbZKY&                 -- videoId
     ei=h-cSZpGNGbW46dsP5ZSskAM&
     fexp=                              -- Empty for MWEB, I assume this has to do with the frame size of the web player.
     ns=yt                              -- (name server) yt for youtube
     plid=AAYVhfVbHWI8tiZe&             -- Probably the ID if the player
     el=detailpage                      -- Might be what the user is looking at? leanback would mean video is perhaps full screen?
     len=1381                           -- The length of the video in seconds
     of=eGDgs4NW9AVjheAFzToDdg&
     vm=CAEQARgEOjJBSHFpSlRKSHlnanZ6Rl9UTlM5QU5BU2hza09EVFpiYnA0c05WWlRRNWJvVVh6RXp4UWJsQVBta0tETEMwQkt4S2JVOGpQU05HMExVNTFVMzl3MFNCSzVMbFVocC1vQzlrVlc5c2xSMTA4SGt3SnZrTHh2SnEzSEtpbEg0WjNZb3pBMkVaM0p2ZExBQXlQdV85VEhNa05hVzlDRy1ZdkpjaAI
     
     el=leanback                        -- !! leanback, detailpage
     cpn=pHI_kIxZU60G7s9O               -- random?
     docid=s8etPjZUDqA                  -- !! (document id) Youtube video ID. videoId
     ver=2                              -- ?? some version
     referrer=https://www.example.com/  -- The referrer url.
     
     --> c stands for client?
     --> t stands for time?
     --> br stands for browser.
     --> os stands for operating system.
     --> ver stands for version.
     --> pl stands for player.
     --> mt probably stands for media time
     --> hl stands for host language
     c=TVHTML5                          -- Name of the client.
     cver=5.20160729                    -- Version of the client. (client version) --> major.YYMMDD.minor.patch
     cplayer=UNIPLAYER                  -- Name of the player. (client player), type of the player, UNIPLAYER --> WEB  
     cbr=Firefox                        -- Name of the browser. (client browser)
     cbrver=61.0                        -- (client browser version)
     cos=Windows                        -- Operating system of the client (client operating system)
     cosver=10.0                        -- (client operating system version)
     cplatform                          -- client platform
     
     cmt=5                              -- ?? client mean time ?? custom machine type?? current machint time?
     plid=AAV0SnP6Z3iATk9B              -- is this the user id? player ID ?
     ei=A2O1suGlUhr9gN5YtjjHZu          -- !! not necessary?
     fmt=244                            -- ?? is the same for all requests, example: 244
     fs=0
     rt=10
     of=pp2cCVN4J3hdMWZP-Fb8dw          -- !!
     euri                               -- (europe innertube?) the server region to use
     lact=3809                          -- ?? latency at current time?
     cl=209783907
     state=playing                      -- (state) playing if the player is playing
     vm=CAIQABgE...                     -- !! base64 encoded: 6 bytes - : - encrypted data
     volume=55                          -- (volume) the volume at which the video is playing

     hl=en_US                           -- (host language)
     cr=TR                              -- current region?
     len=175                            -- !! Length of the video in seconds. (length)
     rtn=15
     afmt=251
     idpj=-6
     ldpj=-1
     rti=4
     muted=0                            -- BOOLEAN (muted) -> is the video muted?
     st=0                               -- (start time?)
     et=5
     fexp=...                           -- Frame experience ??
     seq                                -- for qoe Not required, Sequence number for packets
     bwe                                -- for qoe ?? the time the page was open ??
     
    ?? stationary values
     fmt: 244
     len=175 ?
    // playback
    cmt: 0                              -- this one seems to increase witht he watch time!
    
    // delayplay
     cmt=10.299
     afmt               -- the same for both delayplay and playback, example: 251
     
    // watchtime 1
     
     et                                 -- This is the time at which the video is currently played! only for watchtime api
     st                                 -- works together wtih et? perhaps start time and end time, the intervals of the video play
     cmt                                -- asme value as et? 
     // watchtime 2
     
     st             -- if the previous watchtime request had et 5, the st of this one is also 5.
     rti            -- if rt of the delayplay is 15, rti of the next watchtime is also 15
     rtn            -- both values seem to increase over time, rtn increases more than rti
     
     
     Let's watch the interesting values between two requets:
     
     - Playback
     
     cmt=0          -- cmt is 0 at start of video
     rt=5
     lact=-1        -- lact is probably -1 on all playback requests. this suggest that it is latency?
     rtn=5          -- rtn and rt match
     
     - Delayplay
     
     cmt=10.299
     rt=15
     lact=605
     
     - Watchtime 1
     
     cmt=5      -- seems to match the end time. potentially the amount of time the video was played.
     rt=10
     lact=3809
     rtn=15
     rti=4
     st=0       -- start time 0 for first watchtime
     et=5       -- end time, probably the time the video was at at the moment the watchtime request was sent.
     
     - Watchtime 2
     
     cmt=154
     rt=159
     lact=971   -- latency? appears to be random, likely latency in ms.
     rtn=199
     rti=159
     st=5       -- the et time of the previous watchtime request?
     et=154     -- likely again the time the video is at at time of sending watchtime.
     
     
     
     ---- all parameters found ----
     
     fmt:   Full Media Time
     afmt: ?
     cpn: ?
     ei: ?
     el: ?
     docid: Video Hash (same as: /watch?v=<video_hash>)
     ns: Most likely @"Name Server" because value is yt short for YouTube
     fexp: Values separated by commas, no idea but seem to start with 23-24 in most cases.
     cl: ?
     seq: Sequence number for packets
     cbr: Client Browser (Chrome, Firefox)
     cbrver: Client Browser version (version of Chrome or Firefox)
     c: Client, so if website is open, this will be WEB. Mobile might have something else.
     cver: Client Version major.YYMMDD.minor.patch
     cplayer: Client Player, Kind of player used. UNIPLAYER for web.
     cos: Client OS, Windows/Linux/Mac
     cosver: Client OS version, 10.0 will be Windows 10 (in combination with cos)
     cplatform: Client Platform: eg. DESKTOP
     cmt: ? But not always present
     vps: ?
     user_intent: ?
     bwm: ? But all following values seem related, they are always close together
     bwe: ? Always seem to increase once page is open, so maybe time user has watched the video?
     bat: ?
     vis: ?
     bh: ?
     df: ?
     ?*/
}

+ (FMYouTubePlaybackTracker *)tracker
{
    return [[FMYouTubePlaybackTracker alloc] init];
}

+ (FMYouTubePlaybackTracker *)trackerForVideo:(FMYouTubeVideo *)video
{
//    LYPlaybackTracker *tracker = [LYPlaybackTracker tracker];
    return [[FMYouTubePlaybackTracker alloc] initWithVideo:video];
}

@end
