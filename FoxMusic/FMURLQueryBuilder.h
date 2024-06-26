//
//  FMURLQueryBuilder.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMURLQueryBuilder : NSDictionary

+ (NSString *)queryFromDictionary:(NSDictionary *)dictionary;
+ (NSString *)urlEncodeString:(NSString *)string;
+ (NSString *)addQueryToURLString:(NSString *)string query:(NSDictionary *)query;
+ (NSString *)addQueryToURL:(NSURL *)url query:(NSDictionary *)query;


@end
