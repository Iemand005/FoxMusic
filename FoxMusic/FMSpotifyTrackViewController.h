//
//  FMSpotifyTrackViewController.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "FMViewController.h"

@interface FMSpotifyTrackViewController : FMViewController

@property FMSpotifyTrack *track;

@property IBOutlet UIImageView *albumCoverImageView;

@property IBOutlet UIToolbar *toolbar;
@property IBOutlet UIBarButtonItem *playButtonItem;
@property UIImage *albumCoverImage;

- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)rewind:(id)sender;

@end
