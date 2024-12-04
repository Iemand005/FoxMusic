//
//  FMYouTubeChannel.h
//  FoxMusic YouTube Download Test
//
//  Created by Lasse Lauwerys on 04/12/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMYouTubeChannel : NSObject //<NSURLDownloadDelegate>

//@property NSImage *thumbnail;
@property NSURL *thumbnailUrl;
@property NSString *browseId;
@property NSString *name;
@property NSString *tag;

- (void)setThumbnailWithURL:(NSURL *)url;

+ (FMYouTubeChannel *)channel;

@end
