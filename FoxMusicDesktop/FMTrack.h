//
//  FMTrack.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 24/09/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMTrack : NSObject

@property (strong) NSURL *URL;

+ (FMTrack *)trackWithURL:(NSURL *)url;

@end
