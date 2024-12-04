//
//  FMYouTubeMusicCollectionViewController.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 04/12/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMYouTubeVideo.h"
#import "FMYouTubeMusicCollectionViewCell.h"

@class FMAppDelegate;

@interface FMYouTubeMusicCollectionViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property FMAppDelegate *appDelegate;

@property (strong, nonatomic) NSMutableArray *videos;

@end
