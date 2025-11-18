//
//  FMWaveForm.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 10/10/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import "FMWaveForm.h"

@implementation FMWaveForm


- (void)getSamplesFromURL:(NSURL *)url
{
    NSError *error;
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    AVAssetTrack *track = [asset.tracks objectAtIndex:0];
    
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
    
    NSDictionary *outputSettings = @{
                                     AVFormatIDKey: [NSNumber numberWithInt:kAudioFormatLinearPCM],
                                     AVLinearPCMBitDepthKey: @16
                                     };
    
    AVAssetReaderTrackOutput *output = [[AVAssetReaderTrackOutput alloc] initWithTrack:track outputSettings:outputSettings];
    
    [reader addOutput:output];
    
    UInt32 sampleRate, channelCount;
    
    NSArray *formatDesc = [track formatDescriptions];
    
    for (int i = 0; i < formatDesc.count; ++i) {
//        [reader ]
        CMAudioFormatDescriptionRef item = (__bridge CMAudioFormatDescriptionRef)[formatDesc objectAtIndex:i];
        const AudioStreamBasicDescription* fmtDesc = CMAudioFormatDescriptionGetStreamBasicDescription (item);
        if(fmtDesc ) {
            
            sampleRate = fmtDesc->mSampleRate;
            channelCount = fmtDesc->mChannelsPerFrame;
            
            NSLog(@"channels:%u, bytes/packet: %u, sampleRate %f",fmtDesc->mChannelsPerFrame, fmtDesc->mBytesPerPacket,fmtDesc->mSampleRate);
        }
    }
    
    UInt32 bytesPerSample = 2 * channelCount;
    SInt16 normalizeMax = 0;
    
    NSMutableData * fullSongData = [[NSMutableData alloc] init];
    [reader startReading];
    
    UInt64 totalBytes = 0;
    SInt64 totalLeft = 0;
    SInt64 totalRight = 0;
    NSInteger sampleTally = 0;
    
    NSInteger samplesPerPixel = sampleRate / 50;
    
    while (reader.status == AVAssetReaderStatusReading){
        
        AVAssetReaderTrackOutput * trackOutput = (AVAssetReaderTrackOutput *)[reader.outputs objectAtIndex:0];
        CMSampleBufferRef sampleBufferRef = [trackOutput copyNextSampleBuffer];
        
        if (sampleBufferRef){
            CMBlockBufferRef blockBufferRef = CMSampleBufferGetDataBuffer(sampleBufferRef);
            
            size_t length = CMBlockBufferGetDataLength(blockBufferRef);
            totalBytes += length;
            
//            NSAutoreleasePool *wader = [[NSAutoreleasePool alloc] init];
            @autoreleasepool {
            
            NSMutableData * data = [NSMutableData dataWithLength:length];
            CMBlockBufferCopyDataBytes(blockBufferRef, 0, length, data.mutableBytes);
            
            SInt16 * samples = (SInt16 *) data.mutableBytes;
            int sampleCount = length / bytesPerSample;
            for (int i = 0; i < sampleCount ; i ++) {
                
                SInt16 left = *samples++;
                totalLeft  += left;
                
                SInt16 right;
                if (channelCount==2) {
                    right = *samples++;
                    totalRight += right;
                }
                
                sampleTally++;
                
                if (sampleTally > samplesPerPixel) {
                    
                    left  = totalLeft / sampleTally;
                    
                    SInt16 fix = abs(left);
                    if (fix > normalizeMax) {
                        normalizeMax = fix;
                    }
                    
                    [fullSongData appendBytes:&left length:sizeof(left)];
                    
                    if (channelCount==2) {
                        right = totalRight / sampleTally;
                        
                        SInt16 fix = abs(right);
                        if (fix > normalizeMax) {
                            normalizeMax = fix;
                        }
                        
                        [fullSongData appendBytes:&right length:sizeof(right)];
                    }
                    
                    totalLeft   = 0;
                    totalRight  = 0;
                    sampleTally = 0;
                }
            }
            }
//            [wader drain];
            
            CMSampleBufferInvalidate(sampleBufferRef);
            CFRelease(sampleBufferRef);
        }
    }
}

- (void)getSamplesFromTrack:(FMTrack *)track
{
    [self getSamplesFromURL:track.URL];
}

