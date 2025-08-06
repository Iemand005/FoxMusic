//
//  LYouTubeProfile.h
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 04/12/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMYouTubeProfile : NSObject

@property NSString *name;
@property NSString *givenName;
@property NSString *familyName;
@property NSLocale *locale;
@property NSString *sub;

@property NSURL *pictureUrl;

+ (FMYouTubeProfile *)profile;

@end
