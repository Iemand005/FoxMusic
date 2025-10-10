//
//  FMURLConnection.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 28/11/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMURLConnectionDelegate.h"
#import "FMMutableURLQueryDictionary.h"

@interface FMURLConnection : NSObject

@property FMURLConnectionDelegate *urlConnectionDelegate;

- (void)getDataFromURL:(NSURL *)url withCallback:(void (^)(NSData *))callback;
- (void)getDataFromURL:(NSURL *)url withCallback:(void (^)(NSData *))callback andHeaders:(NSDictionary *)headers;
- (void)getDataFromURL:(NSURL *)url withCallback:(void (^)(NSData *))callback andQuery:(NSDictionary *)query;
- (void)getDataFromURL:(NSURL *)url withCallback:(void (^)(NSData *))callback andQuery:(NSDictionary *)query andHeaders:(NSDictionary *)headers;


+ (FMURLConnection *)urlConnection;

@end
