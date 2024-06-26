//
//  FMURLQueryBuilder.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMURLQueryBuilder.h"

@implementation FMURLQueryBuilder

+ (NSString *)URLEncodeString:(NSString *)string
{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)string, NULL, CFSTR("!*'\"();:@&=+$,/?%#[]%~_-., "), kCFStringEncodingUTF8));
}

+ (NSString *)QueryFromDictionary:(NSDictionary *)dictionary
{
    NSString *query = @"";
    if (dictionary) {
        NSMutableArray *keyValuePairs = [NSMutableArray arrayWithCapacity:dictionary.count];
        for (id key in dictionary) {
            NSString *value = [dictionary objectForKey:key];
            [keyValuePairs addObject:[NSString stringWithFormat:@"%@=%@", [FMURLQueryBuilder URLEncodeString:key], [FMURLQueryBuilder URLEncodeString:value]]];
        }
        query = [keyValuePairs componentsJoinedByString:@"&"];
    }
    return query;
}

@end
