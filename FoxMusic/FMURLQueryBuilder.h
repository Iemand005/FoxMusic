//
//  FMURLQueryBuilder.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMURLQueryBuilder : NSObject

+ (NSString *)QueryFromDictionary:(NSDictionary *)dictionary;
+ (NSString *)URLEncodeString:(NSString *)string;

@end
