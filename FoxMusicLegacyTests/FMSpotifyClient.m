//
//  FMSpotifyClient.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyClient.h"
#import "FMMutableURLQueryDictionary.h"
#import "FMURLConnectionDelegate.h"
#import "FMSpotifyPlaylistArray.h"

@interface FMSpotifyClient ()

@end

@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host;
@end

@implementation FMSpotifyClient

- (id)init
{
    self = [super init];
    if (self) {
        self.clientId = @"756a522d9f1648b89e76e80be654456a";
        
        
        NSString *accountsBaseAddress = @"https://accounts.spotify.com";
        NSString *authorizeDeviceEndpoint = @"oauth2/device/authorize";
        NSString *tokenEndpoint = @"api/token";
        
        self.accountsBaseAddress = [NSURL URLWithString:accountsBaseAddress];
        self.authorizeDeviceEndpoint = [self.accountsBaseAddress URLByAppendingPathComponent:authorizeDeviceEndpoint];
        self.tokenEndpoint = [self.accountsBaseAddress URLByAppendingPathComponent:tokenEndpoint];
        
        
        NSString *apiBaseAddress = @"https://api.spotify.com/v1";
        NSString *searchEndpoint = @"search";
        self.apiBaseAddress = [NSURL URLWithString:apiBaseAddress];
        self.searchEndpoint = [self.apiBaseAddress URLByAppendingPathComponent:searchEndpoint];
        
        self.token = [FMSpotifyToken savedToken];
        
//        apiParser = [FMSpotifyAPIParser apiParser];
    }
    return self;
}

- (NSDictionary *)request:(NSURL *)url withBody:(NSDictionary *)requestBody
{
    return [self request:url withBody:requestBody addClientId:YES error:nil];
}

- (NSDictionary *)request:(NSURL *)url withBody:(NSDictionary *)requestBody error:(NSError **)error
{
    return [self request:url withBody:requestBody addClientId:YES error:error];
}

- (NSDictionary *)request:(NSURL *)url withBody:(NSDictionary *)requestBody addClientId:(BOOL)injectClientId
{
    return [self request:url withBody:requestBody addClientId:injectClientId error:nil];
}

- (NSDictionary *)request:(NSURL *)url withBody:(NSDictionary *)requestBody addClientId:(BOOL)injectClientId error:(NSError **)error
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    FMMutableURLQueryDictionary *body = [FMMutableURLQueryDictionary urlQueryDictionary];
    
    if (injectClientId) [body addEntriesFromDictionary:@{@"client_id": self.clientId}];
    [body addEntriesFromDictionary:requestBody];
    [request setHTTPBody:[body urlEncodedData]];
    
    NSLog(@"sending data: %@", [body urlString]);
    
    [request addValue:@(request.HTTPBody.length).stringValue forHTTPHeaderField:@"Content-Length"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSError *requestError;
    NSURLResponse *response;
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"api.spotify.com"];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    
    NSDictionary *result;
	if (!requestError) {
        result = [self parseResponseData:responseData error:&requestError];
        [self checkResult:result forError:&requestError];
	}
    
    if (error) *error = requestError;
    
    return result;
}

- (id)parseResponseData:(NSData *)data error:(NSError **)error
{
    id response;
    NSError *serializationError;
    @try {
        response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&serializationError];
    } @catch (NSException *ex) {
        serializationError = [NSError errorWithDomain:@"parsingResponse" code:1009 userInfo:@{NSLocalizedDescriptionKey: ex.description, NSLocalizedFailureReasonErrorKey: ex.reason}];
    }
    if (error) *error = serializationError;
    return response;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR ERROR FUCKER: %@", error.localizedDescription);
}

- (void)request:(NSURL *)url callback:(void (^const)(NSDictionary *, NSError *))callback
{
    [self getDataFromURL:url withCallback:^(NSData *data){
        NSError *error;
        NSDictionary *result = [self parseResponseData:data error:&error];
        if (![result isKindOfClass:[NSDictionary class]]) result = @{};
        callback(result, error);
    } andHeaders:@{@"Authorization": [[self token] bearer], @"Accept": @"application/json"}];
}

