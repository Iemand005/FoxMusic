//
//  LYVideoFormat.m
//  YouTube Download Test
//
//  Created by Lasse Lauwerys on 10/04/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMYouTubeVideoFormat.h"

@implementation FMYouTubeVideoFormat

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSString *signatureCipher = [NSURL URLWithString:[dict objectForKey:@"signatureCipher"]];
        
        self.isEncrypted = signatureCipher ? true : false;
        self.signatureCipher = signatureCipher;
        
        self.url = [NSURL URLWithString:[dict objectForKey:@"url"]];
        self.fps = [dict objectForKey:@"fps"];
        self.width = [dict objectForKey:@"width"];
        self.height = [dict objectForKey:@"height"];
        self.mimeType = [dict objectForKey:@"mimeType"];
        self.qualityLabel = [dict objectForKey:@"qualityLabel"];
        NSLog(@"%@", [dict objectForKey:@"qualityLabel"]);
    }
    return self;
}

+ (FMYouTubeVideoFormat *)formatWithDictionary:(NSDictionary *)dict
{
    return [[FMYouTubeVideoFormat alloc] initWithDictionary:dict];
}

@end
