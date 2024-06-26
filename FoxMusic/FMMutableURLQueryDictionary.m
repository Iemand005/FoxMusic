//
//  FMMutableURLQueryDictionary.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMMutableURLQueryDictionary.h"

@implementation FMMutableURLQueryDictionary

- (NSString *)urlString
{
    NSMutableArray *keyValuePairs = [NSMutableArray arrayWithCapacity:self.count];
    for (id key in self) {
        NSString *value = [self objectForKey:key];
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
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)string, NULL, CFSTR("!*'\"();:@&=+$,/?%#[]%~_-., "), kCFStringEncodingUTF8));
}

@end
