//
//  FMAudioPlayerViewController.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 04/12/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMAppDelegate;

@interface FMAudioPlayerViewController : UIViewController

@property FMAppDelegate *appDelegate;

@property IBOutlet UIImageView *albumCoverImageView;

@property IBOutlet UIToolbar *toolbar;
@property IBOutlet UIBarButtonItem *playButtonItem;
@property UIImage *albumCoverImage;

- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)rewind:(id)sender;

@end
