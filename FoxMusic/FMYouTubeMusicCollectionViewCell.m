//
//  FMYouTubeMusicCollectionViewCell.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 04/12/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMYouTubeMusicCollectionViewCell.h"

@implementation FMYouTubeMusicCollectionViewCell

- (void)displayVideo:(FMYouTubeVideo *)video
{
    [[self title] setText:[video title]];
    [[self thumbnail] setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[video thumbnailURL]]]];
    
    FMYouTubeVideoFormat *format = [[video formats] objectAtIndex:0];
    if ([format isEncrypted]) [[self title] setTextColor:[UIColor redColor]];
}

@end
