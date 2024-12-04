//
//  LYVideoFormat.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 04/12/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMYouTubeVideoFormat : NSObject

@property NSNumber *itag;
@property NSURL *URL;
@property NSString *mimeType;
@property int bitrate;
@property NSNumber *width;
@property NSNumber *height;
@property int lastModified;
@property int contentLength;
@property NSString *quality;
@property NSNumber *fps;
@property NSString *qualityLabel;
@property NSString *projectionType;
@property int averageBitrate;
@property NSString *audioQuality;
@property int approxDurationMs;
@property int audioSampleRate;
@property int audioChannels;

- (id)initWithDictionary:(NSDictionary *)dict;

+ (FMYouTubeVideoFormat *)formatWithDictionary:(NSDictionary *)dict;

@end
