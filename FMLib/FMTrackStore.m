//
//  FMTrackStore.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 11/10/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import "FMTrackStore.h"

@implementation FMTrackStore



- (void)save
{
    [NSKeyedArchiver archiveRootObject:self toFile:@"hi.plist"];
}

+ (FMTrackStore *)loadSavedStore
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:@"hi.plist"];
}

@end
