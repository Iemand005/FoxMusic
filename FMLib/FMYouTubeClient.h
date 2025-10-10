//
//  FMYouTubeClient.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 04/12/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMYouTubeVideo.h"
#import "FMYouTubeAPIParser.h"

typedef enum FMYouTubeBaseAddressType {
    FMYouTubeBaseAddressDefault,
    FMYouTubeBaseAddressMusic,
    FMYouTubeBaseAddressAlternative
} FMYouTubeBaseAddressType;

typedef enum FMYouTubeClientName {
    FMYouTubeClientNameMobileWeb,
    FMYouTubeClientNameWebRemix
} FMYouTubeClientName;// FMYouTubeBaseAddressType;

@interface FMYouTubeClient : NSObject

@property (assign) NSURL *baseAddress;
@property (assign) NSURL *playerEndpoint;
@property (assign) NSURL *browseEndpoint;
@property (assign) NSURL *nextEndpoint;
@property (assign) NSURL *likeEndpoint;
@property (assign) NSURL *likeLikeEndpoint;
@property (assign) NSURL *likeDislikeEndpoint;
@property (assign) NSURL *likeRemoveLikeEndpoint;
@property (assign) NSURL *searchEndpoint;
@property (assign) NSURL *discoveryDocumentUrl;
@property (assign) NSURL *deviceAuthorizationEndpoint;
@property (assign) NSURL *tokenEndpoint;
@property (assign) NSURL *userInfoEndpoint;
@property (assign) NSURL *accountEndpoint;
@property (assign) NSURL *accountAccountMenuEndpoint;
@property (assign) NSURL *commentEndpoint;
@property (assign) NSURL *commentCreateCommentEndpoint;
@property (assign) NSURL *commentUpdateCommentEndpoint;
@property (assign) NSURL *commentPerformCommentActionEndpoint;

@property (assign) NSString *credentialFile;
@property (assign) NSString *key;

@property (assign) NSString *cookieString;
@property (assign) NSArray *cookieArray;

@property (assign) NSDictionary *context;

@property (assign) NSString *deviceCode;

@property (assign) NSString *scope;

@property (assign) NSString *accessToken;
@property (assign) NSString *refreshToken;
@property (assign) NSNumber *tokenExpiresIn;
@property (assign) NSDate *tokenCreatedOn;
@property (assign) NSString *tokenType;

@property (assign) NSString *clientId;
@property (assign) NSString *clientSecret;

@property (assign) NSLocale *locale;

@property (nonatomic, readonly) NSString *hostLanguage;
@property (nonatomic, readonly) NSString *gLanguage;

@property (assign) NSString *pageTitle;

@property (assign) NSString *name;
@property (assign) NSString *version;
@property (assign) NSString *browser;
@property (assign) NSString *browserVersion;
@property (assign) NSString *operatingSystem;
@property (assign) NSString *operatingSystemVersion;
@property (assign) NSString *platform;
@property (assign) NSString *player;

@property BOOL logAuthCredentials;
@property (assign) NSString *credentialLogPath;
@property (assign) NSArray *credentialLog;

@property BOOL isLoggedIn;

@property BOOL prettyPrint;

@property (assign) FMYouTubeAPIParser *parser;

@property (assign) FMYouTubeProfile *profile;

- (id)initWithBaseAddressType:(FMYouTubeBaseAddressType)baseAddressType;

- (NSDictionary *)POSTRequest:(NSURL *)url withBody:(NSDictionary *)body error:(NSError **)error;

- (FMYouTubeVideo *)getVideoWithId:(NSString *)videoId;
- (FMYouTubeVideo *)getVideo:(FMYouTubeVideo *)video;
- (FMYouTubeVideo *)getVideoWithId:(NSString *)videoId clientName:(FMYouTubeClientName)clientName;
- (FMYouTubeVideo *)getVideo:(FMYouTubeVideo *)video clientName:(FMYouTubeClientName)clientName;

- (id)requestContinuation:(FMYouTubeContinuation *)continuation;

- (NSDictionary *)getBrowseEndpoint;
- (NSDictionary *)getBrowseEndpointWithBrowseId:(NSString *)browseId;
- (NSDictionary *)getBrowseEndpointWithContinuation:(FMYouTubeContinuation *)continuation;

//- (BOOL)setClientName:(FMYouTubeClientName)clientName;

- (NSArray *)getHome;
- (NSArray *)getHomeWithContinuation:(FMYouTubeContinuation *)continuation;
- (NSArray *)getTrendingVideos;

- (NSDictionary *)getBearerAuthCode;
- (NSDictionary *)getBearerToken;

//- (NSDictionary *)loadAuthCredentials;
- (BOOL)loadAuthCredentials;
- (BOOL)saveAuthCredentials:(NSDictionary *)credentials;
- (BOOL)applyAuthCredentials:(NSDictionary *)credentials;
- (BOOL)refreshAuthCredentials;

//- (void)like;
//- (void)dislike;
//- (void)removeLike;

- (FMYouTubeProfile *)getUserInfo;
- (BOOL)applyUserProfile;
- (void)saveUserProfilePicture:(NSString *)path;

+ (FMYouTubeClient *)youtubeClient;
+ (FMYouTubeClient *)youtubeMusicClient;

@end
