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
    
    if (!response) {
        @throw @"No response on browse endpoint.";
    }
    
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
    
    if (![format isEncrypted]) {
    
    NSData *videoData = [video getVideoDataWithFormat:format];
    
    [[self appDelegate] loadAudioFromData:videoData];
    } else {
        [[self appDelegate] displayError:[NSError errorWithDomain:@"Cannot load video" code:100 userInfo:@{@"Reason": @"This video is encrypted."}]];
    }
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
    
    [cell displayVideo:video];
    
    return cell;
}

- (FMYouTubeVideo *)videoForIndexPath:(NSIndexPath *)indexPath
{
    return [[self videos] objectAtIndex:[indexPath row]];
}

@end
