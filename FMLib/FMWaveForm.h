//
//  FMWaveForm.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 10/10/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "FMTrack.h"

@interface FMWaveForm : NSObject

- (void)getSamplesFromURL:(NSURL *)url;
- (void)getSamplesFromTrack:(FMTrack *)track;

- (NSData *) renderPNGAudioPictogramForAsset:(AVURLAsset *)songAsset;

@end
