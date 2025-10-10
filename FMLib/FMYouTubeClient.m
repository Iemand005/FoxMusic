//
//  FMYouTubeClient.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 04/12/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMYouTubeClient.h"

@implementation FMYouTubeClient



- (id)initWithBaseAddressType:(FMYouTubeBaseAddressType)baseAddressType
{
    self = [super init];
    if (self) {
        // https://github.com/iv-org/invidious/issues/1981
        
        //        id a = @[@(NO)];
        
        NSURL *baseAddress;
        
        self.name = @"MWEB"; // YTMusic uses WEB_REMIX, otherwise MWEB
        self.version = @"1.20250915.03.00";
        self.browser = @"Firefox";
        self.browserVersion = @"10000";
        self.player = @"";
        //        self.version = @"5";
        self.operatingSystem = @"Mac OS X";
        self.operatingSystemVersion = @"10.7";
        self.platform = @"MacOS";
        
        switch (baseAddressType) {
            case FMYouTubeBaseAddressMusic:
                baseAddress = [NSURL URLWithString:@"https://music.youtube.com/youtubei/v1"];
                self.name = @"WEB_REMIX";
                self.version = @"1.20250915.03.00";
                break;
            case FMYouTubeBaseAddressAlternative:
                baseAddress = [NSURL URLWithString:@"https://youtubei.googleapis.com/youtubei/v1"];
                break;
            default:
                baseAddress = [NSURL URLWithString:@"https://www.youtube.com/youtubei/v1"];
        }
        
        [self setBaseAddress:baseAddress];
        
        [self setPrettyPrint:NO];
        
        [self setCredentialFile:@"auth.plist"];
        
        [self setKey:@"AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8"]; // Everyone has the same key, the key isn't even required. I'm just gonna leave this here lol.
        
        [self setClientId:@"861556708454-d6dlm3lh05idd8npek18k6be8ba3oc68.apps.googleusercontent.com"];
        [self setClientSecret:@"SboVhoG9s0rNafixCSGGKXAT"];
        
        [self setScope:@"https://www.googleapis.com/auth/youtube https://www.googleapis.com/auth/userinfo.profile"];
        
        [self setDiscoveryDocumentUrl:[NSURL URLWithString:@"https://accounts.google.com/.well-known/openid-configuration"]];
        
        NSDictionary *openIDConfig = [self getOpenIDConfiguration];
        self.deviceAuthorizationEndpoint = [NSURL URLWithString:[openIDConfig objectForKey:@"device_authorization_endpoint"]];
        self.tokenEndpoint = [NSURL URLWithString:[openIDConfig objectForKey:@"token_endpoint"]];
        self.userInfoEndpoint = [NSURL URLWithString:[openIDConfig objectForKey:@"userinfo_endpoint"]];
        
        [self setLocale:[NSLocale systemLocale]];
        [self setContext:@{@"client": @{@"clientName": self.name, @"clientVersion": self.version, @"hl": self.hostLanguage, @"gl": self.gLanguage}, @"user":@{}}];
        
        
        
        self.playerEndpoint = [baseAddress URLByAppendingPathComponent:@"player"];
        self.nextEndpoint = [baseAddress URLByAppendingPathComponent:@"next"];
        self.browseEndpoint = [baseAddress URLByAppendingPathComponent:@"browse"];
        self.searchEndpoint = [baseAddress URLByAppendingPathComponent:@"search"];
        
        self.likeEndpoint = [baseAddress URLByAppendingPathComponent:@"like"];
        self.likeLikeEndpoint = [self.likeEndpoint URLByAppendingPathComponent:@"like"];
        self.likeDislikeEndpoint = [self.likeEndpoint URLByAppendingPathComponent:@"dislike"];
        self.likeRemoveLikeEndpoint = [self.likeEndpoint URLByAppendingPathComponent:@"removelike"];
        
        self.accountEndpoint = [baseAddress URLByAppendingPathComponent:@"account"];
        self.accountAccountMenuEndpoint = [self.accountEndpoint URLByAppendingPathComponent:@"account_menu"];
        
        self.commentEndpoint = [baseAddress URLByAppendingPathComponent:@"comment"];
        self.commentCreateCommentEndpoint = [self.commentEndpoint URLByAppendingPathComponent:@"create_comment"];
        self.commentUpdateCommentEndpoint = [self.commentEndpoint URLByAppendingPathComponent:@"update_comment"];
        self.commentPerformCommentActionEndpoint = [self.commentEndpoint URLByAppendingPathComponent:@"perform_comment_action"];
        
        //        self.locale = [NSLocale systemLocale];
        
        self.credentialLogPath = @"authlog.plist";
        [self setLogAuthCredentials:YES];
        
        [self setParser:[FMYouTubeAPIParser parser]];
    }
    return self;
}

