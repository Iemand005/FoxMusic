//
//  FMTrackStore.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 11/10/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMTrackStore : NSObject

@property (retain) NSString *saveFileName;

@property (retain) NSArray *tracks;

+ (FMTrackStore *)loadSavedStore;

@end
