//
//  FMDTrackTableItem.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 11/10/25.
//  Copyright (c) 2025 Lasse Lauwerys. All rights reserved.
//

#import "FMTrack.h"
#import <Quartz/Quartz.h>

@interface FMDTrackTableItem : FMTrack <QLPreviewItem>


+ (FMDTrackTableItem *)trackWithURL:(NSURL *)url;

@end