- (id)init
{
    return [self initWithBaseAddressType:FMYouTubeBaseAddressDefault];
}

//- (BOOL)setClientName:(FMYouTubeClientName)clientName
//{
//    [self cli:<#(FMYouTubeClientName)#>]
//}

//- (NSURL *)getBaseAddressForClientName:(FMYouTubeClientName)clientName
//{
//    NSURL *baseAddress;
//    switch (clientName) {
//        case FMYouTubeBaseAddressDefault:
//            baseAddress = [NSURL URLWithString:@"https://www.youtube.com/youtubei/v1"];
//            break;
//        case FMYouTubeBaseAddressMusic:
//            baseAddress = [NSURL URLWithString:@"https://music.youtube.com/youtubei/v1"];
//            self.name = @"WEB_REMIX";
//            self.version = @"1.20241127.01.00";
//            break;
//        case FMYouTubeBaseAddressAlternative:
//            baseAddress = [NSURL URLWithString:@"https://youtubei.googleapis.com/youtubei/v1"];
//            break;
//    }
//    return baseAddress;
//}

// The file formats provided by the API depend heavily on the client name and version!! £Also discovery differs.
- (NSDictionary *)contextForClientName:(FMYouTubeClientName)clientNameStruct
{
    switch (clientNameStruct) {
        default:
        case FMYouTubeClientNameMobileWeb:
            return @{@"client": @{@"clientName": @"MWEB", @"clientVersion": @"2.20220918", @"hl": self.hostLanguage, @"gl": self.gLanguage}, @"user":@{}};
            break;
        case FMYouTubeBaseAddressMusic:
            return @{@"client": @{@"clientName": @"WEB_REMIX", @"clientVersion": @"1.20241127.01.00", @"hl": self.hostLanguage, @"gl": self.gLanguage}, @"user":@{}};
            break;
    }
}

- (NSString *)hostLanguage
{
    return [self languageCodeFromLocaleIdentifier:self.locale.localeIdentifier];
}

- (NSString *)gLanguage
{
    return [self countryCodeFromLocaleIdentifier:self.locale.localeIdentifier];
}

- (NSArray *)componentsOfLocaleIdentifier:(NSString *)localeIdentifier
{
    NSArray *components = [localeIdentifier componentsSeparatedByString:@"_"];
    //    if (components.count == 1) components = [localeIdentifier componentsSeparatedByString:@"-"];
    return components;
}

- (NSString *)languageCodeFromLocaleIdentifier:(NSString *)localeIdentifier
{
    NSString *languageCode = [[self componentsOfLocaleIdentifier:localeIdentifier] objectAtIndex:0];
    return ![languageCode isEqualToString:@""] ? languageCode : @"en";
}

- (NSString *)countryCodeFromLocaleIdentifier:(NSString *)localeIdentifier
{
    NSString *countryCode = [[self componentsOfLocaleIdentifier:localeIdentifier] lastObject];
    return ![countryCode isEqualToString:@""] ? countryCode : @"US";
}

//- (NSDictionary *)POSTRequestWithClientName:(FMYouTubeClientName)clientName endpoint:(NSString *)endpoint body:(NSDictionary *)body error:(NSError **)error
//{
//    [self POSTRequest:[NSURL URLWithString:endpoint relativeToURL:<#(NSURL *)#>] withBody:<#(NSDictionary *)#> error:<#(NSError *__autoreleasing *)#>]
//}

