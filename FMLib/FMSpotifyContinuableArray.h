//
//  FMSpotifyContinuable.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMSpotifyContinuableArray : NSObject

@property NSURL *href;
@property NSNumber *total;
@property NSNumber *limit;
@property NSNumber *offset;
@property NSURL *next;
@property NSURL *previous;

@property NSMutableSet *items;

@property (readonly, nonatomic) NSUInteger count;
@property (readonly, nonatomic) BOOL hasNext;
@property (readonly, nonatomic) BOOL isComplete;
@property (readonly, nonatomic) BOOL hasPrevious;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (id)itemAtIndex:(NSUInteger)index;

- (FMSpotifyContinuableArray *)addItemsFromDictionary:(NSDictionary *)dictionary;
- (FMSpotifyContinuableArray *)addItems:(FMSpotifyContinuableArray *)continuableArray;
- (void)setURLsFromDictionary:(NSDictionary *)dictionary;

//+ (FMSpotifyContinuableArray *)continuableFromDictionary:(NSDictionary *)dictionary;

@end
