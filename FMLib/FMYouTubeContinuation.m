//
//  LYContinuation.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 12/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMYouTubeContinuation.h"

NSString * const LYContinuationRequestTypeBrowse = @"CONTINUATION_REQUEST_TYPE_BROWSE";

@implementation FMYouTubeContinuation

+ (FMYouTubeContinuation *)continuation
{
    return [[FMYouTubeContinuation alloc] init];
}

@end
