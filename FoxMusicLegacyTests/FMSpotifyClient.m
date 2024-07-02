//
//  FMSpotifyClient.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyClient.h"
#import "FMMutableURLQueryDictionary.h"
#import "FMURLConnectionController.h"
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
    
    NSDictionary *result = [self parseResponseData:responseData error:&requestError];
    
    [self checkResult:result forError:&requestError];
    
    if (error) *error = requestError;
    
    return result;
}

- (id)parseResponseData:(NSData *)data error:(NSError **)error
{
    id response;
    NSError *serializationError;
    @try {
        response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
    } @catch (NSException *ex) {
        serializationError = [NSError errorWithDomain:@"parsingResponse" code:1009 userInfo:@{NSLocalizedDescriptionKey: ex.description, NSLocalizedFailureReasonErrorKey: ex.reason}];
    }
    if (error) *error = serializationError;
    return response;
}

- (NSDictionary *)request:(NSURL *)url
{
    return [self request:url error:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR ERROR FUCKER: %@", error.localizedDescription);
}

//- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
//{
//    NSLog(@"I'll send a wrequrest");
//}

//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//    NSLog(@"WTFFFFFF BRO");
//}

- (NSDictionary *)request:(NSURL *)url error:(NSError **)error
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:[self.token bearer] forHTTPHeaderField:@"Authorization"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [connection start];
    
    NSError *requestError;
    __block NSDictionary *result;
    //dispatch_semaphore_t sem = dispatch_semaphore_create(0);
//    [self request:url callback:^(NSDictionary *response, NSError *error){
//        result = response;
//        NSLog(@"request got data to here!!! %@", response);
//        NSLog(@"an error was: %@", error.localizedDescription);
//        dispatch_semaphore_signal(sem);
//    }];
//    dispatch_semaphore_wait(sem, 1000);
    
    NSLog(@"WE GOT THIS DATA OUT!!! %@", result);

    return result;
}

- (void)request:(NSURL *)url callback:(void (^const)(NSDictionary *, NSError *))callback
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:[self.token bearer] forHTTPHeaderField:@"Authorization"];
    
    FMURLConnectionController *urlConnectionController = [FMURLConnectionController urlConnectionControllerWithCallback:^(NSData *data){
        NSError *error;
        NSDictionary *result = [self parseResponseData:data error:&error];
        callback(result, error);
    }];
    [[[NSURLConnection alloc] initWithRequest:request delegate:urlConnectionController] start];
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

- (NSDictionary *)requestWithString:(NSString *)url
{
    return [self request:[NSURL URLWithString:url]];
}

- (NSDictionary *)request:(NSURL *)url queryParameters:(NSDictionary *)parameters error:(NSError **)error
{
    NSError *requestError;
    NSURL *urlWithQuery = [[FMMutableURLQueryDictionary urlQueryDictionaryWithDictionary:parameters] addToURL:url];
    NSLog(@"the new url: %@", urlWithQuery);
    NSDictionary *response = [self request:urlWithQuery error:&requestError];
    
    if (error && requestError) *error = requestError;
    
    return response;
    
}

- (NSDictionary *)request:(NSURL *)url queryParameters:(NSDictionary *)parameters
{
    return [self request:url queryParameters:parameters error:nil];
}

//- (NSURL *)addQueryParameters:(NSDictionary *)parameters toURL:(NSURL *)url

- (BOOL)checkResult:(NSDictionary *)result forError:(NSError **)error
{
    NSString *errorReason = [result objectForKey:@"error"];
    NSString *errorDescription = [result objectForKey:@"error_description"];
    BOOL isError = false;
    if (error && (isError = errorReason || errorDescription)) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        if (errorDescription) [userInfo setValue:errorDescription forKey:NSLocalizedDescriptionKey];
        if (errorReason) [userInfo setValue:errorDescription forKey:NSLocalizedFailureReasonErrorKey];
        *error = [self localizeError:[NSError errorWithDomain:errorReason?errorReason:@"" code:6942 userInfo:userInfo]];
        
    }
    return isError;
}

- (NSError *)localizeError:(NSError *)error
{
//    NSError *localizedError = error;
    NSDictionary *userInfo;
    if ([error.domain isEqualToString:@"authorization_pending"]) userInfo = @{NSLocalizedFailureReasonErrorKey: @"Authorization pending", NSLocalizedDescriptionKey: @"The code has not yet been used"};
    return [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Recieved data!!: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Connection finished!");
}

- (FMSpotifyDeviceAuthorizationInfo *)refreshDeviceAuthorizationInfo
{
    NSDictionary *response = [self request:self.authorizeDeviceEndpoint withBody:@{@"scope": @"streaming"}];
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
    
    NSDictionary *response = [self request:self.tokenEndpoint withBody:self.token.dictionary error:&requestError];
    
    NSLog(@"got a token? %@, %@", response, self.deviceAuthorizationInfo.deviceCode);
    
    [self setTokenFromDictionary:response];
    
    if (error) *error = requestError;
    return self.token.accessToken != nil;
}

- (FMSpotifyToken *)setTokenFromDictionary:(NSDictionary *)dictionary
{
    return self.token = [FMSpotifyToken tokenWithDictionary:dictionary];
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

- (void)continueArray:(FMSpotifyContinuableArray *)continuableArray withOnSuccess:(void(^)(NSDictionary *))callbackSuccess onError:(void(^)(NSError *))callbackError
{
    NSURL *url = [continuableArray hasNext] ? [continuableArray next] : [continuableArray href];
    NSLog(@"I will get the continuation data for: %@ sir yes sir rikesyikes u riekt", url);
    
    [self request:url withOnSuccess:callbackSuccess onError:callbackError];
}

- (NSArray *)getUserPlaylists
{
    [self getUserPlaylistsWithError:nil];
}

- (NSArray *)getUserPlaylistsWithError:(NSError **)error
{
    NSURL *playlistsEndpoint = [self.apiBaseAddress URLByAppendingPathComponent:@"me/playlists"];
    
    NSMutableArray *playlists = [NSMutableArray array];
    
    NSError *requestError;
    NSDictionary *result = [self request:playlistsEndpoint queryParameters:@{@"offset":@10, @"limit":@5} error:&requestError];
    if (error && requestError) *error = requestError;
    
    return result;
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

//- conn

- (NSException *)exceptionWithError:(NSError *)error
{
    return [NSException exceptionWithName:error.domain reason:error.localizedFailureReason userInfo:@{}];
}

+ (FMSpotifyClient *)spotifyClient
{
    return [[FMSpotifyClient alloc] init];
}

@end