//-(UIImage *) audioImageGraph:(SInt16 *) samples
//                normalizeMax:(SInt16) normalizeMax
//                 sampleCount:(NSInteger) sampleCount
//                channelCount:(NSInteger) channelCount
//                 imageHeight:(float) imageHeight {
//    
//    CGSize imageSize = CGSizeMake(sampleCount, imageHeight);
//    UIGraphicsBeginImageContext(imageSize);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
////    CGContextSetFillColorWithColor(context, [CIColor blackColor].CGColor);
//    CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(255, 0, 0, 255));
//    CGContextSetAlpha(context,1.0);
//    CGRect rect;
//    rect.size = imageSize;
//    rect.origin.x = 0;
//    rect.origin.y = 0;
//    
////    CGColorRef leftcolor = [[UIColor whiteColor] CGColor];
////    CGColorRef rightcolor = [[UIColor redColor] CGColor];
//    CGColorRef leftcolor = CGColorCreateGenericRGB(255, 255, 255, 255);
//    CGColorRef rightcolor = CGColorCreateGenericRGB(255, 0, 0, 255);
//    
//    CGContextFillRect(context, rect);
//    
//    CGContextSetLineWidth(context, 1.0);
//    
//    float halfGraphHeight = (imageHeight / 2) / (float) channelCount ;
//    float centerLeft = halfGraphHeight;
//    float centerRight = (halfGraphHeight*3) ;
//    float sampleAdjustmentFactor = (imageHeight/ (float) channelCount) / (float) normalizeMax;
//    
//    for (NSInteger intSample = 0 ; intSample < sampleCount ; intSample ++ ) {
//        SInt16 left = *samples++;
//        float pixels = (float) left;
//        pixels *= sampleAdjustmentFactor;
//        CGContextMoveToPoint(context, intSample, centerLeft-pixels);
//        CGContextAddLineToPoint(context, intSample, centerLeft+pixels);
//        CGContextSetStrokeColorWithColor(context, leftcolor);
//        CGContextStrokePath(context);
//        
//        if (channelCount==2) {
//            SInt16 right = *samples++;
//            float pixels = (float) right;
//            pixels *= sampleAdjustmentFactor;
//            CGContextMoveToPoint(context, intSample, centerRight - pixels);
//            CGContextAddLineToPoint(context, intSample, centerRight + pixels);
//            CGContextSetStrokeColorWithColor(context, rightcolor);
//            CGContextStrokePath(context);
//        }
//    }
//    
//    // Create new image
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    // Tidy up
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//}

struct Sample {
    SInt16 left;
    SInt16 right;
};

-(CGImageRef) audioImageGraph:(SInt16 *) samples
                normalizeMax:(SInt16) normalizeMax
                 sampleCount:(NSInteger) sampleCount
                channelCount:(NSInteger) channelCount
                 imageHeight:(float) imageHeight {

    CGSize imageSize = CGSizeMake(sampleCount, imageHeight);
//    UIGraphicsBeginImageContext(imageSize);
    NSInteger width = sampleCount;
    CGContextRef context = CGBitmapContextCreate(NULL, width, imageHeight, 8, width * 8, NULL, 0);
//    CGContextRef context = UIGraphicsGetCurrentContext();

//    CGContextSetFillColorWithColor(context, [CIColor blackColor].CGColor);
//    CGContextSetFillColorWithColor(context, CGColorCreateGenericRGB(255, 0, 0, 255));
    CGContextSetAlpha(context,1.0);
    CGRect rect;
    rect.size = imageSize;
    rect.origin.x = 0;
    rect.origin.y = 0;

//    CGColorRef leftcolor = [[UIColor whiteColor] CGColor];
//    CGColorRef rightcolor = [[UIColor redColor] CGColor];
    CGColorRef leftcolor = CGColorCreateGenericRGB(255, 255, 255, 255);
    CGColorRef rightcolor = CGColorCreateGenericRGB(255, 0, 0, 255);

    CGContextFillRect(context, rect);

    CGContextSetLineWidth(context, 1.0);

    float halfGraphHeight = (imageHeight / 2) / (float) channelCount ;
    float centerLeft = halfGraphHeight;
    float centerRight = (halfGraphHeight*3) ;
    float sampleAdjustmentFactor = (imageHeight/ (float) channelCount) / (float) normalizeMax;

    for (NSInteger intSample = 0 ; intSample < sampleCount ; intSample ++ ) {
        SInt16 left = *samples++;
        float pixels = (float) left;
        pixels *= sampleAdjustmentFactor;
        CGContextMoveToPoint(context, intSample, centerLeft-pixels);
        CGContextAddLineToPoint(context, intSample, centerLeft+pixels);
        CGContextSetStrokeColorWithColor(context, leftcolor);
        CGContextStrokePath(context);

        if (channelCount==2) {
            SInt16 right = *samples++;
            float pixels = (float) right;
            pixels *= sampleAdjustmentFactor;
            CGContextMoveToPoint(context, intSample, centerRight - pixels);
            CGContextAddLineToPoint(context, intSample, centerRight + pixels);
            CGContextSetStrokeColorWithColor(context, rightcolor);
            CGContextStrokePath(context);
        }
    }

    // Create new image
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    // Tidy up
//    UIGraphicsEndImageContext();
//    CGContextG

    return nil;
}