- (void)getDataFromURL:(NSURL *)url withCallback:(void(^)(NSData *data))callback
{
    [[[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:[FMURLConnectionDelegate urlConnectionControllerWithCallback:^(NSData *data){
        callback(data);
    }]] start];
}

- (void)getDataFromURL:(NSURL *)url withCallback:(void (^)(NSData *))callback andHeaders:(NSDictionary *)headers
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    for (NSString *headerField in headers) [request addValue:[headers objectForKey:headerField] forHTTPHeaderField:headerField];
    [[[NSURLConnection alloc] initWithRequest:request delegate:[FMURLConnectionDelegate urlConnectionControllerWithCallback:callback]] start];
}

- (void)getUserPlaylistsAndWhenSuccess:(void (^)(FMSpotifyPlaylistArray *))callbackSuccess whenError:(void (^)(NSError *))callbackError
{
    NSURL *playlistsEndpoint = [self.apiBaseAddress URLByAppendingPathComponent:@"me/playlists"];
    
    [self request:playlistsEndpoint callback:^(NSDictionary *result, NSError *error){
        if (!error) {
//            NSMutableArray *playlists = [NSMutableArray array];
            
//            NSArray *playlistItems = [result objectForKey:@"items"];
            
            callbackSuccess([FMSpotifyPlaylistArray playlistArrayWithDictionary:result]);
        } else callbackError(error);
    }];
}

- (BOOL)checkResult:(NSDictionary *)result forError:(NSError **)error
{
    NSString *errorReason = [result objectForKey:@"error"];
    NSString *errorDescription = [result objectForKey:@"error_description"];
    BOOL isError = false;
    if (error && (isError = errorReason || errorDescription)) {
//        NSDictionary *userInfo = @{
//                                   NSLocalizedDescriptionKey:errorDescription,
//                                   NSLocalizedFailureReasonErrorKey:errorReason
//                                   };
        NSError *newError = [self localizeError:[NSError errorWithDomain:errorReason ? errorReason : @"" code:6942 userInfo:@{
                                               NSLocalizedDescriptionKey:errorDescription ? errorDescription : @"Unknown description",
                                        NSLocalizedFailureReasonErrorKey:errorReason
                                                 }]];
//        [newError setus:errorReason forKey:NSLocalizedFailureReasonErrorKey]
        *error = [self localizeError:newError];
    }
    return isError;
}

- (NSError *)localizeError:(NSError *)error
{
//    NSError *localizedError = error;
//    NSDictionary *userInfo;
    NSString *failureReason;
    NSString *description;
    if ([error.domain isEqualToString:@"authorization_pending"]) failureReason = @"Authorization pending", description = @"The code has not yet been used";
    if ([error.domain isEqualToString:@"invalid_grant"]) failureReason = @"Refresh token revoked", description = @"The app already used the saved refresh token, you will be logged out once the current token runs out.";
    return [NSError errorWithDomain:error.domain code:error.code userInfo:@{NSLocalizedFailureReasonErrorKey: failureReason, NSLocalizedDescriptionKey: description}];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Recieved data!!: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Connection finished!");
}

- (FMSpotifyDeviceAuthorizationInfo *)refreshDeviceAuthorizationInfoWithError:(NSError **)error
{
	NSError *requestError;
    NSDictionary *response = [self request:self.authorizeDeviceEndpoint withBody:@{@"scope": @"streaming user-read-private user-read-email"} error:&requestError];
	if (requestError) *error = requestError;
    return self.deviceAuthorizationInfo = [FMSpotifyDeviceAuthorizationInfo deviceAuthorizationInfoFromDictionary:response];
}

- (BOOL)tryDeviceAuhorization
{
    return [self tryDeviceAuhorizationWithError:nil];
}

- (BOOL)tryDeviceAuhorizationWithError:(NSError **)error
{
    NSError *requestError;
    
    if (!self.deviceAuthorizationInfo) @throw[NSException exceptionWithName:@"Authorization Failed" reason:@"Device authorization info missing." userInfo:@{}];
    
    NSDictionary *body = @{
                           @"grant_type": @"urn:ietf:params:oauth:grant-type:device_code",
                           @"device_code": self.deviceAuthorizationInfo.deviceCode
                           };
    
    NSDictionary *response = [self request:self.tokenEndpoint withBody:body error:&requestError];
    
    NSLog(@"got a token? %@, %@", response, self.deviceAuthorizationInfo.deviceCode);
    
    self.token = [FMSpotifyToken tokenWithDictionary:response];
    
    if (error) *error = requestError;
    
    [self.token save];
    return [self isLoggedIn];
}

