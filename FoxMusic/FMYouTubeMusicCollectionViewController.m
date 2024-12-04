//
//  FMYouTubeMusicCollectionViewController.m
//  FoxMusic
//
//  Created by Lasse Lauwerys on 04/12/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import "FMYouTubeMusicCollectionViewController.h"

#import "FMAppDelegate.h"

@implementation FMYouTubeMusicCollectionViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
     [self setAppDelegate:(FMAppDelegate *)[[UIApplication sharedApplication] delegate]];
    
    NSDictionary *response = [[[self appDelegate] youtubeClient] getBrowseEndpoint];
    
    NSArray *musicVideos = [[[[self appDelegate] youtubeClient] parser] parseBrowseEndpoint:response];
    
    [self setVideos:[NSMutableArray arrayWithArray:musicVideos]];
    [[self collectionView] reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMYouTubeVideo *video = [self videoForIndexPath:indexPath];
    
    NSString *videoId = [video videoId];
    
    video = [[[self appDelegate] youtubeClient] getVideo:video clientName:FMYouTubeClientNameMobileWeb];
    
    FMYouTubeVideoFormat *format = [[video formats] objectAtIndex:0];
    
    NSData *videoData = [video getVideoDataWithFormat:format];
    
    [[self appDelegate] loadAudioFromData:videoData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger amount = [[self videos] count];
    return amount;// + 5;
}

- (FMYouTubeMusicCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMYouTubeMusicCollectionViewCell *cell = (FMYouTubeMusicCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"musicThumbnailItem" forIndexPath:indexPath];
    
    FMYouTubeVideo *video = [self videoForIndexPath:indexPath];
    [[cell title] setText:[video title]];
    [[cell thumbnail] setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[video thumbnailURL]]]];
    
    return cell;
}

- (FMYouTubeVideo *)videoForIndexPath:(NSIndexPath *)indexPath
{
    return [[self videos] objectAtIndex:[indexPath row]];
}

@end
