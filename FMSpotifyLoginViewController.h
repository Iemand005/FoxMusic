//
//  FMSpotifyLoginViewController.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMAppDelegate.h"
#import "FMTouch.h"

@interface FMSpotifyLoginViewController : UIViewController
{
    NSTimer *activeTimer;
    double expiresIn;
    NSURL *shareURL;
    FMAppDelegate *appDelegate;
}

- (IBAction)logIn:(id)sender;
- (IBAction)refreshCode:(id)sender;
- (IBAction)shareCode:(id)sender;
- (IBAction)cancelLogin:(id)sender;

@property IBOutlet UITextField *userCodeField;
@property IBOutlet UIProgressView *remainingTimeView;

@property IBOutlet UIBarButtonItem *shareButton;

@end