- (NSData *) renderPNGAudioPictogramForAsset:(AVURLAsset *)songAsset {
    
    NSError * error = nil;
    AVAssetReader * reader = [[AVAssetReader alloc] initWithAsset:songAsset error:&error];
    AVAssetTrack * songTrack = [songAsset.tracks objectAtIndex:0];
    
    NSDictionary* outputSettingsDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                                        //     [NSNumber numberWithInt:44100.0],AVSampleRateKey, /*Not Supported*/
                                        //     [NSNumber numberWithInt: 2],AVNumberOfChannelsKey,    /*Not Supported*/
                                        [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                        [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                        [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                        [NSNumber numberWithBool:NO],AVLinearPCMIsNonInterleaved,
                                        nil];
    
    AVAssetReaderTrackOutput* output = [[AVAssetReaderTrackOutput alloc] initWithTrack:songTrack outputSettings:outputSettingsDict];
    
    [reader addOutput:output];
//    [output release];
    
    UInt32 sampleRate,channelCount;
    
    NSArray* formatDesc = songTrack.formatDescriptions;
    for(unsigned int i = 0; i < [formatDesc count]; ++i) {
        CMAudioFormatDescriptionRef item = (__bridge CMAudioFormatDescriptionRef)[formatDesc objectAtIndex:i];
        const AudioStreamBasicDescription* fmtDesc = CMAudioFormatDescriptionGetStreamBasicDescription (item);
        if(fmtDesc ) {
            
            sampleRate = fmtDesc->mSampleRate;
            channelCount = fmtDesc->mChannelsPerFrame;
            
            //    NSLog(@"channels:%u, bytes/packet: %u, sampleRate %f",fmtDesc->mChannelsPerFrame, fmtDesc->mBytesPerPacket,fmtDesc->mSampleRate);
        }
    }
    
    UInt32 bytesPerSample = 2 * channelCount;
    SInt16 normalizeMax = 0;
    
    NSMutableData * fullSongData = [[NSMutableData alloc] init];
    [reader startReading];
    
    UInt64 totalBytes = 0;
    SInt64 totalLeft = 0;
    SInt64 totalRight = 0;
    NSInteger sampleTally = 0;
    
    NSInteger samplesPerPixel = sampleRate / 50;
    
    while (reader.status == AVAssetReaderStatusReading){
        
        AVAssetReaderTrackOutput * trackOutput = (AVAssetReaderTrackOutput *)[reader.outputs objectAtIndex:0];
        CMSampleBufferRef sampleBufferRef = [trackOutput copyNextSampleBuffer];
        
        if (sampleBufferRef){
            CMBlockBufferRef blockBufferRef = CMSampleBufferGetDataBuffer(sampleBufferRef);
            
            size_t length = CMBlockBufferGetDataLength(blockBufferRef);
            totalBytes += length;
            
//            NSAutoreleasePool *wader = [[NSAutoreleasePool alloc] init];
            @autoreleasepool {
            
            NSMutableData * data = [NSMutableData dataWithLength:length];
            CMBlockBufferCopyDataBytes(blockBufferRef, 0, length, data.mutableBytes);
            
            SInt16 * samples = (SInt16 *) data.mutableBytes;
            int sampleCount = length / bytesPerSample;
            for (int i = 0; i < sampleCount ; i ++) {
                
                SInt16 left = *samples++;
                totalLeft  += left;
                
                SInt16 right;
                if (channelCount==2) {
                    right = *samples++;
                    totalRight += right;
                }
                
                sampleTally++;
                
                if (sampleTally > samplesPerPixel) {
                    
                    left  = totalLeft / sampleTally;
                    
                    SInt16 fix = abs(left);
                    if (fix > normalizeMax) {
                        normalizeMax = fix;
                    }
                    
                    [fullSongData appendBytes:&left length:sizeof(left)];
                    
                    if (channelCount==2) {
                        right = totalRight / sampleTally;
                        
                        SInt16 fix = abs(right);
                        if (fix > normalizeMax) {
                            normalizeMax = fix;
                        }
                        
                        [fullSongData appendBytes:&right length:sizeof(right)];
                    }
                    
                    totalLeft   = 0;
                    totalRight  = 0;
                    sampleTally = 0;
                }
            }
            
//            [wader drain];
            }
            
            CMSampleBufferInvalidate(sampleBufferRef);
            CFRelease(sampleBufferRef);
        }
    }
    
    NSData * finalData = nil;
    
    if (reader.status == AVAssetReaderStatusFailed || reader.status == AVAssetReaderStatusUnknown){
        // Something went wrong. return nil
        
        return nil;
    }
    
    if (reader.status == AVAssetReaderStatusCompleted){
        
        NSLog(@"rendering output graphics using normalizeMax %d",normalizeMax);
        
//        return [NSData dataWithBytes:fullSongData.bytes length:fullSongData.length]
        return fullSongData;
        
//        [[NSImage alloc] initWithCGImage:<#(CGImageRef)#> size:<#(NSSize)#>]
        
//        UIImage *test = [self audioImageGraph:(SInt16 *)
//                         fullSongData.bytes 
//                                 normalizeMax:normalizeMax 
//                                  sampleCount:fullSongData.length / 4 
//                                 channelCount:2
//                                  imageHeight:100];
//        
//        finalData = imageToData(test);
    }
    
//    [fullSongData release];
//    [reader release];
    
    return finalData;
}


@end