- (NSDictionary *)POSTRequest:(NSURL *)url withBody:(NSDictionary *)body error:(NSError **)error
{
    NSDictionary *result;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:error];
    
    NSLog(@"%@", [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding]);
    if (url && (!error || !*error)) {
        NSDictionary *optionalParameters = @{@"key":self.key, @"prettyPrint": (self.prettyPrint ? @"true" : @"false")}; // Key is optional and pretty print disabled is faster.
        url = [self.parser addParameters:optionalParameters toURL:url];
        NSLog(@"%@", url);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:requestData];
        [request addValue:[NSString stringWithFormat:@"%li", (unsigned long)requestData.length] forHTTPHeaderField:@"Content-Length"];
        [request addValue:@"com.lasse.macos.youtube/1.0.0 (Darwin; U; Mac OS X 10.7; GB) gzip" forHTTPHeaderField:@"User-Agent"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        if (self.accessToken) [request addValue:[self getAccessTokenHeader] forHTTPHeaderField:@"Authorization"];
        
        NSURLResponse *response;
        NSData *responseBody = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
        
        NSString *responseString = [[NSString alloc] initWithData:responseBody encoding:NSUTF8StringEncoding];
        
        NSLog(@"-- START RESPONSE --");
        
        NSLog(@"%@", responseString);
        
        NSLog(@"-- END RESPONSE --");
        
        if (responseBody && (!error || !*error))
            result = [NSJSONSerialization JSONObjectWithData:responseBody options:NSJSONReadingAllowFragments error:error];
        if (!result) {
            //*==
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.webView.window makeKeyAndOrderFront:self];
//                [[self.webView mainFrame] loadHTMLString:htmlString baseURL:self.playerEndpoint];
                @throw [NSException exceptionWithName:@"Failed to parse json response" reason:@"No idea honestly" userInfo:nil];
            });
        }
    }
    return result;
}

- (NSDictionary *)POSTRequest:(NSURL *)url
{
    return [self POSTRequest:url withBody:@{} error:nil];
}

- (NSDictionary *)POSTRequest:(NSURL *)url withBody:(NSDictionary *)body
{
    return [self POSTRequest:url withBody:body error:nil];
}

- (NSDictionary *)POSTRequestURLString:(NSString *)urlString WithBody:(NSDictionary *)body error:(NSError **)error
{
    return [self POSTRequest:[NSURL URLWithString:urlString] withBody:body error:error];
}

- (NSDictionary *)GETRequest:(NSURL *)url error:(NSError **)error
{
    NSDictionary *result;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if (self.accessToken)
        [request addValue:[self getAccessTokenHeader] forHTTPHeaderField:@"Authorization"];
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
    //NSLog(@"%@", [*error localizedDescription]);
    NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    if (!error && responseData)
        result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:error];
    if (!result) NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    return result;
}

- (NSDictionary *)getOpenIDConfiguration
{
    return [self GETRequest:self.discoveryDocumentUrl error:nil];
}

