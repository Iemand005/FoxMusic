//
//  FMWaveForm.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 10/10/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import "FMWaveForm.h"
#import <AVFoundation/AVFoundation.h>

@implementation FMWaveForm


- (void)getSamplesFromURL:(NSURL *)url
{
    NSError *error;
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    AVAssetTrack *track = [asset.tracks objectAtIndex:0];
    
    AVAssetReader *reader = [[AVASsetReader alloc] initWithAsset:asset error:&error];
    
    NSDictionary *outputSettings = @{
                                     AVFormatIDKey: kAudioFormatLinearPCM,
                                     AVLinearPCMBitDepthKey: @16
                                     };
    
    AVAssetReaderTrackOutput *output = [[AVAssetReaderTrackOutput alloc] initWithTrack: outputSettings:nil];
    
    [reader addOutput:output];
    
    UInt32 sampleRate, channelCount;
    
    NSArray *formatDesc = [track formatDescriptions];
    
    for (int i = 0; i < formatDesc.count; ++i) {
        
    }
}

- (void)getSamplesFromTrack:(FMTrack *)track
{
    [self getSamplesFromURL:track.URL];
}


@end
