//
//  FMURLConnection.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 1/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMURLConnectionController.h"

@implementation FMURLConnectionController

- (id)initWithCallback:(void (^const)(NSData *))callback
{
    self = [super init];
    if (self) {
        _callback = callback;
    }
    return self;
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

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Recieved data!!: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    _data = data;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Connection finished!");
    _callback(_data);
}

+ (FMURLConnectionController *)urlConnectionController
{
    return [[FMURLConnectionController alloc] init];
}

+ (FMURLConnectionController *)urlConnectionControllerWithCallback:(void(^const)(NSData *))callback
{
    return [[FMURLConnectionController alloc] initWithCallback:callback];
}

@end
