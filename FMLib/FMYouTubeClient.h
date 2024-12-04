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

@property NSURL *baseAddress;
@property NSURL *playerEndpoint;
@property NSURL *browseEndpoint;
@property NSURL *nextEndpoint;
@property NSURL *likeEndpoint;
@property NSURL *likeLikeEndpoint;
@property NSURL *likeDislikeEndpoint;
@property NSURL *likeRemoveLikeEndpoint;
@property NSURL *searchEndpoint;
@property NSURL *discoveryDocumentUrl;
@property NSURL *deviceAuthorizationEndpoint;
@property NSURL *tokenEndpoint;
@property NSURL *userInfoEndpoint;
@property NSURL *accountEndpoint;
@property NSURL *accountAccountMenuEndpoint;
@property NSURL *commentEndpoint;
@property NSURL *commentCreateCommentEndpoint;
@property NSURL *commentUpdateCommentEndpoint;
@property NSURL *commentPerformCommentActionEndpoint;

@property NSString *credentialFile;
@property NSString *key;

@property NSString *cookieString;
@property NSArray *cookieArray;

@property NSDictionary *context;

@property NSString *deviceCode;

@property NSString *scope;

@property NSString *accessToken;
@property NSString *refreshToken;
@property NSNumber *tokenExpiresIn;
@property NSDate *tokenCreatedOn;
@property NSString *tokenType;

@property NSString *clientId;
@property NSString *clientSecret;

@property NSLocale *locale;

@property (nonatomic, readonly) NSString *hostLanguage;
@property (nonatomic, readonly) NSString *gLanguage;

@property NSString *pageTitle;

@property NSString *name;
@property NSString *version;
@property NSString *browser;
@property NSString *browserVersion;
@property NSString *operatingSystem;
@property NSString *operatingSystemVersion;
@property NSString *platform;
@property NSString *player;

@property BOOL logAuthCredentials;
@property NSString *credentialLogPath;
@property NSArray *credentialLog;

@property BOOL isLoggedIn;

@property BOOL prettyPrint;

@property FMYouTubeAPIParser *parser;

@property FMYouTubeProfile *profile;

- (id)initWithBaseAddressType:(FMYouTubeBaseAddressType)baseAddressType;

- (NSDictionary *)POSTRequest:(NSURL *)url withBody:(NSDictionary *)body error:(NSError **)error;
- (FMYouTubeVideo *)getVideoWithId:(NSString *)videoId;
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
