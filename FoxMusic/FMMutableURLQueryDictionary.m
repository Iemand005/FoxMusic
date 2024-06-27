//
//  FMMutableURLQueryDictionary.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMMutableURLQueryDictionary.h"

@implementation FMMutableURLQueryDictionary

- (id)init
{
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSString *)urlString
{
    NSMutableArray *keyValuePairs = [NSMutableArray arrayWithCapacity:_dictionary.count];
    for (id key in _dictionary) {
        NSString *value = [_dictionary objectForKey:key];
        [keyValuePairs addObject:[NSString stringWithFormat:@"%@=%@", [self urlEncodeString:key], [self urlEncodeString:value]]];
    }
    return [keyValuePairs componentsJoinedByString:@"&"];
}

- (NSData *)urlEncodedData
{
    return [[self urlString] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlEncodeString:(NSString *)string
{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)string, NULL, CFSTR("!*'\"();:@&=+$,/?%#[]%~-., "), kCFStringEncodingUTF8));
}

- (void)addEntriesFromDictionary:(NSDictionary *)dictionary
{
    [_dictionary addEntriesFromDictionary:dictionary];
}

- (id)initWithCapacity:(NSUInteger)numItems
{
    self = [super init];
    if (self) _dictionary = [[NSMutableDictionary alloc] initWithCapacity:numItems];
    return self;
}

+ (FMMutableURLQueryDictionary *)urlQueryDictionary
{
    return [[FMMutableURLQueryDictionary alloc] init];
}

@end
