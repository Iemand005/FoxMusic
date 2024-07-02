//
//  FMSpotifyContinuable.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMSpotifyContinuableArray.h"

@implementation FMSpotifyContinuableArray

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.href = [NSURL URLWithString:[dictionary objectForKey:@"href"]];
        self.total = [dictionary objectForKey:@"total"];
        self.items = [NSMutableSet set];
    }
    return self;
}
// extend with dictionary
- (FMSpotifyContinuableArray *)addItemsFromDictionary:(NSDictionary *)dictionary
{
    [self.items addObjectsFromArray:[dictionary objectForKey:@"items"]];
    return self;
}

- (NSUInteger)count
{
    return self.items.count;
}

- (id)itemAtIndex:(NSUInteger)index
{
    return [[[[self items] objectEnumerator] allObjects] objectAtIndex:index];
}

- (BOOL)hasNext
{
    return self.next != nil;
}

- (BOOL)hasPrevious
{
    return self.previous != nil;
}

@end
