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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSUInteger amount = [[self videos] count];
    return amount;// + 5;
}

- (FMYouTubeMusicCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMYouTubeMusicCollectionViewCell *cell = (FMYouTubeMusicCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"musicThumbnailItem" forIndexPath:indexPath];
    [[cell title] setText:@"arseeater"];
    
    return cell;
}

@end