- (FMYouTubeVideo *)getVideoWithId:(NSString *)videoId
{
    FMYouTubeVideo *video = [FMYouTubeVideo videoWithId:videoId];
    NSLog(@"%1@, %2@, %3@", self.name, self.version, videoId);
    NSDictionary *body = @{@"context": self.context, @"videoId": videoId, @"contentCheckOk": @"true", @"racyCheckOk": @"true"};
    
    NSError *error;
    NSDictionary *videoInfo = [self POSTRequest:self.nextEndpoint withBody:body error:&error];
    [self.parser addVideoData:videoInfo toVideo:video];
    NSDictionary *videoDetailsDict = [self POSTRequest:self.playerEndpoint withBody:body error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    [self.parser addVideoData:videoDetailsDict toVideo:video];
    
    return video;
}

- (FMYouTubeVideo *)getVideoWithId:(NSString *)videoId clientName:(FMYouTubeClientName)clientName
{
    FMYouTubeVideo *video = [FMYouTubeVideo videoWithId:videoId];
    
    NSDictionary *context = [self contextForClientName:FMYouTubeClientNameMobileWeb]; // this one gives MP3 stuff, the other one gives encrypted MP4 crap or something.
    NSDictionary *body = @{@"context": context, @"videoId": videoId, @"contentCheckOk": @"true", @"racyCheckOk": @"true"};
    
    NSURL *baseAddress = [NSURL URLWithString:@"https://www.youtube.com/youtubei/v1"];
    NSURL *endpoint = [baseAddress URLByAppendingPathComponent:@"player"];
    
    NSError *error;
    NSDictionary *videoInfo = [self POSTRequest:endpoint withBody:body error:&error];
    [self.parser addVideoData:videoInfo toVideo:video];
    NSDictionary *videoDetailsDict = [self POSTRequest:self.playerEndpoint withBody:body error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    [self.parser addVideoData:videoDetailsDict toVideo:video];
    
    return video;
}

- (FMYouTubeVideo *)getVideo:(FMYouTubeVideo *)video clientName:(FMYouTubeClientName)clientName
{
    return [self getVideoWithId:[video videoId] clientName:clientName];
}

- (FMYouTubeVideo *)getVideo:(FMYouTubeVideo *)video
{
    return [self getVideoWithId:[video videoId]];
}

- (NSDictionary *)getBrowseEndpoint
{
    return [self POSTRequest:self.browseEndpoint withBody:@{@"context": [self context]}];
}

- (NSDictionary *)getBrowseEndpointWithBrowseId:(NSString *)browseId
{
    NSDictionary *body = @{@"browseId": browseId, @"context": self.context};
    return [self POSTRequest:self.browseEndpoint withBody:body error:nil];
}

- (NSDictionary *)getBrowseEndpointWithContinuation:(FMYouTubeContinuation *)continuation
{
    NSDictionary *body = @{@"context": self.context, @"continuation": continuation.token};
    return [self POSTRequest:self.browseEndpoint withBody:body error:nil];
}

- (NSArray *)getHome
{
    //    NSString *browseId = self.isLoggedIn ? @"FEwhat_to_watch" : @"FEtrending";
    return [self isLoggedIn] ? [self getWhatToWatchVideos] : [self getTrendingVideos];
    //    NSDictionary *data = [self getBrowseEndpoint:self.isLoggedIn ? @"FEwhat_to_watch" : @"FEtrending"];
    //    return [self.parser parseVideosOnHomePage:data];
}

- (NSArray *)getWhatToWatchVideos
{
    return [self getVideosOnPage:@"FEwhat_to_watch"];
}

- (NSArray *)getTrendingVideos
{
    return [self getVideosOnPage:@"FEtrending"];
}

- (NSArray *)getVideosOnPage:(NSString *)page
{
    NSDictionary *data = [self getBrowseEndpointWithBrowseId:page];
    return [self.parser parseVideosOnHomePage:data];
}

- (NSString *)getCookies
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:@"https://www.youtube.com"]];
    self.cookieArray = cookies;
    NSMutableArray *cookieStrings = [NSMutableArray arrayWithCapacity:cookies.count];
    for (NSHTTPCookie *cookie in cookies) [cookieStrings addObject:[NSString stringWithFormat:@"%1@=%2@", cookie.name, cookie.value]];
    return [cookieStrings componentsJoinedByString:@"; "];
}

- (NSDictionary *)getBearerAuthCode
{
    NSDictionary *requestBody = @{@"client_id": self.clientId, @"scope": self.scope};
    NSDictionary *responseBody = [self POSTRequest:self.deviceAuthorizationEndpoint withBody:requestBody error:nil];
    self.deviceCode = [responseBody objectForKey:@"device_code"];
    return responseBody;
}

- (NSDictionary *)getBearerToken
{
    NSDictionary *tokenBody;
    self.tokenCreatedOn = [NSDate date];
    NSDictionary *data = @{
                           @"client_id": self.clientId,
                           @"client_secret": self.clientSecret,
                           @"device_code": self.deviceCode,
                           @"grant_type": @"urn:ietf:params:oauth:grant-type:device_code"
                           };
    if (self.clientId && self.clientSecret && self.deviceCode) {
        tokenBody = [self POSTRequest:self.tokenEndpoint withBody:data error:nil];
        [self saveAuthCredentials: tokenBody];
    }
    return tokenBody;
}

