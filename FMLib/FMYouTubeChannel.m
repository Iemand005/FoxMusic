//
//  LYouTubeChannel.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 9/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMYouTubeChannel.h"

@implementation FMYouTubeChannel

-(id)init
{
    self = [super init];
    if (self) {
        self.thumbnailUrl = [NSURL URLWithString:@""];
    }
    return self;
}

- (void)setThumbnailWithURL:(NSURL *)url
{
//    NSURLDownload *download = [[NSURLDownload alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
//    NSString *fileName = [url.pathComponents lastObject];
//    [download setDestination:fileName allowOverwrite:NO];
//    NSURL *kurl = [NSURL URLWithString:fileName];
//    self.thumbnailUrl = kurl;
}

//- (void)downloadDidFinish:(NSURLDownload *)download
//{
//    NSLog(@"Finished downloading channel thumbnail!");
//}

+ (FMYouTubeChannel *)channel
{
    return [[FMYouTubeChannel alloc] init];
}

@end