- (BOOL)refreshToken
{
    return [self refreshTokenWithError:nil];
}

- (BOOL)refreshTokenWithError:(NSError **)error
{
    NSError *requestError;
    
    if (!self.token) @throw[NSException exceptionWithName:@"Failed to refresh token" reason:@"Cannot refresh a token that does not exist." userInfo:@{}];
    if (!self.token.refreshToken) [[self token] load];
    if (self.token.refreshToken) {
    
        NSDictionary *body = @{
                               @"grant_type": @"refresh_token",
                               @"refresh_token": self.token.refreshToken
                               };
//    NSMutableDictionary *newBod = [NSMutableDictionary dictionaryWithDictionary:body];
//    [newBod addEntriesFromDictionary:self.token.dictionary];
    
        NSDictionary *response = [self request:self.tokenEndpoint withBody:body error:&requestError];
        
        NSLog(@"got a token? %@, %@", response, self.deviceAuthorizationInfo.deviceCode);
        
        if (!requestError) [self setTokenFromDictionary:response];
        
        
        if (error) *error = requestError;
    }
    return self.token.isValid;
}

- (FMSpotifyToken *)setTokenFromDictionary:(NSDictionary *)dictionary
{
    self.token = [FMSpotifyToken tokenWithDictionary:dictionary];
//    if (!self.token.isValid) [self.token load];
    [self.token save];
    return self.token;
}

- (BOOL)isLoggedIn
{
    return self.token.isValid;
}

- (void)request:(NSURL *)url withOnSuccess:(void(^)(NSDictionary *))callbackSuccess onError:(void(^)(NSError *))callbackError
{
    [self request:url callback:^(NSDictionary *dictionary, NSError *error){
        if (!error) callbackSuccess(dictionary);
        else callbackError(error);
    }];
}

- (void)continueArray:(FMSpotifyContinuableArray *)continuableArray withOnSuccess:(void(^)(FMSpotifyContinuableArray *))callbackSuccess onError:(void(^)(NSError *))callbackError
{
    @try {
        NSURL *url = [continuableArray hasNext] ? [continuableArray next] : [continuableArray href];
        NSLog(@"I will get the continuation data for: %@ sir yes sir rikesyikes u riekt", url);
        if ([url isKindOfClass:[NSString class]]) url = [NSURL URLWithString:(NSString *)url];
        if ([url isKindOfClass:[NSURL class]]) [self request:url withOnSuccess:^(NSDictionary *response){
    //        NSArray *items = [response objectForKey:@"items"];
            callbackSuccess([continuableArray addItemsFromDictionary:response]);
        } onError:callbackError];
        else callbackError([NSError errorWithDomain:@"nil_parameter" code:9000 userInfo:@{NSLocalizedDescriptionKey: @"Attempted to request null", NSLocalizedFailureReasonErrorKey: @"The client tried to fetch more data but there is no more data to be fetched. (this is a bug)"}]);
    }
    @catch (NSException *exception) {
        callbackError([self errorWithException:exception]);
    }
}

