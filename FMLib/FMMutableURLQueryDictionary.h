//
//  FMMutableURLQueryDictionary.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMMutableURLQueryDictionary : NSObject
{
    NSMutableDictionary *_dictionary;
}

- (NSString *)urlString;
- (NSData *)urlEncodedData;

- (id)initWithCapacity:(NSUInteger)numItems;

- (void)addEntriesFromDictionary:(NSDictionary *)dictionary;

+ (FMMutableURLQueryDictionary *)urlQueryDictionary;

@end
