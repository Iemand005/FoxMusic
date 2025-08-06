//
//  FMSpotifyLoginPageViewController.h
//  FoxMusic
//
//  Created by Lasse Lauwerys on 27/06/24.
//  Copyright (c) 2024 Lasse Lauwerys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FMPageViewController.h"

@interface FMSpotifyLoginPageViewController : FMPageViewController
{
    BOOL hasShownLoginPage;
}

- (IBAction)logIn:(id)sender;

@end
