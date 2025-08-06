//
//  LYContinuation.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 04/12/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LYContinuationRequestTypeBrowse;

@interface FMYouTubeContinuation : NSObject

@property NSString *request;
@property NSString *token;
@property NSDictionary *body;

+ (FMYouTubeContinuation *)continuation;

@end
