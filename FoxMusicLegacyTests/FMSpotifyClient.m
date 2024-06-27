//
//  FMSpotifyClient.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyClient.h"
#import "FMMutableURLQueryDictionary.h"

//@interface NSURLRequest (DummyInterface)
//+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;
//+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host;
//@end

@interface FMSpotifyClient ()

@end

@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host;
@end

@interface NSMutableURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host;
@end

@implementation FMSpotifyClient

- (id)init
{
    self = [super init];
    if (self) {
        self.clientId = @"756a522d9f1648b89e76e80be654456a";
        
        NSString *baseAddress = @"https://accounts.spotify.com";
        NSString *authorizeDeviceEndpoint = @"oauth2/device/authorize";
        NSString *tokenEndpoint = @"api/token";
        
        self.baseAddress = [NSURL URLWithString:baseAddress];
        self.authorizeDeviceEndpoint = [self.baseAddress URLByAppendingPathComponent:authorizeDeviceEndpoint];
        self.tokenEndpoint = [self.baseAddress URLByAppendingPathComponent:tokenEndpoint];
    }
    return self;
}

- (NSDictionary *)request:(NSURL *)url withBody:(NSDictionary *)requestBody
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *defaultBody = @{@"client_id": self.clientId};
    FMMutableURLQueryDictionary *body = [FMMutableURLQueryDictionary urlQueryDictionary];
    
    [body addEntriesFromDictionary:defaultBody];
    [body addEntriesFromDictionary:requestBody];
    NSData *bodyData = [@"client_id=756a522d9f1648b89e76e80be654456a&scope=streaming" dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:[body urlEncodedData]];
    [request setHTTPBody:bodyData];
    
    NSLog(@"sending data: %@", [body urlString]);
    
    [request addValue:@(request.HTTPBody.length).stringValue forHTTPHeaderField:@"Content-Length"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (responseData) {
        NSString *responseString = [[NSString alloc ] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"I ate your foot: %@, %@", responseString, error.localizedDescription);
        return [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    } else if (error) {
        NSLog(@"Something went wrong: %@", error.localizedDescription);
//        [self showError:error];
    }
    
    return [NSDictionary dictionary];
}

//- (void)showError:(NSError *)error
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
//    [alert show];
//    // TODO: Add retry button.
//}

- (FMSpotifyDeviceAuthorizationInfo *)deviceAuthorizationInfo
{
    NSDictionary *response = [self request:self.authorizeDeviceEndpoint withBody:@{@"scope": @"streaming"}];
    return [FMSpotifyDeviceAuthorizationInfo deviceAuthorizationInfoFromDictionary:response];
}

+ (FMSpotifyClient *)spotifyClient
{
    return [[FMSpotifyClient alloc] init];
}

@end
