//
//  FMSpotifyTrackViewController.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 2/07/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FMAppDelegate.h"

@interface FMSpotifyTrackViewController : UIViewController
{
    FMAppDelegate *_appDelegate;
}

@property FMSpotifyTrack *track;

- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;

@end
