//
//  FMSecondViewController.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 26/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FMTouch.h"
#import "FMIndeterminableButton.h"

@interface FMSecondViewController : UIViewController <UIWebViewDelegate>
{
    NSTimer *activeTimer;
    double expiresIn;
    FMSpotifyClient *spotifyClient;
}

- (IBAction)logIn:(id)sender;

@property IBOutlet UITextField *userCodeField;
@property IBOutlet UIProgressView *remainingTimeView;

@property IBOutlet UIWebView *webView;

@property IBOutlet FMIndeterminableButton *checkButton;

@end
