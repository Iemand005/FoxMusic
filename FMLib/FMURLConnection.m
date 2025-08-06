//
//  FMURLConnection.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 28/11/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMURLConnection.h"

@implementation FMURLConnection

- (id)init
{
    self = [super init];
    if (self) {
        [self setUrlConnectionDelegate:[FMURLConnectionDelegate urlConnectionDelegate]];
    }
    return self;
}

<<<<<<< HEAD
- (void)getDataFromURL:(NSURL *)url withCallback:(void (^)(NSData *))callback
{
    [self getDataFromURL:url withCallback:callback andQuery:nil andHeaders:nil];
}

=======
>>>>>>> 0528d88226e3bdf583d85e97437e45f885aa773a

- (void)getDataFromURL:(NSURL *)url withCallback:(void (^)(NSData *))callback andHeaders:(NSDictionary *)headers
{
    [self getDataFromURL:url withCallback:callback andQuery:nil andHeaders:headers];
}

- (void)getDataFromURL:(NSURL *)url withCallback:(void (^)(NSData *))callback andQuery:(NSDictionary *)query
{
    [self getDataFromURL:url withCallback:callback andQuery:query andHeaders:nil];
}

- (void)getDataFromURL:(NSURL *)url withCallback:(void (^)(NSData *))callback andQuery:(NSDictionary *)query andHeaders:(NSDictionary *)headers
{
    if (query) url = [[FMMutableURLQueryDictionary urlQueryDictionaryWithDictionary:query] addToURL:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if (headers)
        for (NSString *headerField in headers)
            [request addValue:[headers objectForKey:headerField] forHTTPHeaderField:headerField];
    FMURLConnectionDelegate *delegate = [FMURLConnectionDelegate urlConnectionControllerWithCallback:callback];
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
    [urlConnection start];
}

+ (FMURLConnection *)urlConnection
{
    return [[FMURLConnection alloc] init];
}

@end