- (NSData *)downloadTrack:(FMSpotifyTrack *)track
{
    
//    NSString *url = @"https://api.spotifydown.com/metadata/track/";
    NSString *url = @"https://api.spotifydown.com/download/";
    NSString *fullUrl = [url stringByAppendingString:track.identifier];
    NSURL *urlurl = [NSURL URLWithString:fullUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlurl];
    
    [request addValue:@"https://spotifydown.com" forHTTPHeaderField:@"Origin"];
    [request addValue:@"https://spotifydown.com" forHTTPHeaderField:@"Referer"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *resultString = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
    
    NSLog(@"rebber rubber %@", resultString);
    
    NSDictionary *responseBody = [NSJSONSerialization JSONObjectWithData:result options:0 error:&error];
    
    NSString *downloadLink = [responseBody objectForKey:@"link"];
    
    NSURL *downloadURL = [NSURL URLWithString:downloadLink];
    
//    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:downloadURL];
//    NSURLSession *urlSession = [[NSURLSession alloc] init];
//    NSData *downloadedData = [NSURLConnection sendSynchronousRequest:downloadRequest returningResponse:&response error:&error];
    
    NSData *downloadedData = [NSData dataWithContentsOfURL:downloadURL];
    return downloadedData;
//    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:downloadedData error:&error];
//    [player play];
    
    
//    NSString *metaURL = @"https://spclient.wg.spotify.com/metadata/4/track/";
//    NSString *fullMetaURL = [metaURL stringByAppendingString:@"75aa6e3e6c454cedaca41d842e12a4e6?market=from_token"];
//    [self request:[NSURL URLWithString:fullMetaURL] callback:^(NSDictionary *response, NSError *error){
//        NSLog(@"I GOT RESPONZABLE: %@", response);
//        NSArray *fileFormats = [response objectForKey:@"file"];
//        NSDictionary *fileFormat = [fileFormats lastObject];
//        
//        NSString *fileId = [fileFormat objectForKey:@"file_id"];
//        NSString *format = [fileFormat objectForKey:@"format"];
//        
//        NSLog(@"file ID: %@ with format: %@", fileId, format);
//        
//        NSString *storageURL = @"https://gew4-spclient.spotify.com/storage-resolve/v2/files/audio/interactive/10/";
////        NSString *fullStorageURL = [[metaURL stringByAppendingString:fileId] stringByAppendingString:@"?version=10000000&product=9&platform=39&alt=json"];
//
//         NSString *fullStorageURL = [[storageURL stringByAppendingString:fileId] stringByAppendingString:@"?product=9&alt=json"];
//        
//        [self request:[NSURL URLWithString:fullStorageURL] callback:^(NSDictionary *response, NSError *error){
//            NSLog(@"I GOT RESPONZABLE: %@", response);
//            NSArray *cdns = [response objectForKey:@"cdnurl"];
//            NSString *cdn = [cdns objectAtIndex:0];
//            
//            NSURL *cdnURL = [NSURL URLWithString:cdn];
//            
//            NSLog(@"CDN download url: %@", cdnURL);
//            
//            
//        }];
//    }];
}

- (void)search:(NSString *)query withOnSuccess:(void(^)(FMSpotifyTrackArray *tracks))callbackSuccess onError:(void(^)(NSError *error))callbackError
{
    NSURL *searchEndpoint = [self.apiBaseAddress URLByAppendingPathComponent:@"search"];
    
//    NSArray *types = @[@"album", @"artist", @"playlist", @"track", @"show", @"episode", @"audiobook"];
    FMMutableURLQueryDictionary *queryDictionary = [FMMutableURLQueryDictionary urlQueryDictionaryWithDictionary:@{@"q":query, @"type": @"track"}];
    
    NSURL *searchURL = [queryDictionary addToURL:searchEndpoint];
    NSLog(@"Searching query: %@", searchURL);
    
    [self request:searchURL callback:^(NSDictionary *result, NSError *error){
        if (!error) {
            callbackSuccess([FMSpotifyTrackArray trackArrayWithDictionary:result]);
        } else callbackError(error);
    }];

}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSLog(@"Ignoring SUCKSL");
        SecTrustRef trust = challenge.protectionSpace.serverTrust;
        NSURLCredential *cred;
        cred = [NSURLCredential credentialForTrust:trust];
        [challenge.sender useCredential:cred forAuthenticationChallenge:challenge];
    }
}

- (NSException *)exceptionWithError:(NSError *)error
{
    return [NSException exceptionWithName:error.domain reason:error.localizedFailureReason userInfo:@{}];
}

- (NSError *)errorWithException:(NSException *)exception
{
    return [NSError errorWithDomain:[exception name] code:1000 userInfo:@{NSLocalizedFailureReasonErrorKey: [exception reason], NSLocalizedDescriptionKey: [exception description]}];
}

+ (FMSpotifyClient *)spotifyClient
{
    return [[FMSpotifyClient alloc] init];
}

@end