- (NSString *)getAccessTokenHeader
{
    return [NSString stringWithFormat:@"%1@ %2@", self.tokenType, self.accessToken];
}

- (id)requestContinuation:(FMYouTubeContinuation *)continuation
{
    id result;
    NSURL *endpoint;
    if ([continuation.request isEqualToString:LYContinuationRequestTypeBrowse]) endpoint = self.browseEndpoint;
    NSDictionary *dat = @{@"context": self.context, @"continuation": continuation.token};//@{@"request": continuation.request, @"token": continuation.token};
    NSLog(@"%@", dat);
    if (endpoint) result = [self POSTRequest:endpoint withBody:dat];
    return result;
}

- (NSArray *)getHomeWithContinuation:(FMYouTubeContinuation *)continuation
{
    return [self.parser parseVideosOnHomePage:[self requestContinuation:continuation]];
}

- (BOOL)loadAuthCredentials
{
    return [self applyAuthCredentials:[NSDictionary dictionaryWithContentsOfFile:self.credentialFile]];
}

- (BOOL)saveAuthCredentials:(NSDictionary *)credentials
{
    if (self.logAuthCredentials) {
        NSMutableArray *authLog = [NSMutableArray arrayWithContentsOfFile:self.credentialLogPath];
        [authLog addObject:credentials];
        [authLog writeToFile:self.credentialLogPath atomically:NO];
    }
    if ([self applyAuthCredentials:credentials]) [credentials writeToFile:self.credentialFile atomically:YES];
    return !!credentials;
}

- (BOOL)applyAuthCredentials:(NSDictionary *)credentials
{
    if (credentials) {
        self.accessToken = [credentials objectForKey:@"access_token"];
        self.refreshToken = [credentials objectForKey:@"refresh_token"];
        self.tokenExpiresIn = [credentials objectForKey:@"expires_in"];
        self.tokenType = [credentials objectForKey:@"token_type"];
    }
    //    BOOL a = self.accessToken && self.refreshToken;
    return self.accessToken && self.refreshToken;//!self.isLoggedIn ? self.isLoggedIn = self.accessToken && self.refreshToken : YES;
}

- (BOOL)applyUserProfile
{
    self.profile = [self getUserInfo];
    return self.profile && self.profile.name;
}

- (void)saveUserProfilePicture:(NSString *)path
{
//    NSURLRequest *request = [NSURLRequest requestWithURL:self.profile.pictureUrl];
//    NSURLDownload *download = [[NSURLDownload alloc] initWithRequest:request delegate:nil];
//    [download setDestination:@"profile.jpg" allowOverwrite:YES];
}

- (BOOL)refreshAuthCredentials
{
    //    NSDictionary *credentials;
    BOOL authenticated = NO;
    if ([self loadAuthCredentials]) {
        NSDictionary *data = @{
                               @"client_id": self.clientId,
                               @"client_secret": self.clientSecret,
                               @"grant_type": @"refresh_token",
                               @"refresh_token": self.refreshToken
                               };
        authenticated = [self saveAuthCredentials:[self POSTRequest:self.tokenEndpoint withBody:data error:nil]];
    }// else credentials =
    if (authenticated) self.isLoggedIn = YES;
    return authenticated || self.isLoggedIn;
}
-(NSString *)description
{
    return self.name;
}

- (FMYouTubeProfile *)getUserInfo
{
    NSDictionary *body = @{@"context": self.context};
    NSDictionary *userInfo = [self POSTRequest:self.accountAccountMenuEndpoint withBody:body];
    [userInfo writeToFile:@"user2.plist" atomically:YES];
    NSLog(@"%@, %@", body, userInfo);
    return [self.parser parseProfile:userInfo];
}

+ (FMYouTubeClient *)youtubeClient
{
    return [[FMYouTubeClient alloc] initWithBaseAddressType:FMYouTubeBaseAddressDefault];
}

+ (FMYouTubeClient *)youtubeMusicClient
{
    return [[FMYouTubeClient alloc] initWithBaseAddressType:FMYouTubeBaseAddressMusic];
}

@end
