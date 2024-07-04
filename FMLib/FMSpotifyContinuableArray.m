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
        NSString *href = [dictionary objectForKey:@"href"];
        if (href) self.href = [NSURL URLWithString:href];
        NSString *next = [dictionary objectForKey:@"next"];
        if ([next isKindOfClass:[NSString class]] && [next length]) self.next = [NSURL URLWithString:next];
        NSString *previous = [dictionary objectForKey:@"previous"];
        if ([previous isKindOfClass:[NSString class]] && [previous length]) self.previous = [NSURL URLWithString:previous];
        self.total = [dictionary objectForKey:@"total"];
        self.offset = [dictionary objectForKey:@"offset"];
        self.items = [NSMutableSet set];
    }
    return self;
}
// extend with dictionary
- (FMSpotifyContinuableArray *)addItemsFromDictionary:(NSDictionary *)dictionary
{
    [self setURLsFromDictionary:dictionary];
    
    NSArray *items = [dictionary objectForKey:@"items"];
    if ([items isKindOfClass:[NSArray class]]) [self.items addObjectsFromArray:items];
    return self;
}

- (void)setURLsFromDictionary:(NSDictionary *)dictionary
{
    NSString *href = [dictionary objectForKey:@"href"];
    if (href) self.href = [NSURL URLWithString:href];
    NSString *next = [dictionary objectForKey:@"next"];
    if ([next isKindOfClass:[NSString class]] && [next length]) self.next = [NSURL URLWithString:next];
    else self.next = nil;
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
    return [self next] != nil && [[self next] isKindOfClass:[NSURL class]];
}

- (BOOL)isComplete
{
    return [[self total] unsignedIntegerValue] == [self count];
}

- (BOOL)hasPrevious
{
    return self.previous != nil;
}

@end
