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
        
        NSString *baseAddress = @"http://accounts.spotify.com";
        NSString *authorizeDeviceEndpoint = @"oauth2/device/authorize";
        NSString *tokenEndpoint = @"api/token";
        
        self.baseAddress = [NSURL URLWithString:baseAddress];
        self.authorizeDeviceEndpoint = [NSURL URLWithString:[baseAddress stringByAppendingPathComponent:authorizeDeviceEndpoint]];
        self.tokenEndpoint = [NSURL URLWithString:[baseAddress stringByAppendingPathComponent:tokenEndpoint]];
        
//        [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"*.spotify.com"];
//        [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"accounts.spotify.com"];
//        [NSMutableURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"*.spotify.com"];
//        [NSMutableURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"accounts.spotify.com"];
    }
    return self;
}

- (NSDictionary *)request:(NSURL *)url withBody:(NSDictionary *)requestBody
{
//    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"*.spotify.com"];
//    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"accounts.spotify.com"];
//    [NSMutableURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"*.spotify.com"];
//    [NSMutableURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"accounts.spotify.com"];
//    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"*.spotify.com"];
//    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"accounts.spotify.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *defaultBody = @{@"client_id": self.clientId};
    FMMutableURLQueryDictionary *body = [FMMutableURLQueryDictionary urlQueryDictionary];
    
    [body addEntriesFromDictionary:defaultBody];
    [body addEntriesFromDictionary:requestBody];
    [request setHTTPBody:[body urlEncodedData]];
    
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
        [self showError:error];
    }
    
//    NSString *limitedInputEndrdpoid = @"https://accounts.spotify.com/oauth2/device/authorize";
//    NSMutableURLRequest *requasft = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:limitedInputEndrdpoid]];
//    
//    [requasft setHTTPMethod:@"POST"];
//    [requasft setHTTPBody:[@"client_id=756a522d9f1648b89e76e80be654456a&scope=streaming" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [requasft addValue:@"42" forHTTPHeaderField:@"Content-Length"];
//    [requasft addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    
//    NSError *errford;
//    NSURLResponse *respansee;
//    NSData *responsfible = [NSURLConnection sendSynchronousRequest:requasft returningResponse:&respansee error:&errford];
//    
//    NSString *responsibledatars = [[NSString alloc ] initWithData:responsfible encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"I ate your footbo nI cannot undertsadn thiese chitpansee ece: %@, %@", responsibledatars, errford.localizedDescription);
    
    return [NSDictionary dictionary];
}

- (void)showError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    [alert show];
}

- (FMDeviceAuthorizationInfo *)deviceAuthorizationInfo
{
    NSDictionary *response = [self request:self.authorizeDeviceEndpoint withBody:@{@"scope": @"streaming"}];
    return [FMDeviceAuthorizationInfo deviceAuthorizationInfoFromDictionary:response];
}

+ (FMSpotifyClient *)spotifyClient
{
    return [[FMSpotifyClient alloc] init];
}

@end
