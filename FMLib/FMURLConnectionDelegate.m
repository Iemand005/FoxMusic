//
//  FMURLConnection.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 1/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMURLConnectionDelegate.h"

@implementation FMURLConnectionDelegate

- (id)initWithCallback:(void (^const)(NSData *))callback
{
    self = [super init];
    if (self) {
        _callback = callback;
        _data = [NSMutableData data];
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

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
//    [httpResponse allHeaderFields];
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        NSLog(@"%@",[dictionary description]);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Recieved data!!: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    [_data appendBytes:data.bytes length:data.length];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Connection finished!");
    _callback(_data);
}

+ (FMURLConnectionDelegate *)urlConnectionDelegate
{
    return [[FMURLConnectionDelegate alloc] init];
}

+ (FMURLConnectionDelegate *)urlConnectionControllerWithCallback:(void(^const)(NSData *))callback
{
    return [[FMURLConnectionDelegate alloc] initWithCallback:callback];
}

@end
