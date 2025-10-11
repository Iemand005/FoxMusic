//
//  FMDTrackTableItem.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 11/10/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import "FMDTrackTableItem.h"

@implementation FMDTrackTableItem

- (NSURL *)previewItemURL
{
    return [self URL];
}

+ (FMDTrackTableItem *)trackWithURL:(NSURL *)url
{
    return [[FMDTrackTableItem alloc] initWithURL:url];
}

@end
