//
//  FMLucida.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 28/11/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMLucidaClient.h"

@implementation FMLucidaClient

- (id)init
{
    self = [super init];
    if (self) {
        
        [self setBaseAddress:[NSURL URLWithString:@"https://lucida.to/"]];
        [self setEndpoint:[NSURL URLWithString:@"https://lucida.to/api/load"]];
        [self setStreamURL:[NSURL URLWithString:@"/api/fetch/stream/v2"]];
        
        [self setUrlConnection:[FMURLConnection urlConnection]];
        _parser = [FMLucidaParser lucidaParser];
        
        [self get:@"https://play.qobuz.com/track/263421753"];
    }
    return self;
}

- (void)get:(NSString *)url
{
    [self requestEndpoint:[self baseAddress] withPath:url andCallback:^(NSData *response){
        NSLog(@"%@", response);
//        [_parser parseData:response withCallback:^(NSObject *response){
//            
//        }];
//        NSString *serialisedResponse = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
//        NSStr *pattern = @"<#string#>";
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:<#(NSString *)#> options:<#(NSRegularExpressionOptions)#> error:<#(NSError *__autoreleasing *)#>]
    }];
}

- (NSObject *)load:(NSString *)path
{
//    [self requestEndpoint:<#(NSURL *)#> withPath:<#(NSString *)#> andCallback:<#^(NSData *)callback#>]
}

- (NSObject *)stream:(NSURL *)url
{
    
}

- (void)requestEndpoint:(NSURL *)endpoint withPath:(NSString *)path andCallback:(void (^)(NSData *))callback
{
    [[self urlConnection] getDataFromURL:[self baseAddress] withCallback:callback andQuery:@{@"url": path}];
}

+ (FMLucidaClient *)lucidaClient
{
    return [[FMLucidaClient alloc] init];
}

@end
